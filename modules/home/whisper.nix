{config, pkgs, mylib, ...}: let
  whisperPython = pkgs.python3.withPackages (ps: [
    ps.faster-whisper
  ]);
  voiceClipModuleRoot = mylib.scriptsPythonDir;
  voiceClipConfigPath = "${voiceClipModuleRoot}/voice_clip";
  voiceClipBin = pkgs.writeTextFile {
    name = "voice-clip";
    destination = "/bin/voice-clip";
    executable = true;
    text = ''
      #!${whisperPython}/bin/python3
      import os
      import sys

      module_root = (
          os.getenv("VOICE_CLIP_MODULE_ROOT")
          or os.getenv("NIXOS_SCRIPTS_PYTHON_PATH")
          or "${voiceClipModuleRoot}"
      )
      sys.path.insert(0, module_root)

      from voice_clip.app import main

      if __name__ == "__main__":
          main()
    '';
  };
in {
  home.packages = [
    voiceClipBin
  ];

  home.sessionVariables = {
    VOICE_CLIP_PYTHON = "${whisperPython}/bin/python3";
    VOICE_CLIP_MODULE_ROOT = voiceClipModuleRoot;
    VOICE_CLIP_CONFIG_PATH = voiceClipConfigPath;
  };
}
