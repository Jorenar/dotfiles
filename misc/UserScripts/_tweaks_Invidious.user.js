// ==UserScript==
// @name  _tweaks: Invidious
// @version -
// @description
// @run-at document-start
// @grant GM_addStyle
// @grant GM_getValue
// @grant GM_setValue
// @grant window.onurlchange
// @include https://yt.be/*
// @include https://youtu.be/*
// @include https://*.youtube.com/*
// @include https://www.youtube-nocookie.com/*
// @exclude https://music.youtube.com/*
// @exclude https://www.youtube.com/feeds/*
//
// @ https://redirect.invidious.io
// @match  https://inv.nadeko.net/*
// @match  https://inv.perditum.com/*
// @match  https://invidious.f5.si/*
// @match  https://invidious.nerdvpn.de/*
// @match  https://yewtu.be/*
// ==/UserScript==

if (!GM_info.script.matches.includes(window.origin+'/*')) {
  let url = new URL(window.location);
  if (url.host === "consent.youtube.com") {
    url = new URL(url.searchParams.get("continue"));
  }
  if (GM_info.script.matches.includes(document.referrer+'*')) {
    Object.defineProperty(document, "referrer", { get : () => "" });
    return;
  }
  if (/.(watch|shorts)/.test(url.pathname)) {
    const INV = GM_getValue("INV", new URL(GM_info.script.matches[0]).host);
    window.location.replace(url.href.replace(url.host, INV).replace('start_radio', 'listen'));
    GM_setValue("INV", INV);
  }
  return;
}

document.cookie = "PREFS=" + encodeURIComponent(JSON.stringify({
  "annotations": true,
  "annotations_subscribed": false,
  "automatic_instance_redirect": false,
  "autoplay": false,
  "captions": ["", "", ""],
  "comments": ["youtube", "reddit"],
  "continue": false,
  "continue_autoplay": false,
  "dark_mode": true,
  "default_home": "",
  "extend_desc": false,
  "feed_menu": [],
  "latest_only": false,
  "listen": false,
  "local": true,
  "locale": "en-US",
  "max_results": 40,
  "notifications_only": false,
  "player_style": "youtube",
  "preload": true,
  "quality": "dash",
  "quality_dash": "720p",
  "region": "PL",
  "related_videos": false,
  "save_player_pos": true,
  "show_nick": false,
  "sort": "published",
  "speed": 1.0,
  "thin_mode": false,
  "unseen_only": false,
  "video_loop": false,
  "volume": 100,
  "vr_mode": true,
  "watch_history": false,
}));

GM_addStyle(`
  .video-js .vjs-text-track-display > div > .vjs-text-track-cue > div {
    background-color: initial !important;
    color: white !important;

    line-height: normal !important;

    font-family: Netflix Sans, Helvetica Nueue, Helvetica, Arial, sans-serif !important;
    font-weight: bold !important;
    font-size: 0.8em;

    /* -webkit-text-stroke: 2px black; */
    text-shadow: 2.2px  2.2px 0 black,
                -1.2px -1.2px 0 black,
                 1.2px -1.2px 0 black,
                -1.2px  1.2px 0 black,
                 1.2px  1.2px 0 black;
  }
`);

GM_addStyle(`
  a[title="Video mode"], a[title="Audio mode"] {
    float: right;
  }
`);

window.onload = function() {
  for (const a of document.querySelectorAll('a[href*="youtube.com/watch"]')) {
    a.removeAttribute('rel');
    a.referrerPolicy = 'origin';
  }

  const rssbtn = document.querySelector('a[href*="/feed/"]')
  if (rssbtn) {
    const ytrssurl = 'https://www.youtube.com/feeds/videos.xml?'
    rssbtn.href = rssbtn.href
      .replace(/.*\/feed\/channel\//, ytrssurl+'channel_id=')
      .replace(/.*\/feed\/playlist\//, ytrssurl+'playlist_id=')
  }

  if (window.location.pathname == '/watch') {
    new MutationObserver(function() {
      const cmt = document.querySelector('#comments h3 > a')
      if (cmt) { cmt.click(); this.disconnect(); }
    }).observe(document, { childList: true, subtree: true });
  }
}

// https://docs.invidious.io/preferences/
// JSON.parse(decodeURIComponent(document.cookie.split("PREFS=")[1].split(';')[0]))
