// Enable user configs {{{1

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.aboutConfig.showWarning", false);

// Welcome messages {{{1

user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.firstRunURL", "");
user_pref("browser.uitour.enabled", false);
user_pref("doh-rollout.doneFirstRun", true);
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
user_pref("browser.startup.couldRestoreSession.count", -1);

// UI {{{1

user_pref("intl.locale.requested", "en");
user_pref("browser.compactmode.show", true);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uiCustomization.state", '{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_3c078156-979c-498b-8990-85f7987dd929_-browser-action","treestyletab_piro_sakura_ne_jp-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","_b67c3a9a-b2a2-4fca-af95-7e7a38f3822e_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","simple-translate_sienori-browser-action","jid1-qofqdk4qzufgwq_jetpack-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","vertical-spacer","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","extension_one-tab_com-browser-action","panorama-tab-groups_example_com-browser-action","reset-pbm-toolbar-button","bookmarks-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","cookieautodelete_kennydo_com-browser-action","new-tab-button","customizableui-special-spring62","ublock0_raymondhill_net-browser-action","firefox_tampermonkey_net-browser-action","addon_darkreader_org-browser-action","characterencoding-button","find-button","alltabs-button"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","cookieautodelete_kennydo_com-browser-action","firefox_tampermonkey_net-browser-action","simple-translate_sienori-browser-action","save-to-pocket-button","extension_one-tab_com-browser-action","_a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7_-browser-action","panorama-tab-groups_example_com-browser-action","_b67c3a9a-b2a2-4fca-af95-7e7a38f3822e_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","addon_darkreader_org-browser-action","jid1-qofqdk4qzufgwq_jetpack-browser-action","treestyletab_piro_sakura_ne_jp-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action"],"dirtyAreaCache":["nav-bar","toolbar-menubar","TabsToolbar","PersonalToolbar","unified-extensions-area","vertical-tabs","widget-overflow-fixed-list"],"currentVersion":21,"newElementCount":69}');
user_pref("sidebar.animation.enabled", false);
user_pref("widget.gtk.overlay-scrollbars.enabled", false);
user_pref("browser.tabs.closeTabByDblclick", true);
user_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("general.autoScroll", true);

// URL bar {{{1

user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.urlbar.trimURLs", false);

// New tabpage {{{1

user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.pinned", "");
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", true);

// Privacy {{{1

user_pref("signon.rememberSignons", false);
user_pref("security.insecure_password.ui.enabled", true);

user_pref("browser.contentblocking.category", "strict");
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("dom.private-attribution.submission.enabled", false);
user_pref("network.cookie.cookieBehavior", 3);
user_pref("network.cookie.thirdparty.sessionOnly", true);
user_pref("network.trr.mode", 3);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);

user_pref("breakpad.reportURL", "");
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.usage.uploadEnabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);

user_pref("browser.pagethumbnails.capturing_disabled", true);

// Experiments {{{1

/* 'datareporting.usage.uploadEnabled' also needs to be toggled 'true' */
// user_pref("extensions.experiments.enabled", true);
// user_pref("extensions.formautofill.addresses.experiments.enabled", true);

// Dev tools {{{1

user_pref("devtools.theme", "dark");
user_pref("devtools.editor.tabsize", 2);
user_pref("devtools.editor.expandtab", true);
user_pref("devtools.editor.autoclosebrackets", false);
user_pref("devtools.editor.detectindentation", true);
user_pref("devtools.editor.enableCodeFolding", true);
user_pref("devtools.editor.autocomplete", true);
user_pref("security.fileuri.strict_origin_policy", true); // 'false' allows fetching local files

// Misc. {{{1

user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");

user_pref("dom.webnotifications.enabled", false);
user_pref("browser.tabs.groups.enabled", true);
user_pref("browser.translations.neverTranslateLanguages", "pl");
user_pref("media.eme.enabled", true);   // enable DRM
user_pref("browser.download.useDownloadDir", false);

user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
