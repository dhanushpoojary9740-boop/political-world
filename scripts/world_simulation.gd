extends RefCounted
class_name WorldSimulation

var year: int = 2026
var month: int = 1
var character_name: String = "New Politician"
var character_age: int = 25
var home_state: String = "Karnataka"
var home_city: String = "Brahmavara"
var career_started: bool = false
var career_path: String = ""
var player_party_id: String = ""
var player_role: String = "Ordinary citizen"
var personal_funds: int = 50000
var experience: int = 0
var reputation: float = 0.0
var party_counter: int = 0
var parties: Dictionary = {}
var notifications: Array[String] = []

func initialize() -> void:
    parties = {
        "party_established": {
            "name": "People's Unity Party",
            "members": 12500,
            "funds": 25000000,
            "popularity": 24.0,
            "is_player_created": false
        },
        "party_reform": {
            "name": "Progressive Reform Front",
            "members": 7800,
            "funds": 12000000,
            "popularity": 16.0,
            "is_player_created": false
        }
    }

func date_label() -> String:
    return "%s %d" % [_month_name(month), year]

func _month_name(value: int) -> String:
    var names := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    return names[clampi(value - 1, 0, 11)]

func start_career(name: String, age: int, city: String, path: String, party_name: String = "") -> bool:
    var clean_name := name.strip_edges()
    var clean_city := city.strip_edges()
    if clean_name.is_empty() or clean_city.is_empty():
        notifications = ["Enter your character's name and hometown to begin."]
        return false

    character_name = clean_name
    character_age = clampi(age, 18, 90)
    home_city = clean_city
    career_path = path
    career_started = true
    experience = 0
    reputation = 0.0
    personal_funds = 50000

    if path == "join":
        player_party_id = "party_established"
        player_role = "Party volunteer"
        notifications = ["You joined People's Unity Party as a volunteer in %s, Karnataka." % home_city]
    elif path == "found":
        var clean_party_name := party_name.strip_edges()
        if clean_party_name.is_empty():
            career_started = false
            notifications = ["Enter a name for your new political party."]
            return false
        party_counter += 1
        player_party_id = "player_party_%d" % party_counter
        parties[player_party_id] = {
            "name": clean_party_name,
            "members": 5,
            "funds": 25000,
            "popularity": 1.0,
            "is_player_created": true
        }
        player_role = "Party founder"
        notifications = ["You founded %s with five initial supporters. Your party has no elected seats." % clean_party_name]
    else:
        career_started = false
        notifications = ["Choose a valid political path."]
        return false
    return true

func perform_activity(activity: String) -> Array[String]:
    notifications.clear()
    if not career_started:
        notifications.append("Begin your political career first.")
        return notifications.duplicate()

    match activity:
        "volunteer":
            experience += 2
            reputation += 0.4
            personal_funds = maxi(0, personal_funds - 500)
            _increase_party_popularity(0.15)
            notifications.append("You helped organize a local campaign activity. Experience +2; local reputation improved.")
        "community":
            experience += 2
            reputation += 0.7
            personal_funds = maxi(0, personal_funds - 800)
            _increase_party_popularity(0.25)
            notifications.append("You organized a community service event in %s. Experience +2; reputation improved." % home_city)
        "meeting":
            experience += 1
            reputation += 0.2
            notifications.append("You attended a party meeting and built political relationships. Experience +1.")
        "recruit":
            var party: Dictionary = parties[player_party_id]
            if int(party["members"]) < 100000:
                party["members"] = int(party["members"]) + 1
                party["funds"] = int(party["funds"]) + 500
                parties[player_party_id] = party
                experience += 1
                _increase_party_popularity(0.05)
                notifications.append("You recruited one new party member. Party membership and funds increased slightly.")
            else:
                notifications.append("Your party's local recruitment limit has been reached in this prototype.")
        _:
            notifications.append("That activity is not available.")
    return notifications.duplicate()

func advance_month() -> Array[String]:
    notifications.clear()
    month += 1
    if month > 12:
        month = 1
        year += 1

    if career_started:
        personal_funds += 1500
        if month % 3 == 0:
            var party: Dictionary = parties[player_party_id]
            party["members"] = int(party["members"]) + 2
            party["funds"] = int(party["funds"]) + 2000
            party["popularity"] = minf(100.0, float(party["popularity"]) + 0.1)
            parties[player_party_id] = party
            notifications.append("Your party's AI local unit recruited two members and completed routine administration.")
        if experience >= 20 and reputation >= 5.0:
            notifications.append("You have begun building the experience and reputation needed for local party leadership.")
        else:
            notifications.append("You continued building your political career. Your next opportunities depend on experience, reputation, and party standing.")
    else:
        notifications.append("The calendar advanced. Your political career has not started.")
    return notifications.duplicate()

func _increase_party_popularity(amount: float) -> void:
    if player_party_id == "" or not parties.has(player_party_id):
        return
    var party: Dictionary = parties[player_party_id]
    party["popularity"] = minf(100.0, float(party["popularity"]) + amount)
    parties[player_party_id] = party

func party_summary() -> String:
    if not career_started or player_party_id == "" or not parties.has(player_party_id):
        return "No party membership\nYou are an ordinary citizen."
    var party: Dictionary = parties[player_party_id]
    return "%s\nRole: %s\nMembers: %s\nParty funds: ₹%s\nParty popularity: %.1f%%" % [
        party["name"], player_role, _format_number(int(party["members"])),
        _format_number(int(party["funds"])), float(party["popularity"])
    ]

func career_summary() -> String:
    if not career_started:
        return "You have not entered politics yet.\nChoose whether to join an established party or found your own."
    return "%s, age %d\n%s, Karnataka\nExperience: %d  •  Reputation: %.1f\nPersonal funds: ₹%s" % [
        character_name, character_age, home_city, experience, reputation, _format_number(personal_funds)
    ]

func _format_number(value: int) -> String:
    return str(value)
