{ pkgs, ... }:

# fan control via fan2go instead of the BIOS "smart fan" curves.
# the BIOS curves key off Tctl, which on zen2 jumps ~10C on trivial load,
# so the fans chase it. fan2go smooths the temperature and rate-limits changes.
#
# headers (nct6797), identified by hand with the case open:
#   1 = rear case, 2 = cpu cooler, 4 = top front case,
#   5 = bottom front case, 7 = small ~5800rpm fan on the motherboard (chipset),
#   3, 6 = not connected
# inspect with `sudo fan2go detect`, live state with `sudo fan2go fan --id cpu rpm`.
let
  # minPwm/startPwm measured by hand (fan2go's own analysis put the cpu fan
  # at 27, where it stalls): stepping down 10 at a time until the tach read 0,
  # then up from stopped until it spun. values here leave some margin.
  # maxPwm is set too because with min and max both given, fan2go skips its
  # own (inaccurate, and loud) initialization sweep.
  cpuFan = id: channel: minPwm: startPwm: {
    inherit id minPwm startPwm;
    maxPwm = 255;
    hwmon = {
      platform = "nct6797";
      rpmChannel = channel;
      pwmChannel = channel;
    };
    neverStop = true;
    curve = "cpu";
    # slow ramp: at most 2/255 per 200ms tick (~5s from min to max)
    controlAlgorithm.direct.maxPwmChangePerCycle = 2;
  };

  caseFan = id: channel: minPwm: startPwm: (cpuFan id channel minPwm startPwm) // { curve = "case"; };

  # the BIOS switched this one on whenever tctl crossed 55C, so it flapped
  # constantly at idle. allow it to stop, and only spin it up on sustained load
  # (staircase curve with hysteresis, so it doesn't flap at the threshold).
  chipsetFan = id: channel: minPwm: startPwm: (cpuFan id channel minPwm startPwm) // {
    curve = "chipset";
    neverStop = false;
  };

  config = {
    dbPath = "/var/lib/fan2go/fan2go.db";

    # average temps over 10s (50 x 200ms) to ride out tctl spikes
    tempSensorPollingRate = "200ms";
    tempRollingWindowSize = 50;

    fans = [
      # stalls at / starts at (pwm, 0-255)
      (caseFan "rear" 1 55 55) # 30 / 30
      (cpuFan "cpu" 2 50 50) # 20 / 30
      (caseFan "front_top" 4 100 170) # 80 / 160 (kicked, see below)
      (caseFan "front_bottom" 5 100 190) # 60 / 180 (kicked, see below)
      (chipsetFan "chipset" 7 50 60) # 30 / 40
    ];

    sensors = [
      {
        id = "tctl";
        hwmon = {
          platform = "k10temp";
          index = 1;
        };
      }
      {
        id = "systin";
        hwmon = {
          platform = "nct6797";
          index = 1;
        };
      }
    ];

    curves = [
      {
        # 3950X idles ~50-62C tctl; tjmax is 95C
        id = "cpu";
        linear = {
          sensor = "tctl";
          steps = [
            { "65" = "1%"; }
            { "75" = "35%"; }
            { "85" = "70%"; }
            { "90" = "100%"; }
          ];
        };
      }
      {
        # there's no chipset temp sensor exposed, so follow the (smoothed)
        # cpu temp like the BIOS did, but stay off until it's actually busy.
        # off below 70C; each step holds until temp falls 5C below it.
        id = "chipset";
        staircase = {
          sensor = "tctl";
          hysteresis.down = 5;
          steps = [
            { "70" = 1; }
            { "80" = 128; }
            { "88" = 255; }
          ];
        };
      }
      {
        # motherboard ambient, rises with gpu load
        id = "board";
        linear = {
          sensor = "systin";
          steps = [
            { "45" = "1%"; }
            { "60" = "100%"; }
          ];
        };
      }
      {
        id = "case";
        function = {
          type = "maximum";
          curves = [
            "cpu"
            "board"
          ];
        };
      }
    ];
  };

  configFile = (pkgs.formats.yaml { }).generate "fan2go.yaml" config;

  # the front fans keep turning down to ~90 once spinning, but need 160-180
  # to start, and fan2go doesn't apply startPwm to a fan that is already
  # stopped when it takes over. spin them up so they're moving at handover.
  kickFrontFans = pkgs.writeShellScript "fan2go-kick-front-fans" ''
    set -eu
    name=$(grep -l nct6797 /sys/class/hwmon/hwmon*/name)
    h=$(dirname "$name")
    for n in 4 5; do
      echo 1 > "$h/pwm''${n}_enable"
      echo 255 > "$h/pwm$n"
    done
    sleep 4
  '';
in
{
  boot.kernelModules = [ "nct6775" ];

  environment.systemPackages = [ pkgs.fan2go ];

  systemd.services.fan2go = {
    description = "fan2go fan control";
    wantedBy = [ "multi-user.target" ];
    # fan2go skips (with only a warning) any fan or sensor whose hwmon device
    # is missing at startup, so nct6775 has to be loaded first.
    after = [ "systemd-modules-load.service" ];
    wants = [ "systemd-modules-load.service" ];
    serviceConfig = {
      ExecStartPre = kickFrontFans;
      ExecStart = "${pkgs.fan2go}/bin/fan2go -c ${configFile} --no-style";
      Restart = "always";
      RestartSec = 10;
      StateDirectory = "fan2go";
    };
  };
}
