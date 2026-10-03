# Designer: Inkscape

Applies when working with Inkscape or `.svg` files.

## Rules
- Do all SVG work through the `inkscape_mcp` tools; no hand-written SVG, no inkscape CLI.
- Live first: work in the user's open Inkscape window (`inkscape_live`) so they can watch.
  Check with `ping`; `desclaude` starts Inkscape in parallel, so retry for a few seconds.
  If the bridge stays down, use the headless MCP tools and tell the user.
- Export a PNG so you know what it looks like, and Read it before saying "done":
  live via `inkscape_live` `rasterize` with payload `{"filename": "<abs path>/preview/<name>.png"}`,
  headless via `inkscape_file` `convert`. Create `preview/` first; the export does not.
- After each export, give the user a clickable `file://` link to the PNG.
