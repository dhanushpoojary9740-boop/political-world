extends RefCounted
class_name WorldSimulation

const ELECTION_INTERVAL_MONTHS := 7

var year: int = 2026
var month: int = 1
var player_state: String = "Karnataka"
var player_party_id: String = "party_player"
var player_member_id: String = "player"
var parties: Dictionary = {}
var politicians: Dictionary = {}
var election_log: Array[String] = []
var notifications: Array[String] = []

func initialize() -> void:
    parties = {
        "party_player": {
            "name": "People's Progress Party",
            "funds": 25000000,
            "popularity": {"Karnataka": 18.0, "Maharashtra": 4.0, "Kerala": 3.0, "Tamil Nadu": 3.0},
            "members": ["player", "member_1", "member_2", "member_3"],
            "seat_count": {"Karnataka": 0, "Maharashtra": 0, "Kerala": 0, "Tamil Nadu": 0}
        },
        "party_rival": {
            "name": "National Unity Front",
            "funds": 60000000,
            "popularity": {"Karnataka": 32.0, "Maharashtra": 35.0, "Kerala": 28.0, "Tamil Nadu": 25.0},
            "members": ["rival_1", "rival_2", "rival_3", "rival_4"],
            "seat_count": {"Karnataka": 0, "Maharashtra": 0, "Kerala": 0, "Tamil Nadu": 0}
        }
    }

    politicians = {
        "player": {"name": "Player", "party_id": player_party_id, "state": "Karnataka", "is_player": true, "eligible": true},
        "member_1": {"name": "Ananya Rao", "party_id": player_party_id, "state": "Karnataka", "is_player": false, "eligible": true},
        "member_2": {"name": "Kiran Shetty", "party_id": player_party_id, "state": "Karnataka", "is_player": false, "eligible": true},
        "member_3": {"name": "Meera Nair", "party_id": player_party_id, "state": "Maharashtra", "is_player": false, "eligible": true},
        "rival_1": {"name": "Arjun Desai", "party_id": "party_rival", "state": "Karnataka", "is_player": false, "eligible": true},
        "rival_2": {"name": "Nisha Menon", "party_id": "party_rival", "state": "Maharashtra", "is_player": false, "eligible": true},
        "rival_3": {"name": "Dev Patel", "party_id": "party_rival", "state": "Kerala", "is_player": false, "eligible": true},
        "rival_4": {"name": "Sanjay Kumar", "party_id": "party_rival", "state": "Tamil Nadu", "is_player": false, "eligible": true}
    }

func date_label() -> String:
    return "%s %d" % [_month_name(month), year]

func _month_name(value: int) -> String:
    var names := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    return names[clampi(value - 1, 0, 11)]

func advance_month() -> Array[String]:
    notifications.clear()
    month += 1
    if month > 12:
        month = 1
        year += 1

    _simulate_monthly_party_growth()
    if month == 7:
        _run_election_cycle()
    if notifications.is_empty():
        notifications.append("The month advanced. AI party units completed routine administration.")
    return notifications.duplicate()

func _simulate_monthly_party_growth() -> void:
    for party_id in parties.keys():
        var party: Dictionary = parties[party_id]
        var popularity: Dictionary = party["popularity"]
        for state in popularity.keys():
            var current: float = float(popularity[state])
            var drift := 0.12 if party_id == player_party_id and state == player_state else 0.04
            popularity[state] = clampf(current + drift, 0.0, 100.0)
        party["popularity"] = popularity
        party["funds"] = int(party["funds"]) + 250000

func _run_election_cycle() -> void:
    notifications.append("Election month: AI units organized campaigns across all simulated states.")
    for state in ["Karnataka", "Maharashtra", "Kerala", "Tamil Nadu"]:
        var candidate_id := _find_candidate_for_state(player_party_id, state)
        if state == player_state and candidate_id == player_member_id:
            notifications.append("You were automatically registered as your party's candidate in Karnataka.")
        elif candidate_id != "":
            notifications.append("%s selected %s for %s." % [parties[player_party_id]["name"], politicians[candidate_id]["name"], state])
        else:
            notifications.append("AI could not find an eligible candidate for %s." % state)

        _resolve_state_election(state)

func _find_candidate_for_state(party_id: String, state: String) -> String:
    var party: Dictionary = parties.get(party_id, {})
    for member_id in party.get("members", []):
        var politician: Dictionary = politicians.get(member_id, {})
        if politician.get("state", "") == state and politician.get("eligible", false):
            return member_id
    return ""

func _resolve_state_election(state: String) -> void:
    var player_party: Dictionary = parties[player_party_id]
    var rival_party: Dictionary = parties["party_rival"]
    var player_score := float(player_party["popularity"].get(state, 0.0))
    var rival_score := float(rival_party["popularity"].get(state, 0.0))
    var won := player_score >= rival_score
    var winner_id := player_party_id if won else "party_rival"
    var winner_name: String = parties[winner_id]["name"]
    player_party["seat_count"][state] = 1 if won else 0
    rival_party["seat_count"][state] = 0 if won else 1
    election_log.append("%s election (%s): %s won the simulated seat." % [date_label(), state, winner_name])
    notifications.append("%s result: %s won the simulated seat." % [state, winner_name])

func party_summary() -> String:
    var party: Dictionary = parties[player_party_id]
    return "%s\nParty funds: ₹%s\nMembers: %d\nKarnataka popularity: %.1f%%" % [
        party["name"],
        _format_money(int(party["funds"])),
        party["members"].size(),
        float(party["popularity"]["Karnataka"])
    ]

func _format_money(amount: int) -> String:
    return "%s" % amount
