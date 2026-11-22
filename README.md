# Political World — Milestone 2 replacement files

This package contains only the files changed for the new from-zero political career start.

## Replace these files in your existing project, in this order

1. `scripts/world_simulation.gd`
2. `scripts/main.gd`

Keep the existing `project.godot`, `main.tscn`, and all other project files unchanged.

## What this update changes
- Starts as an ordinary citizen in Karnataka with no party or office.
- Character setup: name, age, hometown.
- Choose to join an established party or found a new party.
- Joining starts as a volunteer; founding starts with five supporters and limited party funds.
- Adds initial political activities: volunteer, community service, party meeting, recruit a member.
- Monthly progression, experience, reputation, personal funds, party membership, and party funds.

This is still a prototype: election registration, local elections, promotions, government formation, party switching, and full save persistence are not implemented in this milestone.

## Test
Run the main scene. Enter a character name and hometown. Choose one of the two political paths. Try an activity, then advance a month.

## Git commit message
`feat: start Political World from grassroots political career`
