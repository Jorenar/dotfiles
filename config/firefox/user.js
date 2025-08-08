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

user_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("browser.tabs.closeTabByDblclick", true);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uiCustomization.state", '{"placements":{"unified-extensions-area":["foxyproxy_eric_h_jung-browser-action","_b67c3a9a-b2a2-4fca-af95-7e7a38f3822e_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","vertical-spacer","urlbar-container","downloads-button","unified-extensions-button","bookmarks-menu-button"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","ublock0_raymondhill_net-browser-action","firefox_tampermonkey_net-browser-action","addon_darkreader_org-browser-action","characterencoding-button","find-button","alltabs-button"]},"currentVersion":23}');
user_pref("general.autoScroll", true);
user_pref("intl.language_notification.shown", true);
user_pref("intl.locale.requested", "en");
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("security.insecure_connection_text.enabled", false);
user_pref("sidebar.animation.enabled", false);
user_pref("widget.gtk.overlay-scrollbars.enabled", false);

// URL bar {{{1

user_pref("browser.urlbar.scotchBonnet.enableOverride", false);
user_pref("browser.urlbar.shortcuts.actions", false);
user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.urlbar.trimURLs", false);

// New tabpage {{{1

user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSearch", true);
user_pref("browser.newtabpage.pinned", "");

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

user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

user_pref("browser.pagethumbnails.capturing_disabled", true);

user_pref("extensions.formautofill.addresses.experiments.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

user_pref("extensions.torlauncher.prompt_at_startup", false);
user_pref("torbrowser.about_torconnect.user_has_ever_clicked_connect", true);
user_pref("torbrowser.settings.quickstart.enabled", true);

// Dev tools {{{1

user_pref("devtools.theme", "dark");

user_pref("devtools.chrome.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);

user_pref("devtools.editor.autoclosebrackets", false);
user_pref("devtools.editor.autocomplete", true);
user_pref("devtools.editor.detectindentation", true);
user_pref("devtools.editor.enableCodeFolding", true);
user_pref("devtools.editor.expandtab", true);
user_pref("devtools.editor.tabsize", 2);

user_pref("devtools.responsive.reloadNotification.enabled", false);
user_pref("devtools.responsive.userAgent", "Mozilla/5.0 (Linux; Android)");
user_pref("devtools.responsive.viewport.height", 800);
user_pref("devtools.responsive.viewport.width", 400);

user_pref("security.fileuri.strict_origin_policy", true); // 'false' allows fetching local files

// Misc. {{{1

user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");

user_pref("browser.bookmarks.defaultLocation", "unfiled_____");
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.tabs.groups.enabled", true);
user_pref("browser.translations.neverTranslateLanguages", "pl");
user_pref("dom.webnotifications.enabled", false);
user_pref("findbar.highlightAll", true);
user_pref("media.eme.enabled", true);   // enable DRM
user_pref("media.webspeech.synth.dont_notify_on_error", true);

user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

user_pref("browser.fixup.domainsuffixwhitelist.i2p", true); // recognize .i2p domain
