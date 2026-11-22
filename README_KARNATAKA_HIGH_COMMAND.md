# Karnataka High Command milestone

This patch adds a basic Karnataka-only campaign command panel to the Elections tab:

- Review/approve the AI-prepared state-level campaign slate. Until approved, the player's party does not spend its Karnataka campaign budget.
- Set a monthly campaign spending plan (capped at ₹200,000 and actual available party funds).
- Select a campaign priority. A non-balanced priority adds a small modeled campaign score bonus for the player's party in Karnataka.
- Other state and Lok Sabha AI campaign operations remain autonomous.

## Scope and limitations

The current election model is state-level, not constituency-by-constituency. This patch does not yet provide a candidate-by-candidate review list, constituency assignment, or individual election-duty assignment. The approval control is a state-level campaign-slate approval gate, not a list of candidate decisions. Godot runtime validation was not available in this environment; please import and run the project in Godot 4.7.2 and share any error screenshot.
