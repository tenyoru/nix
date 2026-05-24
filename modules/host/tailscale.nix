{...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [41641];
  };
}
