{ mylib, ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      configFile = mylib.dotfileConfig "kanata" + "/config.kbd";
    };
  };
}
