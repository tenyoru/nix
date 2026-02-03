{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    # policies = {
    #   AppAutoUpdate = false; # Disable automatic application update
    #   BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
    #   DisableBuiltinPDFViewer = true; # Considered a security liability
    #   DisableFirefoxStudies = true;
    #   DisableFirefoxAccounts = true; # Disable Firefox Sync
    #   DisableFirefoxScreenshots = true; # No screenshots?
    #   DisableForgetButton = true; # Thing that can wipe history for X time, handled differently
    #   DisableMasterPasswordCreation = true; # To be determined how to handle master password
    #   DisableProfileImport = true; # Purity enforcement: Only allow nix-defined profiles
    #   DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
    #   DisableSetDesktopBackground = true; # Remove the “Set As Desktop Background…” menuitem when right clicking on an image, because Nix is the only thing that can manage the backgroud
    #   DisplayMenuBar = "default-off";
    #   DisablePocket = true;
    #   DisableTelemetry = true;
    #   DisableFormHistory = true;
    #   DisablePasswordReveal = true;
    #   DontCheckDefaultBrowser = true; # Stop being attention whore
    #   HardwareAcceleration = true; # Disabled as it's exposes points for fingerprinting
    #   OfferToSaveLogins = false; # Managed by KeepAss instead
    #   EnableTrackingProtection = {
    #     Value = true;
    #     Locked = true;
    #     Cryptomining = true;
    #     Fingerprinting = true;
    #     EmailTracking = true;
    #     # Exceptions = ["https://example.com"]
    #   };
    #   EncryptedMediaExtensions = {
    #     Enabled = true;
    #     Locked = true;
    #   };
    #   ExtensionUpdate = true; #false
    #
    #   FirefoxHome = {
    #     Search = true;
    #     TopSites = true;
    #     SponsoredTopSites = false; # Fuck you
    #     Highlights = true;
    #     Pocket = false;
    #     SponsoredPocket = false; # Fuck you
    #     Snippets = false;
    #     Locked = true;
    #   };
    #   FirefoxSuggest = {
    #     WebSuggestions = false;
    #     SponsoredSuggestions = false; # Fuck you
    #     ImproveSuggest = false;
    #     Locked = true;
    #   };
    #   Handlers = {
    #     # FIXME-QA(Krey): Should be openned in evince if on GNOME
    #     mimeTypes."application/pdf".action = "saveToDisk";
    #   };
    #   extensions = {
    #     pdf = {
    #       action = "useHelperApp";
    #       ask = true;
    #       # FIXME-QA(Krey): Should only happen on GNOME
    #       handlers = [
    #         {
    #           name = "GNOME Document Viewer";
    #           path = "${pkgs.zathura}/bin/zathura";
    #         }
    #       ];
    #     };
    #     activeThemeID = "firefox-compact-dark@mozilla.org";
    #   };
    #
    #   NoDefaultBookmarks = true;
    #   PasswordManagerEnabled = true; # Managed by KeepAss | false
    #   PDFjs = {
    #     Enabled = false; # Fuck No, HELL NO
    #     EnablePermissions = false;
    #   };
    #
    #   PictureInPicture = {
    #     Enabled = true;
    #     Locked = true;
    #   };
    #   PromptForDownloadLocation = true;
    #
    #   Proxy = {
    #     Mode = "system"; # none | system | manual | autoDetect | autoConfig;
    #     Locked = false; # true
    #     # HTTPProxy = hostname;
    #     # UseHTTPProxyForAllProtocols = true;
    #     # SSLProxy = hostname;
    #     # FTPProxy = hostname;
    #     SOCKSProxy = "127.0.0.1:9050"; # Tor
    #     SOCKSVersion = 5; # 4 | 5
    #     #Passthrough = <local>;
    #     # AutoConfigURL = URL_TO_AUTOCONFIG;
    #     # AutoLogin = true;
    #     UseProxyForDNS = true;
    #   };
    #   SanitizeOnShutdown = {
    #     Cache = true;
    #     Cookies = false;
    #     Downloads = true;
    #     FormData = true;
    #     History = false;
    #     Sessions = false;
    #     SiteSettings = false;
    #     OfflineApps = true;
    #     Locked = true;
    #   };
    #   SearchEngines = {
    #     PreventInstalls = true;
    #     Add = [
    #       {
    #         Name = "SearXNG";
    #         URLTemplate = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/search?q={searchTerms}";
    #         Method = "GET"; # GET | POST
    #         IconURL = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/favicon.ico";
    #         # Alias = example;
    #         Description = "SearX instance ran by tiekoetter.com as onion-service";
    #         #PostData = name=value&q={searchTerms};
    #         #SuggestURLTemplate = https =//www.example.org/suggestions/q={searchTerms}
    #       }
    #     ];
    #     Remove = [
    #       "Amazon.com" # Fuck you
    #       "Bing" # Fuck you
    #       "Google" # FUCK YOUU
    #     ];
    #     Default = "DuckDuckGo";
    #   };
    #   SearchSuggestEnabled = false;
    #   ShowHomeButton = true;
    #   # FIXME-SECURITY(Krey): Decide what to do with this
    #   # SSLVersionMax = tls1 | tls1.1 | tls1.2 | tls1.3;
    #   # SSLVersionMin = tls1 | tls1.1 | tls1.2 | tls1.3;
    #   # SupportMenu = {
    #   #   Title = Support Menu;
    #   #   URL = http =//example.com/support;
    #   #   AccessKey = S
    #   # };
    #   StartDownloadsInTempDirectory = true; # For speed? May fuck up the system on low ram
    #   UserMessaging = {
    #     ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
    #     FeatureRecommendations = false; # Don’t recommend browser features
    #     Locked = true; # Prevent the user from changing user messaging preferences
    #     MoreFromMozilla = false; # Don’t show the “More from Mozilla” section in Preferences
    #     SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
    #     UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
    #     WhatsNew = false; # Remove the “What’s New” icon and menuitem
    #   };
    #   UseSystemPrintDialog = true;
    #   # WebsiteFilter = {
    #   #   Block = [<all_urls>];
    #   #   Exceptions = [http =//example.org/*]
    #   # };
    #
    #   Preferences = {
    #     "content.notify.interval" = 100000;
    #
    #     "gfx.canvas.accelerated.cache-items" = 4096;
    #     "gfx.canvas.accelerated.cache-size" = 512;
    #     "gfx.content.skia-font-cache-size" = 20;
    #
    #     "browser.cache.disk.enable" = true;
    #
    #     "media.memory_cache_max_size" = 65536;
    #     "media.cache_readahead_limit" = 7200;
    #     "media.cache_resume_threshold" = 3600;
    #
    #     "image.mem.decode_bytes_at_a_time" = 32768;
    #
    #     "network.http.max-connections" = 1800;
    #     "network.http.max-persistent-connections-per-server" = 10;
    #     "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    #     "network.http.pacing.requests.enabled" = false;
    #     "network.dnsCacheExpiration" = 3600;
    #     "network.ssl_tokens_cache_capacity" = 10240;
    #
    #     "network.dns.disablePrefetch" = true;
    #     "network.dns.disablePrefetchFromHTTPS" = true;
    #     "network.prefetch-next" = false;
    #     "network.predictor.enabled" = false;
    #     "network.predictor.enable-prefetch" = false;
    #
    #     "layout.css.grid-template-masonry-value.enabled" = true;
    #     "dom.enable_web_task_scheduling" = true;
    #
    #     "browser.contentblocking.category" = "strict";
    #     "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
    #     "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
    #     "browser.download.start_downloads_in_tmp_dir" = true;
    #     "browser.helperApps.deleteTempFileOnExit" = true;
    #     "browser.uitour.enabled" = false;
    #     "privacy.globalprivacycontrol.enabled" = true;
    #
    #     "security.OCSP.enabled" = 0;
    #     "security.remote_settings.crlite_filters.enabled" = true;
    #     "security.pki.crlite_mode" = 2;
    #
    #     "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    #     "browser.xul.error_pages.expert_bad_cert" = true;
    #     "security.tls.enable_0rtt_data" = false;
    #
    #     "browser.privatebrowsing.forceMediaMemoryCache" = true;
    #     "browser.sessionstore.interval" = 60000;
    #
    #     "browser.privatebrowsing.resetPBM.enabled" = true;
    #     "privacy.history.custom" = true;
    #
    #     "browser.urlbar.trimHttps" = true;
    #     "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
    #     "browser.search.separatePrivateDefault.ui.enabled" = true;
    #     "browser.urlbar.update2.engineAliasRefresh" = true;
    #     "browser.search.suggest.enabled" = false;
    #     "browser.urlbar.quicksuggest.enabled" = false;
    #     "browser.urlbar.groupLabels.enabled" = false;
    #     "browser.formfill.enable" = false;
    #     "security.insecure_connection_text.enabled" = true;
    #     "security.insecure_connection_text.pbmode.enabled" = true;
    #     "network.IDN_show_punycode" = true;
    #
    #     "dom.security.https_first" = true;
    #
    #     "signon.formlessCapture.enabled" = false;
    #     "signon.privateBrowsingCapture.enabled" = false;
    #     "network.auth.subresource-http-auth-allow" = 1;
    #     "editor.truncate_user_pastes" = false;
    #
    #     "security.mixed_content.block_display_content" = true;
    #     "pdfjs.enableScripting" = false;
    #
    #     "extensions.enabledScopes" = 5;
    #
    #     "network.http.referer.XOriginTrimmingPolicy" = 2;
    #
    #     "privacy.userContext.ui.enabled" = true;
    #
    #     "browser.safebrowsing.downloads.remote.enabled" = false;
    #
    #     "permissions.default.desktop-notification" = 2;
    #     "permissions.default.geo" = 2;
    #     "browser.search.update" = false;
    #     "permissions.manager.defaultsUrl" = "";
    #
    #     "datareporting.policy.dataSubmissionEnabled" = false;
    #     "datareporting.healthreport.uploadEnabled" = false;
    #     "toolkit.telemetry.unified" = false;
    #     "toolkit.telemetry.enabled" = false;
    #     "toolkit.telemetry.server" = "data:,";
    #     "toolkit.telemetry.archive.enabled" = false;
    #     "toolkit.telemetry.newProfilePing.enabled" = false;
    #     "toolkit.telemetry.shutdownPingSender.enabled" = false;
    #     "toolkit.telemetry.updatePing.enabled" = false;
    #     "toolkit.telemetry.bhrPing.enabled" = false;
    #     "toolkit.telemetry.firstShutdownPing.enabled" = false;
    #     "toolkit.telemetry.coverage.opt-out" = true;
    #     "toolkit.coverage.opt-out" = true;
    #     "toolkit.coverage.endpoint.base" = "";
    #     "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    #     "browser.newtabpage.activity-stream.telemetry" = false;
    #
    #     "app.shield.optoutstudies.enabled" = false;
    #     "app.normandy.enabled" = false;
    #     "app.normandy.api_url" = "";
    #
    #     "breakpad.reportURL" = "";
    #     "browser.tabs.crashReporting.sendReport" = false;
    #
    #     "captivedetect.canonicalURL" = "";
    #     "network.captive-portal-service.enabled" = false;
    #     "network.connectivity-service.enabled" = false;
    #
    #     "browser.privatebrowsing.vpnpromourl" = "";
    #     "extensions.getAddons.showPane" = false;
    #     "extensions.htmlaboutaddons.recommendations.enabled" = false;
    #     "browser.discovery.enabled" = false;
    #     "browser.shell.checkDefaultBrowser" = false;
    #     "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    #     "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    #     "browser.preferences.moreFromMozilla" = false;
    #     "browser.aboutConfig.showWarning" = false;
    #     "browser.aboutwelcome.enabled" = false;
    #     "browser.profiles.enabled" = true;
    #
    #     "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     "browser.compactmode.show" = true;
    #     "browser.privateWindowSeparation.enabled" = false;
    #
    #     "cookiebanners.service.mode" = 1;
    #     "cookiebanners.service.mode.privateBrowsing" = 1;
    #
    #     "full-screen-api.transition-duration.enter" = "0 0";
    #     "full-screen-api.transition-duration.leave" = "0 0";
    #     "full-screen-api.warning.timeout" = 0;
    #
    #     "browser.urlbar.suggest.calculator" = true;
    #     "browser.urlbar.unitConversion.enabled" = true;
    #     "browser.urlbar.trending.featureGate" = false;
    #
    #     "browser.newtabpage.activity-stream.feeds.topsites" = false;
    #     "browser.newtabpage.activity-stream.showWeather" = false;
    #     "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    #
    #     "extensions.pocket.enabled" = false;
    #
    #     "browser.download.manager.addToRecentDocs" = false;
    #
    #     "browser.download.open_pdf_attachments_inline" = true;
    #
    #     "browser.bookmarks.openInTabClosesMenu" = false;
    #     "browser.menu.showViewImageInfo" = true;
    #     "findbar.highlightAll" = true;
    #     "layout.word_select.eat_space_to_next_word" = false;
    #
    #     "apz.overscroll.enabled" = true;
    #     "general.smoothScroll" = true;
    #     "general.smoothScroll.msdPhysics.enabled" = true;
    #     "mousewheel.default.delta_multiplier_y" = 300;
    #   };
    #
    #   ExtensionSettings = {
    #     # "*" = {
    #     #   installation_mode = "blocked";
    #     #   blocked_install_message = "FUCKING FORGET IT!";
    #     # };
    #     #dark reader
    #     "addon@darkreader.org" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #
    #     # uBlock Origin:
    #     "uBlock0@raymondhill.net" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    #       installation_mode = "force_installed";
    #     };
    #
    #     # vimium
    #     "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
    #       install_url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi";
    #       installation_mode = "force_installed";
    #     };
    #
    #     # theme spirited away
    #     # "{49aa8e5f-f9d6-4556-a881-010b048e8636}" = {
    #     #   install_url = "https://addons.mozilla.org/firefox/downloads/file/4264276/spirited_away_animated-1.5.xpi";
    #     #   installation_mode = "force_installed";
    #     # };
    #   };
    # };
    #
    # profiles ={
    #   profile_0 = {           # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
    #     id = 0;               # 0 is the default profile; see also option "isDefault"
    #     name = "profile_0";   # name as listed in about:profiles
    #     isDefault = true;     # can be omitted; true if profile ID is 0
    #     settings = {          # specify profile-specific preferences here; check about:config for options
    #       "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
    #       # "browser.startup.homepage" = "https://nixos.org";
    #       # "browser.newtabpage.pinned" = [{
    #       #   title = "NixOS";
    #       #   url = "https://nixos.org";
    #       # }];
    #       # add preferences for profile_0 here...
    #     };
    #   };
    # };
  };
}
