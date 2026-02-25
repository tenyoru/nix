{
  time.timeZone = "Europe/Brussels";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "ru_RU.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "uk_UA.UTF-8/UTF-8"
      "fr_BE.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
      "ru_RU/ISO-8859-5"
      "ru_RU.KOI8-R/KOI8-R"
      #"fr_FR/ISO8859-15"
      "fr_BE@euro/ISO-8859-15"
    ];
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_ADDRESS = "fr_BE.UTF-8";
      LC_IDENTIFICATION = "fr_BE.UTF-8";
      LC_MEASUREMENT = "fr_BE.UTF-8";
      LC_MONETARY = "fr_BE.UTF-8";
      LC_NAME = "fr_BE.UTF-8";
      LC_NUMERIC = "fr_BE.UTF-8";
      LC_PAPER = "fr_BE.UTF-8";
      LC_TELEPHONE = "fr_BE.UTF-8";
      LC_TIME = "fr_BE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # options = "eurosign:e,caps:escape";
  # };
}
