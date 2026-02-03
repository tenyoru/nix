{ config, lib, pkgs, ... }:
let
  audioConfig = {
    lowLatency = true;
    noiseCancellation = true;
    clockRate = 48000;
    quantum = 256;
  } // (config._module.args.audio or {});
in
{
  #sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.pipewire.extraConfig.pipewire = lib.mkMerge [
    (lib.mkIf audioConfig.lowLatency {
      "92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = audioConfig.clockRate;
          "default.clock.quantum" = audioConfig.quantum;
          "default.clock.min-quantum" = audioConfig.quantum;
          "default.clock.max-quantum" = audioConfig.quantum;
        };
      };
    })
    (lib.mkIf audioConfig.noiseCancellation {
      # Noise cancellation using RNNoise
      "99-noise-cancellation" = {
        "context.modules" = [
          {
            name = "libpipewire-module-filter-chain";
            args = {
              "node.description" = "Clean Mic";
              "media.name" = "Clean Mic";
              "filter.graph" = {
                nodes = [
                  # Noise suppression (DeepFilterNet - better than RNNoise)
                  {
                    type = "ladspa";
                    name = "deepfilter";
                    plugin = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                    label = "deep_filter_stereo";
                    control = {
                      "Attenuation Limit (dB)" = 100.0;
                    };
                  }
                  # Noise gate - cuts off quiet sounds like breathing
                  {
                    type = "ladspa";
                    name = "gate";
                    plugin = "${pkgs.ladspaPlugins}/lib/ladspa/gate_1410.so";
                    label = "gate";
                    control = {
                      "LF key filter (Hz)" = 150.0;
                      "HF key filter (Hz)" = 4000.0;
                      "Threshold (dB)" = -18.0;
                      "Attack (ms)" = 10.0;
                      "Hold (ms)" = 20.0;
                      "Decay (ms)" = 40.0;
                      "Range (dB)" = -90.0;
                    };
                  }
                  # Bass boost (warmth) - builtin EQ
                  {
                    type = "builtin";
                    name = "eq_low";
                    label = "bq_lowshelf";
                    control = {
                      "Freq" = 200.0;
                      "Q" = 0.7;
                      "Gain" = 4.0;
                    };
                  }
                  # Presence boost (clarity) - builtin EQ
                  {
                    type = "builtin";
                    name = "eq_mid";
                    label = "bq_peaking";
                    control = {
                      "Freq" = 3000.0;
                      "Q" = 1.0;
                      "Gain" = 2.0;
                    };
                  }
                  # Compressor (SC4 from swh-plugins)
                  {
                    type = "ladspa";
                    name = "compressor";
                    plugin = "${pkgs.ladspaPlugins}/lib/ladspa/sc4_1882.so";
                    label = "sc4";
                    control = {
                      "RMS/peak" = 0.0;
                      "Attack time (ms)" = 10.0;
                      "Release time (ms)" = 100.0;
                      "Threshold level (dB)" = -20.0;
                      "Ratio (1:n)" = 4.0;
                      "Knee radius (dB)" = 6.0;
                      "Makeup gain (dB)" = 6.0;
                    };
                  }
                ];
              };
              "audio.rate" = audioConfig.clockRate;
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
              "capture.props" = {
                "node.name" = "clean_mic_input";
                "node.passive" = true;
              };
              "playback.props" = {
                "node.name" = "clean_mic";
                "media.class" = "Audio/Source";
              };
            };
          }
        ];
      };
    })
  ];

  services.udev.extraRules = ''
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
  '';

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "*";
      type = "-";
      item = "rtprio";
      value = "95";
    }
    {
      domain = "*";
      type = "-";
      item = "nice";
      value = "-19";
    }
  ];
}
