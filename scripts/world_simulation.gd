extends RefCounted
class_name PoliticalWorldSimulation

const LOCAL_ELECTION_MONTH := 12
const LOCAL_ELECTION_CYCLE_YEARS := 5 # Simplified prototype cycle; real local-body terms vary by jurisdiction.
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
const STATE_ASSEMBLY_SEATS: Dictionary = {
	"Andhra Pradesh": 175, "Arunachal Pradesh": 60, "Assam": 126,
	"Bihar": 243, "Chhattisgarh": 90, "Goa": 40, "Gujarat": 182,
	"Haryana": 90, "Himachal Pradesh": 68, "Jharkhand": 81,
	"Karnataka": 224, "Kerala": 140, "Madhya Pradesh": 230,
	"Maharashtra": 288, "Manipur": 60, "Meghalaya": 60,
	"Mizoram": 40, "Nagaland": 60, "Odisha": 147, "Punjab": 117,
	"Rajasthan": 200, "Sikkim": 32, "Tamil Nadu": 234,
	"Telangana": 119, "Tripura": 60, "Uttar Pradesh": 403,
	"Uttarakhand": 70, "West Bengal": 294
}
const MODELED_CAMPAIGN_MONTHS := 3
const MODELED_CAMPAIGN_BASE_COST := 25000
const MODELED_CAMPAIGN_MEMBER_COST := 2
const MODELED_CAMPAIGN_MAX_MONTHLY_COST := 200000
const MODELED_ELECTION_CYCLE_YEARS := 5

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
var last_local_election_year: int = 0
var last_local_election_result: String = ""
var last_election_vote_share: float = 0.0
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
var district_party_role: String = ""
var district_role_application_pending: bool = false
var district_role_approved: bool = false
var district_service_record: int = 0
var world_state: Dictionary = {}

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
	_initialize_world_state()
	for party_id_variant in parties.keys():
		_ensure_party_roster(str(party_id_variant))

func _initialize_world_state() -> void:
	# Shared, serializable world layer. Regional support is tracked independently
	# so popularity in one state does not automatically become nationwide strength.
	var state_names: Array[String] = [
		"Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
		"Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
		"Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
		"Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan",
		"Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh",
		"Uttarakhand", "West Bengal"
	]
	var regional_support: Dictionary = {}
	for party_id in parties.keys():
		var party: Dictionary = parties[party_id]
		var support_by_state: Dictionary = {}
		for state_name in state_names:
			var base_support := float(party.get("popularity", 0.0))
			if state_name == "Karnataka":
				base_support += 5.0
			support_by_state[state_name] = clampf(base_support, 0.5, 85.0)
		regional_support[str(party_id)] = support_by_state
	var state_elections: Array[Dictionary] = []
	for i in range(state_names.size()):
		state_elections.append({
			"state": state_names[i],
			"next_year": 2028 + (i % 4),
			"month": 5 if i % 2 == 0 else 11,
			"assembly_seats": int(STATE_ASSEMBLY_SEATS.get(state_names[i], 60)),
			"last_result": "Not yet held",
			"last_winner": ""
		})
	world_state = {
		"schema_version": 1,
		"regional_support": regional_support,
		"state_elections": state_elections,
		"national_election": {"next_year": 2029, "month": 5, "seats": 543, "last_result": "Not yet held", "last_winner": ""},
		"global_relations": {},
		"seat_results": {},
		"election_history": [],
		"last_monthly_report": "The political world is ready. Regional party organization and election calendars are initialized."
	}

func _ensure_party_world_presence(party_id: String) -> void:
	if party_id.is_empty() or not parties.has(party_id):
		return
	if world_state.is_empty():
		_initialize_world_state()
	var regional: Dictionary = world_state.get("regional_support", {})
	if regional.has(party_id):
		return
	var party: Dictionary = parties[party_id]
	var support_by_state: Dictionary = {}
	for election in world_state.get("state_elections", []):
		var state_name := str(election.get("state", "Karnataka"))
		var base_support := float(party.get("popularity", 0.0))
		if state_name == "Karnataka":
			base_support += 5.0
		support_by_state[state_name] = clampf(base_support, 0.5, 85.0)
	regional[party_id] = support_by_state
	world_state["regional_support"] = regional

func _ensure_election_schema() -> void:
	if not world_state.has("state_elections") or not (world_state.get("state_elections") is Array):
		var state_names: Array[String] = [
			"Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
			"Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
			"Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
			"Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan",
			"Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh",
			"Uttarakhand", "West Bengal"
		]
		var elections: Array[Dictionary] = []
		for i in range(state_names.size()):
			elections.append({
				"state": state_names[i],
				"next_year": 2028 + (i % 4),
				"month": 5 if i % 2 == 0 else 11,
				"assembly_seats": int(STATE_ASSEMBLY_SEATS.get(state_names[i], 60)),
				"last_result": "Not yet held",
				"last_winner": "",
				"phase": "Scheduled",
				"campaign_spend_by_party": {}
			})
		world_state["state_elections"] = elections
	else:
		var saved_elections: Array = world_state.get("state_elections", [])
		for i in range(saved_elections.size()):
			var election: Dictionary = saved_elections[i]
			var state_name := str(election.get("state", ""))
			election["assembly_seats"] = int(election.get("assembly_seats", STATE_ASSEMBLY_SEATS.get(state_name, 60)))
			election["phase"] = str(election.get("phase", "Scheduled"))
			election["campaign_spend_by_party"] = election.get("campaign_spend_by_party", {})
			election["high_command_slate_approved"] = bool(election.get("high_command_slate_approved", false))
			election["high_command_priority"] = str(election.get("high_command_priority", "Balanced outreach"))
			election["high_command_monthly_budget"] = int(election.get("high_command_monthly_budget", 50000))
			saved_elections[i] = election
		world_state["state_elections"] = saved_elections

	if not world_state.has("national_election") or not (world_state.get("national_election") is Dictionary):
		world_state["national_election"] = {
			"next_year": 2029, "month": 5, "seats": 543,
			"last_result": "Not yet held", "last_winner": "",
			"phase": "Scheduled", "campaign_spend_by_party": {}
		}
	else:
		var national: Dictionary = world_state.get("national_election", {})
		national["phase"] = str(national.get("phase", "Scheduled"))
		national["campaign_spend_by_party"] = national.get("campaign_spend_by_party", {})
		world_state["national_election"] = national

	if not world_state.has("election_history"):
		world_state["election_history"] = []
	if not world_state.has("seat_results"):
		world_state["seat_results"] = {}


func _process_world_politics_monthly() -> void:
	if world_state.is_empty():
		_initialize_world_state()
	_ensure_election_schema()
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		_ensure_party_world_presence(party_id)
	var regional: Dictionary = world_state.get("regional_support", {})
	var report_lines: Array[String] = []

	# Rival parties also run monthly operations, with separate accounts.
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		if party_id == player_party_id:
			continue
		var rival_party: Dictionary = parties[party_id]
		var rival_members := int(rival_party.get("members", 0))
		var rival_popularity := float(rival_party.get("popularity", 0.0))
		var rival_funds := int(rival_party.get("funds", 0))
		var rival_debt := int(rival_party.get("debt", 0))
		var recruits := clampi(roundi(rival_popularity / 18.0), 0, 12)
		var donations := 1500 + rival_members * 12
		var operating_cost := 1200 + rival_members * 9
		rival_members += recruits
		var net_cash := donations - operating_cost
		if net_cash >= 0:
			var debt_repayment := mini(rival_debt, net_cash)
			rival_debt -= debt_repayment
			rival_funds += net_cash - debt_repayment
		else:
			var shortfall := -net_cash
			var paid := mini(rival_funds, shortfall)
			rival_funds -= paid
			rival_debt += shortfall - paid
		rival_party["members"] = rival_members
		rival_party["funds"] = rival_funds
		rival_party["debt"] = rival_debt
		rival_party["popularity"] = minf(100.0, rival_popularity + float(recruits) * 0.01)
		parties[party_id] = rival_party

	# Every six months, modest membership moves from the weakest party to the
	# strongest when their popularity gap is meaningful.
	if month % 6 == 0 and parties.size() > 1:
		var strongest_id := ""
		var weakest_id := ""
		var strongest_support := -1.0
		var weakest_support := 101.0
		for party_id_variant in parties.keys():
			var party_id := str(party_id_variant)
			var party_record: Dictionary = parties[party_id]
			var support_score := float(party_record.get("popularity", 0.0))
			if support_score > strongest_support:
				strongest_support = support_score
				strongest_id = party_id
			if support_score < weakest_support:
				weakest_support = support_score
				weakest_id = party_id
		if strongest_id != weakest_id and strongest_support - weakest_support >= 10.0:
			var strong_party: Dictionary = parties[strongest_id]
			var weak_party: Dictionary = parties[weakest_id]
			var transfer := mini(25, maxi(1, int(weak_party.get("members", 0)) / 1000))
			weak_party["members"] = maxi(0, int(weak_party.get("members", 0)) - transfer)
			strong_party["members"] = int(strong_party.get("members", 0)) + transfer
			parties[strongest_id] = strong_party
			parties[weakest_id] = weak_party
			report_lines.append("Party movement: %d members shifted from %s to %s after a sustained support gap." % [transfer, str(weak_party.get("name", "a party")), str(strong_party.get("name", "a party"))])

	# AI organization builds and loses support state by state. The player's party
	# gets the same autonomous regional growth outside direct player decisions.
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties[party_id]
		var party_popularity := float(party.get("popularity", 0.0))
		var support_by_state: Dictionary = regional.get(party_id, {})
		for state_name_variant in support_by_state.keys():
			var state_name := str(state_name_variant)
			var support := float(support_by_state[state_name])
			var drift := (party_popularity - support) * 0.025
			if state_name == home_state and party_id == player_party_id:
				drift += 0.04
			support_by_state[state_name] = clampf(support + drift, 0.5, 95.0)
		regional[party_id] = support_by_state
	world_state["regional_support"] = regional

	# Each election has a three-month AI campaign window. Results are resolved
	# only on the scheduled month, and seat outcomes are stored in shared world state.
	var state_elections: Array = world_state.get("state_elections", [])
	for i in range(state_elections.size()):
		var election: Dictionary = state_elections[i]
		var state_name := str(election.get("state", ""))
		var seats := int(election.get("assembly_seats", STATE_ASSEMBLY_SEATS.get(state_name, 60)))
		state_elections[i] = _advance_modeled_election(
			election, "%s Assembly" % state_name, seats, state_name, regional, report_lines
		)
	world_state["state_elections"] = state_elections

	var national: Dictionary = world_state.get("national_election", {})
	national = _advance_modeled_election(
		national, "Lok Sabha", int(national.get("seats", 543)), "", regional, report_lines
	)
	world_state["national_election"] = national

	if report_lines.is_empty():
		report_lines.append("AI party organizations reviewed regional support and continued routine activity across India.")
	world_state["last_monthly_report"] = "\n".join(report_lines)
	notifications.append_array(report_lines)

func _months_until_election(election: Dictionary) -> int:
	var election_year := int(election.get("next_year", year))
	var election_month := clampi(int(election.get("month", 1)), 1, 12)
	return (election_year - year) * 12 + (election_month - month)


func _advance_modeled_election(
	election: Dictionary,
	jurisdiction: String,
	seat_count: int,
	state_name: String,
	regional: Dictionary,
	report_lines: Array[String]
) -> Dictionary:
	if election.is_empty():
		return election

	var months_remaining := _months_until_election(election)
	if months_remaining > MODELED_CAMPAIGN_MONTHS:
		election["phase"] = "Scheduled"
		return election

	if months_remaining > 0:
		if str(election.get("phase", "")) != "Campaigning":
			report_lines.append("Campaign period opened for %s. AI party organizations are campaigning automatically." % jurisdiction)
		election["phase"] = "Campaigning"
		election["months_to_poll"] = months_remaining
		_run_modeled_ai_campaigns(election, state_name)
		return election

	var result := _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
	election["last_result"] = str(result.get("summary", "Election completed"))
	election["last_winner"] = str(result.get("winner_id", ""))
	election["last_seats"] = result.get("seats_by_party", {})
	election["last_vote_shares"] = result.get("vote_shares", {})
	election["last_year"] = year
	election["last_turnout_percent"] = float(result.get("turnout_percent", 0.0))
	election["phase"] = "Completed"
	election["last_campaign_spending"] = election.get("campaign_spend_by_party", {})

	var history: Array = world_state.get("election_history", [])
	history.append({
		"jurisdiction": jurisdiction,
		"year": year,
		"month": month,
		"summary": election["last_result"],
		"winner_id": election["last_winner"],
		"seats_by_party": election["last_seats"],
		"vote_shares": election["last_vote_shares"]
	})
	while history.size() > 40:
		history.pop_front()
	world_state["election_history"] = history

	var seat_results: Dictionary = world_state.get("seat_results", {})
	seat_results[jurisdiction] = election["last_seats"]
	world_state["seat_results"] = seat_results

	# Election performance feeds back into support without guaranteeing future wins.
	var vote_shares: Dictionary = result.get("vote_shares", {})
	if not state_name.is_empty():
		var regional_support: Dictionary = world_state.get("regional_support", {})
		for party_id_variant in parties.keys():
			var state_party_id := str(party_id_variant)
			var party_regions: Dictionary = regional_support.get(state_party_id, {})
			var current_support := float(party_regions.get(state_name, 0.0))
			var state_vote_share := float(vote_shares.get(state_party_id, 0.0))
			party_regions[state_name] = clampf(current_support + (state_vote_share - 20.0) * 0.025, 0.5, 95.0)
			regional_support[state_party_id] = party_regions
		world_state["regional_support"] = regional_support
	else:
		for party_id_variant in parties.keys():
			var national_party_id := str(party_id_variant)
			var party: Dictionary = parties.get(national_party_id, {})
			var national_vote_share := float(vote_shares.get(national_party_id, 0.0))
			party["popularity"] = clampf(float(party.get("popularity", 0.0)) + (national_vote_share - 20.0) * 0.025, 0.5, 100.0)
			parties[national_party_id] = party

	report_lines.append("%s result: %s. Turnout %.1f%%. Campaigns were AI-managed; this result does not directly appoint the player to office." % [
		jurisdiction, election["last_result"], election["last_turnout_percent"]
	])

	var next_year := int(election.get("next_year", year))
	while next_year <= year:
		next_year += MODELED_ELECTION_CYCLE_YEARS
	election["next_year"] = next_year
	election["phase"] = "Scheduled"
	election["months_to_poll"] = -1
	election["campaign_spend_by_party"] = {}
	election["campaign_months_run"] = 0
	return election


func _run_modeled_ai_campaigns(election: Dictionary, state_name: String = "") -> void:
	var spending_by_party: Dictionary = election.get("campaign_spend_by_party", {})
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties.get(party_id, {})
		if party.is_empty():
			continue
		var members := maxi(0, int(party.get("members", 0)))
		var monthly_budget := mini(
			MODELED_CAMPAIGN_MAX_MONTHLY_COST,
			MODELED_CAMPAIGN_BASE_COST + members * MODELED_CAMPAIGN_MEMBER_COST
		)
		if state_name == "Karnataka" and party_id == player_party_id:
			monthly_budget = mini(
				maxi(0, int(election.get("high_command_monthly_budget", 50000))),
				MODELED_CAMPAIGN_MAX_MONTHLY_COST
			)
			if not bool(election.get("high_command_slate_approved", false)):
				monthly_budget = 0
		var available_funds := maxi(0, int(party.get("funds", 0)))
		var spend := mini(available_funds, monthly_budget)
		if spend <= 0:
			continue
		party["funds"] = available_funds - spend
		parties[party_id] = party
		spending_by_party[party_id] = int(spending_by_party.get(party_id, 0)) + spend
	election["campaign_spend_by_party"] = spending_by_party
	election["campaign_months_run"] = int(election.get("campaign_months_run", 0)) + 1


func _resolve_modeled_election(
	election: Dictionary,
	jurisdiction: String,
	seat_count: int,
	state_name: String,
	regional: Dictionary
) -> Dictionary:
	var scores: Dictionary = {}
	var total_score := 0.0
	var spending_by_party: Dictionary = election.get("campaign_spend_by_party", {})
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties.get(party_id, {})
		var base_support := float(party.get("popularity", 0.0))
		if not state_name.is_empty():
			var support_by_state: Dictionary = regional.get(party_id, {})
			base_support = float(support_by_state.get(state_name, base_support))
		var members := maxi(1, int(party.get("members", 1)))
		var campaign_score := minf(7.0, float(spending_by_party.get(party_id, 0)) / 100000.0)
		var priority_bonus := 0.0
		if state_name == "Karnataka" and party_id == player_party_id:
			var priority := str(election.get("high_command_priority", "Balanced outreach"))
			if priority != "Balanced outreach":
				priority_bonus = 0.35
		var score := maxf(0.5, base_support + log(maxf(1.0, float(members)) / 1000.0) * 2.0 + campaign_score + priority_bonus + randf_range(-1.5, 1.5))
		scores[party_id] = score
		total_score += score

	if scores.is_empty() or total_score <= 0.0:
		return {"summary": "No eligible party was available to contest.", "winner_id": "", "seats_by_party": {}, "vote_shares": {}, "turnout_percent": 0.0}

	var seats_by_party: Dictionary = {}
	var vote_shares: Dictionary = {}
	var remainders: Dictionary = {}
	var allocated_seats := 0
	for party_id_variant in scores.keys():
		var party_id := str(party_id_variant)
		var share := float(scores[party_id]) / total_score
		var raw_seats := share * float(seat_count)
		var whole_seats := int(floor(raw_seats))
		seats_by_party[party_id] = whole_seats
		remainders[party_id] = raw_seats - float(whole_seats)
		vote_shares[party_id] = share * 100.0
		allocated_seats += whole_seats

	var remaining := maxi(0, seat_count - allocated_seats)
	while remaining > 0:
		var best_id := ""
		var best_remainder := -1.0
		for party_id_variant in remainders.keys():
			var party_id := str(party_id_variant)
			var fraction := float(remainders[party_id])
			if fraction > best_remainder:
				best_remainder = fraction
				best_id = party_id
		if best_id.is_empty():
			break
		seats_by_party[best_id] = int(seats_by_party.get(best_id, 0)) + 1
		remainders[best_id] = -1.0
		remaining -= 1

	var winner_id := ""
	var winner_seats := -1
	for party_id_variant in seats_by_party.keys():
		var party_id := str(party_id_variant)
		var party_seats := int(seats_by_party[party_id])
		if party_seats > winner_seats:
			winner_seats = party_seats
			winner_id = party_id
	var winner_party: Dictionary = parties.get(winner_id, {})
	var winner_name := str(winner_party.get("name", "Leading party"))
	var turnout_percent := clampf(54.0 + (total_score / maxf(1.0, float(scores.size()))) * 0.22 + randf_range(-4.0, 4.0), 45.0, 82.0)
	var summary := "%s won the most seats (%d of %d); coalition formation is not yet modeled." % [winner_name, winner_seats, seat_count]
	return {
		"summary": summary,
		"winner_id": winner_id,
		"seats_by_party": seats_by_party,
		"vote_shares": vote_shares,
		"turnout_percent": turnout_percent
	}


func world_politics_summary() -> String:
	if world_state.is_empty():
		return "India-wide party organization and election calendars will initialize with the next monthly simulation."
	var regional: Dictionary = world_state.get("regional_support", {})
	var player_support := 0.0
	var player_regions: Dictionary = regional.get(player_party_id, {})
	if not player_regions.is_empty():
		player_support = float(player_regions.get(home_state, 0.0))
	var next_state_name := ""
	var next_state_year := 99999
	var next_state_month := 13
	var next_state_phase := "Scheduled"
	for election_variant in world_state.get("state_elections", []):
		var election: Dictionary = election_variant
		var election_year := int(election.get("next_year", 99999))
		var election_month := int(election.get("month", 13))
		if election_year < next_state_year or (election_year == next_state_year and election_month < next_state_month):
			next_state_year = election_year
			next_state_month = election_month
			next_state_name = str(election.get("state", ""))
			next_state_phase = str(election.get("phase", "Scheduled"))
	var national: Dictionary = world_state.get("national_election", {})
	var history: Array = world_state.get("election_history", [])
	var latest_result := "No state or national election has been resolved yet."
	if not history.is_empty():
		var latest: Dictionary = history[history.size() - 1]
		latest_result = "%s (%d): %s" % [str(latest.get("jurisdiction", "Election")), int(latest.get("year", year)), str(latest.get("summary", "Result recorded"))]
	return "INDIA-WIDE POLITICAL WORLD\nRegional party support in %s: %.1f / 100\nNext modeled state assembly election: %s — %s %d\nState election phase: %s\nNext modeled Lok Sabha election: %s %d — %s\nLatest modeled result: %s\nAI organizations campaign automatically when you do not take direct action. Schedules are simulation models, not official dates." % [
		home_state, player_support, next_state_name, _month_name(next_state_month), next_state_year,
		next_state_phase, _month_name(int(national.get("month", 5))), int(national.get("next_year", 2029)),
		str(national.get("phase", "Scheduled")), latest_result
	]

func local_election_area() -> String:
	return "%s, %s" % [home_city.strip_edges(), home_state]

func _ensure_party_roster(party_id: String) -> void:
	if not parties.has(party_id):
		return
	var party: Dictionary = parties[party_id]
	var records_variant: Variant = party.get("member_records", [])
	var records: Array = records_variant if typeof(records_variant) == TYPE_ARRAY else []
	var counter := int(party.get("member_counter", records.size()))
	if records.is_empty():
		var seed_count := mini(6, maxi(0, int(party.get("members", 1)) - (1 if party_id == player_party_id else 0)))
		for i in range(seed_count):
			counter += 1
			records.append({"id": "member_%d" % counter, "name": FICTIONAL_AI_NAMES[posmod(counter - 1, FICTIONAL_AI_NAMES.size())], "duty": ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary"][posmod(i, 6)], "region": "Karnataka", "joined_year": year, "joined_month": month, "is_player_added": false})
	# The headline membership includes the founder. Materialize missing player-party
	# members so internal elections use the full electorate, not only the small named seed roster.
	if party_id == player_party_id:
		var target_records := mini(1000, maxi(records.size(), maxi(0, int(party.get("members", 1)) - 1)))
		while records.size() < target_records:
			counter += 1
			var base_name := FICTIONAL_AI_NAMES[posmod(counter - 1, FICTIONAL_AI_NAMES.size())]
			records.append({"id": "member_%d" % counter, "name": "%s %d" % [base_name, 100 + counter], "duty": "Volunteer", "region": home_state, "joined_year": year, "joined_month": month, "is_player_added": false})
	party["member_records"] = records
	party["member_counter"] = counter
	parties[party_id] = party

func _next_fictional_member_name(party: Dictionary) -> String:
	var counter := int(party.get("member_counter", 0)) + 1
	return "%s %d" % [FICTIONAL_AI_NAMES[posmod(counter - 1, FICTIONAL_AI_NAMES.size())], 100 + counter]

func get_player_party_members() -> Array:
	if player_party_id == "" or not parties.has(player_party_id):
		return []
	var party: Dictionary = parties[player_party_id]
	var records: Array = party.get("member_records", [])
	return records.duplicate(true)

func add_party_member(member_name: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "Join or found a party before adding members."
	var clean_name := member_name.strip_edges()
	if clean_name.is_empty():
		return "Enter a member name."
	var party: Dictionary = parties[player_party_id]
	var records: Array = party.get("member_records", [])
	for member_variant in records:
		var member: Dictionary = member_variant
		if str(member.get("name", "")).to_lower() == clean_name.to_lower():
			return "A member with that name is already in the named roster."
	var counter := int(party.get("member_counter", 0)) + 1
	records.append({
		"id": "member_%d" % counter,
		"name": clean_name,
		"duty": "Volunteer",
		"region": home_state,
		"joined_year": year,
		"joined_month": month,
		"is_player_added": true
	})
	party["member_counter"] = counter
	party["member_records"] = records
	party["members"] = int(party.get("members", 0)) + 1
	parties[player_party_id] = party
	return "%s added as a party member." % clean_name

func assign_party_duty(member_id: String, duty: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "Join or found a party first."
	var allowed := ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary", "State Organizer"]
	if not allowed.has(duty):
		return "That party duty is not available."
	var party: Dictionary = parties[player_party_id]
	var records: Array = party.get("member_records", [])
	for i in range(records.size()):
		var member: Dictionary = records[i]
		if str(member.get("id", "")) == member_id:
			member["duty"] = duty
			records[i] = member
			party["member_records"] = records
			parties[player_party_id] = party
			return "%s assigned as %s." % [str(member.get("name", "Member")), duty]
	return "Select a valid party member."

func date_label() -> String:
	return "%s %d" % [_month_name(month), year]

func _month_name(value: int) -> String:
	var names := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	return names[clampi(value - 1, 0, 11)]

func party_constitution() -> Dictionary:
	if player_party_id == "" or not parties.has(player_party_id):
		return {}
	var party: Dictionary = parties[player_party_id]
	return {
		"leadership_model": str(party.get("leadership_model", "Founder-led")),
		"president_term_years": int(party.get("president_term_years", 5)),
		"constitution_adopted": bool(party.get("constitution_adopted", false)),
		"office_bearers": party.get("office_bearers", {})
	}

func adopt_party_constitution(leadership_model: String, term_years: int) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	if leadership_model not in ["Founder-led", "Member election", "Delegate election"]:
		return "Choose a valid leadership model."
	var party: Dictionary = parties[player_party_id]
	party["leadership_model"] = leadership_model
	party["president_term_years"] = clampi(term_years, 2, 6)
	party["constitution_adopted"] = true
	if not party.has("office_bearers"):
		party["office_bearers"] = {}
	parties[player_party_id] = party
	return "Party constitution adopted: %s leadership, %d-year president term. These rules govern internal party leadership only." % [leadership_model, clampi(term_years, 2, 6)]


func nominate_party_president_candidate(candidate_id: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	var party: Dictionary = parties[player_party_id]
	if not bool(party.get("constitution_adopted", false)):
		return "Adopt a party constitution before opening leadership nominations."
	if str(party.get("leadership_model", "Founder-led")) == "Founder-led":
		return "Founder-led rules do not hold contested presidential elections. Update the constitution to Member election or Delegate election."
	var candidate_name := ""
	if candidate_id == "founder":
		candidate_name = character_name
	else:
		for member_variant in party.get("member_records", []):
			var member: Dictionary = member_variant
			if str(member.get("id", "")) == candidate_id:
				candidate_name = str(member.get("name", ""))
				break
	if candidate_name.is_empty():
		return "Choose yourself or a current party member as the candidate."
	var election: Dictionary = party.get("internal_election", {"nominations": [], "history": []})
	var nominations: Array = election.get("nominations", [])
	for item in nominations:
		if str(item.get("candidate_id", "")) == candidate_id:
			return "That candidate is already nominated."
	nominations.append({"candidate_id": candidate_id, "candidate_name": candidate_name})
	election["nominations"] = nominations
	party["internal_election"] = election
	parties[player_party_id] = party
	return "%s is nominated for party president. Nominate at least one other candidate before holding the election." % candidate_name

func hold_party_presidential_election(player_vote_id: String = "") -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	var party: Dictionary = parties[player_party_id]
	if not bool(party.get("constitution_adopted", false)):
		return "Adopt a party constitution before holding a leadership election."
	if str(party.get("leadership_model", "Founder-led")) == "Founder-led":
		return "Your constitution uses Founder-led rules. Change it to Member election or Delegate election to hold a contested election."
	var election: Dictionary = party.get("internal_election", {"nominations": [], "history": []})
	var nominations: Array = election.get("nominations", [])
	if nominations.size() < 2:
		return "At least two nominated candidates are required for a contested leadership election."

	var records: Array = party.get("member_records", [])
	var candidates: Array[Dictionary] = []
	for nomination_variant in nominations:
		var nomination: Dictionary = nomination_variant
		var candidate_id := str(nomination.get("candidate_id", ""))
		var valid := candidate_id == "founder"
		if not valid:
			for member_variant in records:
				var member: Dictionary = member_variant
				if str(member.get("id", "")) == candidate_id:
					valid = true
					break
		if valid:
			candidates.append(nomination)
	if candidates.size() < 2:
		return "At least two valid nominated candidates are required. Review nominations and try again."
	var player_vote_is_valid := false
	for candidate in candidates:
		if str(candidate.get("candidate_id", "")) == player_vote_id:
			player_vote_is_valid = true
			break
	if not player_vote_is_valid:
		return "Select one of the nominated candidates for your personal ballot before holding the election."

	# Every eligible named party member receives one ballot. The founder is included
	# as a voter, and each roster member votes once. Preferences are deterministic
	# so the same saved party state produces the same count.
	var voters: Array[Dictionary] = [{"id": "founder", "name": character_name, "duty": "Founder"}]
	for member_variant in records:
		var member: Dictionary = member_variant
		var voter_id := str(member.get("id", ""))
		if voter_id != "" and voter_id != "founder":
			voters.append({"id": voter_id, "name": str(member.get("name", "Member")), "duty": str(member.get("duty", "Volunteer"))})
	# If a large party has more members than its individually named roster, preserve
	# the full electorate with stable synthetic member IDs and one ballot per member.
	var target_voters := maxi(voters.size(), int(party.get("members", voters.size())))
	while voters.size() < target_voters:
		var synthetic_index := voters.size() + 1
		voters.append({"id": "unlisted_member_%d" % synthetic_index, "name": "Party Member %d" % synthetic_index, "duty": "Volunteer"})

	var vote_totals: Dictionary = {}
	var ballots: Array[Dictionary] = []
	for candidate in candidates:
		vote_totals[str(candidate.get("candidate_id", ""))] = 0

	for voter in voters:
		var voter_id := str(voter.get("id", ""))
		var voter_duty := str(voter.get("duty", "Volunteer"))
		var best_candidate: Dictionary = candidates[0]
		var best_score := -999999
		for candidate_index in range(candidates.size()):
			var candidate: Dictionary = candidates[candidate_index]
			var candidate_id := str(candidate.get("candidate_id", ""))
			var score := 10
			if candidate_id == voter_id:
				score += 8
			if candidate_id == str(party.get("president_member_id", "")):
				score += 3
			if candidate_id == "founder":
				score += int(reputation / 10.0)
			else:
				for member_variant in records:
					var candidate_member: Dictionary = member_variant
					if str(candidate_member.get("id", "")) == candidate_id:
						var candidate_duty := str(candidate_member.get("duty", "Volunteer"))
						if candidate_duty == voter_duty:
							score += 3
						if candidate_duty in ["Treasurer", "District Secretary", "State Organizer"]:
							score += 2
						break
			# Stable tie-breaker avoids random or rerollable results.
			score += maxi(0, candidates.size() - candidate_index)
			if score > best_score:
				best_score = score
				best_candidate = candidate
		var chosen_id := str(best_candidate.get("candidate_id", ""))
		if voter_id == "founder":
			chosen_id = player_vote_id
			for nominated_candidate in candidates:
				if str(nominated_candidate.get("candidate_id", "")) == player_vote_id:
					best_candidate = nominated_candidate
					break
		vote_totals[chosen_id] = int(vote_totals.get(chosen_id, 0)) + 1
		ballots.append({"voter_id": voter_id, "voter_name": str(voter.get("name", "Member")), "candidate_id": chosen_id, "candidate_name": str(best_candidate.get("candidate_name", "Candidate"))})

	var winner: Dictionary = {}
	var winning_votes := -1
	var results: Array[Dictionary] = []
	for candidate in candidates:
		var candidate_id := str(candidate.get("candidate_id", ""))
		var votes := int(vote_totals.get(candidate_id, 0))
		results.append({"candidate_id": candidate_id, "candidate_name": str(candidate.get("candidate_name", "Candidate")), "votes": votes, "vote_percent": (float(votes) * 100.0 / float(maxi(1, voters.size())))})
		if votes > winning_votes:
			winning_votes = votes
			winner = candidate
	if winner.is_empty():
		return "The election could not be completed because no valid candidates remain."

	var previous_president := str(party.get("president_name", "Not assigned"))
	party["president_name"] = str(winner.get("candidate_name", ""))
	party["president_member_id"] = str(winner.get("candidate_id", ""))
	party["president_elected_year"] = year
	party["president_elected_month"] = month
	var history: Array = election.get("history", [])
	history.append({
		"year": year,
		"month": month,
		"previous_president": previous_president,
		"winner": str(winner.get("candidate_name", "")),
		"results": results,
		"ballots": ballots,
		"eligible_voters": voters.size(),
		"votes_cast": ballots.size(),
		"turnout_percent": 100.0,
		"player_ballot_candidate_id": player_vote_id,
		"player_ballot_candidate_name": _candidate_name_from_list(candidates, player_vote_id)
	})
	election["history"] = history
	election["nominations"] = []
	party["internal_election"] = election
	parties[player_party_id] = party
	if str(winner.get("candidate_id", "")) == "founder":
		player_role = "Party President"
		career_rank = "Party President"
	else:
		player_role = "Party Member"
		career_rank = "Party Member"
	var result_lines: Array[String] = ["Party presidential election held in %s %d." % [_month_name(month), year]]
	result_lines.append("Ballots cast: %d of %d eligible voters." % [ballots.size(), voters.size()])
	for result in results:
		result_lines.append("%s: %d votes (%.1f%%)" % [str(result.get("candidate_name", "")), int(result.get("votes", 0)), float(result.get("vote_percent", 0.0))])
	result_lines.append("Winner: %s. Party leadership does not grant government office." % str(winner.get("candidate_name", "")))
	return "\n".join(result_lines)

func _candidate_name_from_list(candidates: Array, candidate_id: String) -> String:
	for candidate_variant in candidates:
		if not candidate_variant is Dictionary:
			continue
		var candidate: Dictionary = candidate_variant
		if str(candidate.get("candidate_id", "")) == candidate_id:
			return str(candidate.get("candidate_name", "Candidate"))
	return "Candidate"

func party_internal_election_summary() -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "No party available."
	var party: Dictionary = parties[player_party_id]
	var election: Dictionary = party.get("internal_election", {})
	var nominations: Array = election.get("nominations", [])
	var history: Array = election.get("history", [])
	var lines: Array[String] = ["PARTY PRESIDENTIAL ELECTION", "Current president: %s" % str(party.get("president_name", "Not assigned")), ""]

	lines.append("CURRENT NOMINATIONS")
	if nominations.is_empty():
		lines.append("No nominees yet.")
	else:
		for candidate_variant in nominations:
			var candidate: Dictionary = candidate_variant
			lines.append("• %s" % str(candidate.get("candidate_name", "Candidate")))
	lines.append("")

	if history.is_empty():
		lines.append("No completed election yet.")
		return "\n".join(lines)

	var latest: Dictionary = history[history.size() - 1]
	lines.append("MOST RECENT RESULT  |  %s %d" % [_month_name(int(latest.get("month", 1))), int(latest.get("year", year))])
	lines.append("Winner: %s" % str(latest.get("winner", "Not recorded")))
	lines.append("")
	lines.append("PARTICIPATION")
	lines.append("Ballots cast: %d / %d eligible" % [int(latest.get("votes_cast", 0)), int(latest.get("eligible_voters", 0))])
	lines.append("Turnout: %.1f%%" % float(latest.get("turnout_percent", 0.0)))
	var player_ballot_name := str(latest.get("player_ballot_candidate_name", "")).strip_edges()
	if player_ballot_name.is_empty():
		lines.append("Your ballot: Not cast")
	else:
		lines.append("Your vote: %s" % player_ballot_name)
	lines.append("")
	lines.append("CANDIDATE RESULTS")
	for result_variant in latest.get("results", []):
		var result: Dictionary = result_variant
		lines.append("%s  —  %d votes  (%.1f%%)" % [str(result.get("candidate_name", "Candidate")), int(result.get("votes", 0)), float(result.get("vote_percent", 0.0))])
	return "\n".join(lines)

func appoint_party_office_bearer(member_id: String, office: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	if office not in ["General Secretary", "Treasurer", "Vice President", "Organization Secretary"]:
		return "Choose a valid internal party office."
	var party: Dictionary = parties[player_party_id]
	if str(party.get("president_member_id", "founder")) != "founder" and str(party.get("president_name", "")) != character_name:
		return "Only the current party president can appoint office bearers."
	var modes: Dictionary = party.get("office_selection_modes", {})
	if str(modes.get(office, "President appoints")) != "President appoints":
		return "This office is set to Internal election. Use its nomination and election controls instead of appointing directly."
	var records: Array = party.get("member_records", [])
	for member_variant in records:
		var member: Dictionary = member_variant
		if str(member.get("id", "")) == member_id:
			var bearers: Dictionary = party.get("office_bearers", {})
			bearers[office] = {"member_id": member_id, "name": str(member.get("name", "Member"))}
			party["office_bearers"] = bearers
			parties[player_party_id] = party
			return "%s appointed as %s. This is an internal party role, not a government office." % [str(member.get("name", "Member")), office]
	return "Selected party member was not found."

func set_party_office_selection_mode(office: String, mode: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	if office not in ["General Secretary", "Treasurer", "Vice President", "Organization Secretary"]:
		return "Choose a valid internal party office."
	if mode not in ["President appoints", "Internal election"]:
		return "Choose appointment or internal election."
	var party: Dictionary = parties[player_party_id]
	if str(party.get("president_member_id", "founder")) != "founder" and str(party.get("president_name", "")) != character_name:
		return "Only the current party president can set office selection methods."
	var modes: Dictionary = party.get("office_selection_modes", {})
	modes[office] = mode
	party["office_selection_modes"] = modes
	parties[player_party_id] = party
	return "%s selection method set to %s." % [office, mode]

func nominate_party_office_candidate(member_id: String, office: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	var party: Dictionary = parties[player_party_id]
	var modes: Dictionary = party.get("office_selection_modes", {})
	if str(modes.get(office, "President appoints")) != "Internal election":
		return "Set this office to Internal election first."
	var candidate_name := ""
	if member_id == "founder":
		candidate_name = character_name
	else:
		for member_variant in party.get("member_records", []):
			var member: Dictionary = member_variant
			if str(member.get("id", "")) == member_id:
				candidate_name = str(member.get("name", ""))
				break
	if candidate_name.is_empty():
		return "Select a valid party member."
	var elections: Dictionary = party.get("office_elections", {})
	var election: Dictionary = elections.get(office, {"nominations": [], "history": []})
	var nominations: Array = election.get("nominations", [])
	for nomination_variant in nominations:
		if str(nomination_variant.get("candidate_id", "")) == member_id:
			return "That member is already nominated."
	nominations.append({"candidate_id": member_id, "candidate_name": candidate_name})
	election["nominations"] = nominations
	elections[office] = election
	party["office_elections"] = elections
	parties[player_party_id] = party
	return "%s nominated for %s. Add at least one other candidate before voting." % [candidate_name, office]

func hold_party_office_election(office: String, player_vote_id: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "You must belong to a party first."
	var party: Dictionary = parties[player_party_id]
	var modes: Dictionary = party.get("office_selection_modes", {})
	if str(modes.get(office, "President appoints")) != "Internal election":
		return "Set this office to Internal election before holding its vote."
	var elections: Dictionary = party.get("office_elections", {})
	var election: Dictionary = elections.get(office, {"nominations": [], "history": []})
	var nominations: Array = election.get("nominations", [])
	if nominations.size() < 2:
		return "Nominate at least two candidates before holding this office election."
	var valid_ids: Array[String] = []
	for n in nominations:
		valid_ids.append(str(n.get("candidate_id", "")))
	if player_vote_id.strip_edges().is_empty():
		return "Choose a nominee for your own ballot before holding the election."
	if not valid_ids.has(player_vote_id):
		return "Select a nominated candidate for your own ballot."
	var records: Array = party.get("member_records", [])
	var voters: Array[Dictionary] = [{"id":"founder", "name":character_name}]
	for r in records:
		var member: Dictionary = r
		if str(member.get("id", "")) != "" and str(member.get("id", "")) != "founder":
			voters.append({"id":str(member.get("id", "")), "name":str(member.get("name", "Member"))})
	var target_voters := maxi(voters.size(), int(party.get("members", voters.size())))
	while voters.size() < target_voters:
		var synthetic_index := voters.size() + 1
		voters.append({"id":"unlisted_member_%d" % synthetic_index, "name":"Party Member %d" % synthetic_index})
	var totals: Dictionary = {}
	for cid in valid_ids:
		totals[cid] = 0
	var ballots: Array[Dictionary] = []
	for voter in voters:
		var voter_id := str(voter.get("id", ""))
		var selected_id := player_vote_id if voter_id == "founder" else valid_ids[posmod(voter_id.hash(), valid_ids.size())]
		totals[selected_id] = int(totals.get(selected_id, 0)) + 1
		ballots.append({"voter_id":voter_id, "voter_name":str(voter.get("name", "Member")), "candidate_id":selected_id})
	var winner_id := valid_ids[0]
	for cid in valid_ids:
		if int(totals.get(cid, 0)) > int(totals.get(winner_id, 0)):
			winner_id = cid
	var winner_name := ""
	var detailed_results: Array[Dictionary] = []
	for n_variant in nominations:
		var n: Dictionary = n_variant
		var candidate_id := str(n.get("candidate_id", ""))
		var candidate_name := str(n.get("candidate_name", "Candidate"))
		var candidate_votes := int(totals.get(candidate_id, 0))
		detailed_results.append({
			"candidate_id": candidate_id,
			"candidate_name": candidate_name,
			"votes": candidate_votes,
			"vote_percent": float(candidate_votes) * 100.0 / float(maxi(1, voters.size()))
		})
		if candidate_id == winner_id:
			winner_name = candidate_name
	var bearers: Dictionary = party.get("office_bearers", {})
	bearers[office] = {"member_id":winner_id, "name":winner_name}
	party["office_bearers"] = bearers
	var history: Array = election.get("history", [])
	var player_vote_name := _candidate_name_from_list(nominations, player_vote_id)
	history.append({
		"year": year,
		"month": month,
		"winner": winner_name,
		"votes": totals,
		"results": detailed_results,
		"ballots": ballots,
		"eligible_voters": voters.size(),
		"votes_cast": ballots.size(),
		"turnout_percent": float(ballots.size()) * 100.0 / float(maxi(1, voters.size())),
		"player_ballot_candidate_id": player_vote_id,
		"player_ballot_candidate_name": player_vote_name
	})
	election["history"] = history
	election["nominations"] = []
	elections[office] = election
	party["office_elections"] = elections
	parties[player_party_id] = party
	var player_candidate_name := "Candidate"
	for nomination_variant in nominations:
		var nomination: Dictionary = nomination_variant
		if str(nomination.get("candidate_id", "")) == player_vote_id:
			player_candidate_name = str(nomination.get("candidate_name", "Candidate"))
			break
	return party_office_election_summary(office)

func party_office_election_summary(office: String) -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "No party available."
	var party: Dictionary = parties[player_party_id]
	var elections: Dictionary = party.get("office_elections", {})
	var election: Dictionary = elections.get(office, {})
	var nominations: Array = election.get("nominations", [])
	var history: Array = election.get("history", [])
	var lines: Array[String] = ["OFFICE-BEARER ELECTION  |  %s" % office, ""]

	if history.is_empty():
		lines.append("CURRENT NOMINATIONS")
		if nominations.is_empty():
			lines.append("No nominees yet.")
		else:
			for nominee_variant in nominations:
				var nominee: Dictionary = nominee_variant
				lines.append("• %s" % str(nominee.get("candidate_name", "Candidate")))
		lines.append("")
		lines.append("No completed election yet.")
		return "\n".join(lines)

	var latest: Dictionary = history[history.size() - 1]
	lines.append("FINAL RESULT  |  %s %d" % [_month_name(int(latest.get("month", 1))), int(latest.get("year", year))])
	lines.append("Elected: %s" % str(latest.get("winner", "Not recorded")))
	lines.append("")
	lines.append("PARTICIPATION")
	lines.append("Ballots cast: %d / %d eligible" % [int(latest.get("votes_cast", latest.get("ballots", []).size())), int(latest.get("eligible_voters", 0))])
	lines.append("Turnout: %.1f%%" % float(latest.get("turnout_percent", 0.0)))
	lines.append("Your vote: %s" % str(latest.get("player_ballot_candidate_name", "Not recorded")))
	lines.append("")
	lines.append("CANDIDATE RESULTS")
	for result_variant in latest.get("results", []):
		var result: Dictionary = result_variant
		lines.append("%s  —  %d votes  (%.1f%%)" % [str(result.get("candidate_name", "Candidate")), int(result.get("votes", 0)), float(result.get("vote_percent", 0.0))])
	return "\n".join(lines)

func start_career(name: String, age: int, city: String, path: String, party_name: String = "", founder_contribution: int = 10000) -> bool:
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
	var contribution := clampi(founder_contribution, 0, 50000)
	if path == "found" and contribution > 50000:
		notifications = ["Your initial party contribution cannot exceed your available starting savings."]
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
	last_local_election_year = 0
	last_local_election_result = ""
	last_election_vote_share = 0.0
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
	district_party_role = ""
	district_role_application_pending = false
	district_role_approved = false
	district_service_record = 0

	if path == "join":
		player_party_id = "party_established"
		player_role = "Party volunteer"
		career_rank = "Party volunteer"
		notifications = ["You joined People's Unity Party as a volunteer in %s, Karnataka. You have no elected office." % home_city]
	else:
		party_counter += 1
		player_party_id = "player_party_%d" % party_counter
		personal_funds -= contribution
		parties[player_party_id] = {
			"name": clean_party_name,
			"founder_name": character_name,
			"president_name": character_name,
			"president_member_id": "founder",
			"founding_year": year,
			"founding_month": month,
			"founder_contribution": contribution,
			"members": 5,
			"funds": 25000 + contribution,
			"debt": 0,
			"popularity": 1.0,
			"is_player_created": true
		}
		player_role = "Founding President"
		career_rank = "Founding President"
		local_leader_relationship = 5.0
		notifications = ["You founded %s and became its founding president and initial funder. Your ₹%s contribution was transferred from personal savings to party funds. Party leadership grants no elected office." % [clean_party_name, _format_number(contribution)]]
	_ensure_party_world_presence(player_party_id)
	_ensure_party_roster(player_party_id)
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
			if int(party.get("members", 0)) < 100000:
				var recruited_name: String = _next_fictional_member_name(party)
				var records: Array = party.get("member_records", [])
				records.append({"id": "member_%d" % int(party.get("member_counter", 0) + 1), "name": recruited_name, "duty": "Volunteer", "region": home_state, "joined_year": year, "joined_month": month, "is_player_added": false})
				party["member_counter"] = int(party.get("member_counter", 0)) + 1
				party["member_records"] = records
				party["members"] = int(party["members"]) + 1
				party["funds"] = int(party["funds"]) + 500
				parties[player_party_id] = party
				experience += 1
				_increase_party_popularity(0.05)
				notifications.append("%s joined your party and was added to the named roster." % recruited_name)
			else:
				notifications.append("The local recruitment limit has been reached in this prototype.")
		"request_ticket":
			_request_local_ticket()
		"campaign":
			_run_local_campaign()
		"district_apply":
			request_district_party_role()
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
		district_service_record += 1
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

func district_progression_summary() -> String:
	var status := "Not yet eligible"
	if district_role_approved:
		status = "Approved: %s" % district_party_role
	elif district_role_application_pending:
		status = "Application pending party review"
	var party_members := 0
	if parties.has(player_party_id):
		party_members = int(parties[player_party_id].get("members", 0))
	return "DISTRICT-LEVEL PARTY PROGRESSION\nStatus: %s\nService record: %d / 3 completed local-office responsibilities\nExperience: %d / 30\nReputation: %.1f / 10\nParty leadership relationship: %.1f / 20\nParty membership: %d / 50\n\nDistrict party roles are organizational positions, not elected government offices. Approval grants no statutory or administrative authority. District government roles and elections will be added as a separate progression system." % [status, district_service_record, experience, reputation, local_leader_relationship, party_members]

func request_district_party_role() -> void:
	if district_role_approved:
		notifications.append("You already hold the district-level party role: %s." % district_party_role)
		return
	if district_role_application_pending:
		notifications.append("Your district-level party role application is already pending review.")
		return
	var party_members := 0
	if parties.has(player_party_id):
		party_members = int(parties[player_party_id].get("members", 0))
	var has_local_standing := career_rank == "Local Party Leader" or has_elected_office
	if experience < 30 or reputation < 10.0 or local_leader_relationship < 20.0 or party_members < 50 or district_service_record < 3 or not has_local_standing:
		notifications.append("Your district-level application was not accepted. Complete at least 3 local-office responsibilities, build experience (30), reputation (10), party leadership relationship (20), party membership (50), and local standing as a Local Party Leader or elected representative.")
		return
	district_role_application_pending = true
	# Party review is modeled as an eligibility-based decision, not an instant public mandate.
	district_role_approved = true
	district_role_application_pending = false
	district_party_role = "District Organization Secretary"
	player_role = district_party_role
	career_rank = district_party_role
	notifications.append("Party review approved your appointment as District Organization Secretary. This is an internal party role only; it does not confer an elected seat, public funds, or government powers.")

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
		_process_world_politics_monthly()
		_process_office_work()
		if has_elected_office:
			generate_monthly_office_missions()
		if month == LOCAL_ELECTION_MONTH and year >= local_election_year:
			_resolve_local_election()
		if notifications.is_empty():
			notifications.append("You continued building your political career. Your next opportunities depend on experience, reputation, relationships, and party standing.")
	else:
		notifications.append("The calendar advanced. Your political career has not started.")
	return notifications.duplicate()

func _resolve_local_election() -> void:
	# Local elections recur on a modeled five-year cycle. Actual schedules differ by local-body type and jurisdiction.
	if local_election_completed:
		return
	last_local_election_year = local_election_year
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
		# AI fallback: the party still fields an eligible fictional candidate and
		# runs a campaign if the player does not register or receive the ticket.
		var party: Dictionary = parties.get(player_party_id, {})
		var party_popularity := float(party.get("popularity", 0.0))
		var party_members := int(party.get("members", 0))
		var campaign_spend := mini(int(party.get("funds", 0)), LOCAL_CAMPAIGN_MODEL_BUDGET)
		party["funds"] = int(party.get("funds", 0)) - campaign_spend
		var ai_candidate_score := party_popularity * 1.1 + log(maxf(1.0, float(party_members))) * 2.2 + reputation * 0.2 + campaign_spend / 50000.0
		var rival_score := 34.0 + randf_range(-7.0, 7.0)
		election_vote_share = clampf(50.0 + (ai_candidate_score - rival_score) * 1.1, 8.0, 92.0)
		var party_votes := roundi(float(election_turnout) * election_vote_share / 100.0)
		var rival_votes := election_turnout - party_votes
		if party_votes > rival_votes:
			local_election_result = "AI PARTY WON"
			party["popularity"] = minf(100.0, party_popularity + 0.6)
			party["members"] = party_members + maxi(1, roundi(float(party_members) * 0.002))
			notifications.append("AI CAMPAIGN RESULT — Your party's candidate won in %s with %.1f%% of votes. Campaign spending: ₹%s. You did not stand, so you do not receive the elected office." % [local_election_area(), election_vote_share, _format_number(campaign_spend)])
		else:
			local_election_result = "AI PARTY LOST"
			party["popularity"] = maxf(0.5, party_popularity - 0.4)
			notifications.append("AI CAMPAIGN RESULT — Your party contested in %s but lost with %.1f%% of votes. Campaign spending: ₹%s. AI leadership will review the result." % [local_election_area(), election_vote_share, _format_number(campaign_spend)])
		parties[player_party_id] = party

	last_local_election_result = local_election_result
	last_election_vote_share = election_vote_share
	local_election_completed = true
	local_candidate_selected = false
	ticket_approved = false
	ticket_requested = false

	# The elected mandate lasts until the next scheduled local election.
	# A defeated incumbent or an incumbent who does not stand loses this office.
	if local_election_result != "WON" and has_elected_office:
		has_elected_office = false
		elected_office_name = ""
		if career_path == "join":
			if experience >= LOCAL_LEADER_XP:
				career_rank = "Local Party Leader"
			elif experience >= ACTIVE_WORKER_XP:
				career_rank = "Active Party Worker"
			else:
				career_rank = "Party volunteer"
		else:
			career_rank = "Party founder"
		player_role = career_rank
		notifications.append("Your local elected term has ended. You no longer hold government authority; you return to your party role.")

	local_election_year += LOCAL_ELECTION_CYCLE_YEARS
	local_election_completed = false

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
	var leadership := "President: %s" % str(party.get("president_name", "Not assigned"))
	var founder_line := "Founder: %s" % str(party.get("founder_name", "Not recorded"))
	var contribution := int(party.get("founder_contribution", 0))
	return "%s\n%s\n%s\nRole: %s\nMembers: %s\nParty funds: ₹%s\nFounder contribution: ₹%s\nParty popularity: %.1f%%" % [
		party["name"], founder_line, leadership, player_role, _format_number(int(party["members"])),
		_format_number(int(party["funds"])), _format_number(contribution), float(party["popularity"])
	]

func set_karnataka_slate_approved(approved: bool) -> String:
	var elections: Array = world_state.get("state_elections", [])
	for i in range(elections.size()):
		var election: Dictionary = elections[i]
		if str(election.get("state", "")) == "Karnataka":
			if str(election.get("phase", "Scheduled")) == "Completed":
				return "The current Karnataka election cycle is complete. Approval applies to the next cycle."
			election["high_command_slate_approved"] = approved
			elections[i] = election
			world_state["state_elections"] = elections
			return "AI-prepared Karnataka slate approved. Your party's planned campaign can now spend within the set budget."
	return "Karnataka election record was not found."

func set_karnataka_campaign_plan(priority: String, monthly_budget: int) -> String:
	var allowed_priorities := ["Balanced outreach", "Public services", "Jobs & economy", "Rural development", "Youth engagement"]
	if not allowed_priorities.has(priority):
		priority = "Balanced outreach"
	var elections: Array = world_state.get("state_elections", [])
	for i in range(elections.size()):
		var election: Dictionary = elections[i]
		if str(election.get("state", "")) == "Karnataka":
			election["high_command_priority"] = priority
			election["high_command_monthly_budget"] = clampi(monthly_budget, 0, MODELED_CAMPAIGN_MAX_MONTHLY_COST)
			elections[i] = election
			world_state["state_elections"] = elections
			return "Karnataka campaign plan saved. Actual spending is capped by available party funds and ₹200,000 per month."
	return "Karnataka election record was not found."

func election_summary() -> String:
	var lines: Array[String] = []
	lines.append("Next local election: December %d" % local_election_year)
	lines.append("Area: %s" % local_election_area())
	if local_candidate_selected:
		lines.append("Your party ticket is approved. Campaigning is open for the scheduled election.")
	elif ticket_requested:
		lines.append("Your ticket application is under review.")
	else:
		lines.append("Apply for a party ticket when you meet the eligibility requirements.")
	if last_local_election_year > 0:
		if last_local_election_result == "WON":
			lines.append("Previous result (%d): WON — %.1f%% of votes." % [last_local_election_year, last_election_vote_share])
		elif last_local_election_result == "LOST":
			lines.append("Previous result (%d): LOST — %.1f%% of votes." % [last_local_election_year, last_election_vote_share])
		elif last_local_election_result == "AI PARTY WON" or last_local_election_result == "AI PARTY LOST":
			lines.append("Previous result (%d): Your party's AI candidate %s — %.1f%% of votes. You did not stand." % [last_local_election_year, "won" if last_local_election_result == "AI PARTY WON" else "lost", last_election_vote_share])
		else:
			lines.append("Previous result (%d): You were not an approved candidate." % last_local_election_year)
	if has_elected_office:
		lines.append("Current mandate: %s, through the next scheduled local election." % elected_office_name)
	return "\n".join(lines)

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
		"save_version": 11,
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
		"last_local_election_year": last_local_election_year,
		"last_local_election_result": last_local_election_result,
		"last_election_vote_share": last_election_vote_share,
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
		"monthly_income": monthly_income,
		"district_party_role": district_party_role,
		"district_role_application_pending": district_role_application_pending,
		"district_role_approved": district_role_approved,
		"district_service_record": district_service_record,
		"world_state": world_state
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
	last_local_election_year = int(parsed.get("last_local_election_year", 0))
	last_local_election_result = str(parsed.get("last_local_election_result", ""))
	last_election_vote_share = float(parsed.get("last_election_vote_share", 0.0))
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
	district_party_role = str(parsed.get("district_party_role", ""))
	district_role_application_pending = bool(parsed.get("district_role_application_pending", false))
	district_role_approved = bool(parsed.get("district_role_approved", false))
	district_service_record = int(parsed.get("district_service_record", 0))
	var saved_world_state: Variant = parsed.get("world_state", {})
	if typeof(saved_world_state) == TYPE_DICTIONARY and not saved_world_state.is_empty():
		world_state = saved_world_state
	else:
		_initialize_world_state()
	for party_id_variant in parties.keys():
		_ensure_party_world_presence(str(party_id_variant))
		_ensure_party_roster(str(party_id_variant))
	if loaded_save_version < 5:
		# Migrate older saves from the prototype's nominal stipend to the new modeled household budget.
		monthly_income = 35000
		monthly_living_expenses = 22000
	if loaded_save_version < 7 and local_election_year < year:
		# Older prototypes only had a one-time 2026 election. Move that stale date
		# to the next December so an existing career can enter the recurring cycle.
		local_election_year = year + (1 if month >= LOCAL_ELECTION_MONTH else 0)
	for party_id in parties.keys():
		var party_record: Dictionary = parties[party_id]
		if not party_record.has("debt"):
			party_record["debt"] = 0
		if bool(party_record.get("is_player_created", false)):
			if not party_record.has("founder_name"):
				party_record["founder_name"] = character_name
			if not party_record.has("president_name"):
				party_record["president_name"] = character_name if career_rank == "Party founder" else str(party_record.get("founder_name", character_name))
			if not party_record.has("founder_contribution"):
				party_record["founder_contribution"] = 0
		parties[party_id] = party_record
	if career_path == "found" and career_rank == "Party founder" and not has_elected_office:
		career_rank = "Founding President"
		player_role = "Founding President"
	if has_elected_office and office_missions.is_empty():
		generate_monthly_office_missions()
	notifications = ["Saved career loaded."]
	return true
