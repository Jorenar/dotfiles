// ==UserScript==
// @name _tweaks: DuckDuckGo
// @version -
// @description
// @run-at document-start
// @match  https://duckduckgo.com/*
// ==/UserScript==

/* eslint-disable no-multi-spaces */

const cookies = [
  "p=1",    // safe search: strict
  "av=1",   // infinite scroll
  "1=-1",   // no ads
  "aj=m",   // metric units of measure
  "ay=b",   // best maps
  "v=m",    // only lines for page breaks
  "ak=-1",  // no "Install DuckDuckGo"
  "ax=-1",  // no reminders to install
  "aq=-1",  // no privacy newsletter sing up form
  "ap=-1",  // no reminders to sing up to privacy newsletter
  "ao=-1",  // no privacy tips
  "au=-1",  // it's not okay to ask about experience using DDG
  "ae=d",   // dark theme
  "5=1",    // video playback on DDG
  "psb=-1", // no 'Always private' reminder
  "bj=1",   // hide AI-generated images
  "be=1",   // Search Assist on demand
];

const ai = {
  preferredDuckaiModel: '"203"',
  duckaiCanUseApproxLocation: false,
  duckaiCustomization: JSON.stringify({
    data: {
      userRole: "Professional",
      tone: "Professional",
      length: "Short",
      shouldSeekClarity: true,
    },
  }),
}

if (document.cookie.length < (cookies.join().length / 2)) {
  for (const s of cookies) { document.cookie = s; };
  for (const s of Object.keys(ai)) { window.localStorage[s] = ai[s]; };
}
