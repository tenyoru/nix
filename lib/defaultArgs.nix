{
  username = "Tenyoru";

  stateVersion = "24.11";
  hmStateVersion = "24.11";
  platform = "x86_64-linux";

  # Git and Jujutsu configuration
  git = {
    userName = "tenyoru";
    userEmail = "mail@tenyoru.io";
  };

  # List of keys to exclude when merging configurations.
  # These keys will not be included in the final configuration.
  excludeKeys = [ "excludeKeys" "modules" "name" ];
}
