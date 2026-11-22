# Political World — Election Engine milestone

Changed files only. Apply to the current project after the World Simulation Foundation update.

## Replace in this order
1. `political-world-main/scripts/world_simulation.gd`

Keep `project.godot`, `main.tscn`, `scripts/main.gd`, your signing key, and save data unchanged.

## Included
- Adds three-month AI campaign windows for modeled state assembly and Lok Sabha elections.
- AI parties spend only from their own party funds, within a monthly campaign cap.
- Resolves election results into modeled party vote shares and seat totals using a largest-remainder allocation.
- Stores election history, seat results, campaign phase, turnout estimate, and last result in the existing world-state save.
- Feeds election performance back into state-level support or national party popularity.
- Uses recognized state assembly seat counts and the 543-seat Lok Sabha model.
- Migrates older world-state data by adding missing election fields and calendars.

## Scope
This milestone is an election simulation layer, not a full official election model. Constituency-level first-past-the-post contests, nomination screens, player-controlled Karnataka high-command decisions, coalition formation, and office appointment are not included yet. Election schedules remain explicitly modeled game dates rather than official dates. Election results do not directly grant the player an office.

## Test
1. Replace the file listed above.
2. Run the project in Godot and advance month by month toward the next listed state or Lok Sabha election.
3. Confirm the campaign phase appears in Overview, party funds decrease during campaign months, and a result is recorded in the monthly report.
4. Save and reload after a campaign month and after an election result.

The patch was prepared from the supplied source ZIP. It has not been run in Godot; verify in the editor/device before treating it as runtime-tested.

## Git commit message
`feat: add AI campaign phases and modeled election seat results`
