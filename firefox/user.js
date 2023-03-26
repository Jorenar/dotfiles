// Don't see first-run welcome messages etc.
user_pref("browser.shell.checkDefaultBrowser",        false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.firstRunURL",         "");
user_pref("browser.uitour.enabled",                   false);
user_pref("doh-rollout.doneFirstRun",                 true);
user_pref("trailhead.firstrun.didSeeAboutWelcome",    true);

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// General prefs
user_pref("browser.startup.page",          1);
user_pref("browser.startup.homepage",      "about:home");
user_pref("browser.tabs.firefox-view",     false);
user_pref("browser.uiCustomization.state", '{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","bookmarks-menu-button","extension_one-tab_com-browser-action","panorama-tab-groups_example_com-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","firefox_tampermonkey_net-browser-action","ublock0_raymondhill_net-browser-action","cookieautodelete_kennydo_com-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","find-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","cookieautodelete_kennydo_com-browser-action","firefox_tampermonkey_net-browser-action","simple-translate_sienori-browser-action","save-to-pocket-button","extension_one-tab_com-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","panorama-tab-groups_example_com-browser-action"],"dirtyAreaCache":["nav-bar","toolbar-menubar","TabsToolbar","PersonalToolbar"],"currentVersion":17,"newElementCount":13}');

user_pref("dom.webnotifications.enabled ", false);

user_pref("widget.content.allow-gtk-dark-theme", true);
user_pref("widget.gtk.overlay-scrollbars.enabled", false);

user_pref("browser.compactmode.show", true);
user_pref("browser.proton.enabled", false);

user_pref("browser.aboutConfig.showWarning", false);

user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("browser.download.useDownloadDir",   false);
user_pref("browser.urlbar.suggest.topsites",   false);
user_pref("general.autoScroll",                true);
user_pref("media.eme.enabled",                 true);   // enable DRM

user_pref("browser.tabs.closeTabByDblclick", true);
user_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

user_pref("browser.search.geoSpecificDefaults", true);

user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons",   false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// New tabpage
user_pref("browser.newtabpage.activity-stream.default.sites",            "");
user_pref("browser.newtabpage.pinned",                                   "");
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets",           false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites",           false);
user_pref("browser.newtabpage.activity-stream.showSearch",               true);

user_pref("browser.chrome.toolbar_tips", false);

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

// The developer tools configuration
user_pref("devtools.theme",                    "dark");
user_pref("devtools.editor.tabsize",           2);
user_pref("devtools.editor.expandtab",         true);
user_pref("devtools.editor.autoclosebrackets", false);
user_pref("devtools.editor.detectindentation", true);
user_pref("devtools.editor.enableCodeFolding", true);
user_pref("devtools.editor.autocomplete",      true);
