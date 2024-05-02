// Disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);

// Set startup home page: 0 = blank, 1 = home, 2 = last visited page, 3 = resume previous session
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Disable activity stream on new windows and tab pages
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false); // disable telemetry
user_pref("browser.newtabpage.activity-stream.telemetry", false); // disable telemetry
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false); // Pocket -> Sponsored Stories
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false); // Sponsored Shortcuts
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// Set language for displaying web pages:
user_pref("intl.accept_languages", "en-US, en");
user_pref("javascript.use_us_english_locale", true); // [HIDDEN PREF]

// Disable auto-installing Firefox updates
user_pref("app.update.background.scheduling.enabled", false); // Windows
//user_pref("app.update.auto", false);                            // Non-Windows

// Disable addons recommendations (use Google Analytics)
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);

// Disable translations
user_pref("browser.translations.enable", false);
user_pref("browser.translations.neverTranslateLanguages", "nl");
user_pref("browser.translations.panelShown", true);

// Disable telemetry
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false); // Default: false
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.endpoint.base.", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("beacon.enabled", false);

// Disable studies
user_pref("app.shield.optoutstudies.enabled", false);

// Disable normandy/shield
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// Disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

// Disable disk cache
user_pref("browser.cache.disk.enable", false);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.pagethumbnails.capturing_disabled", true); // [HIDDEN PREF]
user_pref("browser.shell.shortcutFavicons", false);
user_pref("browser.helperApps.deleteTempFileOnExit", true);

// Disable adding downloads to system's "recent documents" list
user_pref("browser.download.manager.addToRecentDocs", false);

// Disable Pocket extention
user_pref("extensions.pocket.enabled", false);

// Disable PDFJS scripting
user_pref("pdfjs.enableScripting", false);

// Disable saving passwords
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 1);

// Disable captive portal detection
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);

// Disable network connections checks
user_pref("network.connectivity-service.enabled", false);

// Force HTTPS
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Disable WebRTC
user_pref("media.peerconnection.enabled", false);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("webgl.disabled", true);
user_pref("media.autoplay.default", 5);

// Disable DRM Content
user_pref("media.eme.enabled", false);

// Set Mullvad SOCKS5
user_pref("network.proxy.no_proxies_on", "192.168.1.0/24");
user_pref("network.proxy.socks", "10.64.0.1");
user_pref("network.proxy.socks_port", 1080);
user_pref("network.proxy.socks_version", 5);
user_pref("network.proxy.type", 1);
