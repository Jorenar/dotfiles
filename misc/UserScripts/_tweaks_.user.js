// ==UserScript==
// @name _tweaks
// @version -
// @description
// @include *
// @run-at document-start
// @grant window.onurlchange
// @grant GM_addStyle
// ==/UserScript==

"use strict";

const TWEAKS = [

  { host: null, action: () => {
    const plainSel = "head:has(> link[href^='resource://content-accessible/'])";

    for (const [ sel, size ] of [
      [ "code", "95%" ],
      [ `${plainSel} + body > pre`, "80%" ],
    ]) {
      GM_addStyle(`${sel} {
        font-family: "Nerd Font", monospace;
        font-size: ${size};
      }`);
    };

    window.addEventListener("load", () => {
      const darkreader_style = document.querySelector('style#dark-reader-style')
      if (!darkreader_style) { return; }

      if (document.querySelector(plainSel)) { darkreader_style.remove(); return; }

      darkreader_style.textContent = darkreader_style.textContent.replace([
        `/* Page background */`,
        `html {`,
        `  background: rgb(255,255,255) !important;`,
        `}`,
      ].join('\n'), '')
    });
  }},

  { host: "anilist.co", action: () => {
    GM_addStyle(`
      .home.full-width + .home {
        display: none;
      }

      .list-wrap {
        counter-reset: listCounter;
      }

      .medialist.table.compact .entry .title::before {
        counter-increment: listCounter;
        content: counter(listCounter);
        display: inline-block;
        margin-right: 5px;
        margin-left: -10px;
        opacity: 0.2;
        text-align: right;
        width: 25px;
        font-size: 70%;
      }
    `);

    window.onurlchange = () => {
      new MutationObserver(function () {
        if (window.location.pathname !== "/home") { this.disconnect(); return; }
        const f = document.querySelector(".list-preview-wrap:first-child > .list-preview");
        for (const l of document.querySelectorAll(".list-preview-wrap:nth-child(2)")) {
          for (const a of l.querySelectorAll(".media-preview-card")) { f.appendChild(a); }
          l.remove();
        }
      }).observe(document, { childList: true, subtree: true });
    };
  }},

  { host: /bitbucket/, action: () => {
      /* Hide button for adding yourself to the reviewers */
      displayNone(`.manage-self-button.add-self`);
  }},

  { host: /confluence/, action: () => {
    GM_addStyle(`
      /* Don't display tasks on page if there's none */
      #cw-tasks-byline:has(> [title="No Tasks"]) {
        display: none;
      }

      /* Make Gliffy somewhat readable after DarkReader */
      [data-darkreader-inline-bgcolor] canvas.gliffy-graphic {
        filter: invert(1);
      }

      textarea.textarea {
        max-width: 100% !important;
      }
    `);
  }},

  { host: "github.com", action: () => {
    GM_addStyle(`span[class^="pl"] { color: var(--color-fg-default); }`);
    displayNone(`.code-navigation-cursor, .feed-right-column, .user-status-container`);
    displayNone(`button:has(:is(.octicon-star,.icon-sponsor)), .BtnGroup.unstarred`);
  }},

  { host: /google.pl/, action: () => {
    window.location.replace(window.location.href.replace("google.pl", "google.com"));
  }},

  { host: "hn.algolia.com", action: () => {
    if (!window.location.search) { window.location.replace("https://news.ycombinator.com/news"); }
  }},

  { host: "infinitebacklog.net", action: () => {
    GM_addStyle(`
      * {
        scrollbar-color: #2d333e rgba(37,41,51,.9);
      }

      @media (min-width: 576px) {
        .filter-container {
          height: calc(100vh - 230px) !important;
          padding-right: 5px !important;
          scrollbar-width: initial !important;
          width: calc(100% - 5px) !important;
        }
      }
    `);
  }},

  { host: /jenkins/, action: () => {
    GM_addStyle(`
      :root { --even-row-color: none !important; }
      .pane-frame { border: none !important; }
    `);
  }},

  { host: /jira/, action: () => {
    GM_addStyle(`
      .jira-dialog .form-body {
        max-height: 75vh !important;
      }

      /* Fix the alignment of the avatars and story points on the planning view */
      .ghx-issue-compact .ghx-row:not(.ghx-end):not(.ghx-plan-extra-fields) .ghx-estimate {
        width: 65px;
      }
      .ghx-issue-compact .ghx-estimate .ghx-avatar-img {
        float: right;
      }
    `);
  }},

  { host: "mail.google.com", action: () => {
    window.trustedTypes.createPolicy("default", { createHTML: (string) => string });
    document.querySelector("head").innerHTML += '<meta name="theme-color" content="#222">';
    displayNone('div:has(> div > span[data-label="Summarise this email"])');
    displayNone('div[data-message-id] + div:has([role="presentation"])');
    GM_addStyle(`
      /* Add some space between "Back" button and the rest */
      div[role="button"]:is([aria-label^="Back"], [title^="Back"]) {
        padding-right: 30px;
      }

      /* make all messages have same background */
      div[style*="width"] > div[style*="position"] {
        tr[role="row"][aria-labelledby] {
          background: transparent !important;
        }
      }
    `);
  }},

  { host: "news.ycombinator.com", action: () => {
    GM_addStyle(`
      body { zoom: 1.5; }
      a:focus { border: 1.5px dotted blue; }
    `);
  }},

  { host: "www.reddit.com", action: () => {
    if (!/^\/(gallery|media)/.test(window.location.pathname)) {
      window.location.replace(window.location.href.replace("www.reddit.com", "old.reddit.com"));
    } else {
      GM_addStyle(`body { display: flex; min-height: 100vh; img { margin: auto; max-width: initial; } }`);
      window.onload = () => { document.body.innerHTML = `<img src="${document.querySelector('img').src}">`; }
    }
  }},

  { host: "old.reddit.com", action: () => {
    if (window.location.pathname.includes("/register/")) {
      window.location.replace(document.referrer);
    }
    GM_addStyle(`.sitetable.linklisting { width: 60%; }`);
    GM_addStyle(`#header-bottom-left { padding-top: 0.25em; }`);
    GM_addStyle(`#header-img { display: none !important }`);
    displayNone(`.commentsignupbar, .listingsignupbar`);
    window.onload = () => {
      document.querySelector('link[title="applied_subreddit_stylesheet"]')?.remove();
      for (const a of document.querySelectorAll('a[href*="preview.redd.it"')) {
        a.href = a.href.replace(/\?.*/, '').replace('preview', 'i');
      }
    };
  }},

  { host: /stack.*.com/, action: () => {
    displayNone(`#review-button > .s-activity-indicator`);
    displayNone(`.s-sidebarwidget__yellow`);
  }},

  { host: /wixmp.com/, action: () => {
    const m = /\/w_(\d\d\d?),h_(\d\d\d?),/.exec(window.location.pathname);
    if (m) { window.location.replace(window.location.href.replace(m[0], `/S,w_${m[1]*4},h_${m[2]*4},`).replace("q_70", "q_100")); }
  }},

  { host: "x.com", action: () => {
    window.location.replace(window.location.href.replace("x.com", "xcancel.com"));
  }},

];

const displayNone = (sel) => {
  GM_addStyle(`${sel} { display: none !important; }`)
};

/* main */ {
  TWEAKS[0].action();
  const { host } = window.location;
  for (let i = 1; i < TWEAKS.length; ++i) {
    const t = TWEAKS[i];
    const m = (t.host === host || t.host.test?.(host));
    if (m) { t.action(); break; }
  }
}

// vim: fdl=1
