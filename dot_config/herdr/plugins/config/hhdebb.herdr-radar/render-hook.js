'use strict';

// herdr-radar render hook (garuda): a two-line Agents entry.
//
//   line 1  `$badge_<state>`: topic icon + duration
//   line 2  `$line2_<state>`: INDENT + radar's state mark + the title
//
// Radar cannot draw this itself: it only indents its state mark when the row
// has no logo (lib/state.js composeLine), and it has no token for the badge.
// So title() hands radar an empty title (radar then publishes no `$title_*`
// and no title frames), and this hook paints both lines. It runs inside the
// radar daemon, so it reuses radar's own modules: the spinner frames, the
// blocked pulse and the state glyphs (same font, same timing, since radar's
// spin step is wall-clock based) and the socket writer (no process spawn per
// frame). Radar keeps scheduling 150 ms frames while a pane works
// (lib/frame.js paneJobs), and every frame calls state().
//
// It also reports the title as pane metadata, which herdr's pane border label
// needs (see TITLE_SOURCE), and names tabs after their sessions (syncTabs).
// Radar swallows anything a hook throws, so failures go to LOG instead.
// Radar's `trim_group_prefix` and `row_label` do not apply to line 2.
//
// Duration: while working, how long the current turn has run; otherwise, how
// long since the last turn. A daemon restart mid-turn restarts the turn clock.

const crypto = require('node:crypto');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const radar = (name) => require(path.join(process.env.HERDR_PLUGIN_ROOT, 'lib', name));
const { FRAMES } = radar('config');
const { stateGlyph, blockedFrame } = radar('logos');
const { SPIN_MS } = radar('frame');
const { reportMetadataAsync } = radar('herdr');
const ipc = radar('ipc');

const SOURCE = 'garuda.badge';
// Pane border label: herdr shows a reported metadata title first, then a
// manual pane name, then the agent name (src/terminal/state.rs border_label);
// the terminal title is not used. Guarded by `agent`, so the label goes away
// when the agent leaves the pane (src/terminal/metadata.rs guards).
const TITLE_SOURCE = 'garuda.title';
const STATES = ['working', 'done', 'blocked', 'idle_fresh', 'idle', 'idle_stale', 'unknown'];
// Herdr already indents continuation rows by 3 (src/client/shell/agent_sidebar.rs)
// and trims leading whitespace off token values; the zero-width space in front
// survives the trim, as in radar's own INDENT (lib/state.js).
const INDENT = '\u200B  ';
const LOG_EVERY_MS = 60000;
const STATE_DIR = path.join(process.env.XDG_STATE_HOME || path.join(os.homedir(), '.local', 'state'), 'herdr');
const LOG = path.join(STATE_DIR, 'radar-render-hook.log');

// Tab names: the most active session in the tab (working, then blocked, then
// most recent turn) plus "+N" for the others, at most TAB_MAX characters.
// Overwrites any name while a session runs. herdr cannot clear a custom tab
// name (src/workspace/tab.rs set_custom_name), so a tab whose sessions are
// gone gets its position written back (what herdr shows for an unnamed tab)
// and kept in step with it until someone renames it by hand. Which tabs this hook named survives restarts in
// TABS_FILE, one per herdr server (tab ids are per server).
const TAB_SYNC_MS = 3000;
const TAB_MAX = 24;
const ELLIPSIS = String.fromCodePoint(0x2026);
const SOCKET = process.env.HERDR_SOCKET_PATH || '';
const TABS_FILE = path.join(
  STATE_DIR,
  `radar-render-hook-tabs-${crypto.createHash('sha1').update(SOCKET).digest('hex').slice(0, 8)}.json`,
);

// Nerd Font icons, first match against the title wins.
const RULES = [
  [/bug|\bfix|debug|error|crash|stutter/i, '\u{F188}'], // fa-bug
  [/\btest/i, '\u{F0668}'], // md-test_tube
  [/review|audit|pr\u00FCf|\bcheck\b/i, '\u{F002}'], // fa-search
  [/recherche|research|explor|analy/i, '\u{F46B}'], // oct-telescope
  [/notiz|\bnotes?\b|\bdocs?\b|readme|changelog|cheat ?sheet/i, '\u{F4C1}'], // oct-note
  [/\bgit\b|commit|branch|merge|rebase/i, '\u{E725}'], // dev-git_branch
  [/docker|container|\bk8s\b|kube/i, '\u{F308}'], // linux-docker
  [/hypr|noctalia|waybar|wallpaper/i, '\u{F359}'], // linux-hyprland
  [/design|theme|farbe|colou?r|\bui\b/i, '\u{F03D8}'], // md-palette
  [/herdr|kitty|\bzsh\b|shell|terminal|tmux/i, '\u{F489}'], // oct-terminal
  [/config|konfig|setup|install|chezmoi|paket/i, '\u{F0AD}'], // fa-wrench
  [/netz|network|\bwan\b|\bdns\b|\bssh\b/i, '\u{F0317}'], // md-lan
  [/security|\bauth|secret|permission/i, '\u{F132}'], // fa-shield
  [/perf|latenc|\bslow|speed/i, '\u{F04C5}'], // md-speedometer
  [/claude|agent|skill|\bhooks?\b|\bmcp\b|prompt/i, '\u{F06A9}'], // md-robot
  [/refactor|cleanup|aufr\u00E4um/i, '\u{F00E2}'], // md-broom
  [/feature|implement|build|\badd\b|\bneu/i, '\u{F427}'], // oct-rocket
];

function iconFor(title) {
  const rule = RULES.find(([pattern]) => pattern.test(title ?? ''));
  return rule ? rule[1] : '';
}

function age(ms) {
  const minutes = Math.floor(ms / 60000);
  if (minutes < 1) return '<1m';
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h`;
  return `${Math.floor(hours / 24)}d`;
}

// Radar's mark in front of a title (lib/state.js composeLine): motion for the
// two live states, a glyph for the two events, nothing for the idle tiers.
function mark(display, step) {
  if (display === 'working') return FRAMES[step % FRAMES.length];
  if (display === 'blocked') return blockedFrame(step);
  if (display === 'done' || display === 'unknown') return stateGlyph(display);
  return '';
}

function log(message) {
  try {
    fs.mkdirSync(path.dirname(LOG), { recursive: true });
    fs.appendFileSync(LOG, `${new Date().toISOString()} ${message}\n`);
  } catch {
    // Nowhere left to report to.
  }
}

// pane id -> { title, agent, state, turnStart, lastWorked, sent, inflight,
//              titleSent, titleInflight, loggedAt }
const panes = new Map();

function paneInfo(paneId) {
  if (!panes.has(paneId)) panes.set(paneId, { sent: {} });
  return panes.get(paneId);
}

function tokensFor(info, display, now) {
  const since = display === 'working' ? info.turnStart : info.lastWorked;
  const duration = typeof since === 'number' ? age(now - since) : '';
  const badge = [iconFor(info.title), duration].filter(Boolean).join(' ');
  const lead = mark(display, Math.floor(now / SPIN_MS));
  const line2 = info.title ? INDENT + (lead ? `${lead} ` : '') + info.title : '';
  const tokens = {};
  for (const state of STATES) {
    tokens[`badge_${state}`] = state === display && badge ? badge : null;
    tokens[`line2_${state}`] = state === display && line2 ? line2 : null;
  }
  return tokens;
}

// Sends only what differs from the last confirmed write, one write in flight
// per pane; a frame that finds one in flight is skipped and the next frame
// sends the then-current delta.
function publish(paneId, tokens, now) {
  const info = paneInfo(paneId);
  if (info.inflight) return;
  const delta = {};
  for (const [name, value] of Object.entries(tokens)) {
    if ((info.sent[name] ?? null) !== value) delta[name] = value;
  }
  if (Object.keys(delta).length === 0) return;
  info.inflight = true;
  reportMetadataAsync(paneId, SOURCE, delta)
    .then((ok) => {
      if (ok) Object.assign(info.sent, delta);
      else logRateLimited(info, now, `${paneId}: report failed for ${Object.keys(delta).join(',')}`);
    })
    .catch((error) => log(`${paneId}: ${error?.stack ?? error}`))
    .finally(() => {
      info.inflight = false;
    });
}

function logRateLimited(info, now, message) {
  if (now - (info.loggedAt ?? 0) < LOG_EVERY_MS) return;
  info.loggedAt = now;
  log(message);
}

// The session title as the pane's metadata title, sent when it or the agent
// changes. A pane that is already gone counts as done, as in radar.
function reportTitle(paneId, info, now) {
  const key = `${info.agent}\0${info.title}`;
  if (!info.title || info.titleSent === key || info.titleInflight) return;
  info.titleInflight = true;
  ipc
    .call('pane.report_metadata', {
      pane_id: paneId,
      source: TITLE_SOURCE,
      agent: info.agent || undefined,
      title: info.title,
    })
    .then((reply) => {
      if (reply && (!reply.error || reply.error.code === 'pane_not_found')) info.titleSent = key;
      else logRateLimited(info, now, `${paneId}: title report failed: ${JSON.stringify(reply?.error ?? null)}`);
    })
    .catch((error) => log(`${paneId}: ${error?.stack ?? error}`))
    .finally(() => {
      info.titleInflight = false;
    });
}

// tab id -> the label this hook last gave it
const managedTabs = loadManagedTabs();
let syncing = false;
let syncLoggedAt = 0;

function loadManagedTabs() {
  try {
    return new Map(Object.entries(JSON.parse(fs.readFileSync(TABS_FILE, 'utf8'))));
  } catch (error) {
    if (error.code !== 'ENOENT') log(`tabs: cannot read ${TABS_FILE}: ${error.message}`);
    return new Map();
  }
}

function saveManagedTabs() {
  try {
    fs.mkdirSync(STATE_DIR, { recursive: true });
    fs.writeFileSync(TABS_FILE, JSON.stringify(Object.fromEntries(managedTabs)));
  } catch (error) {
    log(`tabs: cannot write ${TABS_FILE}: ${error.message}`);
  }
}

function truncate(text, max) {
  const chars = Array.from(text);
  return chars.length <= max ? text : chars.slice(0, max - 1).join('').trimEnd() + ELLIPSIS;
}

function activityRank(info) {
  return info.state === 'working' ? 2 : info.state === 'blocked' ? 1 : 0;
}

// sessions: [{ title, info }] of one tab
function tabLabel(sessions) {
  const [top] = [...sessions].sort(
    (a, b) => activityRank(b.info) - activityRank(a.info) || (b.info.lastWorked ?? 0) - (a.info.lastWorked ?? 0),
  );
  const suffix = sessions.length > 1 ? ` +${sessions.length - 1}` : '';
  return truncate(top.title, TAB_MAX - suffix.length) + suffix;
}

async function syncTabs() {
  const [paneReply, tabReply] = await Promise.all([ipc.call('pane.list', {}), ipc.call('tab.list', {})]);
  if (!paneReply?.result?.panes || !tabReply?.result?.tabs) {
    const now = Date.now();
    if (now - syncLoggedAt >= LOG_EVERY_MS) {
      syncLoggedAt = now;
      log(`tabs: list failed: ${JSON.stringify(paneReply?.error ?? tabReply?.error ?? null)}`);
    }
    return;
  }
  const sessionsByTab = new Map();
  for (const pane of paneReply.result.panes) {
    if (!pane.agent) continue;
    const info = panes.get(pane.pane_id) ?? {};
    const title = info.title || pane.terminal_title_stripped || pane.title || pane.agent;
    if (!sessionsByTab.has(pane.tab_id)) sessionsByTab.set(pane.tab_id, []);
    sessionsByTab.get(pane.tab_id).push({ title, info });
  }
  // herdr's automatic label is the tab's position in its workspace; `number`
  // is the stable id number (src/app/creation.rs tab_info), not what it shows.
  const counts = new Map();
  const position = new Map();
  for (const tab of tabReply.result.tabs) {
    counts.set(tab.workspace_id, (counts.get(tab.workspace_id) ?? 0) + 1);
    position.set(tab.tab_id, counts.get(tab.workspace_id));
  }
  let changed = false;
  const live = new Set();
  for (const tab of tabReply.result.tabs) {
    live.add(tab.tab_id);
    const sessions = sessionsByTab.get(tab.tab_id);
    const ours = managedTabs.get(tab.tab_id);
    let want;
    if (sessions) want = tabLabel(sessions);
    else if (ours !== undefined && tab.label === ours) want = String(position.get(tab.tab_id));
    else {
      // Renamed by hand since, or never ours: leave it alone.
      if (ours !== undefined) changed = managedTabs.delete(tab.tab_id) || changed;
      continue;
    }
    if (tab.label !== want) {
      const reply = await ipc.call('tab.rename', { tab_id: tab.tab_id, label: want });
      if (!reply || reply.error) {
        log(`tabs: rename ${tab.tab_id} failed: ${JSON.stringify(reply?.error ?? null)}`);
        continue;
      }
    }
    if (ours !== want) {
      managedTabs.set(tab.tab_id, want);
      changed = true;
    }
  }
  for (const id of managedTabs.keys()) {
    if (!live.has(id)) changed = managedTabs.delete(id) || changed;
  }
  if (changed) saveManagedTabs();
}

setInterval(() => {
  if (syncing) return;
  syncing = true;
  syncTabs()
    .catch((error) => log(`tabs: ${error?.stack ?? error}`))
    .finally(() => {
      syncing = false;
    });
}, TAB_SYNC_MS).unref();

function title(text, paneId) {
  paneInfo(paneId).title = text;
  return '';
}

function agent(name, paneId) {
  paneInfo(paneId).agent = name;
  return name;
}

function activity(at, paneId) {
  paneInfo(paneId).lastWorked = at;
  return at;
}

function state(display, paneId) {
  const info = paneInfo(paneId);
  const now = Date.now();
  if (display === 'working' && info.state !== 'working') info.turnStart = now;
  info.state = display;
  publish(paneId, tokensFor(info, display, now), now);
  reportTitle(paneId, info, now);
  return display;
}

module.exports = { title, agent, activity, state, iconFor, age, mark, tabLabel, syncTabs };
