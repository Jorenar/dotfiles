// Don't see first-run welcome messages etc.
user_pref("app.normandy.first_run",                   false);
user_pref("browser.shell.checkDefaultBrowser",        false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.firstRunURL",         "");
user_pref("doh-rollout.doneFirstRun",                 true);
user_pref("trailhead.firstrun.didSeeAboutWelcome",    true);

// General prefs
user_pref("browser.startup.homepage",      "about:home");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\",\"bookmarks-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"cookieautodelete_kennydo_com-browser-action\",\"find-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"cookieautodelete_kennydo_com-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"simple-translate_sienori-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":11}");
user_pref("devtools.theme",                "dark");

user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("browser.download.useDownloadDir",   false);
user_pref("browser.urlbar.suggest.topsites",   false);
user_pref("general.autoScroll",                true);
user_pref("media.eme.enabled",                 true);   // enable DRM

// Disabling default functions (i.e. Sync)
user_pref("identity.fxaccounts.enabled", false);

// New tabpage
user_pref("browser.newtabpage.activity-stream.default.sites"             "");
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets",           false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites",           false);
user_pref("browser.newtabpage.activity-stream.showSearch",               true);

// Privacy and telemery
user_pref("browser.pagethumbnails.capturing_disabled",  true);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled",   false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("network.cookie.cookieBehavior",              3);
user_pref("network.cookie.thirdparty.sessionOnly",      true);
user_pref("privacy.donottrackheader.enabled",           true);
user_pref("security.insecure_password.ui.enabled",      true);
user_pref("signon.rememberSignons",                     false);
user_pref("toolkit.telemetry.unified", false);
