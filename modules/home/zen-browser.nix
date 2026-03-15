{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.twilight];

  # Install Tridactyl native messenger
  home.packages = with pkgs; [
    tridactyl-native
  ];

  programs.zen-browser = {
    enable = true;

    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisableBuiltinPDFViewer = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisplayMenuBar = "default-off";
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = true;
      OfferToSaveLogins = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };

      ExtensionUpdate = true;

      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      Handlers = {
        mimeTypes."application/pdf".action = "saveToDisk";
      };

      extensions = {
        pdf = {
          action = "useHelperApp";
          ask = true;
          handlers = [
            {
              name = "GNOME Document Viewer";
              path = "${pkgs.zathura}/bin/zathura";
            }
          ];
        };
        activeThemeID = "firefox-compact-dark@mozilla.org";
      };

      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;

      PDFjs = {
        Enabled = false;
        EnablePermissions = false;
      };

      PictureInPicture = {
        Enabled = true;
        Locked = true;
      };

      PromptForDownloadLocation = true;

      Proxy = {
        Mode = "system";
        Locked = false;
        SOCKSProxy = "127.0.0.1:9050";
        SOCKSVersion = 5;
        UseProxyForDNS = true;
      };

      SanitizeOnShutdown = {
        Cache = true;
        Cookies = false;
        Downloads = true;
        FormData = true;
        History = false;
        Sessions = false;
        SiteSettings = false;
        OfflineApps = true;
        Locked = true;
      };

      SearchEngines = {
        PreventInstalls = true;
        Add = [
          {
            Name = "SearXNG";
            URLTemplate = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/search?q={searchTerms}";
            Method = "GET";
            IconURL = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/favicon.ico";
            Description = "SearX instance ran by tiekoetter.com as onion-service";
          }
        ];
        Remove = [
          "Amazon.com"
          "Bing"
          "Google"
        ];
        Default = "DuckDuckGo";
      };

      SearchSuggestEnabled = false;
      ShowHomeButton = true;
      StartDownloadsInTempDirectory = true;

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        Locked = true;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
        WhatsNew = false;
      };

      UseSystemPrintDialog = true;

      Preferences = {
        "content.notify.interval" = 100000;

        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;

        "browser.cache.disk.enable" = true;

        "media.memory_cache_max_size" = 65536;
        "media.cache_readahead_limit" = 7200;
        "media.cache_resume_threshold" = 3600;

        "image.mem.decode_bytes_at_a_time" = 32768;

        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        "network.http.pacing.requests.enabled" = false;
        "network.dnsCacheExpiration" = 3600;
        "network.ssl_tokens_cache_capacity" = 10240;

        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;

        "layout.css.grid-template-masonry-value.enabled" = true;
        "dom.enable_web_task_scheduling" = true;

        "browser.contentblocking.category" = "strict";
        "urlclassifier.trackingSkipURLs" = "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
        "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com, *.twitter.com, *.twimg.com";
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.helperApps.deleteTempFileOnExit" = true;
        "browser.uitour.enabled" = false;
        "privacy.globalprivacycontrol.enabled" = true;

        "security.OCSP.enabled" = 0;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "browser.xul.error_pages.expert_bad_cert" = true;
        "security.tls.enable_0rtt_data" = false;

        "browser.privatebrowsing.forceMediaMemoryCache" = true;
        "browser.sessionstore.interval" = 60000;

        "browser.privatebrowsing.resetPBM.enabled" = true;
        "privacy.history.custom" = true;

        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "browser.urlbar.update2.engineAliasRefresh" = true;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.formfill.enable" = false;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "network.IDN_show_punycode" = true;

        "dom.security.https_first" = true;

        "signon.formlessCapture.enabled" = false;
        "signon.privateBrowsingCapture.enabled" = false;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.firefoxRelay.feature" = "disabled";
        "signon.includeOtherSubdomainsInLookup" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "signon.showAutoCompleteFooter" = false;
        "signon.showAutoCompleteOrigins" = false;
        "network.auth.subresource-http-auth-allow" = 1;
        "editor.truncate_user_pastes" = false;

        "security.mixed_content.block_display_content" = true;
        "pdfjs.enableScripting" = false;

        "extensions.enabledScopes" = 5;
        "extensions.update.enabled" = true;
        "extensions.update.autoUpdateDefault" = true;

        "network.http.referer.XOriginTrimmingPolicy" = 2;

        "privacy.userContext.ui.enabled" = true;

        "browser.safebrowsing.downloads.remote.enabled" = false;

        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "browser.search.update" = false;
        "permissions.manager.defaultsUrl" = "";

        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;

        "browser.privatebrowsing.vpnpromourl" = "";
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.profiles.enabled" = true;

        # Zen-specific settings
        "zen.greeting.enabled" = false;
        "zen.welcome.enabled" = false;
        "zen.onboarding.seen" = true;
        "zen.view.compact.hide-toolbar" = false;
        "zen.tabs.show-close-button" = false;

        # Hide tab close buttons
        "browser.tabs.closeButtons" = 2;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.compactmode.show" = true;
        "browser.privateWindowSeparation.enabled" = false;

        "cookiebanners.service.mode" = 1;
        "cookiebanners.service.mode.privateBrowsing" = 1;

        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.timeout" = 0;

        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.urlbar.trending.featureGate" = false;

        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        "extensions.pocket.enabled" = false;

        "browser.download.manager.addToRecentDocs" = false;

        "browser.download.open_pdf_attachments_inline" = true;

        "browser.bookmarks.openInTabClosesMenu" = false;
        "browser.menu.showViewImageInfo" = true;
        "findbar.highlightAll" = true;
        "layout.word_select.eat_space_to_next_word" = false;

        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "mousewheel.default.delta_multiplier_y" = 300;
      };

      ExtensionSettings = {
        # Obsidian Web Clipper
        "clipper@obsidian.md" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/web-clipper-obsidian/latest.xpi";
          installation_mode = "force_installed";
        };

        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
          installation_mode = "normal_installed";
        };

        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Proton Pass
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "force_installed";
        };

        # Proton VPN
        "vpn@proton.ch" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-vpn-firefox-extension/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  # Tridactyl configuration
  # move to config dir and make a link
  xdg.configFile."tridactyl/tridactylrc".text = ''
    " Qutebrowser-style website bindings
    bind ,cc tabopen claude.ai
    bind ,cg tabopen chatgpt.com
    bind ,cb tabopen codeberg.org/tenyoru?tab=repositories
    bind ,gh tabopen github.com
    bind ,pm tabopen mail.proton.me
    bind ,pd tabopen drive.proton.me
    bind ,pc tabopen calendar.proton.me
    bind ,pl tabopen lumo.proton.me
    bind ,pp tabopen pass.proton.me
    bind ,i tabopen inv.nadeko.net
    bind ,tt tabopen track.toggl.com
    bind ,rt tabopen context.reverso.net
    bind ,rd tabopen dictionary.reverso.net
    bind ,rc tabopen conjugator.reverso.net

    " Theme settings
    colors dark
    set theme dark
  '';
}
