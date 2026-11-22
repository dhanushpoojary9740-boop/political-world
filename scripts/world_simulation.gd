extends RefCounted
class_name WorldSimulation

const LOCAL_ELECTION_MONTH := 12
const LOCAL_CAMPAIGN_MODEL_BUDGET := 500000 # In-game budget assumption, not a statutory limit.
const CAMPAIGN_ACTION_COST := 5000
const VOLUNTEER_ACTIVITY_COST := 1000
const COMMUNITY_ACTIVITY_COST := 2500
const ACTIVE_WORKER_XP := 6
const ACTIVE_WORKER_REPUTATION := 1.5
const LOCAL_LEADER_XP := 16
const LOCAL_LEADER_REPUTATION := 5.0
const LOCAL_LEADER_RELATIONSHIP := 8.0
const TICKET_XP := 12
const TICKET_REPUTATION := 3.0
const TICKET_RELATIONSHIP := 5.0
const FICTIONAL_AI_NAMES: Array[String] = [
    "Aarav Kulkarni", "Meera Hegde", "Rohan Shetty", "Ananya Rao",
    "Vikram Nayak", "Kavya Bhat", "Nikhil Gowda", "Ishita Desai",
    "Sanjay Menon", "Divya Acharya", "Arjun Patil", "Pooja Kamath"
]


const OFFICE_MISSION_CATALOG := [
    {"department": "Public Works Department (PWD)", "title": "Inspect a damaged road stretch", "detail": "Document the location and condition of a damaged road, then submit a representation requesting technical inspection and repair prioritization.", "action": "proposal", "impact": "infrastructure"},
    {"department": "Rural Development and Panchayat Raj Department", "title": "Follow up on a village drainage complaint", "detail": "Record the affected street and request the Gram Panchayat and engineering staff to inspect the drainage problem.", "action": "issue", "impact": "service"},
    {"department": "Rural Water Supply and Sanitation Department", "title": "Review a drinking-water supply complaint", "detail": "Collect the affected locality and service details, then forward the complaint for a departmental response.", "action": "issue", "impact": "service"},
    {"department": "Health and Family Welfare Department", "title": "Raise a primary health-centre service concern", "detail": "Document the reported service gap and request a response from the appropriate health authority.", "action": "issue", "impact": "service"},
    {"department": "School Education and Literacy Department", "title": "Review a government-school facility request", "detail": "Meet local stakeholders, record the facility concern, and submit it for review by education authorities.", "action": "proposal", "impact": "service"},
    {"department": "Urban Development Department", "title": "Follow up on streetlight maintenance", "detail": "Identify the affected public stretch and seek an update from the municipal body responsible for maintenance.", "action": "issue", "impact": "infrastructure"},
    {"department": "Revenue Department", "title": "Help residents navigate a pending revenue-service request", "detail": "Collect case references with residents' consent and refer them to the appropriate revenue office. Do not promise a particular decision.", "action": "followup", "impact": "trust"},
    {"department": "Women and Child Development Department", "title": "Review access to local welfare services", "detail": "Meet service users and request an official review of access, outreach, or facility concerns.", "action": "proposal", "impact": "service"},
    {"department": "Food, Civil Supplies and Consumer Affairs Department", "title": "Document a public distribution service complaint", "detail": "Record the location and reported issue, then submit it for review by the responsible office.", "action": "issue", "impact": "trust"},
    {"department": "Transport Department", "title": "Review a local public-transport access concern", "detail": "Gather residents' feedback and submit a representation requesting assessment of access, safety, or service frequency.", "action": "proposal", "impact": "infrastructure"},
    {"department": "Karnataka State Pollution Control Board", "title": "Request inspection of a reported pollution concern", "detail": "Record the reported location and nature of the concern, then refer it for inspection by the competent authority.", "action": "issue", "impact": "service"},
    {"department": "Municipal Administration", "title": "Conduct a public grievance meeting", "detail": "Hear residents' concerns, record the main issues, and send a categorized representation to the relevant local offices.", "action": "meeting", "impact": "trust"},
    {"department": "District Administration", "title": "Review pending inter-department follow-ups", "detail": "Check the status of earlier representations and request written updates from the offices concerned.", "action": "followup", "impact": "trust"},
    {"department": "Public Works Department (PWD)", "title": "Review a public-building maintenance request", "detail": "Document the reported maintenance need and request a technical assessment and appropriate administrative action.", "action": "proposal", "impact": "infrastructure"},
    {"department": "Agriculture Department, Government of Karnataka", "title": "Refer a farmer's input-supply concern", "detail": "Record the reported access or supply issue and refer it to the local agriculture office for verification and guidance.", "action": "issue", "impact": "service"},
    {"department": "Department of Animal Husbandry and Veterinary Services", "title": "Follow up on veterinary-service access", "detail": "Document the affected area and request the local veterinary office to review service availability.", "action": "issue", "impact": "service"},
    {"department": "Karnataka State Road Transport Corporation (KSRTC)", "title": "Submit a public-bus service representation", "detail": "Collect commuter feedback on a route, stop, or schedule and request a service review from the corporation.", "action": "proposal", "impact": "infrastructure"},
    {"department": "Mangalore Electricity Supply Company Limited (MESCOM)", "title": "Refer a repeated power-supply complaint", "detail": "Record the affected locality and outage pattern, then request a technical review from the electricity utility.", "action": "issue", "impact": "service"},
    {"department": "Social Welfare Department, Government of Karnataka", "title": "Review access to a welfare scheme", "detail": "Help residents identify the correct application channel and refer unresolved process issues to the welfare office.", "action": "followup", "impact": "trust"},
    {"department": "Labour Department, Government of Karnataka", "title": "Refer a worker's labour-service grievance", "detail": "Record the broad nature of the concern with consent and direct the resident to the appropriate labour office or grievance channel.", "action": "followup", "impact": "trust"},
    {"department": "Department of Fisheries, Government of Karnataka", "title": "Raise a fisheries-community infrastructure concern", "detail": "Record the community's concern and submit a representation seeking assessment by the competent fisheries authority.", "action": "proposal", "impact": "service"},
    {"department": "Forest Department, Government of Karnataka", "title": "Refer a local human-wildlife conflict concern", "detail": "Record the reported location and refer it promptly to the Forest Department; do not approach wildlife or promise compensation.", "action": "issue", "impact": "service"},
    {"department": "Directorate of Municipal Administration", "title": "Follow up on municipal solid-waste collection", "detail": "Record missed collection locations and request the urban local body to review the service schedule and response.", "action": "issue", "impact": "service"},
    {"department": "Rural Development and Panchayat Raj Department", "title": "Review a Gram Panchayat public-facility request", "detail": "Record the facility concern and submit it to the Gram Panchayat for discussion and action within its authority.", "action": "proposal", "impact": "service"}
]


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
var personal_debt: int = 0
var monthly_living_expenses: int = 22000
var campaign_expenditure: int = 0
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
var rival_candidate_name: String = "Rohan Shetty"
var has_elected_office: bool = false
var elected_office_name: String = ""
var office_proposals: Array = []
var constituency_issues: Array = []
var office_action_counter: int = 0
var office_missions: Array = []
var office_mission_history: Array = []
var office_mission_counter: int = 0
var party_counter: int = 0
var parties: Dictionary = {}
var notifications: Array[String] = []
var local_infrastructure: float = 50.0
var local_service_quality: float = 50.0
var public_trust: float = 50.0
var monthly_income: int = 35000

func initialize() -> void:
    parties = {
        "party_established": {
            "name": "People's Unity Party",
            "members": 12500,
            "funds": 25000000,
            "debt": 0,
            "popularity": 24.0,
            "is_player_created": false
        },
        "party_reform": {
            "name": "Progressive Reform Front",
            "members": 7800,
            "funds": 12000000,
            "debt": 0,
            "popularity": 16.0,
            "is_player_created": false
        }
    }

func local_election_area() -> String:
    return "%s, %s" % [home_city.strip_edges(), home_state]

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
    personal_debt = 0
    monthly_income = 35000
    monthly_living_expenses = 22000
    campaign_expenditure = 0
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
    office_proposals.clear()
    constituency_issues.clear()
    office_action_counter = 0
    office_missions.clear()
    office_mission_history.clear()
    office_mission_counter = 0

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
            "debt": 0,
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
            if personal_funds < VOLUNTEER_ACTIVITY_COST:
                notifications.append("Not enough personal cash for this activity. Review your personal finances before spending.")
                return notifications.duplicate()
            personal_funds -= VOLUNTEER_ACTIVITY_COST
            experience += 2
            reputation += 0.4
            campaign_effort += 1.5
            _increase_party_popularity(0.15)
            notifications.append("You volunteered in a local campaign. Personal expense: ₹%s. Experience +2; reputation and campaign experience improved." % _format_number(VOLUNTEER_ACTIVITY_COST))
        "community":
            if personal_funds < COMMUNITY_ACTIVITY_COST:
                notifications.append("Not enough personal cash for this community event. Review your personal finances before spending.")
                return notifications.duplicate()
            personal_funds -= COMMUNITY_ACTIVITY_COST
            experience += 2
            reputation += 0.7
            _increase_party_popularity(0.25)
            notifications.append("You organized a community service event in %s. Personal expense: ₹%s. Experience +2; local reputation improved." % [home_city, _format_number(COMMUNITY_ACTIVITY_COST)])
        "meeting":
            experience += 1
            reputation += 0.2
            local_leader_relationship = minf(100.0, local_leader_relationship + 2.0)
            var organizer_name: String = FICTIONAL_AI_NAMES[posmod(int(experience + local_leader_relationship), FICTIONAL_AI_NAMES.size())]
            notifications.append("You attended a party meeting with local organizer %s. Experience +1; your relationship with local leadership improved." % organizer_name)
        "recruit":
            var party: Dictionary = parties[player_party_id]
            if int(party["members"]) < 100000:
                var recruited_name: String = FICTIONAL_AI_NAMES[posmod(int(party["members"]), FICTIONAL_AI_NAMES.size())]
                party["members"] = int(party["members"]) + 1
                party["funds"] = int(party["funds"]) + 500
                parties[player_party_id] = party
                experience += 1
                _increase_party_popularity(0.05)
                notifications.append("%s joined your party. Membership and party funds increased slightly." % recruited_name)
            else:
                notifications.append("The local recruitment limit has been reached in this prototype.")
        "request_ticket":
            _request_local_ticket()
        "campaign":
            _run_local_campaign()
        "office_proposal":
            submit_office_proposal()
        "office_issue":
            raise_constituency_issue()
        "office_resubmit":
            resubmit_returned_proposal()
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
    if campaign_expenditure + CAMPAIGN_ACTION_COST > LOCAL_CAMPAIGN_MODEL_BUDGET:
        notifications.append("The modeled local campaign budget is exhausted. No further campaign spending is allowed in this election.")
        return
    if not parties.has(player_party_id):
        notifications.append("Your party finance account is unavailable.")
        return
    var party: Dictionary = parties[player_party_id]
    var party_funds := int(party.get("funds", 0))
    if party_funds < CAMPAIGN_ACTION_COST:
        notifications.append("Your party does not have enough available funds for this campaign action. Personal and party funds are separate.")
        return
    party["funds"] = party_funds - CAMPAIGN_ACTION_COST
    parties[player_party_id] = party
    campaign_expenditure += CAMPAIGN_ACTION_COST
    campaign_effort += 2.0
    reputation += 0.25
    notifications.append("Campaign activity completed in %s. Party campaign expense: ₹%s. Candidate campaign spending: ₹%s / ₹%s. Personal funds were not used." % [
        local_election_area(), _format_number(CAMPAIGN_ACTION_COST),
        _format_number(campaign_expenditure), _format_number(LOCAL_CAMPAIGN_MODEL_BUDGET)
    ])


func generate_monthly_office_missions() -> void:
    if not has_elected_office:
        office_missions.clear()
        return
    office_missions.clear()
    # Each monthly brief is assembled from a grounded department assignment plus
    # independently varied local context. This creates thousands of combinations
    # without pretending every generated combination is a separately authored mission.
    var situations: Array[String] = [
        "new resident petition", "repeat complaint", "seasonal service pressure",
        "safety concern", "accessibility concern", "maintenance backlog",
        "inspection follow-up", "public feedback", "service coverage gap",
        "budget-priority request", "delayed contractor work", "monsoon preparedness",
        "school-term readiness", "market-area congestion", "public facility upkeep"
    ]
    var urgency_levels: Array[String] = ["routine", "time-sensitive", "priority", "monitoring"]
    var stakeholder_groups: Array[String] = [
        "nearby residents", "commuters and road users", "local service users",
        "school families", "senior residents", "small businesses",
        "farmers and agricultural workers", "women's self-help groups"
    ]
    var action_steps: Array[String] = [
        "Record the affected location and dates, verify the complaint with residents, and submit a written representation to the named office.",
        "Collect the relevant service details, request an inspection or status report, and log the department's response for follow-up.",
        "Hold a short public consultation, summarize the concerns without personal data, and refer the matter to the competent authority.",
        "Check the status of earlier correspondence, seek a written update, and inform residents of the next official step."
    ]
    var seen_signatures: Dictionary = {}
    var target_count := randi_range(3, 5)
    var attempts := 0
    while office_missions.size() < target_count and attempts < 300:
        attempts += 1
        var source: Dictionary = OFFICE_MISSION_CATALOG[randi_range(0, OFFICE_MISSION_CATALOG.size() - 1)]
        var situation := situations[randi_range(0, situations.size() - 1)]
        var urgency := urgency_levels[randi_range(0, urgency_levels.size() - 1)]
        var stakeholder := stakeholder_groups[randi_range(0, stakeholder_groups.size() - 1)]
        var action_step := action_steps[randi_range(0, action_steps.size() - 1)]
        var signature := "%s|%s|%s|%s|%s" % [str(source["title"]), situation, urgency, stakeholder, action_step]
        if seen_signatures.has(signature):
            continue
        seen_signatures[signature] = true
        office_mission_counter += 1
        office_missions.append({
            "id": office_mission_counter,
            "title": "%s: %s" % [str(source["title"]), situation.capitalize()],
            "department": str(source["department"]),
            "detail": "%s\n\nThis month's brief: %s. Priority: %s. Raised by: %s.\n\nYour representative's task: %s You may submit representations and request updates; the department, elected council, and authorised officers decide and carry out official action." % [str(source["detail"]), situation.capitalize(), urgency, stakeholder, action_step],
            "action": str(source["action"]),
            "impact": str(source["impact"]),
            "location": "%s, %s" % [home_city, home_state],
            "status": "Available",
            "generated_index": year * 12 + month,
            "deadline": "%s %d" % [_month_name(month), year]
        })

func complete_office_mission(mission_id: int) -> Array[String]:
    notifications.clear()
    if not has_elected_office:
        notifications.append("You need a current elected office to act on constituency responsibilities.")
        return notifications.duplicate()
    for i in range(office_missions.size()):
        var mission: Dictionary = office_missions[i]
        if int(mission.get("id", -1)) != mission_id:
            continue
        if str(mission.get("status", "")) != "Available":
            notifications.append("This monthly responsibility has already been completed or submitted.")
            return notifications.duplicate()
        var action_type := str(mission.get("action", "issue"))
        var title_text := str(mission.get("title", "Constituency matter"))
        var department := str(mission.get("department", "District Administration"))
        var location := str(mission.get("location", local_election_area()))
        var current_index := year * 12 + month
        if action_type == "proposal":
            office_action_counter += 1
            office_proposals.append({
                "id": office_action_counter, "title": title_text, "department": department,
                "location": location, "status": "Pending council review",
                "submitted_index": current_index, "approved_index": -1
            })
            mission["status"] = "Submitted for review"
            notifications.append("Representation submitted to %s regarding %s. Council and the competent department will review it; you cannot direct implementation." % [department, title_text])
        elif action_type == "issue":
            office_action_counter += 1
            constituency_issues.append({
                "id": office_action_counter, "topic": title_text, "department": department,
                "location": location, "status": "Submitted to department", "submitted_index": current_index
            })
            mission["status"] = "Referred to department"
            notifications.append("The matter was formally referred to %s for examination and response: %s." % [department, title_text])
        elif action_type == "meeting":
            reputation = minf(100.0, reputation + 0.35)
            public_trust = minf(100.0, public_trust + 0.5)
            mission["status"] = "Meeting held; follow-up recorded"
            notifications.append("You held a public grievance meeting in %s. Residents' concerns were recorded and routed to the relevant offices." % location)
        else:
            public_trust = minf(100.0, public_trust + 0.25)
            mission["status"] = "Follow-up completed"
            notifications.append("You requested written updates from %s and recorded the follow-up for %s." % [department, title_text])
        mission["completed_index"] = current_index
        office_missions[i] = mission
        office_mission_history.append(mission.duplicate(true))
        if office_mission_history.size() > 100:
            office_mission_history.pop_front()
        return notifications.duplicate()
    notifications.append("That monthly responsibility is no longer available.")
    return notifications.duplicate()

func submit_office_proposal() -> void:
    if not has_elected_office:
        notifications.append("Only a current elected representative can submit an official constituency proposal.")
        return
    var open_count := 0
    for item in office_proposals:
        if str(item.get("status", "")) in ["Pending council review", "Approved — awaiting AI implementation"]:
            open_count += 1
    if open_count >= 2:
        notifications.append("You already have two proposals awaiting review or implementation. Wait for the council and competent departments to process them.")
        return

    office_action_counter += 1
    var titles := [
        "Repair priority roads",
        "Improve public drainage",
        "Upgrade drinking-water access",
        "Improve street lighting",
        "Strengthen local health services"
    ]
    var title: String = titles[(office_action_counter - 1) % titles.size()]
    office_proposals.append({
        "id": office_action_counter,
        "title": title,
        "status": "Pending council review",
        "submitted_index": year * 12 + month,
        "approved_index": -1
    })
    notifications.append("You submitted the constituency proposal: %s. The council must review it; you cannot authorize spending or direct departments yourself." % title)

func raise_constituency_issue() -> void:
    if not has_elected_office:
        notifications.append("Only a current elected representative can formally raise a constituency issue.")
        return
    var open_count := 0
    for item in constituency_issues:
        if str(item.get("status", "")) in ["Submitted to AI department", "Submitted to department"]:
            open_count += 1
    if open_count >= 3:
        notifications.append("Three constituency issues are already awaiting a departmental response. Let the offices process them before raising another.")
        return

    office_action_counter += 1
    var topics := [
        "Streetlight outage",
        "Waste collection delay",
        "Water-supply complaint",
        "Road-surface hazard",
        "Public facility maintenance"
    ]
    var topic: String = topics[(office_action_counter - 1) % topics.size()]
    constituency_issues.append({
        "id": office_action_counter,
        "topic": topic,
        "status": "Submitted to department",
        "department": str(OFFICE_MISSION_CATALOG[randi_range(0, OFFICE_MISSION_CATALOG.size() - 1)]["department"]),
        "location": local_election_area(),
        "submitted_index": year * 12 + month
    })
    notifications.append("You formally raised a constituency issue: %s. The competent public office handles routine investigation and service delivery." % topic)

func resubmit_returned_proposal() -> void:
    if not has_elected_office:
        notifications.append("You need a current elected office to resubmit an official proposal.")
        return
    var open_count := 0
    for proposal in office_proposals:
        if str(proposal.get("status", "")) in ["Pending council review", "Approved — awaiting AI implementation"]:
            open_count += 1
    if open_count >= 2:
        notifications.append("You already have two proposals awaiting review or implementation. Wait for one to finish before resubmitting.")
        return
    for i in range(office_proposals.size()):
        var item: Dictionary = office_proposals[i]
        if str(item.get("status", "")) == "Returned for revision":
            item["status"] = "Pending council review"
            item["submitted_index"] = year * 12 + month
            item["approved_index"] = -1
            office_proposals[i] = item
            notifications.append("You revised and resubmitted %s. It is pending council review; implementation remains with the responsible departments." % str(item.get("title", "proposal")))
            return
    notifications.append("There is no returned proposal to resubmit.")

func _process_office_work() -> void:
    if not has_elected_office:
        return
    var current_index := year * 12 + month

    for i in range(office_proposals.size()):
        var proposal: Dictionary = office_proposals[i]
        var status := str(proposal.get("status", ""))
        var submitted_index := int(proposal.get("submitted_index", current_index))
        if status == "Pending council review" and current_index > submitted_index:
            var party_popularity := 0.0
            if parties.has(player_party_id):
                party_popularity = float(parties[player_party_id].get("popularity", 0.0))
            var review_score := reputation + party_popularity * 0.1
            if review_score >= 5.0:
                proposal["status"] = "Approved — awaiting AI implementation"
                proposal["approved_index"] = current_index
                notifications.append("Council approved '%s'. AI public-works officials now schedule implementation; you do not control department operations." % str(proposal.get("title", "proposal")))
            else:
                proposal["status"] = "Returned for revision"
                notifications.append("Council returned '%s' for revision. Improve its public support or revise and resubmit it." % str(proposal.get("title", "proposal")))
        elif status == "Approved — awaiting AI implementation" and current_index > int(proposal.get("approved_index", current_index)):
            proposal["status"] = "Implemented by %s" % str(proposal.get("department", "the competent department"))
            var project_title := str(proposal.get("title", "proposal"))
            _apply_project_impact(project_title)
            notifications.append("AI officials completed '%s'. Local infrastructure is now %.1f/100, service quality %.1f/100, and public trust %.1f/100." % [project_title, local_infrastructure, local_service_quality, public_trust])
        office_proposals[i] = proposal

    for i in range(constituency_issues.size()):
        var issue: Dictionary = constituency_issues[i]
        if str(issue.get("status", "")) in ["Submitted to AI department", "Submitted to department"] and current_index > int(issue.get("submitted_index", current_index)):
            issue["status"] = "Response received from %s" % str(issue.get("department", "the responsible department"))
            local_service_quality = minf(100.0, local_service_quality + 0.6)
            public_trust = minf(100.0, public_trust + 0.4)
            _increase_party_popularity(0.03)
            notifications.append("%s responded to '%s'. Service quality rose to %.1f/100 and public trust to %.1f/100." % [str(issue.get("department", "The responsible department")), str(issue.get("topic", "issue")), local_service_quality, public_trust])
        constituency_issues[i] = issue

func _process_party_monthly() -> void:
    if player_party_id == "" or not parties.has(player_party_id):
        return
    var party: Dictionary = parties[player_party_id]
    var members := int(party.get("members", 0))
    var popularity := float(party.get("popularity", 0.0))
    var funds := int(party.get("funds", 0))
    var debt := int(party.get("debt", 0))

    # Illustrative game economy: routine donations and operating costs scale with membership.
    # This is not a claim about any real party's accounts.
    var monthly_recruits := clampi(roundi(popularity / 15.0), 0, 8)
    var donations := 2000 + members * 15
    var operating_cost := 1000 + members * 10
    members += monthly_recruits
    var net := donations - operating_cost
    if net >= 0:
        var debt_payment := mini(debt, net)
        debt -= debt_payment
        funds += net - debt_payment
    else:
        var shortfall := -net
        var paid_from_cash := mini(funds, shortfall)
        funds -= paid_from_cash
        debt += shortfall - paid_from_cash
    if monthly_recruits > 0:
        popularity = minf(100.0, popularity + float(monthly_recruits) * 0.015)
    party["members"] = members
    party["funds"] = funds
    party["debt"] = debt
    party["popularity"] = popularity
    parties[player_party_id] = party
    notifications.append("AI party accounts: +%d members; modeled donations ₹%s; operating costs ₹%s; party cash ₹%s; party debt ₹%s." % [
        monthly_recruits, _format_number(donations), _format_number(operating_cost),
        _format_number(funds), _format_number(debt)
    ])

func _process_personal_monthly_finances() -> void:
    var net_cashflow := monthly_income - monthly_living_expenses
    if net_cashflow >= 0:
        var debt_payment := mini(personal_debt, net_cashflow)
        personal_debt -= debt_payment
        personal_funds += net_cashflow - debt_payment
    else:
        var shortfall := -net_cashflow
        var paid_from_cash := mini(personal_funds, shortfall)
        personal_funds -= paid_from_cash
        personal_debt += shortfall - paid_from_cash
    notifications.append("Personal finances: income ₹%s; living costs ₹%s; net ₹%s. Cash ₹%s; debt ₹%s." % [
        _format_number(monthly_income), _format_number(monthly_living_expenses),
        _format_number(net_cashflow), _format_number(personal_funds), _format_number(personal_debt)
    ])

func finance_summary() -> String:
    var party_cash := 0
    var party_debt := 0
    var party_members := 0
    var party_donations := 0
    var party_operating_cost := 0
    if player_party_id != "" and parties.has(player_party_id):
        var party: Dictionary = parties[player_party_id]
        party_cash = int(party.get("funds", 0))
        party_debt = int(party.get("debt", 0))
        party_members = int(party.get("members", 0))
        party_donations = 2000 + party_members * 15
        party_operating_cost = 1000 + party_members * 10
    var monthly_net := monthly_income - monthly_living_expenses
    return "PERSONAL FINANCES\nCash savings: ₹%s\nMonthly income: ₹%s\nLiving costs: ₹%s\nNet monthly cash flow: ₹%s\nPersonal debt: ₹%s\n\nPARTY FINANCES\nParty cash: ₹%s\nParty debt: ₹%s\nModeled monthly donations: ₹%s\nModeled operating costs: ₹%s\n\nCAMPAIGN ACCOUNTING\nCampaign spending this election: ₹%s / ₹%s\nCampaign actions are paid from party funds; personal and party money stay separate. The campaign budget is a simplified game rule, not a statement of the legal limit for every local election." % [
        _format_number(personal_funds), _format_number(monthly_income),
        _format_number(monthly_living_expenses), _format_number(monthly_net),
        _format_number(personal_debt), _format_number(party_cash), _format_number(party_debt),
        _format_number(party_donations), _format_number(party_operating_cost),
        _format_number(campaign_expenditure), _format_number(LOCAL_CAMPAIGN_MODEL_BUDGET)
    ]

func _apply_project_impact(project_title: String) -> void:
    if project_title.contains("road") or project_title.contains("drainage") or project_title.contains("lighting"):
        local_infrastructure = minf(100.0, local_infrastructure + 3.0)
    else:
        local_service_quality = minf(100.0, local_service_quality + 3.0)
    public_trust = minf(100.0, public_trust + 2.0)
    reputation = minf(100.0, reputation + 0.5)
    _increase_party_popularity(0.25)

func local_conditions_summary() -> String:
    return "Local infrastructure: %.1f/100\nPublic-service quality: %.1f/100\nPublic trust: %.1f/100" % [local_infrastructure, local_service_quality, public_trust]

func office_summary() -> String:
    if not has_elected_office:
        return "No elected office. Party roles do not grant government authority."
    var pending_proposals := 0
    var active_issues := 0
    var available_missions := 0
    for proposal in office_proposals:
        if str(proposal.get("status", "")) in ["Pending council review", "Approved — awaiting AI implementation"]:
            pending_proposals += 1
    for issue in constituency_issues:
        if str(issue.get("status", "")) in ["Submitted to AI department", "Submitted to department"]:
            active_issues += 1
    for mission in office_missions:
        if str(mission.get("status", "")) == "Available":
            available_missions += 1
    return "Office: %s\nArea: %s, %s\nOpen proposals: %d\nIssues awaiting department response: %d\nMonthly responsibilities available: %d\nYour authority: represent residents, submit representations, and request action. Elected councils, civil servants, and competent departments retain their legal powers and operational duties." % [
        elected_office_name, home_city, home_state, pending_proposals, active_issues, available_missions
    ]

func office_activity_summary() -> String:
    var lines: Array[String] = []
    for i in range(maxi(0, office_proposals.size() - 3), office_proposals.size()):
        var proposal: Dictionary = office_proposals[i]
        lines.append("Proposal: %s — %s" % [str(proposal.get("title", "")), str(proposal.get("status", ""))])
    for i in range(maxi(0, constituency_issues.size() - 3), constituency_issues.size()):
        var issue: Dictionary = constituency_issues[i]
        lines.append("Issue: %s — %s" % [str(issue.get("topic", "")), str(issue.get("status", ""))])
    if lines.is_empty():
        return "No office matters filed yet."
    return "\n".join(lines)

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
        # Monthly transition order is deliberate: household finances, party operations,
        # then council/department work. Every downstream system reads the updated state.
        _process_personal_monthly_finances()
        if month == 1:
            character_age += 1
            notifications.append("Birthday: you are now %d. Personal income and political activity continue on the monthly calendar." % character_age)
        _process_party_monthly()
        _process_office_work()
        if has_elected_office:
            generate_monthly_office_missions()
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
    rival_candidate_name = FICTIONAL_AI_NAMES[posmod(local_election_year + month, FICTIONAL_AI_NAMES.size())]

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
            + (public_trust - 50.0) * 0.15
            + (local_service_quality - 50.0) * 0.1
        )
        var rival_score: float = 24.0 + randf_range(-5.0, 5.0)
        election_vote_share = clampf(50.0 + (candidate_score - rival_score) * 1.6, 5.0, 95.0)
        var candidate_votes: int = roundi(float(election_turnout) * election_vote_share / 100.0)
        var rival_votes: int = election_turnout - candidate_votes

        if candidate_votes > rival_votes:
            has_elected_office = true
            generate_monthly_office_missions()
            elected_office_name = "Local elected representative — %s" % home_city
            player_role = elected_office_name
            career_rank = elected_office_name
            local_election_result = "WON"
            notifications.append(
                 "ELECTION RESULT — WON in %s. You received %s of %s votes (%.1f%%) with %d%% turnout. You are now a Local elected representative. Your authority is limited to this elected office." % [
                    local_election_area(), _format_number(candidate_votes), _format_number(election_turnout),
                    election_vote_share, roundi(float(election_turnout) / 100.0)
                ]
            )
        else:
            local_election_result = "LOST"
            notifications.append(
                 "ELECTION RESULT — LOST. You received %s of %s votes (%.1f%%); %s won with %s votes in %s. You remain in your party role and receive no elected-office authority." % [
                    _format_number(candidate_votes), _format_number(election_turnout),
                    election_vote_share, rival_candidate_name, _format_number(rival_votes), local_election_area()
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
            return "Local election: completed (%d)\nArea: %s\nResult: WON — %.1f%% of votes\nAI opponent: %s\nElected office: %s" % [
                local_election_year, local_election_area(), election_vote_share, rival_candidate_name, elected_office_name
            ]
        if local_election_result == "LOST":
            return "Local election: completed (%d)\nArea: %s\nResult: LOST — %.1f%% of votes\nAI opponent: %s\nNo elected office or government authority." % [
                local_election_year, local_election_area(), election_vote_share, rival_candidate_name
            ]
        return "Local election: completed (%d)\nArea: %s\nYou were not an approved candidate." % [local_election_year, local_election_area()]
    if local_candidate_selected:
        return "Local election: December %d\nArea: %s\nYour party ticket is approved. Campaigning is open." % [local_election_year, local_election_area()]
    if ticket_requested:
        return "Local election: December %d\nArea: %s\nYour ticket application is under review." % [local_election_year, local_election_area()]
    return "Local election: December %d\nApply for a party ticket when you meet the eligibility requirements."

func _format_number(value: int) -> String:
    var negative := value < 0
    var raw := str(absi(value))
    if raw.length() <= 3:
        return ("-" if negative else "") + raw
    var formatted := raw.substr(raw.length() - 3, 3)
    var prefix := raw.substr(0, raw.length() - 3)
    while prefix.length() > 2:
        formatted = prefix.substr(prefix.length() - 2, 2) + "," + formatted
        prefix = prefix.substr(0, prefix.length() - 2)
    if not prefix.is_empty():
        formatted = prefix + "," + formatted
    return ("-" if negative else "") + formatted


const SAVE_PATH := "user://political_world_save.json"

func save_game() -> bool:
    var save_data: Dictionary = {
        "save_version": 6,
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
        "personal_debt": personal_debt,
        "monthly_living_expenses": monthly_living_expenses,
        "campaign_expenditure": campaign_expenditure,
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
        "rival_candidate_name": rival_candidate_name,
        "has_elected_office": has_elected_office,
        "elected_office_name": elected_office_name,
        "office_proposals": office_proposals,
        "constituency_issues": constituency_issues,
        "office_action_counter": office_action_counter,
        "office_missions": office_missions,
        "office_mission_history": office_mission_history,
        "office_mission_counter": office_mission_counter,
        "party_counter": party_counter,
        "parties": parties,
        "local_infrastructure": local_infrastructure,
        "local_service_quality": local_service_quality,
        "public_trust": public_trust,
        "monthly_income": monthly_income
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

    var loaded_save_version := int(parsed.get("save_version", 1))
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
    personal_debt = int(parsed.get("personal_debt", 0))
    monthly_living_expenses = int(parsed.get("monthly_living_expenses", 22000))
    campaign_expenditure = int(parsed.get("campaign_expenditure", 0))
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
    rival_candidate_name = str(parsed.get("rival_candidate_name", "Rohan Shetty"))
    has_elected_office = bool(parsed.get("has_elected_office", false))
    elected_office_name = str(parsed.get("elected_office_name", ""))
    var saved_proposals: Variant = parsed.get("office_proposals", [])
    office_proposals = saved_proposals if typeof(saved_proposals) == TYPE_ARRAY else []
    var saved_issues: Variant = parsed.get("constituency_issues", [])
    constituency_issues = saved_issues if typeof(saved_issues) == TYPE_ARRAY else []
    office_action_counter = int(parsed.get("office_action_counter", 0))
    var saved_missions: Variant = parsed.get("office_missions", [])
    office_missions = saved_missions if typeof(saved_missions) == TYPE_ARRAY else []
    var saved_mission_history: Variant = parsed.get("office_mission_history", [])
    office_mission_history = saved_mission_history if typeof(saved_mission_history) == TYPE_ARRAY else []
    office_mission_counter = int(parsed.get("office_mission_counter", 0))
    party_counter = int(parsed.get("party_counter", 0))
    var saved_parties: Variant = parsed.get("parties", {})
    if typeof(saved_parties) == TYPE_DICTIONARY and not saved_parties.is_empty():
        parties = saved_parties
    local_infrastructure = float(parsed.get("local_infrastructure", 50.0))
    local_service_quality = float(parsed.get("local_service_quality", 50.0))
    public_trust = float(parsed.get("public_trust", 50.0))
    monthly_income = int(parsed.get("monthly_income", 35000))
    if loaded_save_version < 5:
        # Migrate older saves from the prototype's nominal stipend to the new modeled household budget.
        monthly_income = 35000
        monthly_living_expenses = 22000
    for party_id in parties.keys():
        var party_record: Dictionary = parties[party_id]
        if not party_record.has("debt"):
            party_record["debt"] = 0
        parties[party_id] = party_record
    if has_elected_office and office_missions.is_empty():
        generate_monthly_office_missions()
    notifications = ["Saved career loaded."]
    return true
