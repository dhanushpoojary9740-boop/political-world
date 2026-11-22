# Political World — Party Members & Duties milestone

This changed-files patch adds a persistent named party roster, manual member entry, and individual party-duty assignment.

## Files
- `scripts/world_simulation.gd`: stores member records inside each party, seeds fictional AI member names for legacy parties, adds manual member/duty APIs, and includes roster data in existing party save data.
- `scripts/main.gd`: adds Party > Members and Party > Duties sub-tabs with member entry, roster display, and duty assignment controls.

Party duties are internal organization roles and do not grant government authority. AI-generated member names are fictional. The roster is a named management subset of the party's overall membership count.

## Apply
Extract the changed files into the project root, preserving paths. Replace only the listed files. Keep `project.godot`, scenes, signing material, and save data.

## Test
Run the project, open Party > Members, add a member, assign a duty under Party > Duties, save, then reload and confirm the member and duty persist.
