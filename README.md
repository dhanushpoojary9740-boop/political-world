# Political World — recurring local election foundation

This is a changed-files update for the current Godot project. It keeps the existing UI and save format compatible.

## Replace in this order

1. `scripts/world_simulation.gd`

Keep `project.godot`, `main.tscn`, `scripts/main.gd`, and all other files unchanged.

## Included

- Local elections now recur on a simplified five-year prototype cycle instead of being a one-time event.
- The election screen shows the next scheduled local election and the previous result.
- A local elected mandate continues until the next modeled local election. An incumbent who loses or does not stand loses that office and returns to their party role; they do not retain government authority.
- New election-history fields are saved, and older saves are migrated to a usable upcoming local-election date.

## Scope and realism note

The five-year interval is a game-model placeholder, not a claim that every Indian local-body election follows one uniform term. Municipal, panchayat, state, national, and international systems need separate schedules, jurisdictions, eligibility rules, and authority boundaries. Those are planned as separate layers rather than being represented by one generic election.

## Test on device

1. Replace the file above and run the project.
2. Load your existing save. Confirm the Elections page shows the next local election.
3. Advance to December of the scheduled year. Confirm the result is recorded and the next election date moves five years ahead.
4. If you hold local office, test a later election where you do not stand or lose; confirm the Office tab and government authority are removed.
5. Save, close, and reopen to check that the next election date and previous result persist.

I inspected the source and packaged this update, but I have not run it in the Godot runtime.

## Git commit message

`feat: add recurring local election terms and incumbent transitions`

## Political World shared simulation foundation (Milestone 1)

- Adds a persistent shared world-state layer with separate regional party support for India's 28 states.
- Advances modeled state assembly and Lok Sabha election calendars through the same monthly simulation step.
- Runs rival-party monthly recruitment and operating accounts, regional support drift, and periodic modest member movement between parties.
- If the player does not stand in the recurring local election, the player's party now runs an AI campaign, spends from party funds, and records an AI party win/loss without granting the player an elected office.
- Saves the world-state data in save version 9 and initializes it when loading older saves.

These are initial game-model rules, not real election dates, statutory campaign limits, or official forecasts. The world-state foundation is being expanded in later milestones; this update does not yet implement player-controlled Karnataka state/national campaign decisions, full seat-by-seat election results, government formation, or global diplomacy.
