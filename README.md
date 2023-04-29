# Journal

This is an ongoing attempt to replicate <750words.com> locally. Mainly for privacy,
but also because using `$EDITOR` is better than typing in a browser.

Just run  `./750.sh` (requires `zellij` and `helix`)

## What it does for now

- create today's file if it doesn't exist yet
- open a zellij layout with two panes
  - today's file in `hx` (not `$EDITOR` for now)
  - `watch` displaying the current word count

## What I'd like it to do

- work with `$EDITOR`
- record events in a sqlite table (file creation timestamp, completion timestamp)
- compute streaks and rewards based on events
- perform sentiment analysis and keyword / theme extraction on text