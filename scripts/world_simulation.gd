extends RefCounted
class_name WorldSimulation

const LOCAL_ELECTION_MONTH := 12
const ACTIVE_WORKER_XP := 6
const ACTIVE_WORKER_REPUTATION := 1.5
const LOCAL_LEADER_XP := 16
const LOCAL_LEADER_REPUTATION := 5.0
const LOCAL_LEADER_RELATIONSHIP := 8.0
const TICKET_XP := 12
const TICKET_REPUTATION := 3.0
const TICKET_RELATIONSHIP := 5.0

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
var career_rank: String = "Ordinary citizen"
var personal_funds: int = 50000
var experience: int = 0
var reputation: float = 0.0
var local_leader_relationship: float = 0.0
var campaign_effort: float = 0.0
var ticket_requested: bool = false
var ticket_approved: bool = false
var local_candidate_selected: bool = false
var local_election_completed: bool = false
var local_election_year: int = 2026
var local_election_result: String = ""
var election_vote_share: float = 0.0
var election_turnout: int = 0
var has_elected_office: bool = false
var elected_office_name: String = ""
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

    if path != "join" and path != "found":
        notifications = ["Choose a valid political path."]
        return false

    var clean_party_name := party_name.strip_edges()
    if path == "found" and clean_party_name.is_empty():
        notifications = ["Enter a name for your new political party."]
        return false

    character_name = clean_name
    character_age = clampi(age, 18, 90)
    home_city = clean_city
    career_path = path
    career_started = true
    experience = 0
    reputation = 0.0
    personal_funds = 50000
    local_leader_relationship = 2.0
    campaign_effort = 0.0
    ticket_requested = false
    ticket_approved = false
    local_candidate_selected = false
    local_election_completed = false
    local_election_year = year
    local_election_result = ""
    election_vote_share = 0.0
    election_turnout = 0
    has_elected_office = false
    elected_office_name = ""

    if path == "join":
        player_party_id = "party_established"
        player_role = "Party volunteer"
        career_rank = "Party volunteer"
        notifications = ["You joined People's Unity Party as a volunteer in %s, Karnataka. You have no elected office." % home_city]
    else:
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
        career_rank = "Party founder"
        local_leader_relationship = 5.0
        notifications = ["You founded %s with five initial supporters. Founding a party gives you organizational responsibility, not an elected office." % clean_party_name]
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
            campaign_effort += 1.5
            _increase_party_popularity(0.15)
            notifications.append("You worked on a local campaign. Experience +2; reputation and campaign experience improved.")
        "community":
            experience += 2
            reputation += 0.7
            personal_funds = maxi(0, personal_funds - 800)
            _increase_party_popularity(0.25)
            notifications.append("You organized a community service event in %s. Experience +2; local reputation improved." % home_city)
        "meeting":
            experience += 1
            reputation += 0.2
            local_leader_relationship = minf(100.0, local_leader_relationship + 2.0)
            notifications.append("You attended a party meeting. Experience +1; your relationship with local leadership improved.")
        "recruit":
            var party: Dictionary = parties[player_party_id]
            if int(party["members"]) < 100000:
                party["members"] = int(party["members"]) + 1
                party["funds"] = int(party["funds"]) + 500
                parties[player_party_id] = party
                experience += 1
                _increase_party_popularity(0.05)
                notifications.append("You recruited one new party member. Membership and party funds increased slightly.")
            else:
                notifications.append("The local recruitment limit has been reached in this prototype.")
        "request_ticket":
            _request_local_ticket()
        "campaign":
            _run_local_campaign()
        _:
            notifications.append("That activity is not available.")

    _check_promotion()
    return notifications.duplicate()

func _request_local_ticket() -> void:
    if local_election_completed:
        notifications.append("The current local election has already concluded.")
        return
    if ticket_requested:
        notifications.append("Your local election ticket application is already under review.")
        return
    ticket_requested = true
    var eligible := experience >= TICKET_XP and reputation >= TICKET_REPUTATION and local_leader_relationship >= TICKET_RELATIONSHIP
    if eligible:
        ticket_approved = true
        local_candidate_selected = true
        notifications.append("Your party approved your local election ticket. You are now its candidate for the scheduled local election.")
    else:
        ticket_requested = false
        notifications.append("Your ticket application was reviewed but not approved. You may apply again after improving your experience, reputation, and relationship with local leadership. Requirements: %d experience, %.1f reputation, and %.1f relationship." % [TICKET_XP, TICKET_REPUTATION, TICKET_RELATIONSHIP])

func _run_local_campaign() -> void:
    if not local_candidate_selected:
        notifications.append("You cannot campaign as a candidate without an approved party ticket.")
        return
    if local_election_completed:
        notifications.append("The local election has already concluded.")
        return
    if personal_funds < 300:
        notifications.append("You do not have enough personal funds for this campaign activity.")
        return
    personal_funds -= 300
    campaign_effort += 2.0
    reputation += 0.25
    notifications.append("You campaigned in your local constituency. Campaign effort and public reputation improved.")

func _check_promotion() -> void:
    if career_path == "join" and career_rank == "Party volunteer" and experience >= ACTIVE_WORKER_XP and reputation >= ACTIVE_WORKER_REPUTATION:
        career_rank = "Active Party Worker"
        player_role = career_rank
        notifications.append("Promotion: local party leadership recognized your work. You are now an Active Party Worker.")
    elif career_path == "join" and career_rank == "Active Party Worker" and experience >= LOCAL_LEADER_XP and reputation >= LOCAL_LEADER_REPUTATION and local_leader_relationship >= LOCAL_LEADER_RELATIONSHIP:
        career_rank = "Local Party Leader"
        player_role = career_rank
        notifications.append("Promotion: you became a Local Party Leader. This is a party position, not an elected government office.")

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
            notifications.append("AI local unit completed routine administration and recruited two members.")
        if month == LOCAL_ELECTION_MONTH and not local_election_completed:
            _resolve_local_election()
        if notifications.is_empty():
            notifications.append("You continued building your political career. Your next opportunities depend on experience, reputation, relationships, and party standing.")
    else:
        notifications.append("The calendar advanced. Your political career has not started.")
    return notifications.duplicate()

func _resolve_local_election() -> void:
    # Resolve the scheduled local election once. Party roles do not grant government authority.
    election_turnout = randi_range(5500, 7500)

    if local_candidate_selected and ticket_approved:
        var party: Dictionary = parties[player_party_id]
        var party_popularity: float = float(party["popularity"])
        var membership_strength: float = log(maxf(1.0, float(party["members"]))) / log(10.0)
        var candidate_score: float = (
            party_popularity * 1.2
            + reputation * 1.8
            + campaign_effort * 2.0
            + local_leader_relationship * 0.35
            + membership_strength * 2.4
        )
        var rival_score: float = 24.0 + randf_range(-5.0, 5.0)
        election_vote_share = clampf(50.0 + (candidate_score - rival_score) * 1.6, 5.0, 95.0)
        var candidate_votes: int = roundi(float(election_turnout) * election_vote_share / 100.0)
        var rival_votes: int = election_turnout - candidate_votes

        if candidate_votes > rival_votes:
            has_elected_office = true
            elected_office_name = "Local elected representative"
            player_role = elected_office_name
            career_rank = elected_office_name
            local_election_result = "WON"
            notifications.append(
                "ELECTION RESULT — WON. You received %s of %s votes (%.1f%%) with %d%% turnout. You are now a Local elected representative. Your authority is limited to this elected office." % [
                    _format_number(candidate_votes), _format_number(election_turnout),
                    election_vote_share, roundi(float(election_turnout) / 100.0)
                ]
            )
        else:
            local_election_result = "LOST"
            notifications.append(
                "ELECTION RESULT — LOST. You received %s of %s votes (%.1f%%); the rival candidate won with %s votes. You remain in your party role and receive no elected-office authority." % [
                    _format_number(candidate_votes), _format_number(election_turnout),
                    election_vote_share, _format_number(rival_votes)
                ]
            )
    else:
        local_election_result = "NOT A CANDIDATE"
        election_vote_share = 0.0
        notifications.append(
            "LOCAL ELECTION RESULT. The election took place and your party's AI organization handled its campaign. You were not an approved candidate and gained no elected office."
        )

    local_election_completed = true
    local_candidate_selected = false
    ticket_approved = false
    ticket_requested = false

func _increase_party_popularity(amount: float) -> void:
    if player_party_id == "" or not parties.has(player_party_id):
        return
    var party: Dictionary = parties[player_party_id]
    party["popularity"] = minf(100.0, float(party["popularity"]) + amount)
    parties[player_party_id] = party

func career_summary() -> String:
    if not career_started:
        return "You have not entered politics yet."
    return "%s, age %d\n%s, Karnataka\nCareer rank: %s\nExperience: %d  •  Reputation: %.1f\nLeadership relationship: %.1f\nPersonal funds: ₹%s" % [
        character_name, character_age, home_city, career_rank, experience, reputation,
        local_leader_relationship, _format_number(personal_funds)
    ]

func party_summary() -> String:
    if not career_started or player_party_id == "" or not parties.has(player_party_id):
        return "No party membership\nYou are an ordinary citizen."
    var party: Dictionary = parties[player_party_id]
    return "%s\nRole: %s\nMembers: %s\nParty funds: ₹%s\nParty popularity: %.1f%%" % [
        party["name"], player_role, _format_number(int(party["members"])),
        _format_number(int(party["funds"])), float(party["popularity"])
    ]

func election_summary() -> String:
    if local_election_completed:
        if local_election_result == "WON":
            return "Local election: completed (%d)\\nResult: WON — %.1f%% of votes\\nElected office: %s" % [
                local_election_year, election_vote_share, elected_office_name
            ]
        if local_election_result == "LOST":
            return "Local election: completed (%d)\\nResult: LOST — %.1f%% of votes\\nNo elected office or government authority." % [
                local_election_year, election_vote_share
            ]
        return "Local election: completed (%d)\\nYou were not an approved candidate." % local_election_year
    if local_candidate_selected:
        return "Local election: December %d\\nYour party ticket is approved. Campaigning is open." % local_election_year
    if ticket_requested:
        return "Local election: December %d\\nYour ticket application is under review." % local_election_year
    return "Local election: December %d\\nApply for a party ticket when you meet the eligibility requirements."

func _format_number(value: int) -> String:
    return str(value)


const SAVE_PATH := "user://political_world_save.json"

func save_game() -> bool:
    var save_data: Dictionary = {
        "save_version": 2,
        "year": year,
        "month": month,
        "character_name": character_name,
        "character_age": character_age,
        "home_state": home_state,
        "home_city": home_city,
        "career_started": career_started,
        "career_path": career_path,
        "player_party_id": player_party_id,
        "player_role": player_role,
        "career_rank": career_rank,
        "personal_funds": personal_funds,
        "experience": experience,
        "reputation": reputation,
        "local_leader_relationship": local_leader_relationship,
        "campaign_effort": campaign_effort,
        "ticket_requested": ticket_requested,
        "ticket_approved": ticket_approved,
        "local_candidate_selected": local_candidate_selected,
        "local_election_completed": local_election_completed,
        "local_election_year": local_election_year,
        "local_election_result": local_election_result,
        "election_vote_share": election_vote_share,
        "election_turnout": election_turnout,
        "has_elected_office": has_elected_office,
        "elected_office_name": elected_office_name,
        "party_counter": party_counter,
        "parties": parties
    }
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(JSON.stringify(save_data))
    file.close()
    return true

func load_game() -> bool:
    if not FileAccess.file_exists(SAVE_PATH):
        return false
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return false
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    file.close()
    if typeof(parsed) != TYPE_DICTIONARY or not bool(parsed.get("career_started", false)):
        return false

    year = int(parsed.get("year", 2026))
    month = clampi(int(parsed.get("month", 1)), 1, 12)
    character_name = str(parsed.get("character_name", "New Politician"))
    character_age = int(parsed.get("character_age", 25))
    home_state = str(parsed.get("home_state", "Karnataka"))
    home_city = str(parsed.get("home_city", "Brahmavara"))
    career_started = bool(parsed.get("career_started", false))
    career_path = str(parsed.get("career_path", ""))
    player_party_id = str(parsed.get("player_party_id", ""))
    player_role = str(parsed.get("player_role", "Ordinary citizen"))
    career_rank = str(parsed.get("career_rank", "Ordinary citizen"))
    personal_funds = int(parsed.get("personal_funds", 50000))
    experience = int(parsed.get("experience", 0))
    reputation = float(parsed.get("reputation", 0.0))
    local_leader_relationship = float(parsed.get("local_leader_relationship", 0.0))
    campaign_effort = float(parsed.get("campaign_effort", 0.0))
    ticket_requested = bool(parsed.get("ticket_requested", false))
    ticket_approved = bool(parsed.get("ticket_approved", false))
    local_candidate_selected = bool(parsed.get("local_candidate_selected", false))
    local_election_completed = bool(parsed.get("local_election_completed", false))
    local_election_year = int(parsed.get("local_election_year", year))
    local_election_result = str(parsed.get("local_election_result", ""))
    election_vote_share = float(parsed.get("election_vote_share", 0.0))
    election_turnout = int(parsed.get("election_turnout", 0))
    has_elected_office = bool(parsed.get("has_elected_office", false))
    elected_office_name = str(parsed.get("elected_office_name", ""))
    party_counter = int(parsed.get("party_counter", 0))
    var saved_parties: Variant = parsed.get("parties", {})
    if typeof(saved_parties) == TYPE_DICTIONARY and not saved_parties.is_empty():
        parties = saved_parties
    notifications = ["Saved career loaded."]
    return true
