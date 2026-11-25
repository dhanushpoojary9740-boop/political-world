extends RefCounted
class_name PoliticalWorldSimulation

const LOCAL_ELECTION_MONTH := 12
const LOCAL_ELECTION_CYCLE_YEARS := 5 # Simplified prototype cycle; real local-body terms vary by jurisdiction.
const LOCAL_CAMPAIGN_MODEL_BUDGET := 500000000 # ₹5 crore modeled local campaign ceiling; game assumption, not a statutory limit.
const CAMPAIGN_ACTION_COST := 500000 # ₹5 lakh per modeled campaign action
const VOLUNTEER_ACTIVITY_COST := 100000 # ₹1 lakh modeled personal activity cost
const COMMUNITY_ACTIVITY_COST := 250000 # ₹2.5 lakh modeled personal activity cost
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
const KARNATAKA_ASSEMBLY_CONSTITUENCIES: Array[String] = [
	"Nippani", "Chikkodi-Sadalga", "Athani", "Kagwad",
	"Kudachi (SC)", "Raibag (SC)", "Hukkeri", "Arabhavi",
	"Gokak", "Yemkanmardi (ST)", "Belgaum Uttar", "Belgaum Dakshin",
	"Belgaum Rural", "Khanapur", "Kittur", "Bailhongal",
	"Saundatti Yellamma", "Ramdurg", "Mudhol (SC)", "Terdal",
	"Jamkhandi", "Bilgi", "Badami", "Bagalkot",
	"Hungund", "Muddebihal", "Devar Hippargi", "Basavana Bagevadi",
	"Babaleshwar", "Bijapur City", "Nagathan (SC)", "Indi",
	"Sindagi", "Afzalpur", "Jevargi", "Shorapur (ST)",
	"Shahapur", "Yadgir", "Gurmitkal", "Chittapur (SC)",
	"Sedam", "Chincholi (SC)", "Gulbarga Rural (SC)", "Gulbarga Dakshin",
	"Gulbarga Uttar", "Aland", "Basavakalyan", "Humnabad",
	"Bidar South", "Bidar", "Bhalki", "Aurad (SC)",
	"Raichur Rural (ST)", "Raichur", "Manvi (ST)", "Devadurga (ST)",
	"Lingsugur (SC)", "Sindhanur", "Maski (ST)", "Kushtagi",
	"Kanakagiri (SC)", "Gangawati", "Yelburga", "Koppal",
	"Shirahatti (SC)", "Gadag", "Ron", "Nargund",
	"Navalgund", "Kundgol", "Dharwad", "Hubli-Dharwad East (SC)",
	"Hubli-Dharwad Central", "Hubli-Dharwad West", "Kalghatgi", "Haliyal",
	"Karwar", "Kumta", "Bhatkal", "Sirsi",
	"Yellapur", "Hangal", "Shiggaon", "Haveri (SC)",
	"Byadgi", "Hirekerur", "Ranebennur", "Hoovina Hadagali (SC)",
	"Hagaribommanahalli (SC)", "Vijayanagara", "Kampli (ST)", "Siruguppa (ST)",
	"Bellary Rural (ST)", "Bellary City", "Sandur (ST)", "Kudligi (ST)",
	"Molakalmuru (ST)", "Challakere (ST)", "Chitradurga", "Hiriyur",
	"Hosadurga", "Holalkere (SC)", "Jagalur (ST)", "Harapanahalli",
	"Harihar", "Davanagere North", "Davanagere South", "Mayakonda (SC)",
	"Channagiri", "Honnali", "Shimoga Rural (SC)", "Bhadravati",
	"Shimoga", "Tirthahalli", "Shikaripura", "Soraba",
	"Sagar", "Byndoor", "Kundapura", "Udupi",
	"Kapu", "Karkala", "Sringeri", "Mudigere (SC)",
	"Chikmagalur", "Tarikere", "Kadur", "Chiknayakanhalli",
	"Tiptur", "Turuvekere", "Kunigal", "Tumkur City",
	"Tumkur Rural", "Koratagere (SC)", "Gubbi", "Sira",
	"Pavagada (SC)", "Madhugiri", "Gauribidanur", "Bagepalli",
	"Chikkaballapur", "Sidlaghatta", "Chintamani", "Srinivaspur",
	"Mulbagal (SC)", "Kolar Gold Field (SC)", "Bangarapet (SC)", "Kolar",
	"Malur", "Yelahanka", "Krishnarajapuram", "Byatarayanapura",
	"Yeshwantpur", "Rajarajeshwarinagar", "Dasarahalli", "Mahalakshmi Layout",
	"Malleshwaram", "Hebbal", "Pulakeshinagar (SC)", "Sarvagnanagar",
	"C. V. Raman Nagar (SC)", "Shivajinagar", "Shanti Nagar", "Gandhi Nagar",
	"Rajaji Nagar", "Govindraj Nagar", "Vijay Nagar", "Chamrajpet",
	"Chickpet", "Basavanagudi", "Padmanabhanagar", "B.T.M. Layout",
	"Jayanagar", "Mahadevapura (SC)", "Bommanahalli", "Bangalore South",
	"Anekal (SC)", "Hosakote", "Devanahalli (SC)", "Doddaballapur",
	"Nelamangala (SC)", "Magadi", "Ramanagaram", "Kanakapura",
	"Channapatna", "Malavalli (SC)", "Maddur", "Melukote",
	"Mandya", "Shrirangapattana", "Nagamangala", "Krishnarajapet",
	"Shravanabelagola", "Arsikere", "Belur", "Hassan",
	"Holenarasipur", "Arkalgud", "Sakleshpur (SC)", "Belthangady",
	"Moodabidri", "Mangalore City North", "Mangalore City South", "Mangalore",
	"Bantval", "Puttur", "Sullia (SC)", "Madikeri",
	"Virajpet", "Periyapatna", "Krishnarajanagara", "Hunsur",
	"Heggadadevankote (ST)", "Nanjangud (SC)", "Chamundeshwari", "Krishnaraja",
	"Chamaraja", "Narasimharaja", "Varuna", "T. Narasipur (SC)",
	"Hanur", "Kollegal (SC)", "Chamarajanagar", "Gundlupet"
]
const MODELED_CAMPAIGN_MONTHS := 3
const MODELED_CAMPAIGN_BASE_COST := 25000
const MODELED_CAMPAIGN_MEMBER_COST := 2
const MODELED_CAMPAIGN_MAX_MONTHLY_COST := 200000
const MODELED_ELECTION_CYCLE_YEARS := 5
const LOCAL_GOVERNMENT_ELECTION_CYCLE_YEARS := 5
const KARNATAKA_PARTY_OFFICE_DISTRICTS: Array[String] = [
	"Bagalkot", "Ballari", "Belagavi", "Bengaluru Rural", "Bengaluru Urban",
	"Bidar", "Chamarajanagar", "Chikkaballapura", "Chikkamagaluru", "Chitradurga",
	"Dakshina Kannada", "Davanagere", "Dharwad", "Gadag", "Hassan", "Haveri",
	"Kalaburagi", "Kodagu", "Kolar", "Koppal", "Mandya", "Mysuru", "Raichur",
	"Ramanagara", "Shivamogga", "Tumakuru", "Udupi", "Uttara Kannada",
	"Vijayapura", "Yadgir", "Vijayanagara"
]
const DISTRICT_OFFICE_MONTHLY_COST := 2500
const ASSEMBLY_CONSTITUENCY_OFFICE_MONTHLY_COST := 500
const HIGH_COMMAND_STRATEGIES: Array[String] = [
	"Balanced outreach", "Jobs & economy", "Public services", "Rural development",
	"Welfare & inclusion", "Infrastructure", "Public safety", "Youth engagement"
]
const HIGH_COMMAND_COALITION_POLICIES: Array[String] = [
	"modeled negotiate a working majority", "Prefer single-party government", "Avoid coalition agreements"
]
const HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET := 500000000 # ₹5 crore monthly ceiling
const HIGH_COMMAND_MAX_MONTHLY_BUDGET := 2000000000 # ₹20 crore monthly ceiling
const GOVERNMENT_MAP_PALETTE: Array[String] = [
	"#d6b15a", "#4c91c8", "#2f9f8c", "#b85b67", "#8b78c6", "#d58b48",
	"#6b9b6d", "#c16e9e", "#7c98ac", "#b2a54c", "#5f83bd", "#bf806f"
]
const AI_GOVERNMENT_ACTIONS: Array[Dictionary] = [
	{"metric": "service_delivery", "action": "Reviewed public-service delivery and department response times."},
	{"metric": "infrastructure", "action": "Prioritized road, drainage, water, and public-building maintenance."},
	{"metric": "welfare", "action": "Reviewed welfare-scheme reach and pending beneficiary cases."},
	{"metric": "economy", "action": "Reviewed employment, business activity, and local investment conditions."},
	{"metric": "public_safety", "action": "Reviewed public-safety coordination and emergency readiness."}
]

var _fictional_name_cache: Array = []

func _fictional_name_count() -> int:
	_load_fictional_names()
	return _fictional_name_cache.size()

func _fictional_name_at(index: int) -> String:
	_load_fictional_names()
	if _fictional_name_cache.is_empty():
		return "Unassigned Member"
	return str(_fictional_name_cache[posmod(index, _fictional_name_cache.size())])

func _load_fictional_names() -> void:
	if not _fictional_name_cache.is_empty():
		return
	var file := FileAccess.open("res://Data/fictional_indian_names.json", FileAccess.READ)
	if file == null:
		_fictional_name_cache = ["Aarav Kulkarni", "Meera Hegde", "Rohan Shetty", "Ananya Rao"]
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Array:
		_fictional_name_cache = parsed
	else:
		_fictional_name_cache = ["Aarav Kulkarni", "Meera Hegde", "Rohan Shetty", "Ananya Rao"]


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


var _india_district_catalog_cache: Array[Dictionary] = []
var _india_district_catalog_loaded: bool = false

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
var last_local_election_details: Dictionary = {}
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
var _district_offices_ensured_party_id: String = ""
var _assembly_offices_ensured_party_id: String = ""
var _lok_sabha_records: Array = []
var _assembly_records: Array = []

func _load_lok_sabha_records() -> void:
	if not _lok_sabha_records.is_empty():
		return
	var file := FileAccess.open("res://Data/lok_sabha_constituencies.json", FileAccess.READ)
	if file == null:
		push_warning("Lok Sabha constituency database could not be opened.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Lok Sabha constituency database has an invalid root structure.")
		return
	var rows: Variant = parsed.get("constituencies", [])
	if rows is Array:
		_lok_sabha_records = rows
		if _lok_sabha_records.size() != 543:
			push_warning("Lok Sabha constituency database should contain 543 records; found %d." % _lok_sabha_records.size())

func lok_sabha_integrity_summary() -> String:
	_load_lok_sabha_records()
	var expected_seats := 543
	var seen_constituencies: Dictionary = {}
	var invalid_rows := 0
	var duplicate_rows := 0
	for row_variant in _lok_sabha_records:
		if not row_variant is Dictionary:
			invalid_rows += 1
			continue
		var row: Dictionary = row_variant
		var state_name := str(row.get("state", "")).strip_edges()
		var constituency_name := str(row.get("name", "")).strip_edges()
		var constituency_number := int(row.get("number", 0))
		if state_name.is_empty() or constituency_name.is_empty() or constituency_number <= 0:
			invalid_rows += 1
			continue
		var key := "%s|%d" % [state_name, constituency_number]
		if seen_constituencies.has(key):
			duplicate_rows += 1
		else:
			seen_constituencies[key] = true
	var status := "PASS" if _lok_sabha_records.size() == expected_seats and invalid_rows == 0 and duplicate_rows == 0 else "REVIEW REQUIRED"
	var summary := "CONSTITUENCY DATA  %s\nRecords  %d / %d\nUnique state-seat keys  %d\nInvalid rows  %d · Duplicate state-seat keys  %d" % [status, _lok_sabha_records.size(), expected_seats, seen_constituencies.size(), invalid_rows, duplicate_rows]
	var national: Dictionary = world_state.get("national_election", {})
	var phase := str(national.get("phase", "Scheduled"))
	if phase == "Campaigning":
		var slate_variant: Variant = national.get("player_candidate_slate", [])
		var slate: Array = slate_variant if slate_variant is Array else []
		var candidate_ids: Dictionary = {}
		var missing_candidates := 0
		var duplicate_candidates := 0
		for candidate_variant in slate:
			if not candidate_variant is Dictionary or candidate_variant.is_empty():
				missing_candidates += 1
				continue
			var candidate: Dictionary = candidate_variant
			var member_id := str(candidate.get("member_id", "")).strip_edges()
			if member_id.is_empty():
				missing_candidates += 1
			elif candidate_ids.has(member_id):
				duplicate_candidates += 1
			else:
				candidate_ids[member_id] = true
		var slate_status := "PASS" if slate.size() == expected_seats and missing_candidates == 0 and duplicate_candidates == 0 else "REVIEW REQUIRED"
		summary += "\n\nPLAYER TICKET SLATE  %s\nTickets  %d / %d\nMissing member IDs  %d · Duplicate member IDs  %d" % [slate_status, slate.size() - missing_candidates, expected_seats, missing_candidates, duplicate_candidates]
	else:
		summary += "\n\nPlayer ticket slate opens during the campaign period."
	return summary


func lok_sabha_candidate_review_rows() -> Array[Dictionary]:
	_ensure_high_command_schema()
	_load_lok_sabha_records()
	var command: Dictionary = world_state.get("high_command", {})
	var decisions: Dictionary = command.get("national_candidate_review", {})
	var assignments: Dictionary = command.get("national_candidate_assignments", {})
	var records := _ensure_player_candidate_records(543, "India")
	var rows: Array[Dictionary] = []
	for seat_index in range(mini(543, _lok_sabha_records.size())):
		var seat_number := seat_index + 1
		var source: Dictionary = _lok_sabha_records[seat_index]
		var record: Dictionary = {}
		var assigned_id := str(assignments.get(str(seat_number), ""))
		if not assigned_id.is_empty():
			for member_variant in records:
				if member_variant is Dictionary and str(member_variant.get("id", "")) == assigned_id:
					record = member_variant
					break
		rows.append({
				"seat_number": seat_number,
				"state": str(source.get("state", "")),
				"constituency": str(source.get("name", "")),
				"member_id": str(record.get("id", "")),
				"candidate_name": str(record.get("name", "Nominee not assigned")),
				"decision": str(decisions.get(str(seat_number), "Pending"))
			})
	return rows

func lok_sabha_party_member_search(query: String = "") -> Array[Dictionary]:
	var records := _ensure_player_candidate_records(543, "India")
	var normalized := query.strip_edges().to_lower()
	var results: Array[Dictionary] = []
	for record_variant in records:
		if not record_variant is Dictionary:
			continue
		var record: Dictionary = record_variant
		var member_name := str(record.get("name", ""))
		var member_id := str(record.get("id", ""))
		if normalized.is_empty() or member_name.to_lower().contains(normalized) or member_id.to_lower().contains(normalized):
			results.append({"id": member_id, "name": member_name})
	return results

func assign_lok_sabha_candidate(seat_number: int, member_id: String) -> String:
	if seat_number < 1 or seat_number > 543:
		return "Choose a valid Lok Sabha constituency."
	var records := _ensure_player_candidate_records(543, "India")
	var found := false
	for record_variant in records:
		if record_variant is Dictionary and str(record_variant.get("id", "")) == member_id:
			found = true
			break
	if not found:
		return "That party member could not be found in your roster."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments: Dictionary = command.get("national_candidate_assignments", {})
	for assigned_seat_variant in assignments.keys():
		var assigned_seat := int(assigned_seat_variant)
		if assigned_seat != seat_number and str(assignments[assigned_seat_variant]) == member_id:
			return "That member is already assigned to Lok Sabha constituency %d. Each member can be nominated to only one seat." % assigned_seat
	assignments[str(seat_number)] = member_id
	command["national_candidate_assignments"] = assignments
	world_state["high_command"] = command
	_invalidate_lok_sabha_candidate_slate()
	return "Member assigned to Lok Sabha constituency %d. Ticket remains Pending until approved." % seat_number

func set_lok_sabha_candidate_decision(seat_number: int, decision: String) -> String:
	if seat_number < 1 or seat_number > 543 or decision not in ["Approved", "Rejected", "Pending"]:
		return "Select a valid constituency and review decision."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	if decision == "Approved":
		var assignments: Dictionary = command.get("national_candidate_assignments", {})
		var assigned_id := str(assignments.get(str(seat_number), ""))
		if assigned_id.is_empty():
			var records := _ensure_player_candidate_records(543, "India")
			var default_index := seat_number - 1
			if default_index < 0 or default_index >= records.size():
				return "No default nominee is available for this constituency."
			assigned_id = str(records[default_index].get("id", ""))
			assignments[str(seat_number)] = assigned_id
			command["national_candidate_assignments"] = assignments
		for assigned_seat_variant in assignments.keys():
			if int(assigned_seat_variant) != seat_number and str(assignments[assigned_seat_variant]) == assigned_id:
				return "This member is already assigned to another Lok Sabha constituency."
	var decisions: Dictionary = command.get("national_candidate_review", {})
	decisions[str(seat_number)] = decision
	command["national_candidate_review"] = decisions
	world_state["high_command"] = command
	_invalidate_lok_sabha_candidate_slate()
	return "Lok Sabha ticket %d marked %s." % [seat_number, decision.to_lower()]

func auto_assign_unassigned_lok_sabha_candidates() -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments: Dictionary = command.get("national_candidate_assignments", {})
	var records := _ensure_player_candidate_records(543, "India")
	var used_ids: Dictionary = {}
	for value in assignments.values():
		var existing_id := str(value)
		if not existing_id.is_empty():
			used_ids[existing_id] = true
	var available_ids: Array[String] = []
	for record_variant in records:
		if not record_variant is Dictionary:
			continue
		var member_id := str(record_variant.get("id", ""))
		if not member_id.is_empty() and not used_ids.has(member_id) and not available_ids.has(member_id):
			available_ids.append(member_id)
	var assigned_count := 0
	var next_member_index := 0
	for seat_number in range(1, 544):
		if not str(assignments.get(str(seat_number), "")).is_empty():
			continue
		if next_member_index >= available_ids.size():
			break
		assignments[str(seat_number)] = available_ids[next_member_index]
		next_member_index += 1
		assigned_count += 1
	command["national_candidate_assignments"] = assignments
	world_state["high_command"] = command
	_invalidate_lok_sabha_candidate_slate()
	return "Auto-assigned %d previously unassigned Lok Sabha ticket(s). Existing assignments were preserved; each member is assigned at most once." % assigned_count


func bulk_approve_assigned_lok_sabha_candidates() -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments: Dictionary = command.get("national_candidate_assignments", {})
	var decisions: Dictionary = command.get("national_candidate_review", {})
	var approved_count := 0
	var skipped_count := 0
	var seen_ids: Dictionary = {}
	for seat_variant in assignments.keys():
		var seat_number := int(seat_variant)
		var member_id := str(assignments[seat_variant])
		if member_id.is_empty() or seat_number < 1 or seat_number > 543:
			skipped_count += 1
			continue
		if str(decisions.get(str(seat_number), "Pending")) != "Pending":
			continue
		if seen_ids.has(member_id):
			skipped_count += 1
			continue
		seen_ids[member_id] = true
		decisions[str(seat_number)] = "Approved"
		approved_count += 1
	command["national_candidate_review"] = decisions
	world_state["high_command"] = command
	_invalidate_lok_sabha_candidate_slate()
	return "Bulk approval complete: %d assigned pending ticket(s) approved; %d invalid or duplicate assignment(s) skipped. Rejected or already reviewed tickets were left unchanged." % [approved_count, skipped_count]


func _invalidate_lok_sabha_candidate_slate() -> void:
	var national: Dictionary = world_state.get("national_election", {})
	national.erase("player_candidate_slate")
	national.erase("player_candidate_slate_key")
	world_state["national_election"] = national


func _lok_sabha_record_for_seat(seat_number: int) -> Dictionary:
	_load_lok_sabha_records()
	var index := seat_number - 1
	if index < 0 or index >= _lok_sabha_records.size():
		return {}
	var row: Variant = _lok_sabha_records[index]
	return row if row is Dictionary else {}

func _load_assembly_records() -> void:
	if not _assembly_records.is_empty():
		return
	var file := FileAccess.open("res://Data/assembly_constituencies.json", FileAccess.READ)
	if file == null:
		push_warning("Assembly constituency database could not be opened.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		push_warning("Assembly constituency database has an invalid root structure.")
		return
	var rows: Variant = parsed.get("constituencies", [])
	if rows is Array:
		_assembly_records = rows
		var karnataka_count := 0
		var placeholder_count := 0
		for row in _assembly_records:
			if row is Dictionary:
				if str(row.get("state", "")) == "Karnataka":
					karnataka_count += 1
				if str(row.get("record_status", "")) == "fictional_placeholder":
					placeholder_count += 1
		if karnataka_count != 224:
			push_warning("Karnataka Assembly database should contain 224 records; found %d." % karnataka_count)
		if placeholder_count > 0:
			push_warning("Assembly database contains %d explicitly fictional constituency placeholders; these are not official names." % placeholder_count)

func _assembly_record_for_seat(state_name: String, seat_number: int) -> Dictionary:
	_load_assembly_records()
	for row in _assembly_records:
		if row is Dictionary and str(row.get("state", "")) == state_name and int(row.get("number", -1)) == seat_number:
			return row
	return {}

func _constituency_name_for_seat(state_name: String, seat_number: int) -> String:
	if state_name.is_empty():
		var parliamentary_record := _lok_sabha_record_for_seat(seat_number)
		if not parliamentary_record.is_empty():
			return str(parliamentary_record.get("name", "Parliamentary Constituency %03d" % seat_number))
		return "Parliamentary Constituency %03d" % seat_number
	var assembly_record := _assembly_record_for_seat(state_name, seat_number)
	if not assembly_record.is_empty():
		return str(assembly_record.get("name", "%s Assembly Constituency %03d" % [state_name, seat_number]))
	return "%s Assembly Constituency %03d" % [state_name, seat_number]

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
	_ensure_authority_schema()
	for party_id_variant in parties.keys():
		_ensure_party_roster(str(party_id_variant))
	_ensure_party_map_colors()

func _initialize_world_state() -> void:
	_district_offices_ensured_party_id = ""
	_assembly_offices_ensured_party_id = ""
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
		"political_authority": {
			"schema_version": 1,
			"positions": {},
			"history": [],
			"last_updated_index": year * 12 + month
		},
		"regional_support": regional_support,
		"state_elections": state_elections,
		"national_election": {"next_year": 2029, "month": 5, "seats": 543, "last_result": "Not yet held", "last_winner": ""},
		"governments": {"schema_version": 4, "national": {}, "states": {}, "districts": {}, "history": [], "last_ai_month_index": -1},
		"high_command": {"strategy": "Balanced outreach", "monthly_campaign_budget": HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET, "coalition_policy": "modeled negotiate a working majority", "auto_candidate_nomination": true, "month_index": -1, "spent_this_month": 0, "local_candidate_counter": 0},
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
	_ensure_party_map_colors()

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
				"campaign_spend_by_party": {},
				"campaign_spend_by_constituency": {}
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
			election["campaign_spend_by_constituency"] = election.get("campaign_spend_by_constituency", {})
			election["high_command_slate_approved"] = bool(election.get("high_command_slate_approved", false))
			election["high_command_priority"] = str(election.get("high_command_priority", "Balanced outreach"))
			election["high_command_monthly_budget"] = int(election.get("high_command_monthly_budget", 50000))
			saved_elections[i] = election
		# Backfill every modeled state into older saves without replacing existing records.
		var modeled_state_names: Array[String] = [
			"Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
			"Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
			"Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
			"Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan",
			"Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh",
			"Uttarakhand", "West Bengal"
		]
		var present_states: Dictionary = {}
		for saved_variant in saved_elections:
			if saved_variant is Dictionary:
				var saved_state := str(saved_variant.get("state", "")).strip_edges()
				if not saved_state.is_empty():
					present_states[saved_state] = true
		for state_index in range(modeled_state_names.size()):
			var modeled_state := modeled_state_names[state_index]
			if present_states.has(modeled_state):
				continue
			saved_elections.append({
				"state": modeled_state,
				"next_year": 2028 + (state_index % 4),
				"month": 5 if state_index % 2 == 0 else 11,
				"assembly_seats": int(STATE_ASSEMBLY_SEATS.get(modeled_state, 60)),
				"last_result": "Not yet held",
				"last_winner": "",
				"phase": "Scheduled",
				"campaign_spend_by_party": {},
				"campaign_spend_by_constituency": {}
			})
		world_state["state_elections"] = saved_elections

	if not world_state.has("national_election") or not (world_state.get("national_election") is Dictionary):
		world_state["national_election"] = {
			"next_year": 2029, "month": 5, "seats": 543,
			"last_result": "Not yet held", "last_winner": "",
			"phase": "Scheduled", "campaign_spend_by_party": {}, "campaign_spend_by_constituency": {}
		}
	else:
		var national: Dictionary = world_state.get("national_election", {})
		national["phase"] = str(national.get("phase", "Scheduled"))
		national["campaign_spend_by_party"] = national.get("campaign_spend_by_party", {})
		national["campaign_spend_by_constituency"] = national.get("campaign_spend_by_constituency", {})
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
	_ensure_party_map_colors()
	_ensure_high_command_schema()
	_ensure_government_system()
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

	# AI organization builds and loses support state by state. Give the player's
	# party a visible, gradual national-growth baseline so a newly founded party
	# does not remain trapped near its initial 1% popularity. Growth scales modestly
	# with membership; home-state activity receives an additional local bonus.
	if parties.has(player_party_id):
		var player_party: Dictionary = parties[player_party_id]
		var player_members := maxi(0, int(player_party.get("members", 0)))
		var monthly_popularity_growth := 0.15 + minf(0.20, float(player_members) / 20000.0)
		player_party["popularity"] = minf(45.0, float(player_party.get("popularity", 0.0)) + monthly_popularity_growth)
		parties[player_party_id] = player_party

	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties[party_id]
		var party_popularity := float(party.get("popularity", 0.0))
		var support_by_state: Dictionary = regional.get(party_id, {})
		for state_name_variant in support_by_state.keys():
			var state_name := str(state_name_variant)
			var support := float(support_by_state[state_name])
			var drift := (party_popularity - support) * 0.05
			if party_id == player_party_id:
				# Small, persistent national outreach; stronger in the player's home state.
				drift += 0.15
				if state_name == home_state:
					drift += 0.25
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
	_ensure_government_system()
	_advance_ai_local_government_elections(report_lines)
	_run_ai_government_monthly()
	var government_system: Dictionary = world_state.get("governments", {})
	var state_governments: Dictionary = government_system.get("states", {})
	var local_governments: Dictionary = government_system.get("districts", {})
	report_lines.append("Union, state, and district administrations completed their monthly review (%d state governments, %d district administrations). Party organizations field candidates and run campaigns; the player makes High Command strategy decisions only. Party leadership never transfers an executive office to the player." % [state_governments.size(), local_governments.size()])

	if report_lines.is_empty():
		report_lines.append("Party organizations reviewed regional support and continued routine activity across India.")
	world_state["last_monthly_report"] = "\n".join(report_lines)
	_record_strategic_snapshot()
	notifications.append_array(report_lines)

func _record_strategic_snapshot() -> void:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	var history_variant: Variant = world_state.get("strategic_history", [])
	var history: Array = history_variant if history_variant is Array else []
	var month_index := year * 12 + month
	if not history.is_empty() and int(history[-1].get("month_index", -1)) == month_index:
		return
	var party: Dictionary = parties.get(player_party_id, {})
	var support_by_state: Dictionary = world_state.get("regional_support", {}).get(player_party_id, {})
	var support_total := 0.0
	var support_count := 0
	for support_variant in support_by_state.values():
		support_total += float(support_variant)
		support_count += 1
	var state_elected := 0
	var state_contested := 0
	for election_variant in world_state.get("state_elections", []):
		if election_variant is Dictionary:
			var election: Dictionary = election_variant
			state_elected += int(election.get("player_party_candidates_elected", 0))
			state_contested += int(election.get("player_party_candidates_contested", 0))
	var national: Dictionary = world_state.get("national_election", {})
	state_elected += int(national.get("player_party_candidates_elected", 0))
	state_contested += int(national.get("player_party_candidates_contested", 0))
	history.append({
		"month_index": month_index,
		"date": date_label(),
		"party_funds": int(party.get("funds", 0)),
		"members": int(party.get("members", 0)),
		"average_regional_support": support_total / float(maxi(1, support_count)),
		"candidates_contested": state_contested,
		"candidates_elected": state_elected,
		"campaign_spent": int(world_state.get("high_command", {}).get("spent_this_month", 0))
	})
	while history.size() > 24:
		history.pop_front()
	world_state["strategic_history"] = history

func strategic_performance_summary() -> String:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return "Start or join a party to build a strategic performance record."
	var history_variant: Variant = world_state.get("strategic_history", [])
	var history: Array = history_variant if history_variant is Array else []
	if history.is_empty():
		return "No monthly review recorded yet. Advance one month to establish the first baseline."
	var latest: Dictionary = history[-1]
	var previous: Dictionary = history[-2] if history.size() > 1 else latest
	var support_change := float(latest.get("average_regional_support", 0.0)) - float(previous.get("average_regional_support", 0.0))
	var member_change := int(latest.get("members", 0)) - int(previous.get("members", 0))
	var funds_change := int(latest.get("party_funds", 0)) - int(previous.get("party_funds", 0))
	var lines: Array[String] = ["STRATEGIC PERFORMANCE REVIEW  ·  %s" % str(latest.get("date", date_label()))]
	lines.append("Party treasury: ₹%s  (%s₹%s vs. previous month)" % [_format_number(int(latest.get("party_funds", 0))), "+" if funds_change >= 0 else "−", _format_number(absi(funds_change))])
	lines.append("Membership: %s  (%s%d)" % [_format_number(int(latest.get("members", 0))), "+" if member_change >= 0 else "", member_change])
	lines.append("Average regional support: %.1f%%  (%s%.2f points)" % [float(latest.get("average_regional_support", 0.0)), "+" if support_change >= 0.0 else "", support_change])
	lines.append("Campaign spend this month: ₹%s" % _format_number(int(latest.get("campaign_spent", 0))))
	lines.append("Recorded party candidates: %d contested  ·  %d elected" % [int(latest.get("candidates_contested", 0)), int(latest.get("candidates_elected", 0))])
	var regional: Dictionary = world_state.get("regional_support", {}).get(player_party_id, {})
	var regional_rows: Array[Dictionary] = []
	for state_variant in regional.keys():
		regional_rows.append({"state": str(state_variant), "support": float(regional[state_variant])})
	regional_rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("support", 0.0)) > float(b.get("support", 0.0))
	)
	if not regional_rows.is_empty():
		var strongest: Array[String] = []
		var priority: Array[String] = []
		for i in range(mini(3, regional_rows.size())):
			var row: Dictionary = regional_rows[i]
			strongest.append("%s %.1f%%" % [str(row.get("state", "")), float(row.get("support", 0.0))])
		var start_index := maxi(0, regional_rows.size() - 3)
		for i in range(start_index, regional_rows.size()):
			var row: Dictionary = regional_rows[i]
			priority.append("%s %.1f%%" % [str(row.get("state", "")), float(row.get("support", 0.0))])
		lines.append("STRONGEST REGIONAL BASES  ·  %s" % "  /  ".join(strongest))
		lines.append("BUILD-OUT PRIORITIES  ·  %s" % "  /  ".join(priority))
	lines.append("Use State Assemblies dossiers to review each state’s calendar, slate, spending, and latest result before changing campaign priorities.")
	lines.append("Review history: %d monthly snapshots retained" % history.size())
	return "\n".join(lines)

func election_readiness_summary() -> String:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return "Start or join a party to review election readiness."
	_ensure_election_schema()
	var rows: Array[Dictionary] = []
	var regional: Dictionary = world_state.get("regional_support", {}).get(player_party_id, {})
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		var state_name := str(election.get("state", "State"))
		var months_left := _months_until_election(election)
		var seats := int(election.get("assembly_seats", STATE_ASSEMBLY_SEATS.get(state_name, 60)))
		var phase := str(election.get("phase", "Scheduled"))
		var slate: Array = election.get("player_candidate_slate", []) if phase == "Campaigning" else []
		var support := float(regional.get(state_name, 0.0))
		var organization_profile: Dictionary = party_organization_profile(state_name)
		var organization_score := int(organization_profile.get("readiness_score", 0))
		var organization_status := str(organization_profile.get("readiness", "No structure"))
		var readiness := "EARLY PLANNING"
		if phase == "Campaigning":
			readiness = "CAMPsimulationGN ACTIVE"
		elif months_left <= 12:
			readiness = "PREPARE CANDIDATES"
		rows.append({"name": state_name, "months": months_left, "year": int(election.get("next_year", year)), "month": int(election.get("month", 1)), "seats": seats, "phase": phase, "readiness": readiness, "support": support, "organization_score": organization_score, "organization_status": organization_status, "slate": slate.size(), "spend": int(election.get("campaign_spend_by_party", {}).get(player_party_id, 0))})
	var national: Dictionary = world_state.get("national_election", {})
	if not national.is_empty():
		var national_months := _months_until_election(national)
		var national_phase := str(national.get("phase", "Scheduled"))
		var national_slate: Array = national.get("player_candidate_slate", []) if national_phase == "Campaigning" else []
		var national_readiness := "EARLY PLANNING"
		if national_phase == "Campaigning":
			national_readiness = "CAMPsimulationGN ACTIVE"
		elif national_months <= 12:
			national_readiness = "PREPARE CANDIDATES"
		rows.append({"name": "Lok Sabha · India", "months": national_months, "year": int(national.get("next_year", year)), "month": int(national.get("month", 1)), "seats": int(national.get("seats", 543)), "phase": national_phase, "readiness": national_readiness, "support": float(parties[player_party_id].get("popularity", 0.0)), "slate": national_slate.size(), "spend": int(national.get("campaign_spend_by_party", {}).get(player_party_id, 0))})
	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("months", 0)) < int(b.get("months", 0))
	)
	var lines: Array[String] = ["ELECTION READINESS · NEXT POLLS", "Planning view only; it does not predict or alter election results."]
	var shown := 0
	for row_variant in rows:
		if not row_variant is Dictionary:
			continue
		var row: Dictionary = row_variant
		if int(row.get("months", 0)) < 0:
			continue
		var timing := "this month" if int(row.get("months", 0)) == 0 else "in %d months" % int(row.get("months", 0))
		var coverage := "slate %d/%d" % [int(row.get("slate", 0)), int(row.get("seats", 0))] if str(row.get("phase", "")) == "Campaigning" else "candidate slate opens during campaign period"
		var organization_detail := "ground network %d/100 · %s" % [int(row.get("organization_score", 0)), str(row.get("organization_status", "No structure"))] if row.has("organization_score") else "national coverage is built through state organizations"
		lines.append("%s · %s %d · %s · %s · support %.1f%% · %s · %s" % [str(row.get("name", "Election")), _month_name(int(row.get("month", 1))), int(row.get("year", year)), timing, str(row.get("readiness", "")), float(row.get("support", 0.0)), organization_detail, coverage])
		shown += 1
		if shown >= 6:
			break
	if shown == 0:
		lines.append("No upcoming election dates are currently recorded.")
	lines.append("Use the state and Lok Sabha dossiers for recorded campaign spending, results, and constituency-level analysis.")
	return "\n".join(lines)

func _months_until_election(election: Dictionary) -> int:
	var election_year := int(election.get("next_year", year))
	var election_month := clampi(int(election.get("month", 1)), 1, 12)
	return (election_year - year) * 12 + (election_month - month)


func _lok_sabha_nomination_readiness() -> Dictionary:
	var rows := lok_sabha_candidate_review_rows()
	var assigned := 0
	var approved := 0
	var duplicate_count := 0
	var seen_member_ids: Dictionary = {}
	for row in rows:
		var member_id := str(row.get("member_id", "")).strip_edges()
		if member_id.is_empty():
			continue
		assigned += 1
		if seen_member_ids.has(member_id):
			duplicate_count += 1
		else:
			seen_member_ids[member_id] = true
		if str(row.get("decision", "Pending")) == "Approved":
			approved += 1
	var ready := rows.size() == 543 and assigned == 543 and approved == 543 and duplicate_count == 0
	return {
		"ready": ready,
		"total": rows.size(),
		"assigned": assigned,
		"approved": approved,
		"vacant": maxi(0, rows.size() - assigned),
		"duplicate": duplicate_count
	}


func lok_sabha_polling_counting_summary() -> String:
	var election: Dictionary = world_state.get("national_election", {})
	if election.is_empty():
		return "No Lok Sabha election record is available."
	var phase := str(election.get("phase", "Scheduled"))
	var next_date := "%s %d" % [_month_name(int(election.get("month", 5))), int(election.get("next_year", year))]
	match phase:
		"Polling":
			return "POLLING DAY  ·  %s\nPolling is recorded for this election. Constituency declarations begin when the simulation advances to counting." % next_date
		"Counting":
			var total := maxi(1, int(election.get("counting_total_constituencies", election.get("seats", 543))))
			var declared := clampi(int(election.get("counted_constituencies", 0)), 0, total)
			var round_number := clampi(int(election.get("counting_round", 0)), 0, 4)
			var pending: Dictionary = election.get("counting_pending_result", {})
			var results: Array = pending.get("constituency_results", [])
			var tally: Dictionary = {}
			for index in range(mini(declared, results.size())):
				var seat_variant: Variant = results[index]
				if not seat_variant is Dictionary:
					continue
				var seat: Dictionary = seat_variant
				var winner_id := str(seat.get("winner_party_id", ""))
				if not winner_id.is_empty():
					tally[winner_id] = int(tally.get(winner_id, 0)) + 1
			var standings: Array[String] = []
			var party_ids: Array = tally.keys()
			party_ids.sort_custom(func(a: Variant, b: Variant) -> bool:
				var a_count := int(tally.get(a, 0))
				var b_count := int(tally.get(b, 0))
				if a_count == b_count:
					return _government_party_name(str(a)) < _government_party_name(str(b))
				return a_count > b_count
			)
			for index in range(mini(5, party_ids.size())):
				var party_id := str(party_ids[index])
				standings.append("%s — %d declared seats" % [_government_party_name(party_id), int(tally.get(party_id, 0))])
			return "COUNTING ROUND %d/4\nConstituencies declared: %d / %d\nConstituencies remaining: %d\n\nDECLARED-SEAT TALLY (not a projection)\n%s\n\nTurnout: %.1f%% · Ballots cast: %s / %s" % [
				round_number, declared, total, total - declared,
				"\n".join(standings) if not standings.is_empty() else "No constituencies declared yet.",
				float(election.get("polling_turnout_percent", 0.0)),
				_format_number(int(election.get("polling_ballots_cast", 0))),
				_format_number(int(election.get("polling_eligible_voters", 0)))
			]
		"Completed":
			return "COUNT COMPLETE  ·  FINAL RESULT LOCKED\nAll %d constituencies declared.\nFinal result: %s\nTurnout: %.1f%% · Ballots cast: %s / %s" % [
				int(election.get("seats", 543)), str(election.get("last_result", "Final result recorded")),
				float(election.get("last_turnout_percent", 0.0)),
				_format_number(int(election.get("last_ballots_cast", 0))),
				_format_number(int(election.get("last_eligible_voters", 0)))
			]
		"Campaigning":
			return "PRE-POLL CAMPAIGN\nScheduled polling: %s\nNo votes have been counted." % next_date
		_:
			return "NEXT LOK SABHA POLL  ·  %s\nPhase: %s\nPolling and counting are simulated game records, not real-world live results." % [next_date, phase]


func _shift_election_date(election: Dictionary, months_to_add: int) -> void:
	var absolute_month := year * 12 + month - 1
	absolute_month += maxi(1, months_to_add)
	election["next_year"] = int(floor(float(absolute_month) / 12.0))
	election["month"] = absolute_month % 12 + 1


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
	if jurisdiction == "Lok Sabha":
		var nomination_status := _lok_sabha_nomination_readiness()
		if not bool(nomination_status.get("ready", false)):
			if months_remaining <= MODELED_CAMPAIGN_MONTHS:
				var first_nomination_hold := not bool(election.get("nomination_hold", false))
				_shift_election_date(election, MODELED_CAMPAIGN_MONTHS + 1)
				election["phase"] = "Scheduled"
				election["nomination_hold"] = true
				election["nomination_hold_reason"] = "Campaign held: approve unique nominees for all 543 Lok Sabha constituencies."
				election.erase("player_candidate_slate")
				election.erase("player_candidate_slate_key")
				if first_nomination_hold:
					report_lines.append("Lok Sabha campaign held. %d of 543 seats have nominees and %d tickets are approved; %d duplicate member assignments must be resolved. Poll date moved to %s %d." % [
						int(nomination_status.get("assigned", 0)),
						int(nomination_status.get("approved", 0)),
						int(nomination_status.get("duplicate", 0)),
						_month_name(int(election.get("month", month))),
						int(election.get("next_year", year))
					])
			return election
		if bool(election.get("nomination_hold", false)):
			if months_remaining <= MODELED_CAMPAIGN_MONTHS:
				_shift_election_date(election, MODELED_CAMPAIGN_MONTHS + 1)
				months_remaining = _months_until_election(election)
			election.erase("nomination_hold")
			election.erase("nomination_hold_reason")
			report_lines.append("Lok Sabha nomination slate is complete. The national campaign can now begin.")
	if months_remaining > MODELED_CAMPAIGN_MONTHS:
		election["phase"] = "Scheduled"
		return election

	if months_remaining > 0:
		if str(election.get("phase", "")) != "Campaigning":
			var focus_state := str(world_state.get("high_command", {}).get("campaign_focus_state", ""))
			var focus_note := " High Command priority: %s." % focus_state if not focus_state.is_empty() and focus_state == state_name else ""
			report_lines.append("Campaign period opened for %s. The party is increasing outreach and directing a larger share of its available campaign budget to the nearest election.%s" % [jurisdiction, focus_note])
		election["phase"] = "Campaigning"
		election["months_to_poll"] = months_remaining
		if not player_party_id.is_empty():
			_prepare_player_candidate_slate(election, jurisdiction, seat_count, state_name)
		_run_modeled_ai_campaigns(election, state_name)
		return election

	var result: Dictionary = {}
	if jurisdiction != "Lok Sabha":
		# State Assembly elections follow the same polling/counting lifecycle as Lok Sabha.
		# Candidate results are computed at poll close, held privately, and released in four
		# staged constituency-declaration rounds. No interim leads are fabricated.
		var state_phase := str(election.get("phase", "Scheduled"))
		if state_phase in ["Scheduled", "Campaigning"]:
			election["phase"] = "Polling"
			election["results_locked"] = false
			election["polling_year"] = year
			election["polling_month"] = month
			election["counting_round"] = 0
			election["counted_constituencies"] = 0
			election["counting_total_constituencies"] = seat_count
			report_lines.append("%s polling day reached. Constituency results will be declared in staged counting." % jurisdiction)
			return election
		elif state_phase == "Polling":
			result = _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
			election["counting_pending_result"] = result
			election["phase"] = "Counting"
			election["counting_round"] = 0
			election["counted_constituencies"] = 0
			election["counting_total_constituencies"] = seat_count
			election["polling_eligible_voters"] = int(result.get("eligible_voters", 0))
			election["polling_ballots_cast"] = int(result.get("ballots_cast", 0))
			election["polling_turnout_percent"] = float(result.get("turnout_percent", 0.0))
			report_lines.append("%s polling closed. Counting has begun; no constituency is declared until its counting round is released." % jurisdiction)
			return election
		elif state_phase == "Counting":
			var next_round := mini(4, int(election.get("counting_round", 0)) + 1)
			var total_constituencies := maxi(1, int(election.get("counting_total_constituencies", seat_count)))
			var declared_target := mini(total_constituencies, int(ceil(float(total_constituencies * next_round) / 4.0)))
			election["counting_round"] = next_round
			election["counted_constituencies"] = declared_target
			if next_round < 4:
				report_lines.append("%s counting round %d/4 complete: %d of %d constituencies declared." % [jurisdiction, next_round, declared_target, total_constituencies])
				return election
			var pending_state_result: Variant = election.get("counting_pending_result", {})
			result = pending_state_result if pending_state_result is Dictionary else {}
			election.erase("counting_pending_result")
		else:
			result = _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
	elif jurisdiction == "Lok Sabha":
		var election_phase := str(election.get("phase", "Scheduled"))
		if election_phase in ["Scheduled", "Campaigning"]:
			election["phase"] = "Polling"
			election["results_locked"] = false
			election["polling_year"] = year
			election["polling_month"] = month
			election["counting_round"] = 0
			election["counted_constituencies"] = 0
			election["counting_total_constituencies"] = seat_count
			report_lines.append("Lok Sabha polling day reached. Constituency results will be declared in staged counting.")
			return election
		elif election_phase == "Polling":
			result = _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
			election["counting_pending_result"] = result
			election["phase"] = "Counting"
			election["counting_round"] = 0
			election["counted_constituencies"] = 0
			election["counting_total_constituencies"] = seat_count
			election["polling_eligible_voters"] = int(result.get("eligible_voters", 0))
			election["polling_ballots_cast"] = int(result.get("ballots_cast", 0))
			election["polling_turnout_percent"] = float(result.get("turnout_percent", 0.0))
			report_lines.append("Lok Sabha polling closed. Counting has begun; no constituency is declared until its counting round is released.")
			return election
		elif election_phase == "Counting":
			var next_round := mini(4, int(election.get("counting_round", 0)) + 1)
			var total_constituencies := maxi(1, int(election.get("counting_total_constituencies", seat_count)))
			var declared_target := mini(total_constituencies, int(ceil(float(total_constituencies * next_round) / 4.0)))
			election["counting_round"] = next_round
			election["counted_constituencies"] = declared_target
			if next_round < 4:
				report_lines.append("Lok Sabha counting round %d/4 complete: %d of %d constituencies declared." % [next_round, declared_target, total_constituencies])
				return election
			var pending_result: Variant = election.get("counting_pending_result", {})
			result = pending_result if pending_result is Dictionary else {}
			election.erase("counting_pending_result")
		else:
			result = _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
	else:
		result = _resolve_modeled_election(election, jurisdiction, seat_count, state_name, regional)
	if result.is_empty():
		return election
	election["last_result"] = str(result.get("summary", "Election completed"))
	election["last_winner"] = str(result.get("winner_id", ""))
	election["last_seats"] = result.get("seats_by_party", {})
	election["last_vote_shares"] = result.get("vote_shares", {})
	election["last_constituency_results"] = result.get("constituency_results", [])
	election["last_eligible_voters"] = int(result.get("eligible_voters", 0))
	election["last_ballots_cast"] = int(result.get("ballots_cast", 0))
	election["player_party_candidates_contested"] = int(result.get("player_party_candidates_contested", 0))
	election["player_party_candidates_elected"] = int(result.get("player_party_candidates_elected", 0))
	election["last_player_organization_score"] = int(result.get("player_organization_score", 0))
	election["last_player_organization_bonus"] = float(result.get("player_organization_bonus", 0.0))
	election["last_year"] = int(election.get("polling_year", year))
	election["last_month"] = int(election.get("polling_month", month))
	election["last_turnout_percent"] = float(result.get("turnout_percent", 0.0))
	election["phase"] = "Completed"
	election["results_locked"] = true
	election["last_campaign_spending"] = election.get("campaign_spend_by_party", {})
	election["last_campaign_spend_by_constituency"] = election.get("campaign_spend_by_constituency", {})

	var history: Array = world_state.get("election_history", [])
	history.append({
		"jurisdiction": jurisdiction,
		"year": int(election.get("last_year", year)),
		"month": int(election.get("last_month", month)),
		"summary": election["last_result"],
		"winner_id": election["last_winner"],
		"seats_by_party": election["last_seats"],
		"vote_shares": election["last_vote_shares"],
		"eligible_voters": election["last_eligible_voters"],
		"ballots_cast": election["last_ballots_cast"],
		"turnout_percent": election["last_turnout_percent"],
		"player_party_candidates_contested": election["player_party_candidates_contested"],
		"player_party_candidates_elected": election["player_party_candidates_elected"],
		"player_organization_score": election["last_player_organization_score"],
		"player_organization_bonus": election["last_player_organization_bonus"]
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

	report_lines.append("%s result: %s. Turnout %.1f%%. Campaigns were modeled; this result does not directly appoint the player to office." % [
		jurisdiction, election["last_result"], election["last_turnout_percent"]
	])

	var election_cycle_base_year := int(election.get("polling_year", year)) if jurisdiction == "Lok Sabha" else year
	var next_year := int(election.get("next_year", election_cycle_base_year))
	while next_year <= election_cycle_base_year:
		next_year += MODELED_ELECTION_CYCLE_YEARS
	election["next_year"] = next_year
	var government_level := "state" if not state_name.is_empty() else "national"
	var government_jurisdiction := state_name if not state_name.is_empty() else "India"
	if government_level == "state" and government_jurisdiction == "Karnataka":
		# Karnataka government formation is a player decision. Keep the incumbent record
		# in place until High Command confirms a majority and appoints the CM.
		election["government_status"] = "Awaiting High Command formation"
		election["government_party_id"] = ""
		election["government_formation_pending"] = true
		world_state["pending_karnataka_government_formation"] = {
			"pending": true,
			"year": year,
			"month": month,
			"seats_by_party": (result.get("seats_by_party", {}) as Dictionary).duplicate(true),
			"total_seats": seat_count,
			"majority_required": int(floor(float(seat_count) / 2.0)) + 1,
			"vote_shares": (result.get("vote_shares", {}) as Dictionary).duplicate(true),
			"turnout_percent": float(result.get("turnout_percent", 0.0)),
			"winner_id": str(result.get("winner_id", "")),
			"next_year": next_year,
			"next_month": int(election.get("month", 5))
		}
		report_lines.append("Karnataka results are final. Government formation is awaiting your High Command decision. Review the result, negotiate a coalition if needed, and appoint the Chief Minister and cabinet.")
	else:
		var formed_government := _form_ai_government_from_result(
			government_level, government_jurisdiction, result.get("seats_by_party", {}),
			seat_count, next_year, int(election.get("month", 5))
		)
		election["government_status"] = str(formed_government.get("formation_type", "Government formed"))
		election["government_party_id"] = str(formed_government.get("ruling_party_id", ""))
		report_lines.append("Government formed in %s: %s, led by %s. Executive administration remains with the elected government; party leaders do not automatically receive office." % [
			government_jurisdiction,
			_government_party_name(str(formed_government.get("ruling_party_id", ""))),
			str(formed_government.get("leader_name", "Leader not recorded"))
		])
	election["phase"] = "Completed"
	election["months_to_poll"] = -1
	election["campaign_spend_by_party"] = {}
	election["campaign_spend_by_constituency"] = {}
	election["campaign_months_run"] = 0
	return election


func _high_command_budget_for_election(election: Dictionary, state_name: String) -> int:
	# During the three-month campaign window, allocate a larger share to the
	# nearest election. A selected focus state receives additional priority.
	var remaining_budget := _high_command_remaining_budget()
	if remaining_budget <= 0:
		return 0
	var current_remaining := _months_until_election(election)
	if current_remaining <= 0 or current_remaining > MODELED_CAMPAIGN_MONTHS:
		return 0

	var command: Dictionary = world_state.get("high_command", {})
	var focus_state := str(command.get("campaign_focus_state", ""))
	var current_weight := float(MODELED_CAMPAIGN_MONTHS + 1 - current_remaining)
	if not state_name.is_empty() and state_name == focus_state:
		current_weight *= 1.5

	var total_weight := 0.0
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var other: Dictionary = election_variant
		var remaining := _months_until_election(other)
		if remaining <= 0 or remaining > MODELED_CAMPAIGN_MONTHS:
			continue
		var weight := float(MODELED_CAMPAIGN_MONTHS + 1 - remaining)
		if str(other.get("state", "")) == focus_state and not focus_state.is_empty():
			weight *= 1.5
		total_weight += weight

	var national: Dictionary = world_state.get("national_election", {})
	var national_remaining := _months_until_election(national)
	if national_remaining > 0 and national_remaining <= MODELED_CAMPAIGN_MONTHS:
		total_weight += float(MODELED_CAMPAIGN_MONTHS + 1 - national_remaining)

	if total_weight <= 0.0:
		return 0
	return mini(remaining_budget, maxi(1, int(floor(float(remaining_budget) * current_weight / total_weight))))


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
		if party_id == player_party_id:
			monthly_budget = mini(
				_high_command_budget_for_election(election, state_name),
				HIGH_COMMAND_MAX_MONTHLY_BUDGET
			)
		var available_funds := maxi(0, int(party.get("funds", 0)))
		var spend := mini(available_funds, monthly_budget)
		if spend <= 0:
			continue
		party["funds"] = available_funds - spend
		parties[party_id] = party
		spending_by_party[party_id] = int(spending_by_party.get(party_id, 0)) + spend
		if party_id == player_party_id:
			_record_high_command_campaign_spend(spend)
			if state_name == "Karnataka":
				_record_karnataka_constituency_campaign_spend(election, spend)
	election["campaign_spend_by_party"] = spending_by_party
	election["campaign_months_run"] = int(election.get("campaign_months_run", 0)) + 1


func _record_karnataka_constituency_campaign_spend(election: Dictionary, monthly_spend: int) -> void:
	if monthly_spend <= 0:
		return
	var plans: Dictionary = world_state.get("constituency_campaign_plans", {})
	if plans.is_empty():
		return
	var spent_by_seat: Dictionary = election.get("campaign_spend_by_constituency", {})
	var candidates: Array[Dictionary] = []
	var total_weight := 0.0
	for key_variant in plans.keys():
		var key := str(key_variant)
		var plan: Dictionary = plans.get(key, {})
		var target := maxi(0, roundi(float(plan.get("allocation_crore", 0.0)) * 10000000.0))
		var already_spent := maxi(0, int(spent_by_seat.get(key, 0)))
		var remaining := maxi(0, target - already_spent)
		if remaining <= 0:
			continue
		var priority := str(plan.get("priority", "Target"))
		var priority_weight := 1.25 if priority == "Defend" else (0.5 if priority == "Low Priority" else 1.0)
		var weight := float(remaining) * priority_weight
		candidates.append({"key": key, "remaining": remaining, "weight": weight})
		total_weight += weight
	if candidates.is_empty() or total_weight <= 0.0:
		return
	var remaining_budget := monthly_spend
	# Split this month's already-approved campaign spend proportionally by plan size
	# and priority. Any unassigned amount remains general campaign spending.
	for index in range(candidates.size()):
		var row: Dictionary = candidates[index]
		var proposed := int(floor(float(monthly_spend) * float(row["weight"]) / total_weight))
		var allocation := mini(int(row["remaining"]), mini(proposed, remaining_budget))
		if allocation > 0:
			spent_by_seat[str(row["key"])] = int(spent_by_seat.get(str(row["key"]), 0)) + allocation
			remaining_budget -= allocation
	# Rounding remainder stays in general campaign spending; it is not charged again.
	election["campaign_spend_by_constituency"] = spent_by_seat


func karnataka_constituency_campaign_spend(seat_number: int) -> Dictionary:
	var elections: Array = world_state.get("state_elections", [])
	for election_variant in elections:
		if not election_variant is Dictionary or str(election_variant.get("state", "")) != "Karnataka":
			continue
		var election: Dictionary = election_variant
		var current: Dictionary = election.get("campaign_spend_by_constituency", {})
		var previous: Dictionary = election.get("last_campaign_spend_by_constituency", {})
		return {"current": int(current.get(str(seat_number), 0)), "previous": int(previous.get(str(seat_number), 0))}
	return {"current": 0, "previous": 0}


func karnataka_constituency_campaign_spending_summary() -> Dictionary:
	var elections: Array = world_state.get("state_elections", [])
	for election_variant in elections:
		if not election_variant is Dictionary or str(election_variant.get("state", "")) != "Karnataka":
			continue
		var election: Dictionary = election_variant
		var current: Dictionary = election.get("campaign_spend_by_constituency", {})
		var previous: Dictionary = election.get("last_campaign_spend_by_constituency", {})
		var current_total := 0
		var previous_total := 0
		for value in current.values(): current_total += int(value)
		for value in previous.values(): previous_total += int(value)
		return {"current": current_total, "previous": previous_total}
	return {"current": 0, "previous": 0}


func _resolve_modeled_election(
	election: Dictionary,
	jurisdiction: String,
	seat_count: int,
	state_name: String,
	regional: Dictionary
) -> Dictionary:
	var party_ids: Array[String] = []
	var spending_by_party: Dictionary = election.get("campaign_spend_by_party", {})
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		if not party_id.is_empty() and parties.has(party_id):
			party_ids.append(party_id)
	party_ids.sort()
	if party_ids.is_empty() or seat_count <= 0:
		return {"summary": "No eligible party was available to contest.", "winner_id": "", "seats_by_party": {}, "vote_shares": {}, "turnout_percent": 0.0, "constituency_results": [], "eligible_voters": 0, "ballots_cast": 0}

	var player_slate: Array[Dictionary] = _prepare_player_candidate_slate(election, jurisdiction, seat_count, state_name)
	var player_organization_profile: Dictionary = party_organization_profile(state_name) if not state_name.is_empty() else {}
	var player_organization_score := int(player_organization_profile.get("readiness_score", 0))
	var player_organization_bonus := float(player_organization_profile.get("election_score_bonus", 0.0))
	var base_scores: Dictionary = {}
	for party_id in party_ids:
		var party: Dictionary = parties.get(party_id, {})
		var base_support := float(party.get("popularity", 0.0))
		if not state_name.is_empty():
			var support_by_state: Dictionary = regional.get(party_id, {})
			base_support = float(support_by_state.get(state_name, base_support))
		var members := maxi(1, int(party.get("members", 1)))
		var campaign_score := minf(8.0, float(spending_by_party.get(party_id, 0)) / 100000.0)
		var high_command_bonus := _high_command_strategy_bonus() if party_id == player_party_id else 0.0
		var focus_bonus := 0.0
		if party_id == player_party_id and not state_name.is_empty():
			var command: Dictionary = world_state.get("high_command", {})
			if str(command.get("campaign_focus_state", "")) == state_name and int(spending_by_party.get(party_id, 0)) > 0:
				focus_bonus = 2.5
		var organization_bonus := player_organization_bonus if party_id == player_party_id else 0.0
		base_scores[party_id] = maxf(0.5, base_support + log(maxf(1.0, float(members)) / 1000.0) * 2.0 + campaign_score + high_command_bonus + focus_bonus + organization_bonus)

	var seats_by_party: Dictionary = {}
	var votes_by_party: Dictionary = {}
	var constituency_results: Array[Dictionary] = []
	var eligible_total := 0
	var ballots_total := 0
	var turnout_total := 0.0
	var player_contested := 0
	var player_elected := 0
	for seat_index in range(seat_count):
		var seat_number := seat_index + 1
		var constituency := _constituency_name_for_seat(state_name, seat_number)
		var local_scores: Dictionary = {}
		var score_total := 0.0
		for party_id in party_ids:
			if party_id == player_party_id and state_name == "Karnataka" and _get_player_candidate_for_seat(player_slate, seat_index).is_empty():
				continue
			var base_score := float(base_scores.get(party_id, 0.5))
			var variance_seed := absi((jurisdiction + "|" + str(year) + "|" + str(seat_number) + "|" + party_id).hash()) % 2801
			var local_variation := float(variance_seed) / 100.0 - 14.0
			var seat_score := maxf(0.2, base_score + local_variation)
			if party_id == player_party_id and state_name == "Karnataka":
				var targeted_spend: Dictionary = election.get("campaign_spend_by_constituency", {})
				var seat_spend := int(targeted_spend.get(str(seat_number), 0))
				# Targeted spending adds a modest seat-specific score bonus, capped at 4 points.
				seat_score += minf(4.0, float(seat_spend) / 2500000.0)
			local_scores[party_id] = seat_score
			score_total += seat_score
		var eligible_voters := 42000 + (absi((jurisdiction + "|eligible|" + str(seat_number) + "|" + str(year)).hash()) % 38000)
		var turnout_percent := 56.0 + float(absi((jurisdiction + "|turnout|" + str(seat_number) + "|" + str(year)).hash()) % 2200) / 100.0
		var ballots := maxi(1, roundi(float(eligible_voters) * turnout_percent / 100.0))
		var remaining_votes := ballots
		var candidate_rows: Array[Dictionary] = []
		var winning_party_id := ""
		var winning_candidate_name := ""
		var winning_votes := -1
		var active_party_ids: Array[String] = []
		for active_id in party_ids:
			if local_scores.has(active_id):
				active_party_ids.append(active_id)
		for party_index in range(active_party_ids.size()):
			var party_id := active_party_ids[party_index]
			var seat_score := float(local_scores.get(party_id, 0.0))
			var candidate_share := seat_score / maxf(score_total, 0.001)
			var candidate_votes := remaining_votes if party_index == active_party_ids.size() - 1 else clampi(roundi(float(ballots) * candidate_share), 0, remaining_votes)
			remaining_votes -= candidate_votes
			var roster_index := _candidate_pool_index_for_constituency(state_name, seat_index)
			var candidate: Dictionary = _candidate_record_for_party(party_id, roster_index, state_name)
			if party_id == player_party_id:
				var player_candidate := _get_player_candidate_for_seat(player_slate, seat_index)
				if not player_candidate.is_empty():
					candidate = player_candidate
					player_contested += 1
			var candidate_row := {
				"party_id": party_id,
				"party_name": str(parties.get(party_id, {}).get("name", party_id)),
				"member_id": str(candidate.get("member_id", "")),
				"candidate_name": str(candidate.get("candidate_name", "party candidate")),
				"votes": candidate_votes,
				"vote_percent": float(candidate_votes) * 100.0 / float(ballots),
				"status": "Pending"
			}
			candidate_rows.append(candidate_row)
			votes_by_party[party_id] = int(votes_by_party.get(party_id, 0)) + candidate_votes
			if candidate_votes > winning_votes or (candidate_votes == winning_votes and (winning_party_id.is_empty() or party_id < winning_party_id)):
				winning_votes = candidate_votes
				winning_party_id = party_id
				winning_candidate_name = str(candidate.get("candidate_name", "party candidate"))
		eligible_total += eligible_voters
		ballots_total += ballots
		turnout_total += turnout_percent
		seats_by_party[winning_party_id] = int(seats_by_party.get(winning_party_id, 0)) + 1
		if winning_party_id == player_party_id:
			player_elected += 1
		for candidate_index in range(candidate_rows.size()):
			var row: Dictionary = candidate_rows[candidate_index]
			row["status"] = "Elected" if str(row.get("party_id", "")) == winning_party_id else "Not elected"
			candidate_rows[candidate_index] = row
		var constituency_record := _lok_sabha_record_for_seat(seat_number) if state_name.is_empty() else _assembly_record_for_seat(state_name, seat_number)
		constituency_results.append({
			"seat_number": seat_number,
			"constituency": constituency,
			"constituency_number": int(constituency_record.get("number", seat_number)),
			"state": str(constituency_record.get("state", state_name)),
			"reservation_category": str(constituency_record.get("category", "General")),
			"record_status": str(constituency_record.get("record_status", "not_in_database")),
			"winner_party_id": winning_party_id,
			"winner_candidate_name": winning_candidate_name,
			"eligible_voters": eligible_voters,
			"ballots_cast": ballots,
			"turnout_percent": turnout_percent,
			"candidates": candidate_rows
		})

	var vote_shares: Dictionary = {}
	for party_id in party_ids:
		vote_shares[party_id] = float(votes_by_party.get(party_id, 0)) * 100.0 / float(maxi(1, ballots_total))
	var winner_id := ""
	var winner_seats := -1
	var total_winner_votes := -1
	for party_id in party_ids:
		var party_seats := int(seats_by_party.get(party_id, 0))
		var party_votes := int(votes_by_party.get(party_id, 0))
		if party_seats > winner_seats or (party_seats == winner_seats and party_votes > total_winner_votes):
			winner_id = party_id
			winner_seats = party_seats
			total_winner_votes = party_votes
	var winner_party: Dictionary = parties.get(winner_id, {})
	var winner_name := str(winner_party.get("name", "Leading party"))
	var majority_required := int(floor(float(seat_count) / 2.0)) + 1
	var summary := "%s led the constituency results with %d of %d seats. modeled High Command and party organizations contested all modeled constituencies; government formation is handled automatically." % [winner_name, winner_seats, seat_count]
	if winner_seats >= majority_required:
		summary = "%s won a modeled majority with %d of %d seats. Its leadership formed the government." % [winner_name, winner_seats, seat_count]
	return {
		"summary": summary,
		"winner_id": winner_id,
		"seats_by_party": seats_by_party,
		"vote_shares": vote_shares,
		"turnout_percent": turnout_total / float(seat_count),
		"constituency_results": constituency_results,
		"eligible_voters": eligible_total,
		"ballots_cast": ballots_total,
		"player_party_candidates_contested": player_contested,
		"player_party_candidates_elected": player_elected,
		"player_organization_score": player_organization_score,
		"player_organization_bonus": player_organization_bonus
	}


# ---------------------------------------------------------------------------
# Party High Command — strategic direction only. Candidate selection, constituency
# assignments, campaigning, and routine organization are performed by the AI.
func _ensure_high_command_schema() -> void:
	if world_state.is_empty():
		return
	var command: Dictionary = world_state.get("high_command", {})
	if not command.has("karnataka_contest_enabled"):
		command["karnataka_contest_enabled"] = false
	if not command.has("national_candidate_assignments"):
		command["national_candidate_assignments"] = {}
	if not command.has("national_candidate_review"):
		command["national_candidate_review"] = {}
	if command.is_empty():
		command = {
			"strategy": "Balanced outreach",
			"monthly_campaign_budget": HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET,
			"coalition_policy": "modeled negotiate a working majority",
			"campaign_focus_state": "",
			"auto_candidate_nomination": true,
			"month_index": -1,
			"spent_this_month": 0,
			"local_candidate_counter": 0,
			"karnataka_candidate_review": {},
			"karnataka_contest_enabled": false
		}
	var strategy := str(command.get("strategy", "Balanced outreach"))
	if not HIGH_COMMAND_STRATEGIES.has(strategy):
		strategy = "Balanced outreach"
	var coalition_policy := str(command.get("coalition_policy", "modeled negotiate a working majority"))
	if not HIGH_COMMAND_COALITION_POLICIES.has(coalition_policy):
		coalition_policy = "modeled negotiate a working majority"
	command["strategy"] = strategy
	command["monthly_campaign_budget"] = clampi(int(command.get("monthly_campaign_budget", HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET)), 0, HIGH_COMMAND_MAX_MONTHLY_BUDGET)
	command["coalition_policy"] = coalition_policy
	command["campaign_focus_state"] = str(command.get("campaign_focus_state", ""))
	command["auto_candidate_nomination"] = true
	command["month_index"] = int(command.get("month_index", -1))
	command["spent_this_month"] = int(command.get("spent_this_month", 0))
	command["local_candidate_counter"] = int(command.get("local_candidate_counter", 0))
	world_state["high_command"] = command

func set_high_command_policy(strategy: String, monthly_budget: int, coalition_policy: String, campaign_focus_state: String = "") -> String:
	_ensure_high_command_schema()
	if not HIGH_COMMAND_STRATEGIES.has(strategy):
		strategy = "Balanced outreach"
	if not HIGH_COMMAND_COALITION_POLICIES.has(coalition_policy):
		coalition_policy = "modeled negotiate a working majority"
	var command: Dictionary = world_state.get("high_command", {})
	command["strategy"] = strategy
	command["monthly_campaign_budget"] = clampi(monthly_budget, 0, HIGH_COMMAND_MAX_MONTHLY_BUDGET)
	command["coalition_policy"] = coalition_policy
	var valid_focus := campaign_focus_state.is_empty()
	for election_variant in world_state.get("state_elections", []):
		if election_variant is Dictionary and str(election_variant.get("state", "")) == campaign_focus_state:
			valid_focus = true
			break
	command["campaign_focus_state"] = campaign_focus_state if valid_focus else ""
	command["auto_candidate_nomination"] = true
	world_state["high_command"] = command
	var focus_description := "No state focus" if str(command["campaign_focus_state"]).is_empty() else str(command["campaign_focus_state"])
	return "High Command directive saved. Campaign focus: %s. Your monthly campaign ceiling is ₹%s." % [focus_description, _format_number(int(command["monthly_campaign_budget"]))]

func high_command_summary() -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var party: Dictionary = parties.get(player_party_id, {})
	var assignments := int(party.get("automatic_candidate_assignments", 0))
	var state_contested := 0
	var state_elected := 0
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var state_election: Dictionary = election_variant
		state_contested += int(state_election.get("player_party_candidates_contested", 0))
		state_elected += int(state_election.get("player_party_candidates_elected", 0))
	var national: Dictionary = world_state.get("national_election", {})
	var national_contested := int(national.get("player_party_candidates_contested", 0))
	var national_elected := int(national.get("player_party_candidates_elected", 0))
	var local_contested := 0
	var local_elected := 0
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	for local_variant in districts.values():
		if not local_variant is Dictionary:
			continue
		var local_record: Dictionary = local_variant
		var last_results: Array = local_record.get("last_local_candidate_results", [])
		var has_player_candidate := false
		var assignment_map_variant: Variant = local_record.get("local_candidate_assignments", {})
		var assignment_map: Dictionary = assignment_map_variant if assignment_map_variant is Dictionary else {}
		for assignment_variant in assignment_map.values():
			if assignment_variant is Dictionary:
				var assignment: Dictionary = assignment_variant
				if str(assignment.get("member_id", "")).begins_with("%s_member_" % player_party_id):
					has_player_candidate = true
					break
		if has_player_candidate or not last_results.is_empty():
			local_contested += 1
		for row_variant in last_results:
			if row_variant is Dictionary:
				var row: Dictionary = row_variant
				if str(row.get("party_id", "")) == player_party_id and str(row.get("status", "")) == "Elected":
					local_elected += 1
	var focus_state := str(command.get("campaign_focus_state", ""))
	if focus_state.is_empty():
		focus_state = "No state focus"
	return "YOUR ROLE: PARTY HIGH COMMAND\nStrategy: %s\nCampaign focus state: %s\nMonthly campaign budget ceiling: ₹%s\nCoalition directive: %s\nCANDIDATE DEPLOYMENT\nLok Sabha: %d contested / %d elected\nState Assemblies: %d contested / %d elected\nDistrict-local contests: %d assigned / %d elected\nTotal automatic party candidate assignments recorded: %d\nCAMPsimulationGN OPERATIONS\nParty High Command nominates party members by constituency, runs campaigns, manages routine organization, and reports results. Your role is to set strategy and approve major party direction only. The The elected government administers Union, state, and local governments; party leadership does not give you executive office." % [
		str(command.get("strategy", "Balanced outreach")),
		focus_state,
		_format_number(int(command.get("monthly_campaign_budget", HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET))),
		str(command.get("coalition_policy", "modeled negotiate a working majority")),
		national_contested, national_elected, state_contested, state_elected,
		local_contested, local_elected, assignments
	]

func _high_command_remaining_budget() -> int:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var current_index := year * 12 + month
	if int(command.get("month_index", -1)) != current_index:
		command["month_index"] = current_index
		command["spent_this_month"] = 0
		world_state["high_command"] = command
	var ceiling := int(command.get("monthly_campaign_budget", HIGH_COMMAND_DEFAULT_MONTHLY_BUDGET))
	return maxi(0, ceiling - int(command.get("spent_this_month", 0)))

func _record_high_command_campaign_spend(amount: int) -> void:
	if amount <= 0:
		return
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var current_index := year * 12 + month
	if int(command.get("month_index", -1)) != current_index:
		command["month_index"] = current_index
		command["spent_this_month"] = 0
	command["spent_this_month"] = int(command.get("spent_this_month", 0)) + amount
	world_state["high_command"] = command

func _high_command_strategy_bonus() -> float:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var strategy := str(command.get("strategy", "Balanced outreach"))
	match strategy:
		"Balanced outreach": return 0.25
		"Jobs & economy": return 0.45
		"Public services": return 0.45
		"Rural development": return 0.45
		"Welfare & inclusion": return 0.45
		"Infrastructure": return 0.45
		"Public safety": return 0.45
		"Youth engagement": return 0.35
	return 0.25

func _high_command_active_campaign_count() -> int:
	var active_count := 0
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		var remaining := _months_until_election(election)
		if remaining > 0 and remaining <= MODELED_CAMPAIGN_MONTHS:
			active_count += 1
	var national: Dictionary = world_state.get("national_election", {})
	var national_remaining := _months_until_election(national)
	if national_remaining > 0 and national_remaining <= MODELED_CAMPAIGN_MONTHS:
		active_count += 1
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	for district_variant in districts.values():
		if not district_variant is Dictionary:
			continue
		var local_government: Dictionary = district_variant
		var local_year := int(local_government.get("next_election_year", year + 5))
		var local_month := clampi(int(local_government.get("next_election_month", 12)), 1, 12)
		var remaining := (local_year - year) * 12 + (local_month - month)
		if remaining > 0 and remaining <= MODELED_CAMPAIGN_MONTHS:
			active_count += 1
	return maxi(1, active_count)

func _high_command_campaign_budget_share() -> int:
	var remaining_budget := _high_command_remaining_budget()
	if remaining_budget <= 0:
		return 0
	var active_count := _high_command_active_campaign_count()
	return mini(remaining_budget, maxi(1, int(floor(float(remaining_budget) / float(active_count)))))

func _total_modeled_state_seats() -> int:
	var total := 0
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		total += int(election.get("assembly_seats", 0))
	return total

func _candidate_pool_index_for_constituency(state_name: String, seat_index: int) -> int:
	if state_name.is_empty():
		return maxi(0, seat_index)
	var national: Dictionary = world_state.get("national_election", {})
	var offset := int(national.get("seats", 543))
	for election_variant in world_state.get("state_elections", []):
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		var election_state := str(election.get("state", ""))
		if election_state == state_name:
			return offset + maxi(0, seat_index)
		offset += int(election.get("assembly_seats", 0))
	return offset + maxi(0, seat_index)

func _local_candidate_pool_offset() -> int:
	var national: Dictionary = world_state.get("national_election", {})
	return int(national.get("seats", 543)) + _total_modeled_state_seats()

func _local_district_candidate_index(district_key: String) -> int:
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	var local_record: Dictionary = districts.get(district_key, {})
	var district_order := int(local_record.get("candidate_roster_index", -1))
	if district_order < 0:
		var keys: Array = districts.keys()
		keys.sort()
		district_order = maxi(0, keys.find(district_key))
	return _local_candidate_pool_offset() + district_order

func _ensure_party_candidate_records(party_id: String, required_count: int, state_name: String = "") -> Array:
	if party_id.is_empty() or not parties.has(party_id):
		return []
	var party: Dictionary = parties[party_id]
	var records_variant: Variant = party.get("member_records", [])
	var records: Array = records_variant if records_variant is Array else []
	var target_count := mini(10000, maxi(records.size(), required_count))
	var counter := int(party.get("member_counter", records.size()))
	var sorted_party_ids: Array = parties.keys()
	sorted_party_ids.sort()
	var party_name_offset := maxi(0, sorted_party_ids.find(party_id))
	while records.size() < target_count:
		counter += 1
		var base_name := _fictional_name_at(counter - 1 + party_name_offset)
		var nominee_name := base_name
		records.append({
			"id": "%s_member_%d" % [party_id, counter],
			"name": nominee_name,
			"duty": "modeled Constituency Candidate",
			"region": state_name if not state_name.is_empty() else "India",
			"joined_year": year,
			"joined_month": month,
			"is_player_added": false,
			"auto_recruited_for_elections": true
		})
	party["member_records"] = records
	party["member_counter"] = counter
	party["members"] = maxi(int(party.get("members", 0)), records.size() + 1)
	party["last_candidate_pool_size"] = maxi(int(party.get("last_candidate_pool_size", 0)), target_count)
	parties[party_id] = party
	return records

func _ensure_player_candidate_records(required_count: int, state_name: String = "") -> Array:
	var records := _ensure_party_candidate_records(player_party_id, required_count, state_name)
	if not career_started or character_name.strip_edges().is_empty() or records.is_empty():
		return records

	# Keep the player character in the candidate search roster so the career
	# profile and party nomination system use the same identity.
	var player_record_id := "player_character"
	var player_record_index := -1
	for index in range(records.size()):
		var record_variant: Variant = records[index]
		if record_variant is Dictionary and str(record_variant.get("id", "")) == player_record_id:
			player_record_index = index
			break

	var player_record := {
		"id": player_record_id,
		"name": character_name.strip_edges(),
		"duty": career_rank,
		"region": home_state,
		"joined_year": year,
		"joined_month": month,
		"is_player_added": true,
		"is_player_character": true
	}
	if player_record_index >= 0:
		records[player_record_index] = player_record
	else:
		records.append(player_record)

	if parties.has(player_party_id):
		var party: Dictionary = parties[player_party_id]
		party["member_records"] = records
		party["member_counter"] = int(party.get("member_counter", records.size()))
		parties[player_party_id] = party
	return records



func assembly_state_names() -> Array[String]:
	_load_assembly_records()
	var names: Array[String] = []
	for row in _assembly_records:
		if not row is Dictionary:
			continue
		var state_name := str(row.get("state", ""))
		if not state_name.is_empty() and not names.has(state_name):
			names.append(state_name)
	names.sort()
	return names

func assembly_seat_count(state_name: String) -> int:
	_load_assembly_records()
	var count := 0
	for row in _assembly_records:
		if row is Dictionary and str(row.get("state", "")) == state_name:
			count += 1
	return count


func _assembly_candidate_roster_offset(state_name: String) -> int:
	# Preserve existing modeled-state roster ranges; place additional data-only
	# states after all modeled ranges so they cannot alias one another.
	for election_variant in world_state.get("state_elections", []):
		if election_variant is Dictionary and str(election_variant.get("state", "")) == state_name:
			return _candidate_pool_index_for_constituency(state_name, 0)
	var national: Dictionary = world_state.get("national_election", {})
	var offset := int(national.get("seats", 543)) + _total_modeled_state_seats()
	var names := assembly_state_names()
	for name in names:
		if name == state_name:
			return offset
		var found_in_elections := false
		for election_variant in world_state.get("state_elections", []):
			if election_variant is Dictionary and str(election_variant.get("state", "")) == name:
				found_in_elections = true
				break
		if not found_in_elections:
			offset += assembly_seat_count(name)
	return offset

func _invalidate_state_candidate_slate(state_name: String) -> void:
	var elections: Array = world_state.get("state_elections", [])
	for index in range(elections.size()):
		if not elections[index] is Dictionary:
			continue
		var election: Dictionary = elections[index]
		if str(election.get("state", "")) == state_name:
			election.erase("player_candidate_slate")
			election.erase("player_candidate_slate_key")
			elections[index] = election
	world_state["state_elections"] = elections


func state_candidate_review_rows(state_name: String) -> Array[Dictionary]:
	_ensure_high_command_schema()
	var seat_count := assembly_seat_count(state_name)
	var command: Dictionary = world_state.get("high_command", {})
	var decisions_by_state: Dictionary = command.get("state_candidate_review", {})
	var assignments_by_state: Dictionary = command.get("state_candidate_assignments", {})
	var decisions: Dictionary = command.get("karnataka_candidate_review", {}) if state_name == "Karnataka" else decisions_by_state.get(state_name, {})
	var assignments: Dictionary = command.get("karnataka_candidate_assignments", {}) if state_name == "Karnataka" else assignments_by_state.get(state_name, {})
	var roster_offset := _assembly_candidate_roster_offset(state_name)
	var records := _ensure_player_candidate_records(roster_offset + seat_count, state_name)
	var rows: Array[Dictionary] = []
	for seat_index in range(seat_count):
		var seat_number := seat_index + 1
		var record: Dictionary = records[roster_offset + seat_index] if roster_offset + seat_index < records.size() else {}
		var assigned_id := str(assignments.get(str(seat_number), ""))
		if not assigned_id.is_empty():
			for member_variant in records:
				if member_variant is Dictionary and str(member_variant.get("id", "")) == assigned_id:
					record = member_variant
					break
		rows.append({
			"seat_number": seat_number,
			"constituency": _constituency_name_for_seat(state_name, seat_number),
			"candidate_name": str(record.get("name", "Party nominee %03d" % seat_number)),
			"decision": str(decisions.get(str(seat_number), "Pending"))
		})
	return rows

func state_party_member_search(state_name: String, query: String = "") -> Array[Dictionary]:
	var seat_count := assembly_seat_count(state_name)
	var roster_offset := _assembly_candidate_roster_offset(state_name)
	var records := _ensure_player_candidate_records(roster_offset + seat_count, state_name)
	var normalized := query.strip_edges().to_lower()
	var results: Array[Dictionary] = []
	for record_variant in records:
		if not record_variant is Dictionary:
			continue
		var record: Dictionary = record_variant
		var name := str(record.get("name", ""))
		var member_id := str(record.get("id", ""))
		if normalized.is_empty() or name.to_lower().contains(normalized) or member_id.to_lower().contains(normalized):
			results.append({"id": member_id, "name": name})
	return results

func assign_state_candidate(state_name: String, seat_number: int, member_id: String) -> String:
	var seat_count := assembly_seat_count(state_name)
	if seat_number < 1 or seat_number > seat_count:
		return "Choose a valid constituency in the selected state."
	var roster_offset := _assembly_candidate_roster_offset(state_name)
	var records := _ensure_player_candidate_records(roster_offset + seat_count, state_name)
	var selected: Dictionary = {}
	for record_variant in records:
		if record_variant is Dictionary and str(record_variant.get("id", "")) == member_id:
			selected = record_variant
			break
	if selected.is_empty():
		return "That party member could not be found in your roster."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	if state_name == "Karnataka":
		var assignments: Dictionary = command.get("karnataka_candidate_assignments", {})
		assignments[str(seat_number)] = member_id
		command["karnataka_candidate_assignments"] = assignments
	else:
		var assignments_by_state: Dictionary = command.get("state_candidate_assignments", {})
		var assignments: Dictionary = assignments_by_state.get(state_name, {})
		assignments[str(seat_number)] = member_id
		assignments_by_state[state_name] = assignments
		command["state_candidate_assignments"] = assignments_by_state
	world_state["high_command"] = command
	_invalidate_state_candidate_slate(state_name)
	return "%s assigned to contest %s, %s. Review and approve the ticket before the election." % [str(selected.get("name", "Party member")), _constituency_name_for_seat(state_name, seat_number), state_name]

func set_state_candidate_decision(state_name: String, seat_number: int, decision: String) -> String:
	var seat_count := assembly_seat_count(state_name)
	if seat_number < 1 or seat_number > seat_count:
		return "Select a valid constituency."
	if decision not in ["Approved", "Rejected", "Pending"]:
		return "Invalid review decision."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	if state_name == "Karnataka":
		var decisions: Dictionary = command.get("karnataka_candidate_review", {})
		decisions[str(seat_number)] = decision
		command["karnataka_candidate_review"] = decisions
	else:
		var decisions_by_state: Dictionary = command.get("state_candidate_review", {})
		var decisions: Dictionary = decisions_by_state.get(state_name, {})
		decisions[str(seat_number)] = decision
		decisions_by_state[state_name] = decisions
		command["state_candidate_review"] = decisions_by_state
	world_state["high_command"] = command
	_invalidate_state_candidate_slate(state_name)
	return "%s, %s ticket marked %s." % [_constituency_name_for_seat(state_name, seat_number), state_name, decision.to_lower()]


func bulk_assign_state_candidates(state_name: String) -> String:
	var seat_count := assembly_seat_count(state_name)
	if seat_count <= 0:
		return "No assembly constituency records are available for %s." % state_name
	var roster_offset := _assembly_candidate_roster_offset(state_name)
	var records := _ensure_player_candidate_records(roster_offset + seat_count, state_name)
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments_by_state: Dictionary = command.get("state_candidate_assignments", {})
	var assignments: Dictionary = command.get("karnataka_candidate_assignments", {}) if state_name == "Karnataka" else assignments_by_state.get(state_name, {})
	var assigned_count := 0
	for seat_index in range(seat_count):
		var seat_number := seat_index + 1
		if not str(assignments.get(str(seat_number), "")).is_empty():
			continue
		var roster_index := roster_offset + seat_index
		if roster_index >= records.size() or not (records[roster_index] is Dictionary):
			continue
		var member_id := str(records[roster_index].get("id", ""))
		if member_id.is_empty():
			continue
		assignments[str(seat_number)] = member_id
		assigned_count += 1
	if state_name == "Karnataka":
		command["karnataka_candidate_assignments"] = assignments
	else:
		assignments_by_state[state_name] = assignments
		command["state_candidate_assignments"] = assignments_by_state
	world_state["high_command"] = command
	_invalidate_state_candidate_slate(state_name)
	return "Bulk nominee preparation complete for %s: %d new tickets assigned. Tickets remain Pending until you approve them." % [state_name, assigned_count]

func bulk_approve_state_candidates(state_name: String) -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var decisions_by_state: Dictionary = command.get("state_candidate_review", {})
	var decisions: Dictionary = command.get("karnataka_candidate_review", {}) if state_name == "Karnataka" else decisions_by_state.get(state_name, {})
	var count := 0
	for seat_number in range(1, assembly_seat_count(state_name) + 1):
		if str(decisions.get(str(seat_number), "Pending")) == "Pending":
			decisions[str(seat_number)] = "Approved"
			count += 1
	if state_name == "Karnataka":
		command["karnataka_candidate_review"] = decisions
	else:
		decisions_by_state[state_name] = decisions
		command["state_candidate_review"] = decisions_by_state
	world_state["high_command"] = command
	_invalidate_state_candidate_slate(state_name)
	return "Bulk review complete: %d pending %s tickets approved." % [count, state_name]

func karnataka_candidate_review_rows() -> Array[Dictionary]:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var decisions: Dictionary = command.get("karnataka_candidate_review", {})
	var rows: Array[Dictionary] = []
	var roster_offset := _candidate_pool_index_for_constituency("Karnataka", 0)
	var records := _ensure_player_candidate_records(roster_offset + 224, "Karnataka")
	for seat_index in range(224):
		var roster_index := roster_offset + seat_index
		var record: Dictionary = records[roster_index] if roster_index < records.size() else {}
		var constituency := _constituency_name_for_seat("Karnataka", seat_index + 1)
		var assignments: Dictionary = command.get("karnataka_candidate_assignments", {})
		var assigned_id := str(assignments.get(str(seat_index + 1), ""))
		if not assigned_id.is_empty():
			for member_variant in records:
				if member_variant is Dictionary and str(member_variant.get("id", "")) == assigned_id:
					record = member_variant
					break
		var member_name := str(record.get("name", "Party nominee %03d" % (seat_index + 1)))
		var decision := str(decisions.get(str(seat_index + 1), "Pending"))
		rows.append({"seat_number": seat_index + 1, "constituency": constituency, "candidate_name": member_name, "decision": decision})
	return rows

func karnataka_party_member_search(query: String = "") -> Array[Dictionary]:
	var roster_offset := _candidate_pool_index_for_constituency("Karnataka", 0)
	var records := _ensure_player_candidate_records(roster_offset + 224, "Karnataka")
	var normalized := query.strip_edges().to_lower()
	var results: Array[Dictionary] = []
	for record_variant in records:
		if not record_variant is Dictionary:
			continue
		var record: Dictionary = record_variant
		var name := str(record.get("name", ""))
		var member_id := str(record.get("id", ""))
		if normalized.is_empty() or name.to_lower().contains(normalized) or member_id.to_lower().contains(normalized):
			results.append({"id": member_id, "name": name})
	return results

func assign_karnataka_candidate(seat_number: int, member_id: String) -> String:
	if seat_number < 1 or seat_number > 224:
		return "Choose a valid Karnataka constituency first."
	var roster_offset := _candidate_pool_index_for_constituency("Karnataka", 0)
	var records := _ensure_player_candidate_records(roster_offset + 224, "Karnataka")
	var selected: Dictionary = {}
	for record_variant in records:
		if record_variant is Dictionary and str(record_variant.get("id", "")) == member_id:
			selected = record_variant
			break
	if selected.is_empty():
		return "That party member could not be found in your roster."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments: Dictionary = command.get("karnataka_candidate_assignments", {})
	assignments[str(seat_number)] = member_id
	command["karnataka_candidate_assignments"] = assignments
	world_state["high_command"] = command
	_invalidate_karnataka_candidate_slates()
	return "%s assigned to contest %s. Review and approve the ticket before the election." % [str(selected.get("name", "Party member")), _constituency_name_for_seat("Karnataka", seat_number)]

func set_karnataka_candidate_decision(seat_number: int, decision: String) -> String:
	if seat_number < 1 or seat_number > 224:
		return "Select a valid Karnataka constituency."
	if decision not in ["Approved", "Rejected", "Pending"]:
		return "Invalid review decision."
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var decisions: Dictionary = command.get("karnataka_candidate_review", {})
	decisions[str(seat_number)] = decision
	command["karnataka_candidate_review"] = decisions
	world_state["high_command"] = command
	_invalidate_karnataka_candidate_slates()
	return "%s constituency candidate %s: %s." % [_constituency_name_for_seat("Karnataka", seat_number), "reviewed", decision.to_lower()]


func _invalidate_karnataka_candidate_slates() -> void:
	var elections: Array = world_state.get("state_elections", [])
	for index in range(elections.size()):
		if not elections[index] is Dictionary:
			continue
		var election: Dictionary = elections[index]
		if str(election.get("state", "")) == "Karnataka":
			election.erase("player_candidate_slate")
			election.erase("player_candidate_slate_key")
		elections[index] = election
	world_state["state_elections"] = elections

func is_karnataka_contest_enabled() -> bool:
	_ensure_high_command_schema()
	return bool(world_state.get("high_command", {}).get("karnataka_contest_enabled", false))

func toggle_karnataka_contest() -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var enabled := not bool(command.get("karnataka_contest_enabled", false))
	command["karnataka_contest_enabled"] = enabled
	world_state["high_command"] = command
	_invalidate_karnataka_candidate_slates()
	return "Your party will %s the next Karnataka Assembly election. Only approved tickets are eligible." % ("contest" if enabled else "not contest")

func bulk_approve_karnataka_candidates() -> String:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var decisions: Dictionary = command.get("karnataka_candidate_review", {})
	var count := 0
	for seat_number in range(1, 225):
		if str(decisions.get(str(seat_number), "Pending")) == "Pending":
			decisions[str(seat_number)] = "Approved"
			count += 1
	command["karnataka_candidate_review"] = decisions
	world_state["high_command"] = command
	_invalidate_karnataka_candidate_slates()
	return "Bulk review complete: %d pending Karnataka tickets approved." % count

func set_karnataka_candidate_name(seat_number: int, candidate_name: String) -> String:
	if seat_number < 1 or seat_number > 224:
		return "Select a valid Karnataka constituency."
	var cleaned := candidate_name.strip_edges()
	if cleaned.is_empty() or cleaned.length() > 80:
		return "Enter a nominee name between 1 and 80 characters."
	var roster_index := _candidate_pool_index_for_constituency("Karnataka", seat_number - 1)
	var records := _ensure_player_candidate_records(roster_index + 1, "Karnataka")
	if roster_index < 0 or roster_index >= records.size():
		return "Could not find the assigned nominee record."
	var record: Dictionary = records[roster_index]
	record["name"] = cleaned
	record["duty"] = "Karnataka Assembly Candidate"
	record["region"] = "Karnataka"
	records[roster_index] = record
	var party: Dictionary = parties.get(player_party_id, {})
	party["member_records"] = records
	parties[player_party_id] = party
	_invalidate_karnataka_candidate_slates()
	return "%s nominee updated to %s." % [_constituency_name_for_seat("Karnataka", seat_number), cleaned]

func karnataka_candidate_review_summary() -> String:
	var rows := karnataka_candidate_review_rows()
	var approved := 0
	var rejected := 0
	for row in rows:
		match str(row.get("decision", "Pending")):
			"Approved": approved += 1
			"Rejected": rejected += 1
	return "KARNATAKA CANDIDATE REVIEW\nApproved  %d / 224\nRejected  %d\nPending  %d\n\nReview decisions are saved with this career." % [approved, rejected, 224 - approved - rejected]

func _candidate_record_for_party(party_id: String, roster_index: int, state_name: String = "") -> Dictionary:
	var records := _ensure_party_candidate_records(party_id, roster_index + 1, state_name)
	if roster_index < 0 or roster_index >= records.size():
		return _candidate_name_for_party(party_id, state_name, roster_index + 1)
	var member: Dictionary = records[roster_index]
	return {"member_id": str(member.get("id", "")), "candidate_name": str(member.get("name", "party candidate"))}

func _auto_assign_and_approve_state_tickets(state_name: String, seat_count: int, records: Array, roster_offset: int) -> void:
	_ensure_high_command_schema()
	var command: Dictionary = world_state.get("high_command", {})
	var assignments_by_state: Dictionary = command.get("state_candidate_assignments", {})
	var assignments: Dictionary = assignments_by_state.get(state_name, {})
	var decisions_by_state: Dictionary = command.get("state_candidate_review", {})
	var decisions: Dictionary = decisions_by_state.get(state_name, {})
	var changed := false
	for seat_index in range(seat_count):
		var seat_key := str(seat_index + 1)
		var roster_index := roster_offset + seat_index
		if str(assignments.get(seat_key, "")).is_empty() and roster_index >= 0 and roster_index < records.size() and records[roster_index] is Dictionary:
			var member_id := str(records[roster_index].get("id", ""))
			if not member_id.is_empty():
				assignments[seat_key] = member_id
				changed = true
		# Pending tickets are approved by the state president; an explicit High Command
		# rejection is preserved as an override.
		if str(decisions.get(seat_key, "Pending")) == "Pending":
			decisions[seat_key] = "Approved"
			changed = true
	if changed:
		assignments_by_state[state_name] = assignments
		decisions_by_state[state_name] = decisions
		command["state_candidate_assignments"] = assignments_by_state
		command["state_candidate_review"] = decisions_by_state
		world_state["high_command"] = command


func _prepare_player_candidate_slate(election: Dictionary, jurisdiction: String, seat_count: int, state_name: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return result
	if state_name == "Karnataka" and not is_karnataka_contest_enabled():
		return result
	var election_key := "%s|%d|%d" % [jurisdiction, int(election.get("next_year", year)), int(election.get("month", month))]
	var candidate_start := _candidate_pool_index_for_constituency(state_name, 0)
	var records := _ensure_player_candidate_records(candidate_start + seat_count, state_name)
	# Outside Karnataka, each state party president automatically assigns and approves
	# the party's Assembly tickets. High Command can still review or override them.
	if state_name != "Karnataka" and not state_name.is_empty():
		_auto_assign_and_approve_state_tickets(state_name, seat_count, records, candidate_start)
	var saved_variant: Variant = election.get("player_candidate_slate", [])
	var saved_slate: Array = saved_variant if saved_variant is Array else []
	if str(election.get("player_candidate_slate_key", "")) == election_key and saved_slate.size() == seat_count:
		for candidate_variant in saved_slate:
			if candidate_variant is Dictionary:
				result.append(candidate_variant)
		return result
	for seat_index in range(seat_count):
		var roster_index := candidate_start + seat_index
		if roster_index < 0 or roster_index >= records.size():
			break
		var member: Dictionary = records[roster_index]
		var constituency := _constituency_name_for_seat(state_name, seat_index + 1)
		var command: Dictionary = world_state.get("high_command", {})
		if state_name.is_empty():
			var national_decisions: Dictionary = command.get("national_candidate_review", {})
			if str(national_decisions.get(str(seat_index + 1), "Pending")) != "Approved":
				result.append({})
				continue
			var national_assignments: Dictionary = command.get("national_candidate_assignments", {})
			var national_assigned_id := str(national_assignments.get(str(seat_index + 1), ""))
			if not national_assigned_id.is_empty():
				for member_variant in records:
					if member_variant is Dictionary and str(member_variant.get("id", "")) == national_assigned_id:
						member = member_variant
						break
		elif state_name == "Karnataka":
			var review: Dictionary = command.get("karnataka_candidate_review", {})
			if str(review.get(str(seat_index + 1), "Pending")) != "Approved":
				result.append({})
				continue
			var assignments: Dictionary = command.get("karnataka_candidate_assignments", {})
			var assigned_id := str(assignments.get(str(seat_index + 1), ""))
			if not assigned_id.is_empty():
				for member_variant in records:
					if member_variant is Dictionary and str(member_variant.get("id", "")) == assigned_id:
						member = member_variant
						break
		elif not state_name.is_empty():
			var decisions_by_state: Dictionary = command.get("state_candidate_review", {})
			var state_decisions: Dictionary = decisions_by_state.get(state_name, {})
			if str(state_decisions.get(str(seat_index + 1), "Pending")) == "Rejected":
				result.append({})
				continue
			var assignments_by_state: Dictionary = command.get("state_candidate_assignments", {})
			var state_assignments: Dictionary = assignments_by_state.get(state_name, {})
			var assigned_id := str(state_assignments.get(str(seat_index + 1), ""))
			if not assigned_id.is_empty():
				for member_variant in records:
					if member_variant is Dictionary and str(member_variant.get("id", "")) == assigned_id:
						member = member_variant
						break
		result.append({
			"seat_number": seat_index + 1,
			"constituency": constituency,
			"member_id": str(member.get("id", "")),
			"candidate_name": str(member.get("name", "Party nominee")),
			"party_id": player_party_id,
			"nomination": "Approved by party leadership",
			"status": "Campaigning"
		})
	election["player_candidate_slate"] = result
	election["player_candidate_slate_key"] = election_key
	var approved_count := 0
	for candidate_variant in result:
		if candidate_variant is Dictionary and not candidate_variant.is_empty():
			approved_count += 1
	election["player_party_candidates_contested"] = approved_count
	if parties.has(player_party_id):
		var player_party: Dictionary = parties[player_party_id]
		player_party["last_candidate_slate_jurisdiction"] = jurisdiction
		player_party["last_candidate_slate_size"] = result.size()
		player_party["automatic_candidate_assignments"] = int(player_party.get("automatic_candidate_assignments", 0)) + result.size()
		parties[player_party_id] = player_party
	return result

func _candidate_name_for_party(party_id: String, jurisdiction: String, seat_number: int) -> Dictionary:
	var party: Dictionary = parties.get(party_id, {})
	var members_variant: Variant = party.get("member_records", [])
	var members: Array = members_variant if members_variant is Array else []
	if party_id == player_party_id and not members.is_empty():
		var member_index := clampi(seat_number - 1, 0, members.size() - 1)
		var member: Dictionary = members[member_index]
		return {"member_id": str(member.get("id", "")), "candidate_name": str(member.get("name", "party nominee"))}
	if not members.is_empty():
		var rival_member_index := absi((party_id + "|" + jurisdiction + "|" + str(seat_number)).hash()) % members.size()
		var member: Dictionary = members[rival_member_index]
		return {"member_id": str(member.get("id", "")), "candidate_name": str(member.get("name", "party candidate"))}
	var fallback_index := absi((party_id + "|" + jurisdiction + "|" + str(seat_number)).hash()) % _fictional_name_count()
	return {"member_id": "ai_%s_%d" % [party_id, seat_number], "candidate_name": _fictional_name_at(fallback_index)}

func _get_player_candidate_for_seat(slate: Array[Dictionary], seat_index: int) -> Dictionary:
	if seat_index >= 0 and seat_index < slate.size():
		return slate[seat_index]
	return {}

# ---------------------------------------------------------------------------
# AI-managed governments (Union, states, and district-level local administration)
# Party control is stored separately from player authority. A party winning seats
# does not automatically make the player Prime Minister or Chief Minister.
func _ensure_party_map_colors() -> void:
	var used: Dictionary = {}
	var party_ids: Array[String] = []
	for party_id_variant in parties.keys():
		party_ids.append(str(party_id_variant))
	party_ids.sort()
	for party_id in party_ids:
		var party: Dictionary = parties.get(party_id, {})
		var existing_color := str(party.get("map_color", ""))
		if existing_color in GOVERNMENT_MAP_PALETTE and not used.has(existing_color):
			used[existing_color] = true
			continue
		var chosen_color := ""
		for palette_color in GOVERNMENT_MAP_PALETTE:
			if not used.has(palette_color):
				chosen_color = palette_color
				break
		if chosen_color.is_empty():
			chosen_color = GOVERNMENT_MAP_PALETTE[posmod(party_ids.find(party_id), GOVERNMENT_MAP_PALETTE.size())]
		party["map_color"] = chosen_color
		parties[party_id] = party
		used[chosen_color] = true

func party_map_colors() -> Dictionary:
	_ensure_party_map_colors()
	var result: Dictionary = {}
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties.get(party_id, {})
		result[party_id] = str(party.get("map_color", "#263b54"))
	return result

func _load_india_district_catalog() -> Array[Dictionary]:
	# GeoJSON is static project data. Parse it once instead of reopening and
	# parsing the 4 MB file whenever the user changes map layer or opens a state.
	if _india_district_catalog_loaded:
		return _india_district_catalog_cache
	_india_district_catalog_loaded = true
	var path := "res://Data/india.geojson"
	if not FileAccess.file_exists(path):
		return _india_district_catalog_cache
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _india_district_catalog_cache
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not parsed is Dictionary:
		return _india_district_catalog_cache
	var features: Array = parsed.get("features", [])
	var seen: Dictionary = {}
	for feature_variant in features:
		if not feature_variant is Dictionary:
			continue
		var feature: Dictionary = feature_variant
		var properties: Dictionary = feature.get("properties", {})
		var state_name := str(properties.get("st_nm", "")).strip_edges()
		var district_name := str(properties.get("district", "")).strip_edges()
		if state_name.is_empty() or district_name.is_empty():
			continue
		var key := _local_government_key(state_name, district_name)
		if seen.has(key):
			continue
		seen[key] = true
		_india_district_catalog_cache.append({"state": state_name, "district": district_name, "key": key})
	return _india_district_catalog_cache

func _local_government_key(state_name: String, district_name: String) -> String:
	return "%s|%s" % [state_name.strip_edges(), district_name.strip_edges()]

func _choose_initial_ai_government_party(state_name: String, district_name: String = "") -> String:
	var candidate_ids: Array[String] = []
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		# Existing governments are AI-run incumbencies. A player's party does not
		# inherit office merely because the player joined or founded that party.
		if not player_party_id.is_empty() and party_id == player_party_id:
			continue
		candidate_ids.append(party_id)
	if candidate_ids.is_empty():
		var emergency_ai_id := "party_ai_caretaker"
		if not parties.has(emergency_ai_id):
			parties[emergency_ai_id] = {
				"name": "National Caretaker Alliance", "members": 1800,
				"funds": 4000000, "debt": 0, "popularity": 12.0,
				"is_player_created": false, "is_emergency_ai_party": true
			}
			_ensure_party_roster(emergency_ai_id)
			_ensure_party_world_presence(emergency_ai_id)
		candidate_ids.append(emergency_ai_id)
	candidate_ids.sort()
	if candidate_ids.is_empty():
		return ""
	var regional: Dictionary = world_state.get("regional_support", {})
	var best_id := candidate_ids[0]
	var best_score := -INF
	for party_id in candidate_ids:
		var party: Dictionary = parties.get(party_id, {})
		var score := float(party.get("popularity", 0.0))
		if not state_name.is_empty():
			var by_state: Dictionary = regional.get(party_id, {})
			score = float(by_state.get(state_name, score))
		var seed_text := "%s|%s|%s" % [state_name, district_name, party_id]
		var geographic_variation := float(absi(seed_text.hash()) % 1500) / 100.0
		if not district_name.is_empty():
			geographic_variation *= 1.15
		score += geographic_variation
		if score > best_score:
			best_score = score
			best_id = party_id
	return best_id

func _ai_government_leader_name(party_id: String, jurisdiction: String) -> String:
	var party: Dictionary = parties.get(party_id, {})
	var members_variant: Variant = party.get("member_records", [])
	var members: Array = members_variant if members_variant is Array else []
	var eligible_names: Array[String] = []
	for member_variant in members:
		if not member_variant is Dictionary:
			continue
		var member: Dictionary = member_variant
		var member_name := str(member.get("name", "")).strip_edges()
		if member_name.is_empty() or bool(member.get("is_player_added", false)):
			continue
		eligible_names.append(member_name)
	if not eligible_names.is_empty():
		var index := absi((party_id + "|" + jurisdiction).hash()) % eligible_names.size()
		return eligible_names[index]
	var fallback_index := absi((party_id + "|" + jurisdiction).hash()) % _fictional_name_count()
	return _fictional_name_at(fallback_index)

func _government_leader_title(level: String) -> String:
	match level:
		"national":
			return "Prime Minister"
		"state":
			return "Chief Minister"
		_:
			return "Local body chairperson / administrator"

func _make_initial_ai_government(level: String, jurisdiction: String, party_id: String, election_year: int = -1, election_month: int = -1) -> Dictionary:
	var coalition: Array[String] = []
	if not party_id.is_empty():
		coalition.append(party_id)
	return {
		"level": level,
		"jurisdiction": jurisdiction,
		"ruling_party_id": party_id,
		"coalition_party_ids": coalition,
		"opposition_party_ids": [],
		"leader_name": _ai_government_leader_name(party_id, jurisdiction),
		"leader_title": _government_leader_title(level),
		"formation_type": "Incumbent government baseline",
		"government_status": "Operating",
		"administration_mode": "simulation",
		"source": "pre-election simulation baseline; not an election result",
		"seat_count": 0,
		"majority_required": 0,
		"coalition_seats": 0,
		"next_election_year": election_year,
		"next_election_month": election_month,
		"performance": {"service_delivery": 50.0, "infrastructure": 50.0, "welfare": 50.0, "economy": 50.0, "public_safety": 50.0, "public_approval": 50.0},
		"last_ai_action": "administration is maintaining routine services pending the next modeled election.",
		"last_ai_review_index": -1
	}

func karnataka_government_formation_pending() -> bool:
	var pending: Dictionary = world_state.get("pending_karnataka_government_formation", {})
	return bool(pending.get("pending", false))

func karnataka_government_formation_summary() -> String:
	var pending: Dictionary = world_state.get("pending_karnataka_government_formation", {})
	if not bool(pending.get("pending", false)):
		var government := get_state_government("Karnataka")
		return "KARNATAKA GOVERNMENT\nStatus: %s\nChief Minister: %s" % [str(government.get("government_status", "Incumbent administration")), str(government.get("leader_name", "Not recorded"))]
	var seats: Dictionary = pending.get("seats_by_party", {})
	var standings: Array[String] = []
	for party_id_variant in seats.keys():
		var party_id := str(party_id_variant)
		standings.append("%s: %d" % [_government_party_name(party_id), int(seats.get(party_id_variant, 0))])
	standings.sort()
	var player_seats := int(seats.get(player_party_id, 0))
	var majority := int(pending.get("majority_required", 113))
	var status := "Your party has a majority" if player_seats >= majority else "Your party needs coalition partners"
	return "KARNATAKA ASSEMBLY RESULT — %d/%d seats needed for majority\n%s\n\n%s\nGovernment formation is pending your decision." % [player_seats, majority, status, "\n".join(standings)]

func karnataka_coalition_options() -> Array[Dictionary]:
	var pending: Dictionary = world_state.get("pending_karnataka_government_formation", {})
	var seats: Dictionary = pending.get("seats_by_party", {})
	var options: Array[Dictionary] = []
	for party_id_variant in seats.keys():
		var party_id := str(party_id_variant)
		var count := int(seats.get(party_id_variant, 0))
		if party_id != player_party_id and count > 0:
			options.append({"id": party_id, "name": _government_party_name(party_id), "seats": count})
	options.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a.get("seats", 0)) > int(b.get("seats", 0)))
	return options

func karnataka_cabinet_candidates() -> Array[String]:
	var names: Array[String] = []
	if not character_name.strip_edges().is_empty():
		names.append(character_name)
	for party_id_variant in parties.keys():
		var party: Dictionary = parties.get(str(party_id_variant), {})
		var records: Array = party.get("member_records", [])
		for member_variant in records:
			if member_variant is Dictionary:
				var member_name := str(member_variant.get("name", "")).strip_edges()
				if not member_name.is_empty() and not names.has(member_name):
					names.append(member_name)
	return names

func form_karnataka_government(coalition_party_ids: Array, chief_minister_name: String, cabinet_appointments: Dictionary = {}) -> String:
	if not karnataka_government_formation_pending():
		return "There is no pending Karnataka government formation."
	var pending: Dictionary = world_state.get("pending_karnataka_government_formation", {})
	var seats: Dictionary = pending.get("seats_by_party", {})
	if player_party_id.is_empty() or int(seats.get(player_party_id, 0)) <= 0:
		return "Your party did not win any Karnataka Assembly seats and cannot lead this formation."
	var selected: Array[String] = []
	selected.append(player_party_id)
	for id_variant in coalition_party_ids:
		var id := str(id_variant)
		if id != player_party_id and int(seats.get(id, 0)) > 0 and not selected.has(id):
			selected.append(id)
	var coalition_seats := 0
	for id in selected:
		coalition_seats += int(seats.get(id, 0))
	var total_seats := int(pending.get("total_seats", 224))
	var majority := int(pending.get("majority_required", int(floor(float(total_seats) / 2.0)) + 1))
	if coalition_seats < majority:
		return "The proposed coalition has %d seats; %d are required. Add partners before confirming." % [coalition_seats, majority]
	var cm_name := chief_minister_name.strip_edges()
	if cm_name.is_empty():
		return "Select a Chief Minister before confirming government formation."
	var election_year := int(pending.get("next_year", year))
	var election_month := int(pending.get("next_month", month))
	var government := _make_initial_ai_government("state", "Karnataka", player_party_id, election_year, election_month)
	government["coalition_party_ids"] = selected.duplicate()
	government["coalition_seats"] = coalition_seats
	government["seat_count"] = total_seats
	government["majority_required"] = majority
	government["leader_name"] = cm_name
	government["leader_title"] = "Chief Minister"
	government["formation_type"] = "Single-party majority government" if selected.size() == 1 else "Coalition government"
	government["government_status"] = "Formed by High Command after completed Karnataka Assembly election"
	government["source"] = "player-confirmed Karnataka government formation"
	government["cabinet_appointments"] = cabinet_appointments.duplicate(true)
	government["cabinet_status"] = "Cabinet appointed by High Command" if not cabinet_appointments.is_empty() else "Cabinet formation pending"
	government["formed_index"] = year * 12 + month
	var system: Dictionary = world_state.get("governments", {})
	var states: Dictionary = system.get("states", {})
	states["Karnataka"] = government
	system["states"] = states
	var history: Array = system.get("history", [])
	history.append({"level": "state", "jurisdiction": "Karnataka", "year": year, "month": month, "ruling_party_id": player_party_id, "coalition_party_ids": selected.duplicate(), "formation_type": str(government["formation_type"]), "summary": "High Command confirmed a Karnataka government with %d of %d seats; CM: %s." % [coalition_seats, total_seats, cm_name]})
	system["history"] = history
	world_state["governments"] = system
	var pending_copy: Dictionary = pending.duplicate(true)
	pending_copy["pending"] = false
	pending_copy["formed"] = true
	pending_copy["coalition_party_ids"] = selected.duplicate()
	pending_copy["chief_minister_name"] = cm_name
	world_state["pending_karnataka_government_formation"] = pending_copy
	var elections: Array = world_state.get("state_elections", [])
	for i in range(elections.size()):
		if elections[i] is Dictionary and str(elections[i].get("state", "")) == "Karnataka":
			elections[i]["government_status"] = str(government["formation_type"])
			elections[i]["government_party_id"] = player_party_id
			elections[i]["government_formation_pending"] = false
			break
	world_state["state_elections"] = elections
	if cm_name.to_lower() == character_name.to_lower():
		has_elected_office = true
		elected_office_name = "Chief Minister of Karnataka"
		player_role = elected_office_name
		career_rank = elected_office_name
		generate_monthly_office_missions()
	return "Karnataka government formed. %s is Chief Minister; coalition support is %d/%d seats. Cabinet appointments can now be made." % [cm_name, coalition_seats, total_seats]

func _form_ai_government_from_result(level: String, jurisdiction: String, seats_by_party: Dictionary, total_seats: int, next_year: int, next_month: int) -> Dictionary:
	var party_order: Array[String] = []
	for party_id_variant in seats_by_party.keys():
		var party_id := str(party_id_variant)
		if parties.has(party_id) and int(seats_by_party.get(party_id, 0)) > 0:
			party_order.append(party_id)
	for i in range(party_order.size()):
		for j in range(i + 1, party_order.size()):
			var left_id := party_order[i]
			var right_id := party_order[j]
			var left_seats := int(seats_by_party.get(left_id, 0))
			var right_seats := int(seats_by_party.get(right_id, 0))
			if right_seats > left_seats or (right_seats == left_seats and right_id < left_id):
				party_order[i] = right_id
				party_order[j] = left_id
	if party_order.is_empty():
		return _make_initial_ai_government(level, jurisdiction, _choose_initial_ai_government_party("" if level == "national" else jurisdiction), next_year, next_month)

	var majority_required := int(floor(float(total_seats) / 2.0)) + 1
	var coalition: Array[String] = []
	var opposition: Array[String] = []
	var coalition_seats := 0
	_ensure_high_command_schema()
	var coalition_policy := str(world_state.get("high_command", {}).get("coalition_policy", "modeled negotiate a working majority"))
	for party_id in party_order:
		if coalition.is_empty():
			coalition.append(party_id)
			coalition_seats += int(seats_by_party.get(party_id, 0))
		elif coalition_seats < majority_required and coalition_policy == "modeled negotiate a working majority":
			coalition.append(party_id)
			coalition_seats += int(seats_by_party.get(party_id, 0))
		else:
			opposition.append(party_id)
	var leading_party_id := party_order[0]
	var formation_type := "Single-party majority government"
	if coalition.size() > 1:
		formation_type = "Coalition government"
	elif coalition_seats < majority_required:
		formation_type = "Single-party minority government"
	var government := _make_initial_ai_government(level, jurisdiction, leading_party_id, next_year, next_month)
	government["coalition_party_ids"] = coalition
	government["opposition_party_ids"] = opposition
	government["formation_type"] = formation_type
	government["government_status"] = "Formed from completed modeled election"
	government["source"] = "modeled election seat results"
	government["seat_count"] = total_seats
	government["majority_required"] = majority_required
	government["coalition_seats"] = coalition_seats
	government["leader_name"] = _ai_government_leader_name(leading_party_id, jurisdiction)
	var party_names: Array[String] = []
	for party_id in coalition:
		var coalition_party: Dictionary = parties.get(party_id, {})
		party_names.append(str(coalition_party.get("name", party_id)))
	government["coalition_names"] = party_names
	government["last_ai_action"] = "The elected administration formed from the completed election and began routine executive operations."
	government["formed_index"] = year * 12 + month
	government["last_ai_review_index"] = -1

	var system: Dictionary = world_state.get("governments", {})
	if level == "national":
		system["national"] = government
	else:
		var states: Dictionary = system.get("states", {})
		states[jurisdiction] = government
		system["states"] = states
	var history: Array = system.get("history", [])
	var leading_party: Dictionary = parties.get(leading_party_id, {})
	history.append({"level": level, "jurisdiction": jurisdiction, "year": year, "month": month, "ruling_party_id": leading_party_id, "coalition_party_ids": coalition.duplicate(), "formation_type": formation_type, "summary": "%s formed by modeled with %d of %d seats." % [str(leading_party.get("name", leading_party_id)), coalition_seats, total_seats]})
	while history.size() > 100:
		history.pop_front()
	system["history"] = history
	world_state["governments"] = system
	return government

func _ensure_ai_competitor_parties() -> void:
	var ai_templates: Array[Dictionary] = [
		{"id": "party_civic_development", "name": "Civic Development Alliance", "members": 6200, "funds": 8200000, "popularity": 13.5},
		{"id": "party_national_reform", "name": "National Reform Forum", "members": 4700, "funds": 6100000, "popularity": 11.0},
		{"id": "party_regional_justice", "name": "Regional Justice Party", "members": 3900, "funds": 4300000, "popularity": 9.0}
	]
	var competitor_count := 0
	for party_id_variant in parties.keys():
		if str(party_id_variant) != player_party_id:
			competitor_count += 1
	for template_variant in ai_templates:
		if competitor_count >= 3:
			break
		var template: Dictionary = template_variant
		var new_id := str(template.get("id", ""))
		if new_id.is_empty() or parties.has(new_id) or new_id == player_party_id:
			continue
		parties[new_id] = {
			"name": str(template.get("name", "modeled Political Party")),
			"members": int(template.get("members", 3000)),
			"funds": int(template.get("funds", 3000000)),
			"debt": 0,
			"popularity": float(template.get("popularity", 10.0)),
			"is_player_created": false,
			"is_ai_generated": true
		}
		_ensure_party_roster(new_id)
		_ensure_party_world_presence(new_id)
		competitor_count += 1
	_ensure_party_map_colors()

func _ensure_government_system() -> void:
	# The map page is built before a career starts. Do not assign incumbents until
	# the player's party is known, or joining the default party can make it a false
	# pre-existing government in every jurisdiction.
	if not career_started or player_party_id.is_empty():
		return
	if world_state.is_empty():
		_initialize_world_state()
	_ensure_ai_competitor_parties()
	_ensure_election_schema()
	_ensure_party_map_colors()
	var system: Dictionary = world_state.get("governments", {})
	var prior_government_schema := int(system.get("schema_version", 1))
	if system.is_empty():
		system = {"schema_version": 4, "national": {}, "states": {}, "districts": {}, "history": [], "last_ai_month_index": -1}
	var national: Dictionary = system.get("national", {})
	var national_election: Dictionary = world_state.get("national_election", {})
	if national.is_empty():
		var national_seats: Dictionary = national_election.get("last_seats", {})
		if not national_seats.is_empty():
			national = _form_ai_government_from_result("national", "India", national_seats, int(national_election.get("seats", 543)), int(national_election.get("next_year", 2029)), int(national_election.get("month", 5)))
		else:
			var national_party := _choose_initial_ai_government_party("")
			national = _make_initial_ai_government("national", "India", national_party, int(national_election.get("next_year", 2029)), int(national_election.get("month", 5)))
		system["national"] = national

	var states: Dictionary = system.get("states", {})
	var state_elections: Array = world_state.get("state_elections", [])
	for election_variant in state_elections:
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		var state_name := str(election.get("state", ""))
		if state_name.is_empty() or states.has(state_name):
			continue
		var saved_seats: Dictionary = election.get("last_seats", {})
		var state_government: Dictionary = {}
		if not saved_seats.is_empty():
			state_government = _form_ai_government_from_result("state", state_name, saved_seats, int(election.get("assembly_seats", STATE_ASSEMBLY_SEATS.get(state_name, 60))), int(election.get("next_year", year)), int(election.get("month", 5)))
		else:
			var incumbent_party := _choose_initial_ai_government_party(state_name)
			state_government = _make_initial_ai_government("state", state_name, incumbent_party, int(election.get("next_year", year)), int(election.get("month", 5)))
		states[state_name] = state_government
	system["states"] = states

	var districts: Dictionary = system.get("districts", {})
	# Always reconcile the saved district records against the supplied catalog. Older
	# saves can claim catalog version 1 while still missing districts.
	var district_catalog := _load_india_district_catalog()
	for district_variant in district_catalog:
		var district_entry: Dictionary = district_variant
		var district_state_name := str(district_entry.get("state", ""))
		var district_name := str(district_entry.get("district", ""))
		var district_key := str(district_entry.get("key", _local_government_key(district_state_name, district_name)))
		if districts.has(district_key):
			continue
		var local_party := _choose_initial_ai_government_party(district_state_name, district_name)
		var local_government := _make_initial_ai_government("local", district_name + ", " + district_state_name, local_party)
		local_government["state"] = district_state_name
		local_government["district"] = district_name
		local_government["formation_type"] = "District local administration"
		local_government["source"] = "modeled local administration baseline; no district election result inferred"
		local_government["next_election_year"] = year + 1 + (absi(district_key.hash()) % LOCAL_GOVERNMENT_ELECTION_CYCLE_YEARS)
		local_government["next_election_month"] = 1 + (absi((district_key + "|month").hash()) % 12)
		local_government["local_election_phase"] = "Scheduled"
		local_government["local_campaign_spend_by_party"] = {}
		local_government["local_candidate_assignments"] = {}
		local_government["last_local_election_result"] = "No district-level local-body model election held yet"
		districts[district_key] = local_government
	system["district_catalog_version"] = 1 if not district_catalog.is_empty() else 0
	var ordered_district_keys: Array = districts.keys()
	ordered_district_keys.sort()
	for district_order_index in range(ordered_district_keys.size()):
		var district_key := str(ordered_district_keys[district_order_index])
		var local_record: Dictionary = districts[district_key]
		var local_performance: Dictionary = local_record.get("performance", {})
		for metric_name in ["service_delivery", "infrastructure", "welfare", "economy", "public_safety", "public_approval"]:
			if not local_performance.has(metric_name):
				local_performance[metric_name] = 50.0
		local_record["performance"] = local_performance
		local_record["candidate_roster_index"] = district_order_index
		if prior_government_schema < 4 and int(local_record.get("last_local_election_year", 0)) <= 0:
			# Rebuild uncompleted legacy slates using stable district-specific roster indexes.
			local_record["local_candidate_assignments"] = {}
		if not local_record.has("next_election_year"):
			local_record["next_election_year"] = year + 1 + (absi(district_key.hash()) % LOCAL_GOVERNMENT_ELECTION_CYCLE_YEARS)
		if not local_record.has("next_election_month"):
			local_record["next_election_month"] = 1 + (absi((district_key + "|month").hash()) % 12)
		local_record["local_election_phase"] = str(local_record.get("local_election_phase", "Scheduled"))
		local_record["local_campaign_spend_by_party"] = local_record.get("local_campaign_spend_by_party", {})
		local_record["local_candidate_assignments"] = local_record.get("local_candidate_assignments", {})
		local_record["last_local_election_result"] = str(local_record.get("last_local_election_result", "No district-level local-body model election held yet"))
		districts[district_key] = local_record
	system["districts"] = districts
	system["schema_version"] = 4
	if not system.has("history") or not (system.get("history") is Array):
		system["history"] = []
	if not system.has("last_ai_month_index"):
		system["last_ai_month_index"] = -1
	# Migration safety: if a legacy setup assigned the player's party as an
	# incumbent before the career path was selected, replace only un-elected
	# baseline records. Never overwrite a result created by a completed election.
	var national_record: Dictionary = system.get("national", {})
	var national_last_seats: Dictionary = national_election.get("last_seats", {})
	if str(national_record.get("ruling_party_id", "")) == player_party_id and str(national_record.get("source", "")) != "modeled election seat results":
		if not national_last_seats.is_empty():
			national_record = _form_ai_government_from_result("national", "India", national_last_seats, int(national_election.get("seats", 543)), int(national_election.get("next_year", year + 1)), int(national_election.get("month", 5)))
		else:
			var national_winner := str(national_election.get("last_winner", ""))
			var replacement_national := national_winner if not national_winner.is_empty() else _choose_initial_ai_government_party("")
			national_record = _make_initial_ai_government("national", "India", replacement_national, int(national_election.get("next_year", 2029)), int(national_election.get("month", 5)))
			if not national_winner.is_empty():
				national_record["source"] = "legacy recorded election winner; administration"
		system["national"] = national_record
	var migrated_states: Dictionary = system.get("states", {})
	for state_key_variant in migrated_states.keys():
		var state_key := str(state_key_variant)
		var state_record: Dictionary = migrated_states[state_key]
		var matching_election: Dictionary = {}
		for election_variant in state_elections:
			if election_variant is Dictionary and str(election_variant.get("state", "")) == state_key:
				matching_election = election_variant
				break
		var matching_last_seats: Dictionary = matching_election.get("last_seats", {})
		if str(state_record.get("ruling_party_id", "")) == player_party_id and str(state_record.get("source", "")) != "modeled election seat results":
			if not matching_last_seats.is_empty():
				state_record = _form_ai_government_from_result("state", state_key, matching_last_seats, int(matching_election.get("assembly_seats", STATE_ASSEMBLY_SEATS.get(state_key, 60))), int(matching_election.get("next_year", year + 1)), int(matching_election.get("month", 5)))
			else:
				var matching_winner := str(matching_election.get("last_winner", ""))
				var replacement_state := matching_winner if not matching_winner.is_empty() else _choose_initial_ai_government_party(state_key)
				state_record = _make_initial_ai_government("state", state_key, replacement_state, int(matching_election.get("next_year", year + 1)), int(matching_election.get("month", 5)))
				if not matching_winner.is_empty():
					state_record["source"] = "legacy recorded election winner; administration"
			migrated_states[state_key] = state_record
	system["states"] = migrated_states
	var migrated_districts: Dictionary = system.get("districts", {})
	for district_key_variant in migrated_districts.keys():
		var district_key := str(district_key_variant)
		var local_record: Dictionary = migrated_districts[district_key]
		var local_has_election_result := int(local_record.get("last_local_election_year", 0)) > 0 or str(local_record.get("source", "")) == "modeled district-level local election"
		if str(local_record.get("ruling_party_id", "")) == player_party_id and not local_has_election_result:
			var local_state := str(local_record.get("state", ""))
			var local_district := str(local_record.get("district", ""))
			var replacement_local := _choose_initial_ai_government_party(local_state, local_district)
			var replacement_record := _make_initial_ai_government("local", local_district + ", " + local_state, replacement_local)
			replacement_record["state"] = local_state
			replacement_record["district"] = local_district
			replacement_record["source"] = "modeled local administration baseline; no district election result inferred"
			replacement_record["next_election_year"] = int(local_record.get("next_election_year", year + 1))
			replacement_record["next_election_month"] = int(local_record.get("next_election_month", 12))
			replacement_record["candidate_roster_index"] = int(local_record.get("candidate_roster_index", 0))
			migrated_districts[district_key] = replacement_record
	system["districts"] = migrated_districts
	world_state["governments"] = system
	_ensure_high_command_schema()

func _get_or_create_local_candidate(party_id: String, government: Dictionary, district_key: String, state_name: String, district_name: String) -> Dictionary:
	var assignments_variant: Variant = government.get("local_candidate_assignments", {})
	var assignments: Dictionary = assignments_variant if assignments_variant is Dictionary else {}
	var election_key := "%s|%d|%d" % [district_key, int(government.get("next_election_year", year)), int(government.get("next_election_month", month))]
	if assignments.has(party_id):
		var existing: Dictionary = assignments[party_id]
		if str(existing.get("election_key", "")) == election_key:
			return existing
	var roster_index := _local_district_candidate_index(district_key)
	var chosen := _candidate_record_for_party(party_id, roster_index, state_name)
	chosen["election_key"] = election_key
	assignments[party_id] = chosen
	government["local_candidate_assignments"] = assignments
	if party_id == player_party_id and parties.has(player_party_id):
		var player_party: Dictionary = parties[player_party_id]
		player_party["automatic_candidate_assignments"] = int(player_party.get("automatic_candidate_assignments", 0)) + 1
		parties[player_party_id] = player_party
	return chosen

func _run_local_government_campaign(government: Dictionary, district_key: String) -> void:
	var spending: Dictionary = government.get("local_campaign_spend_by_party", {})
	var state_name := str(government.get("state", ""))
	var district_name := str(government.get("district", ""))
	var assignments: Dictionary = government.get("local_candidate_assignments", {})
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties.get(party_id, {})
		if party.is_empty():
			continue
		_get_or_create_local_candidate(party_id, government, district_key, state_name, district_name)
		assignments = government.get("local_candidate_assignments", {})
		var budget := mini(1200, 250 + int(party.get("members", 0)) / 500)
		if party_id == player_party_id:
			budget = mini(_high_command_campaign_budget_share(), 1200)
		var available := maxi(0, int(party.get("funds", 0)))
		var spend := mini(available, budget)
		if spend > 0:
			party["funds"] = available - spend
			parties[party_id] = party
			spending[party_id] = int(spending.get(party_id, 0)) + spend
			if party_id == player_party_id:
				_record_high_command_campaign_spend(spend)
	government["local_campaign_spend_by_party"] = spending
	government["local_candidate_assignments"] = assignments
	government["local_election_phase"] = "Campaigning"
	government["last_ai_campaign_action"] = "modeled organizations assigned candidates, organized local outreach, and ran the campaign in %s." % district_name

func _resolve_local_government_election(government: Dictionary, district_key: String) -> Dictionary:
	var state_name := str(government.get("state", ""))
	var district_name := str(government.get("district", ""))
	var regional: Dictionary = world_state.get("regional_support", {})
	var spending: Dictionary = government.get("local_campaign_spend_by_party", {})
	var scores: Dictionary = {}
	var score_total := 0.0
	var assignments: Dictionary = government.get("local_candidate_assignments", {})
	for party_id_variant in parties.keys():
		var party_id := str(party_id_variant)
		var party: Dictionary = parties.get(party_id, {})
		var support_by_state: Dictionary = regional.get(party_id, {})
		var support := float(support_by_state.get(state_name, party.get("popularity", 10.0)))
		var campaign_bonus := minf(10.0, float(spending.get(party_id, 0)) / 5000.0)
		var geographic_seed := absi((district_key + "|" + str(year) + "|" + party_id).hash()) % 2801
		var geographic_variation := float(geographic_seed) / 100.0 - 14.0
		var high_command_bonus := _high_command_strategy_bonus() if party_id == player_party_id else 0.0
		var score := maxf(0.2, support + campaign_bonus + geographic_variation + high_command_bonus)
		scores[party_id] = score
		score_total += score
	var winner_id := ""
	var winning_votes := -1
	var total_eligible := 18000 + (absi((district_key + "|eligible").hash()) % 32000)
	var turnout_percent := 58.0 + float(absi((district_key + "|turnout|" + str(year)).hash()) % 1800) / 100.0
	var ballots := maxi(1, roundi(float(total_eligible) * turnout_percent / 100.0))
	var result_rows: Array[Dictionary] = []
	var votes_by_party: Dictionary = {}
	var remaining_votes := ballots
	var party_ids: Array[String] = []
	for party_id_variant in scores.keys():
		party_ids.append(str(party_id_variant))
	party_ids.sort()
	for party_index in range(party_ids.size()):
		var party_id := party_ids[party_index]
		var share := float(scores.get(party_id, 0.0)) / maxf(score_total, 0.001)
		var votes := remaining_votes if party_index == party_ids.size() - 1 else clampi(roundi(float(ballots) * share), 0, remaining_votes)
		remaining_votes -= votes
		var candidate: Dictionary = assignments.get(party_id, {})
		if candidate.is_empty():
			candidate = _get_or_create_local_candidate(party_id, government, district_key, state_name, district_name)
			assignments = government.get("local_candidate_assignments", {})
		votes_by_party[party_id] = votes
		if votes > winning_votes or (votes == winning_votes and (winner_id.is_empty() or party_id < winner_id)):
			winning_votes = votes
			winner_id = party_id
		result_rows.append({
			"party_id": party_id,
			"party_name": str(parties.get(party_id, {}).get("name", party_id)),
			"member_id": str(candidate.get("member_id", "")),
			"candidate_name": str(candidate.get("candidate_name", "modeled local candidate")),
			"votes": votes,
			"vote_percent": float(votes) * 100.0 / float(ballots),
			"status": "Pending"
		})
	for result_index in range(result_rows.size()):
		var result_row: Dictionary = result_rows[result_index]
		result_row["status"] = "Elected" if str(result_row.get("party_id", "")) == winner_id else "Not elected"
		result_rows[result_index] = result_row
	var winner_candidate: Dictionary = assignments.get(winner_id, {})
	if winner_candidate.is_empty():
		winner_candidate = _get_or_create_local_candidate(winner_id, government, district_key, state_name, district_name)
	var winner_name := _government_party_name(winner_id)
	government["ruling_party_id"] = winner_id
	government["coalition_party_ids"] = [winner_id]
	government["leader_name"] = str(winner_candidate.get("candidate_name", "modeled local leader"))
	government["leader_title"] = "Local body representative (office-holder)"
	government["formation_type"] = "modeled district local-administration election result"
	government["government_status"] = "Operating"
	government["source"] = "modeled district-level local election"
	government["last_local_election_year"] = year
	government["last_local_election_month"] = month
	government["last_local_election_result"] = "%s's candidate %s won the modeled district-local election with %d votes (%.1f%% turnout)." % [winner_name, str(winner_candidate.get("candidate_name", "modeled local leader")), int(votes_by_party.get(winner_id, 0)), turnout_percent]
	government["last_local_candidate_results"] = result_rows
	government["last_local_eligible_voters"] = total_eligible
	government["last_local_ballots_cast"] = ballots
	government["local_candidate_assignments"] = assignments
	government["next_election_year"] = year + LOCAL_GOVERNMENT_ELECTION_CYCLE_YEARS
	government["local_election_phase"] = "Scheduled"
	government["local_campaign_spend_by_party"] = {}
	var current_system: Dictionary = world_state.get("governments", {})
	var history: Array = current_system.get("history", [])
	history.append({"level": "local", "jurisdiction": district_name + ", " + state_name, "year": year, "month": month, "ruling_party_id": winner_id, "leader_name": str(winner_candidate.get("candidate_name", "modeled local leader")), "summary": str(government["last_local_election_result"])})
	while history.size() > 500:
		history.pop_front()
	current_system["history"] = history
	world_state["governments"] = current_system
	return government

func _advance_ai_local_government_elections(report_lines: Array[String]) -> void:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	var campaign_count := 0
	var election_count := 0
	for district_key_variant in districts.keys():
		var district_key := str(district_key_variant)
		var government: Dictionary = districts[district_key]
		var election_year := int(government.get("next_election_year", year + 5))
		var election_month := clampi(int(government.get("next_election_month", 12)), 1, 12)
		var months_remaining := (election_year - year) * 12 + (election_month - month)
		if months_remaining > MODELED_CAMPAIGN_MONTHS:
			government["local_election_phase"] = "Scheduled"
		elif months_remaining > 0:
			_run_local_government_campaign(government, district_key)
			campaign_count += 1
		else:
			government = _resolve_local_government_election(government, district_key)
			election_count += 1
		districts[district_key] = government
	system["districts"] = districts
	world_state["governments"] = system
	if campaign_count > 0:
		report_lines.append("Party organizations are campaigning in %d district-level local administration contests. Your party fields nominees and runs outreach under the High Command strategy." % campaign_count)
	if election_count > 0:
		report_lines.append("%d district-level local administration elections were resolved through party candidate nominations and campaign operations. Winners now control their modeled local administrations; the player receives no office automatically." % election_count)

func _run_ai_government_monthly() -> void:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var current_index := year * 12 + month
	if int(system.get("last_ai_month_index", -1)) == current_index:
		return
	var national: Dictionary = system.get("national", {})
	if not national.is_empty():
		system["national"] = _advance_ai_government_record(national)
	var states: Dictionary = system.get("states", {})
	for state_variant in states.keys():
		var state_name := str(state_variant)
		var state_government: Dictionary = states[state_name]
		states[state_name] = _advance_ai_government_record(state_government)
	var districts: Dictionary = system.get("districts", {})
	for district_variant in districts.keys():
		var district_key := str(district_variant)
		var district_government: Dictionary = districts[district_key]
		districts[district_key] = _advance_ai_government_record(district_government)
	system["states"] = states
	system["districts"] = districts
	system["last_ai_month_index"] = current_index
	world_state["governments"] = system

func _advance_ai_government_record(government: Dictionary) -> Dictionary:
	var performance: Dictionary = government.get("performance", {})
	for metric in ["service_delivery", "infrastructure", "welfare", "economy", "public_safety", "public_approval"]:
		performance[metric] = clampf(float(performance.get(metric, 50.0)), 0.0, 100.0)
	var action_index := randi_range(0, AI_GOVERNMENT_ACTIONS.size() - 1)
	var action: Dictionary = AI_GOVERNMENT_ACTIONS[action_index]
	var metric_name := str(action.get("metric", "service_delivery"))
	var coalition_variant: Variant = government.get("coalition_party_ids", [])
	var coalition: Array = coalition_variant if coalition_variant is Array else []
	var stability_bonus := 0.18 if coalition.size() <= 1 else -0.08
	var progress := randf_range(-0.25, 0.65) + stability_bonus
	performance[metric_name] = clampf(float(performance.get(metric_name, 50.0)) + progress, 0.0, 100.0)
	var average := 0.0
	for metric in ["service_delivery", "infrastructure", "welfare", "economy", "public_safety"]:
		average += float(performance.get(metric, 50.0))
	performance["public_approval"] = clampf(average / 5.0, 0.0, 100.0)
	government["performance"] = performance
	government["last_ai_action"] = str(action.get("action", "Reviewed routine public administration."))
	government["last_ai_review_index"] = year * 12 + month
	government["administration_mode"] = "simulation"
	return government

func get_state_government(state_name: String) -> Dictionary:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var states: Dictionary = system.get("states", {})
	if states.has(state_name):
		var government: Dictionary = states.get(state_name, {})
		return government.duplicate(true)
	# The map also contains Union Territories, which do not use the state
	# assembly election schedule in this simulation. Show their AI-administered
	# Union Government model rather than leaving the territory without control.
	var national: Dictionary = system.get("national", {})
	if not national.is_empty():
		var territory_government: Dictionary = national.duplicate(true)
		territory_government["level"] = "territory"
		territory_government["jurisdiction"] = state_name
		territory_government["leader_title"] = "Administrator / Lieutenant Governor (modeled model)"
		territory_government["leader_name"] = _ai_government_leader_name(str(national.get("ruling_party_id", "")), state_name + " territory")
		territory_government["formation_type"] = "Union Territory administration"
		territory_government["source"] = "simplified Union Government administration model"
		return territory_government
	return {}

func get_national_government() -> Dictionary:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var government: Dictionary = system.get("national", {})
	return government.duplicate(true)

func get_local_government(state_name: String, district_name: String) -> Dictionary:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	var key := _local_government_key(state_name, district_name)
	var government: Dictionary = districts.get(key, {})
	return government.duplicate(true)

func local_government_party_map(state_name: String = "") -> Dictionary:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var districts: Dictionary = system.get("districts", {})
	var result: Dictionary = {}
	for key_variant in districts.keys():
		var key := str(key_variant)
		var government: Dictionary = districts[key]
		if not state_name.is_empty() and str(government.get("state", "")) != state_name:
			continue
		var party_id := str(government.get("ruling_party_id", ""))
		if not party_id.is_empty():
			result[key] = party_id
	return result

func _government_party_name(party_id: String) -> String:
	if party_id.is_empty():
		return "No party recorded"
	return str(parties.get(party_id, {}).get("name", party_id))

func government_party_status(government: Dictionary) -> String:
	if player_party_id.is_empty():
		return "No player party selected"
	var coalition_variant: Variant = government.get("coalition_party_ids", [])
	var coalition: Array = coalition_variant if coalition_variant is Array else []
	if str(government.get("ruling_party_id", "")) == player_party_id:
		return "Your party leads the government; executive administration is under the elected executive until you hold a specific executive office."
	if player_party_id in coalition:
		return "Your party is a coalition partner; the elected leader and administration run the government."
	return "Your party is outside this government. The recorded ruling party and its elected government lead the administration."

func _home_district_name() -> String:
	var city := home_city.strip_edges().to_lower()
	if city in ["brahmavara", "udupi", "manipal", "kundapura", "karkala", "kaup", "kapu"]:
		return "Udupi"
	if city in ["mangaluru", "mangalore", "puttur", "bantwal", "sullia"]:
		return "Dakshina Kannada"
	if city in ["bengaluru", "bangalore"]:
		return "Bengaluru Urban"
	if city in ["mysuru", "mysore"]:
		return "Mysuru"
	return home_city

func government_system_summary() -> String:
	_ensure_government_system()
	var system: Dictionary = world_state.get("governments", {})
	var national: Dictionary = system.get("national", {})
	var states: Dictionary = system.get("states", {})
	var districts: Dictionary = system.get("districts", {})
	var national_party := str(national.get("ruling_party_id", ""))
	var lines: Array[String] = ["UNION GOVERNMENT", "Ruling party: %s" % _government_party_name(national_party), "%s: %s" % [str(national.get("leader_title", "Prime Minister")), str(national.get("leader_name", "Leader not recorded"))], "Formation: %s" % str(national.get("formation_type", "Administration in operation")), "Administration: Routine executive administration", "Your party's position: %s" % government_party_status(national)]
	lines.append("STATE GOVERNMENTS")
	lines.append("State administrations: %d" % states.size())
	var home_state_government := get_state_government(home_state)
	lines.append("%s — Ruling party: %s" % [home_state, _government_party_name(str(home_state_government.get("ruling_party_id", "")))])
	lines.append("Chief Minister / executive leader: %s" % str(home_state_government.get("leader_name", "Leader not recorded")))
	lines.append("Your party's position: %s" % government_party_status(home_state_government))
	lines.append("LOCAL ADMINISTRATIONS")
	lines.append("District administrations: %d" % districts.size())
	var home_district := _home_district_name()
	var home_local_government := get_local_government(home_state, home_district)
	if home_local_government.is_empty():
		lines.append("%s local body: modeled administration; district boundary record unavailable." % home_city)
	else:
		lines.append("%s local body — Ruling party: %s" % [home_district, _government_party_name(str(home_local_government.get("ruling_party_id", "")))])
		lines.append("Local executive leader: %s" % str(home_local_government.get("leader_name", "Administrator not recorded")))
		lines.append("Your party's position: %s" % government_party_status(home_local_government))
	lines.append("Authority rule: Party president, party officer, or coalition membership alone does not grant executive powers. Player actions require an active office record for the relevant jurisdiction.")
	return "\n".join(lines)

func national_government_briefing() -> String:
	var government := get_national_government()
	return "Union government: %s\nPrime Minister: %s\nGovernment type: %s\nAdministration: Routine executive administration\nYour party: %s" % [
		_government_party_name(str(government.get("ruling_party_id", ""))),
		str(government.get("leader_name", "Leader not recorded")),
		str(government.get("formation_type", "Administration in operation")),
		government_party_status(government)
	]

func state_government_briefing(state_name: String) -> String:
	var government := get_state_government(state_name)
	if government.is_empty():
		return "Government: modeled caretaker administration pending modeled results."
	return "Ruling party: %s\nChief Minister / executive leader: %s\nFormation: %s\nAdministration: Routine executive administration\nYour party: %s" % [
		_government_party_name(str(government.get("ruling_party_id", ""))),
		str(government.get("leader_name", "Leader not recorded")),
		str(government.get("formation_type", "Administration in operation")),
		government_party_status(government)
	]

func local_government_briefing(state_name: String, district_name: String) -> String:
	var government := get_local_government(state_name, district_name)
	if government.is_empty():
		return "Local administration: modeled fallback. No district boundary record is available."

	var next_poll := _month_name(int(government.get("next_election_month", 12))) + " " + str(government.get("next_election_year", year + LOCAL_GOVERNMENT_ELECTION_CYCLE_YEARS))
	var briefing_lines := PackedStringArray([
		"Local ruling party: " + _government_party_name(str(government.get("ruling_party_id", ""))),
		"Local executive leader: " + str(government.get("leader_name", "Administrator not recorded")),
		"Administration: Routine executive administration",
		"Government type: " + str(government.get("formation_type", "modeled local administration")),
		"Modeled next district-local poll: " + next_poll,
		"Latest local result: " + str(government.get("last_local_election_result", "No district-local result yet")),
		"Status: " + str(government.get("government_status", "Operating")),
		"Your party: " + government_party_status(government),
		"Latest modeled action: " + str(government.get("last_ai_action", "Routine administration"))
	])
	return "\n".join(briefing_lines)

# ---------------------------------------------------------------------------
# Political authority foundation (Phase 1)
# Authority is stored as explicit office records, never inferred from a display
# label such as player_role or career_rank. This prevents party roles from
# accidentally granting government powers.
func _ensure_authority_schema() -> void:
	if world_state.is_empty():
		_initialize_world_state()
	var authority: Dictionary = world_state.get("political_authority", {})
	if authority.is_empty():
		authority = {
			"schema_version": 1,
			"positions": {},
			"history": [],
			"last_updated_index": year * 12 + month
		}
	if not (authority.get("positions", {}) is Dictionary):
		authority["positions"] = {}
	if not (authority.get("history", []) is Array):
		authority["history"] = []
	authority["schema_version"] = 1
	world_state["political_authority"] = authority

func _authority_actor_id() -> String:
	return "player"

func _authority_record(position_id: String) -> Dictionary:
	_ensure_authority_schema()
	var authority: Dictionary = world_state.get("political_authority", {})
	var positions: Dictionary = authority.get("positions", {})
	var record: Variant = positions.get(position_id, {})
	return record.duplicate(true) if record is Dictionary else {}

func player_has_authority(permission: String, jurisdiction: String = "") -> bool:
	# Legacy local-office status grants only representative-level actions.
	# It does not grant executive, legislative, or national authority.
	if has_elected_office and permission in [
		"representative.submit_representation",
		"representative.request_report",
		"representative.raise_constituency_issue"
	]:
		return jurisdiction.is_empty() or jurisdiction == home_state or jurisdiction == home_city
	_ensure_authority_schema()
	var authority: Dictionary = world_state.get("political_authority", {})
	var positions: Dictionary = authority.get("positions", {})
	for position_variant in positions.values():
		if not position_variant is Dictionary:
			continue
		var position: Dictionary = position_variant
		if str(position.get("holder_id", "")) != _authority_actor_id():
			continue
		if not bool(position.get("active", false)):
			continue
		var scope := str(position.get("jurisdiction", ""))
		if not jurisdiction.is_empty() and scope != jurisdiction and scope != "India":
			continue
		var permissions: Array = position.get("permissions", [])
		if permission in permissions:
			return true
	return false

func can_player_perform_action(action_id: String, jurisdiction: String = "") -> bool:
	# Explicit allowlist: every gameplay action must be mapped to an office
	# permission. Unknown actions fail closed rather than inheriting authority.
	var permission_by_action := {
		"submit_representation": "representative.submit_representation",
		"request_department_report": "representative.request_report",
		"raise_constituency_issue": "representative.raise_constituency_issue",
		"approve_department_budget": "executive.approve_budget",
		"direct_department": "executive.direct_department",
		"introduce_bill": "legislature.introduce_bill",
		"vote_on_bill": "legislature.vote",
		"appoint_minister": "executive.appoint_minister",
		"form_government": "executive.form_government"
	}
	if not permission_by_action.has(action_id):
		return false
	return player_has_authority(str(permission_by_action[action_id]), jurisdiction)

func player_authority_summary() -> String:
	_ensure_authority_schema()
	var lines: Array[String] = ["POLITICAL AUTHORITY", "Career title: %s" % career_rank]
	var authority: Dictionary = world_state.get("political_authority", {})
	var positions: Dictionary = authority.get("positions", {})
	var active_count := 0
	for position_variant in positions.values():
		if not position_variant is Dictionary:
			continue
		var position: Dictionary = position_variant
		if str(position.get("holder_id", "")) != _authority_actor_id() or not bool(position.get("active", false)):
			continue
		active_count += 1
		lines.append("Active office: %s — %s" % [
			str(position.get("title", "Public office")),
			str(position.get("jurisdiction", "Unspecified jurisdiction"))
		])
		var permissions: Array = position.get("permissions", [])
		if not permissions.is_empty():
			lines.append("Powers: %s" % ", ".join(PackedStringArray(permissions)))
	if active_count == 0:
		lines.append("Mandate: No active elected government office.")
	lines.append("Party titles and internal party appointments do not grant government powers.")
	lines.append("Government authority is granted only by an active, jurisdiction-specific office record.")
	return "\n".join(lines)

func register_authority_position(
	position_id: String,
	position_title: String,
	holder_id: String,
	jurisdiction: String,
	permissions: Array,
	source: String
) -> bool:
	# Internal foundation for future election/government-formation systems.
	# A position must have a real holder, jurisdiction, and explicit permissions.
	if position_id.strip_edges().is_empty() or holder_id.strip_edges().is_empty() or jurisdiction.strip_edges().is_empty():
		return false
	_ensure_authority_schema()
	var authority: Dictionary = world_state.get("political_authority", {})
	var positions: Dictionary = authority.get("positions", {})
	var previous: Dictionary = positions.get(position_id, {})
	positions[position_id] = {
		"position_id": position_id,
		"title": position_title,
		"holder_id": holder_id,
		"jurisdiction": jurisdiction,
		"permissions": permissions.duplicate(),
		"source": source,
		"active": true,
		"start_index": year * 12 + month,
		"end_index": -1
	}
	authority["positions"] = positions
	var history: Array = authority.get("history", [])
	if not previous.is_empty():
		previous["active"] = false
		previous["end_index"] = year * 12 + month
		history.append(previous)
	history.append(positions[position_id].duplicate(true))
	authority["history"] = history
	authority["last_updated_index"] = year * 12 + month
	world_state["political_authority"] = authority
	return true

func revoke_authority_position(position_id: String, reason: String) -> bool:
	_ensure_authority_schema()
	var authority: Dictionary = world_state.get("political_authority", {})
	var positions: Dictionary = authority.get("positions", {})
	if not positions.has(position_id):
		return false
	var record: Dictionary = positions[position_id]
	if not bool(record.get("active", false)):
		return false
	record["active"] = false
	record["end_index"] = year * 12 + month
	record["end_reason"] = reason
	positions[position_id] = record
	authority["positions"] = positions
	var history: Array = authority.get("history", [])
	history.append(record.duplicate(true))
	authority["history"] = history
	authority["last_updated_index"] = year * 12 + month
	world_state["political_authority"] = authority
	return true

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
	return "INDIA-WIDE POLITICAL WORLD\nRegional party support in %s: %.1f / 100\nNext modeled state assembly election: %s — %s %d\nState election phase: %s\nNext modeled Lok Sabha election: %s %d — %s\nLatest modeled result: %s\nmodeled organizations campaign automatically when you do not take direct action. Schedules are simulation models, not official dates." % [
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
			records.append({"id": "member_%d" % counter, "name": _fictional_name_at(counter - 1), "duty": ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary"][posmod(i, 6)], "region": "Karnataka", "joined_year": year, "joined_month": month, "is_player_added": false})
	# The headline membership includes the founder. Materialize missing player-party
	# members so internal elections use the full electorate, not only the small named seed roster.
	if party_id == player_party_id:
		var target_records := mini(1000, maxi(records.size(), maxi(0, int(party.get("members", 1)) - 1)))
		while records.size() < target_records:
			counter += 1
			var base_name := _fictional_name_at(counter - 1)
			records.append({"id": "member_%d" % counter, "name": base_name, "duty": "Volunteer", "region": home_state, "joined_year": year, "joined_month": month, "is_player_added": false})
	party["member_records"] = records
	party["member_counter"] = counter
	parties[party_id] = party
	_ensure_state_active_membership(party_id)

func _ensure_state_active_membership(party_id: String) -> void:
	if party_id.is_empty() or not parties.has(party_id):
		return
	var party: Dictionary = parties[party_id]
	var total_members := maxi(0, int(party.get("members", 0)))
	var saved_variant: Variant = party.get("state_active_members", {})
	var counts: Dictionary = saved_variant if saved_variant is Dictionary else {}
	var states: Array = STATE_ASSEMBLY_SEATS.keys()
	states.sort()
	if states.is_empty():
		return
	if counts.is_empty():
		# Existing careers only stored a national membership total. Initialize a
		# persistent state distribution weighted by each state's modeled support.
		# Every state gets a baseline weight so the roster is nationwide, not
		# concentrated in Karnataka merely because the old named roster was local.
		var regional_support_all: Dictionary = world_state.get("regional_support", {})
		var regional_support: Dictionary = regional_support_all.get(party_id, {})
		var weights: Dictionary = {}
		var total_weight := 0.0
		for state_variant in states:
			var state_name := str(state_variant)
			var weight := maxf(1.0, float(regional_support.get(state_name, 0.0)) + 1.0)
			weights[state_name] = weight
			total_weight += weight
		var assigned := 0
		for state_variant in states:
			var state_name := str(state_variant)
			var amount := int(floor(float(total_members) * float(weights[state_name]) / maxf(1.0, total_weight)))
			counts[state_name] = amount
			assigned += amount
		var remainder := total_members - assigned
		for index in range(remainder):
			var state_name := str(states[index % states.size()])
			counts[state_name] = int(counts.get(state_name, 0)) + 1
	else:
		for state_variant in states:
			var state_name := str(state_variant)
			if not counts.has(state_name):
				counts[state_name] = 0
		# Keep legacy career totals consistent when monthly recruitment or transfers
		# changed the national count outside a state-specific roster action.
		var counted_total := 0
		for count_variant in counts.values():
			counted_total += maxi(0, int(count_variant))
		var difference := total_members - counted_total
		var home_key := home_state if counts.has(home_state) else str(states[0])
		if difference > 0:
			counts[home_key] = int(counts.get(home_key, 0)) + difference
		elif difference < 0:
			var to_remove := -difference
			var reduction_order: Array = [home_key]
			for state_variant in states:
				var state_name := str(state_variant)
				if state_name != home_key:
					reduction_order.append(state_name)
			for state_variant in reduction_order:
				var state_name := str(state_variant)
				var removed := mini(to_remove, maxi(0, int(counts.get(state_name, 0))))
				counts[state_name] = int(counts.get(state_name, 0)) - removed
				to_remove -= removed
				if to_remove <= 0:
					break
	party["state_active_members"] = counts
	parties[party_id] = party

func _add_active_member_to_state(party_id: String, state_name: String, amount: int = 1) -> void:
	if amount <= 0 or party_id.is_empty() or not parties.has(party_id):
		return
	_ensure_state_active_membership(party_id)
	var party: Dictionary = parties[party_id]
	var counts: Dictionary = party.get("state_active_members", {})
	var resolved_state := state_name if counts.has(state_name) else home_state
	if not counts.has(resolved_state):
		var state_names: Array = STATE_ASSEMBLY_SEATS.keys()
		state_names.sort()
		resolved_state = str(state_names[0])
	counts[resolved_state] = int(counts.get(resolved_state, 0)) + amount
	party["state_active_members"] = counts
	parties[party_id] = party

func _next_fictional_member_name(party: Dictionary) -> String:
	var counter := int(party.get("member_counter", 0)) + 1
	return _fictional_name_at(counter - 1)

func get_player_party_members() -> Array:
	if player_party_id == "" or not parties.has(player_party_id):
		return []
	var party: Dictionary = parties[player_party_id]
	var records: Array = party.get("member_records", [])
	return records.duplicate(true)

func add_party_member(member_name: String, region: String = "") -> String:
	if player_party_id == "" or not parties.has(player_party_id):
		return "Join or found a party before adding members."
	var clean_name := member_name.strip_edges()
	if clean_name.is_empty():
		return "Enter a member name."
	_ensure_state_active_membership(player_party_id)
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
		"region": region.strip_edges() if not region.strip_edges().is_empty() else home_state,
		"joined_year": year,
		"joined_month": month,
		"is_player_added": true
	})
	party["member_counter"] = counter
	party["member_records"] = records
	party["members"] = int(party.get("members", 0)) + 1
	parties[player_party_id] = party
	_add_active_member_to_state(player_party_id, str(records.back().get("region", home_state)))
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

func assign_party_member_organization(member_id: String, region: String, duty: String) -> String:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return "Join or found a party first."
	if not STATE_ASSEMBLY_SEATS.has(region):
		return "Choose a valid State Assembly region."
	var allowed := ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary", "State Organizer"]
	if not allowed.has(duty):
		return "That party duty is not available."
	var party: Dictionary = parties[player_party_id]
	var records: Array = party.get("member_records", [])
	for record_index in range(records.size()):
		var member: Dictionary = records[record_index]
		if str(member.get("id", "")) != member_id:
			continue
		var previous_region := str(member.get("region", home_state))
		member["region"] = region
		member["duty"] = duty
		records[record_index] = member
		party["member_records"] = records
		parties[player_party_id] = party
		_ensure_state_active_membership(player_party_id)
		if previous_region != region:
			var refreshed_party: Dictionary = parties[player_party_id]
			var active_counts: Dictionary = refreshed_party.get("state_active_members", {})
			if active_counts.has(previous_region) and active_counts.has(region):
				active_counts[previous_region] = maxi(0, int(active_counts.get(previous_region, 0)) - 1)
				active_counts[region] = int(active_counts.get(region, 0)) + 1
				refreshed_party["state_active_members"] = active_counts
				parties[player_party_id] = refreshed_party
		return "%s assigned as %s in %s. Previous region: %s. Organization readiness recalculated." % [str(member.get("name", "Member")), duty, region, previous_region]
	return "Select a valid party member."

func _process_party_state_organization_monthly() -> void:
	# State presidents and their local teams handle routine organization in every
	# modeled state. This is background simulation; the player need not assign
	# individual office-bearers state by state.
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	_ensure_state_active_membership(player_party_id)
	var party: Dictionary = parties[player_party_id]
	var active_variant: Variant = party.get("state_active_members", {})
	var active_counts: Dictionary = active_variant if active_variant is Dictionary else {}
	var progress_variant: Variant = party.get("state_organization_progress", {})
	var progress: Dictionary = progress_variant if progress_variant is Dictionary else {}
	var state_names: Array = STATE_ASSEMBLY_SEATS.keys()
	state_names.sort()
	for state_variant in state_names:
		var state_name := str(state_variant)
		var members_here := maxi(0, int(active_counts.get(state_name, 0)))
		var current_score := clampf(float(progress.get(state_name, 0.0)), 0.0, 100.0)
		# Existing membership provides the volunteer base. Larger state teams
		# establish local units faster, with a small baseline so smaller states
		# are not permanently left at zero.
		var monthly_gain := 0.65 + minf(2.1, float(members_here) / 140.0)
		if members_here <= 0:
			monthly_gain *= 0.25
		progress[state_name] = minf(100.0, current_score + monthly_gain)
	party["state_organization_progress"] = progress
	parties[player_party_id] = party


func party_organization_profile(state_name: String) -> Dictionary:
	if player_party_id.is_empty() or not parties.has(player_party_id) or not STATE_ASSEMBLY_SEATS.has(state_name):
		return {}
	_ensure_state_active_membership(player_party_id)
	var party: Dictionary = parties[player_party_id]
	var records_variant: Variant = party.get("member_records", [])
	var records: Array = records_variant if records_variant is Array else []
	var named_member_count := 0
	var duty_counts: Dictionary = {
		"Volunteer": 0,
		"Booth Coordinator": 0,
		"Ward Organizer": 0,
		"Media Coordinator": 0,
		"Treasurer": 0,
		"District Secretary": 0,
		"State Organizer": 0
	}
	for member_variant in records:
		if not member_variant is Dictionary:
			continue
		var member: Dictionary = member_variant
		if str(member.get("region", home_state)) != state_name:
			continue
		named_member_count += 1
		var duty := str(member.get("duty", "Volunteer"))
		duty_counts[duty] = int(duty_counts.get(duty, 0)) + 1
	var state_active_members: Dictionary = party.get("state_active_members", {})
	var member_count := maxi(0, int(state_active_members.get(state_name, 0)))
	var progress_variant: Variant = party.get("state_organization_progress", {})
	var progress: Dictionary = progress_variant if progress_variant is Dictionary else {}
	var automated_score := clampf(float(progress.get(state_name, 0.0)), 0.0, 100.0)
	var readiness_score := automated_score
	readiness_score += 20.0 if int(duty_counts.get("State Organizer", 0)) > 0 else 0.0
	readiness_score += float(mini(4, int(duty_counts.get("District Secretary", 0)))) * 8.0
	readiness_score += float(mini(15, int(duty_counts.get("Ward Organizer", 0)))) * 2.0
	readiness_score += float(mini(30, int(duty_counts.get("Booth Coordinator", 0))))
	readiness_score += float(mini(2, int(duty_counts.get("Media Coordinator", 0)))) * 4.0
	readiness_score += 4.0 if int(duty_counts.get("Treasurer", 0)) > 0 else 0.0
	readiness_score += float(mini(20, int(duty_counts.get("Volunteer", 0)))) * 0.1
	readiness_score = clampf(readiness_score, 0.0, 100.0)
	var readiness := "No structure"
	if readiness_score >= 70.0:
		readiness = "Established"
	elif readiness_score >= 35.0:
		readiness = "Developing"
	elif readiness_score > 0.0:
		readiness = "Emerging"
	var priorities: Array[String] = []
	if int(duty_counts.get("State Organizer", 0)) == 0:
		priorities.append("appoint a State Organizer")
	if int(duty_counts.get("District Secretary", 0)) < 2:
		priorities.append("build district leadership")
	if int(duty_counts.get("Ward Organizer", 0)) < 3:
		priorities.append("add Ward Organizers")
	if int(duty_counts.get("Booth Coordinator", 0)) < 5:
		priorities.append("expand booth coverage")
	if int(duty_counts.get("Media Coordinator", 0)) == 0:
		priorities.append("appoint a Media Coordinator")
	if member_count == 0:
		priorities = ["recruit and assign members in this state"]
	return {
		"state": state_name,
		"member_count": member_count,
		"named_member_count": named_member_count,
		"duty_counts": duty_counts,
		"readiness_score": roundi(readiness_score),
		"readiness": readiness,
		"election_score_bonus": readiness_score * 0.025,
		"priorities": priorities
	}

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
	if not _create_career_recovery_point("party presidential election"):
		return "Election cancelled because a safe recovery point could not be created."

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
			if not _create_career_recovery_point("party office election: " + office):
				return "Election cancelled because a safe recovery point could not be created."
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
	# Determine whether the highest vote total is shared.
	var highest_votes := -1
	var tied_ids: Array[String] = []
	for cid in valid_ids:
		var candidate_votes := int(totals.get(cid, 0))
		if candidate_votes > highest_votes:
			highest_votes = candidate_votes
			tied_ids = [cid]
		elif candidate_votes == highest_votes:
			tied_ids.append(cid)

	# A tied election must not appoint the first nominee by default.
	# Keep nominations so the player can hold a runoff election.
	var winner_id := tied_ids[0] if tied_ids.size() == 1 else ""
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
	if winner_id.is_empty():
		winner_name = "TIE — runoff required"
	else:
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
	# Preserve nominees after a tie so the same candidates can contest the runoff.
	if not winner_id.is_empty():
		election["nominations"] = []
	else:
		election["nominations"] = nominations
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
	var recorded_winner := str(latest.get("winner", "Not recorded"))
	if recorded_winner == "TIE — runoff required":
		lines.append("Outcome: TIE — no office-bearer appointed")
		lines.append("Runoff required: hold the election again with the same nominees.")
	else:
		lines.append("Elected: %s" % recorded_winner)
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
	last_local_election_details = {}
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
			"funding_totals": {
				"founder_contribution": contribution,
				"starter_reserve": 25000,
				"member_dues": 0,
				"small_donors": 0,
				"fundraising_events": 0,
				"one_time_grants": 0
			},
			"funding_ledger": [],
			"last_background_report": {},
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
	_ensure_party_map_colors()
	_ensure_high_command_schema()
	_ensure_government_system()
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
			var organizer_name: String = _fictional_name_at(int(experience + local_leader_relationship))
			notifications.append("You attended a party meeting with local organizer %s. Experience +1; your relationship with local leadership improved." % organizer_name)
		"recruit":
			_ensure_state_active_membership(player_party_id)
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
				_add_active_member_to_state(player_party_id, home_state)
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
		if player_role in ["Party President", "Founding President"]:
			notifications.append("As party president, you selected yourself as the party's local candidate. You are approved to contest the scheduled local election.")
		else:
			notifications.append("Your local election ticket was approved by the party leadership. You are now its candidate for the scheduled local election.")
	else:
		ticket_requested = false
		if player_role in ["Party President", "Founding President"]:
			notifications.append("You can select yourself as party president, but you must meet the candidacy requirements first. Improve your experience, reputation, and relationship with local leadership. Requirements: %d experience, %.1f reputation, and %.1f relationship." % [TICKET_XP, TICKET_REPUTATION, TICKET_RELATIONSHIP])
		else:
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
		if str(item.get("status", "")) in ["Pending council review", "Approved — awaiting modeled implementation"]:
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
		if str(item.get("status", "")) in ["Submitted to modeled department", "Submitted to department"]:
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
		if str(proposal.get("status", "")) in ["Pending council review", "Approved — awaiting modeled implementation"]:
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
				proposal["status"] = "Approved — awaiting modeled implementation"
				proposal["approved_index"] = current_index
				notifications.append("Council approved '%s'. modeled public-works officials now schedule implementation; you do not control department operations." % str(proposal.get("title", "proposal")))
			else:
				proposal["status"] = "Returned for revision"
				notifications.append("Council returned '%s' for revision. Improve its public support or revise and resubmit it." % str(proposal.get("title", "proposal")))
		elif status == "Approved — awaiting modeled implementation" and current_index > int(proposal.get("approved_index", current_index)):
			proposal["status"] = "Implemented by %s" % str(proposal.get("department", "the competent department"))
			var project_title := str(proposal.get("title", "proposal"))
			_apply_project_impact(project_title)
			notifications.append("modeled officials completed '%s'. Local infrastructure is now %.1f/100, service quality %.1f/100, and public trust %.1f/100." % [project_title, local_infrastructure, local_service_quality, public_trust])
		office_proposals[i] = proposal

	for i in range(constituency_issues.size()):
		var issue: Dictionary = constituency_issues[i]
		if str(issue.get("status", "")) in ["Submitted to modeled department", "Submitted to department"] and current_index > int(issue.get("submitted_index", current_index)):
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

	# Illustrative in-game funding model. These are fictional simulation values,
	# not claims about real parties or real-world funding rules.
	var monthly_recruits := clampi(roundi(popularity / 15.0), 0, 8)
	var member_dues := members * 5
	var small_donor_contributions := 1000 + members * 8
	var fundraising_events := 1000 + members * 2
	var donations := member_dues + small_donor_contributions + fundraising_events
	var operating_cost := 1000 + members * 10
	members += monthly_recruits

	var funding_totals: Dictionary = party.get("funding_totals", {})
	funding_totals["founder_contribution"] = int(funding_totals.get("founder_contribution", party.get("founder_contribution", 0)))
	funding_totals["starter_reserve"] = int(funding_totals.get("starter_reserve", 25000))
	funding_totals["member_dues"] = int(funding_totals.get("member_dues", 0)) + member_dues
	funding_totals["small_donors"] = int(funding_totals.get("small_donors", 0)) + small_donor_contributions
	funding_totals["fundraising_events"] = int(funding_totals.get("fundraising_events", 0)) + fundraising_events
	var grant_total := 0
	for grant_value in party.get("grant_history", []):
		var grant: Dictionary = grant_value
		grant_total += int(grant.get("amount", 0))
	funding_totals["one_time_grants"] = grant_total
	party["funding_totals"] = funding_totals

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

	# The party organization continues routine work in the background each month.
	# Its budget is limited to available cash and scales gently with membership.
	var background_budget := mini(funds, 500 + members * 2)
	var outreach_spend := int(floor(float(background_budget) * 0.45))
	var volunteer_coordination_spend := int(floor(float(background_budget) * 0.35))
	var recruitment_spend := background_budget - outreach_spend - volunteer_coordination_spend
	funds -= background_budget
	var background_activity_gain := float(outreach_spend) / 50000.0 + float(volunteer_coordination_spend) / 80000.0
	if background_budget > 0:
		popularity = minf(100.0, popularity + minf(0.08, background_activity_gain * 0.01))
	if monthly_recruits > 0:
		popularity = minf(100.0, popularity + float(monthly_recruits) * 0.015)

	var monthly_ledger: Array = party.get("funding_ledger", [])
	monthly_ledger.append({
		"year": year, "month": month,
		"member_dues": member_dues,
		"small_donors": small_donor_contributions,
		"fundraising_events": fundraising_events,
		"operating_cost": operating_cost,
		"outreach_spend": outreach_spend,
		"volunteer_coordination_spend": volunteer_coordination_spend,
		"recruitment_spend": recruitment_spend,
		"recruits": monthly_recruits
	})
	while monthly_ledger.size() > 36:
		monthly_ledger.pop_front()

	party["members"] = members
	party["funds"] = funds
	party["debt"] = debt
	party["popularity"] = popularity
	party["funding_ledger"] = monthly_ledger
	party["last_background_report"] = {
		"recruits": monthly_recruits,
		"outreach_spend": outreach_spend,
		"volunteer_coordination_spend": volunteer_coordination_spend,
		"recruitment_spend": recruitment_spend,
		"popularity_gain": minf(0.08, background_activity_gain * 0.01) if background_budget > 0 else 0.0
	}
	parties[player_party_id] = party
	_ensure_state_active_membership(player_party_id)
	_process_party_state_organization_monthly()
	notifications.append("%s monthly party report: funds received ₹%s — member dues ₹%s, small-donor contributions ₹%s, fundraising events ₹%s. Costs: operations ₹%s; background outreach ₹%s, volunteer coordination ₹%s, recruitment ₹%s. +%d members; closing party cash ₹%s; debt ₹%s." % [
		str(party.get("name", "Your party")),
		_format_number(donations), _format_number(member_dues),
		_format_number(small_donor_contributions), _format_number(fundraising_events),
		_format_number(operating_cost), _format_number(outreach_spend),
		_format_number(volunteer_coordination_spend), _format_number(recruitment_spend),
		monthly_recruits, _format_number(funds), _format_number(debt)
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
	var district_office_monthly_cost := 0
	var funding_detail := "No party funding account is available."
	if player_party_id != "" and parties.has(player_party_id):
		ensure_party_district_offices()
		var party: Dictionary = parties[player_party_id]
		party_cash = int(party.get("funds", 0))
		party_debt = int(party.get("debt", 0))
		party_members = int(party.get("members", 0))
		party_donations = 2000 + party_members * 15
		party_operating_cost = 1000 + party_members * 10
		var network_by_party: Dictionary = world_state.get("party_district_offices", {})
		var offices: Dictionary = network_by_party.get(player_party_id, {})
		for district_name in KARNATAKA_PARTY_OFFICE_DISTRICTS:
			var office: Dictionary = offices.get(district_name, {})
			if bool(office.get("established", false)):
				district_office_monthly_cost += int(office.get("monthly_cost", DISTRICT_OFFICE_MONTHLY_COST))

		var totals: Dictionary = party.get("funding_totals", {})
		var founder_amount := int(totals.get("founder_contribution", party.get("founder_contribution", 0)))
		var starter_reserve := int(totals.get("starter_reserve", 25000))
		var dues_total := int(totals.get("member_dues", 0))
		var donors_total := int(totals.get("small_donors", 0))
		var events_total := int(totals.get("fundraising_events", 0))
		var grants_total := int(totals.get("one_time_grants", 0))
		if grants_total == 0:
			for grant_value in party.get("grant_history", []):
				var grant: Dictionary = grant_value
				grants_total += int(grant.get("amount", 0))
		funding_detail = "FUNDING SOURCES — CUMULATIVE TRACKING\n"
		funding_detail += "Founder contribution (transferred from personal savings): ₹%s\n" % _format_number(founder_amount)
		funding_detail += "Starting treasury reserve (game setup allocation): ₹%s\n" % _format_number(starter_reserve)
		funding_detail += "Member dues / recurring member contributions: ₹%s\n" % _format_number(dues_total)
		funding_detail += "Small-donor contributions: ₹%s\n" % _format_number(donors_total)
		funding_detail += "Fundraising events: ₹%s\n" % _format_number(events_total)
		funding_detail += "Recorded one-time grants: ₹%s\n" % _format_number(grants_total)
		funding_detail += "Monthly sources are fictional game-economy channels, not claims about real-world party funding. Historical totals begin when this ledger feature is active.\n"
		var ledger: Array = party.get("funding_ledger", [])
		funding_detail += "\nLATEST MONTHLY LEDGER\n"
		if ledger.is_empty():
			funding_detail += "No monthly ledger entries yet. Advance one month to record the first breakdown.\n"
		else:
			for index in range(maxi(0, ledger.size() - 6), ledger.size()):
				var entry: Dictionary = ledger[index]
				funding_detail += "%02d/%d — received ₹%s (dues ₹%s, small donors ₹%s, events ₹%s); operating cost ₹%s; background outreach ₹%s; volunteer coordination ₹%s; recruitment ₹%s.\n" % [
					int(entry.get("month", 1)), int(entry.get("year", year)),
					_format_number(int(entry.get("member_dues", 0)) + int(entry.get("small_donors", 0)) + int(entry.get("fundraising_events", 0))),
					_format_number(int(entry.get("member_dues", 0))),
					_format_number(int(entry.get("small_donors", 0))),
					_format_number(int(entry.get("fundraising_events", 0))),
					_format_number(int(entry.get("operating_cost", 0))),
					_format_number(int(entry.get("outreach_spend", 0))),
					_format_number(int(entry.get("volunteer_coordination_spend", 0))),
					_format_number(int(entry.get("recruitment_spend", 0)))
				]
		var background: Dictionary = party.get("last_background_report", {})
		funding_detail += "\nBACKGROUND PARTY ACTIVITY\n"
		funding_detail += "Last month: +%d members; outreach ₹%s; volunteer coordination ₹%s; recruitment ₹%s. Routine party work runs automatically when you advance the month and is paid from party funds.\n" % [
			int(background.get("recruits", 0)),
			_format_number(int(background.get("outreach_spend", 0))),
			_format_number(int(background.get("volunteer_coordination_spend", 0))),
			_format_number(int(background.get("recruitment_spend", 0)))
		]
	var monthly_net := monthly_income - monthly_living_expenses
	return "PERSONAL FINANCES\nCash savings: ₹%s\nMonthly income: ₹%s\nLiving costs: ₹%s\nNet monthly cash flow: ₹%s\nPersonal debt: ₹%s\n\nPARTY FINANCES\nParty cash: ₹%s\nParty debt: ₹%s\nModeled monthly receipts: ₹%s\nModeled operating costs: ₹%s\nDistrict office network: ₹%s / month\n\n%s\nCAMPAIGN ACCOUNTING\nCampaign spending this election: ₹%s / ₹%s\nCampaign actions are paid from party funds; personal and party money stay separate. All funding channels and costs here are simplified fictional game rules, not audited real-world accounts or legal guidance." % [
		_format_number(personal_funds), _format_number(monthly_income),
		_format_number(monthly_living_expenses), _format_number(monthly_net),
		_format_number(personal_debt), _format_number(party_cash), _format_number(party_debt),
		_format_number(party_donations), _format_number(party_operating_cost),
		_format_number(district_office_monthly_cost), funding_detail,
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
		if str(proposal.get("status", "")) in ["Pending council review", "Approved — awaiting modeled implementation"]:
			pending_proposals += 1
	for issue in constituency_issues:
		if str(issue.get("status", "")) in ["Submitted to modeled department", "Submitted to department"]:
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

func ensure_party_district_offices() -> void:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	if _district_offices_ensured_party_id == player_party_id:
		return
	if world_state.is_empty():
		_initialize_world_state()
	var network_by_party: Dictionary = world_state.get("party_district_offices", {})
	var offices: Dictionary = network_by_party.get(player_party_id, {})
	var party: Dictionary = parties[player_party_id]
	var party_members := int(party.get("members", 0))
	var starting_members_per_district := maxi(1, int(floor(float(party_members) / float(KARNATAKA_PARTY_OFFICE_DISTRICTS.size()))))
	var base_support := clampf(float(party.get("popularity", 10.0)), 0.0, 100.0)
	for district_name in KARNATAKA_PARTY_OFFICE_DISTRICTS:
		if offices.has(district_name):
			continue
		offices[district_name] = {
			"state": "Karnataka",
			"district": district_name,
			"established": true,
			"office_bearer": "District office team",
			"members": starting_members_per_district,
			"active_workers": maxi(1, int(floor(float(starting_members_per_district) * 0.2))),
			"local_support": base_support,
			"organization_strength": 10.0,
			"monthly_cost": DISTRICT_OFFICE_MONTHLY_COST,
			"outreach_events": 0,
			"recruitment_drives": 0,
			"completed_activities": 0,
			"last_monthly_report": "District party office established.",
			"activity_log": []
		}
	network_by_party[player_party_id] = offices
	world_state["party_district_offices"] = network_by_party
	_district_offices_ensured_party_id = player_party_id

func get_party_district_office(district_name: String) -> Dictionary:
	ensure_party_district_offices()
	var network_by_party: Dictionary = world_state.get("party_district_offices", {})
	var offices: Dictionary = network_by_party.get(player_party_id, {})
	var office: Dictionary = offices.get(district_name, {})
	return office.duplicate(true)

func party_district_office_report(district_name: String) -> String:
	var office := get_party_district_office(district_name)
	if office.is_empty():
		return "No party office record is available for this district."
	var log_lines: Array[String] = []
	var activity_log: Array = office.get("activity_log", [])
	for i in range(maxi(0, activity_log.size() - 4), activity_log.size()):
		log_lines.append("• " + str(activity_log[i]))
	var recent_text := "\n".join(log_lines) if not log_lines.is_empty() else "No recorded office activities yet."
	return "%s DISTRICT PARTY OFFICE\nStatus: %s\nOffice team: %s\nParty members: %d\nActive workers: %d\nLocal support: %.1f / 100\nOrganization strength: %.1f / 100\nOutreach events: %d\nRecruitment drives: %d\nCompleted activities: %d\nMonthly operating cost: ₹%s\n\nRECENT ACTIVITY\n%s" % [
		district_name.to_upper(),
		"Established" if bool(office.get("established", false)) else "Not established",
		str(office.get("office_bearer", "District office team")),
		int(office.get("members", 0)),
		int(office.get("active_workers", 0)),
		float(office.get("local_support", 0.0)),
		float(office.get("organization_strength", 0.0)),
		int(office.get("outreach_events", 0)),
		int(office.get("recruitment_drives", 0)),
		int(office.get("completed_activities", 0)),
		_format_number(int(office.get("monthly_cost", DISTRICT_OFFICE_MONTHLY_COST))),
		recent_text
	]

func party_district_offices_statewide_report() -> String:
	ensure_party_district_offices()
	var network_by_party: Dictionary = world_state.get("party_district_offices", {})
	var offices: Dictionary = network_by_party.get(player_party_id, {})
	var total_members := 0
	var total_workers := 0
	var total_cost := 0
	var average_support := 0.0
	var average_strength := 0.0
	var active_count := 0
	for district_name in KARNATAKA_PARTY_OFFICE_DISTRICTS:
		var office: Dictionary = offices.get(district_name, {})
		if office.is_empty():
			continue
		active_count += 1 if bool(office.get("established", false)) else 0
		total_members += int(office.get("members", 0))
		total_workers += int(office.get("active_workers", 0))
		total_cost += int(office.get("monthly_cost", DISTRICT_OFFICE_MONTHLY_COST))
		average_support += float(office.get("local_support", 0.0))
		average_strength += float(office.get("organization_strength", 0.0))
	if active_count > 0:
		average_support /= float(active_count)
		average_strength /= float(active_count)
	return "KARNATAKA STATEWIDE OFFICE NETWORK\nDistrict offices: %d / %d established\nParty members across offices: %d\nActive workers: %d\nAverage local support: %.1f / 100\nAverage organization strength: %.1f / 100\nCombined modeled monthly operating cost: ₹%s" % [
		active_count, KARNATAKA_PARTY_OFFICE_DISTRICTS.size(), total_members, total_workers,
		average_support, average_strength, _format_number(total_cost)
	]

func run_party_district_office_action(district_name: String, action: String) -> String:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return "Start or join a party before managing district offices."
	ensure_party_district_offices()
	var network_by_party: Dictionary = world_state.get("party_district_offices", {})
	var offices: Dictionary = network_by_party.get(player_party_id, {})
	if not offices.has(district_name):
		return "Choose a valid Karnataka district."
	var party: Dictionary = parties[player_party_id]
	var office: Dictionary = offices[district_name]
	var cost := 0
	var result := ""
	match action:
		"outreach":
			cost = 50000
			if int(party.get("funds", 0)) < cost:
				return "Insufficient party funds. District outreach costs ₹50,000."
			office["outreach_events"] = int(office.get("outreach_events", 0)) + 1
			office["completed_activities"] = int(office.get("completed_activities", 0)) + 1
			office["local_support"] = minf(100.0, float(office.get("local_support", 0.0)) + 1.2)
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 0.6)
			result = "Public outreach completed in %s. Local support and organization strength increased." % district_name
		"recruit":
			cost = 25000
			if int(party.get("funds", 0)) < cost:
				return "Insufficient party funds. A recruitment drive costs ₹25,000."
			office["recruitment_drives"] = int(office.get("recruitment_drives", 0)) + 1
			office["completed_activities"] = int(office.get("completed_activities", 0)) + 1
			office["members"] = int(office.get("members", 0)) + 5
			office["active_workers"] = int(office.get("active_workers", 0)) + 2
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 1.0)
			party["members"] = int(party.get("members", 0)) + 5
			result = "Recruitment drive completed in %s. Five members and two active workers joined." % district_name
		_:
			return "Choose a supported district-office action."
	party["funds"] = int(party.get("funds", 0)) - cost
	parties[player_party_id] = party
	var activity_log: Array = office.get("activity_log", [])
	activity_log.append("%s — %s (₹%s)" % [date_label(), result, _format_number(cost)])
	while activity_log.size() > 12:
		activity_log.pop_front()
	office["activity_log"] = activity_log
	office["last_monthly_report"] = result
	offices[district_name] = office
	network_by_party[player_party_id] = offices
	world_state["party_district_offices"] = network_by_party
	return result

func _process_party_district_offices_monthly() -> void:
	ensure_party_district_offices()
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	var network_by_party: Dictionary = world_state.get("party_district_offices", {})
	var offices: Dictionary = network_by_party.get(player_party_id, {})
	var total_cost := 0
	for district_name in KARNATAKA_PARTY_OFFICE_DISTRICTS:
		var office: Dictionary = offices.get(district_name, {})
		if office.is_empty() or not bool(office.get("established", false)):
			continue
		total_cost += int(office.get("monthly_cost", DISTRICT_OFFICE_MONTHLY_COST))
	var party: Dictionary = parties[player_party_id]
	var available_funds := int(party.get("funds", 0))
	var paid_cost := mini(available_funds, total_cost)
	party["funds"] = available_funds - paid_cost
	parties[player_party_id] = party
	var funded_ratio := float(paid_cost) / float(total_cost) if total_cost > 0 else 1.0
	for district_name in KARNATAKA_PARTY_OFFICE_DISTRICTS:
		var office: Dictionary = offices.get(district_name, {})
		if office.is_empty() or not bool(office.get("established", false)):
			continue
		if funded_ratio >= 0.999:
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 0.08)
			office["local_support"] = minf(100.0, float(office.get("local_support", 0.0)) + 0.03)
			office["last_monthly_report"] = "Office funded; routine organization and local outreach continued."
		else:
			office["organization_strength"] = maxf(0.0, float(office.get("organization_strength", 0.0)) - 0.2)
			office["last_monthly_report"] = "Party funds covered only part of district office operating costs; local activity slowed."
		offices[district_name] = office
	network_by_party[player_party_id] = offices
	world_state["party_district_offices"] = network_by_party

func assembly_office_states() -> Array[String]:
	_load_assembly_records()
	var states: Array[String] = []
	for row in _assembly_records:
		if row is Dictionary:
			var state_name := str(row.get("state", ""))
			if not state_name.is_empty() and state_name != "Karnataka" and not states.has(state_name):
				states.append(state_name)
	states.sort()
	return states

func assembly_office_constituencies(state_name: String) -> Array[Dictionary]:
	_load_assembly_records()
	var result: Array[Dictionary] = []
	for row in _assembly_records:
		if row is Dictionary and str(row.get("state", "")) == state_name and state_name != "Karnataka":
			result.append(row.duplicate(true))
	return result

func _assembly_office_key(state_name: String, seat_number: int) -> String:
	return "%s::%03d" % [state_name, seat_number]

func ensure_party_assembly_constituency_offices() -> void:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	if _assembly_offices_ensured_party_id == player_party_id:
		return
	if world_state.is_empty():
		_initialize_world_state()
	var by_party: Dictionary = world_state.get("party_assembly_constituency_offices", {})
	var offices: Dictionary = by_party.get(player_party_id, {})
	var party: Dictionary = parties[player_party_id]
	var rows := assembly_office_states()
	var seat_total := 0
	for state_name in rows:
		seat_total += assembly_office_constituencies(state_name).size()
	var initial_members := maxi(0, int(floor(float(party.get("members", 0)) / float(maxi(1, seat_total)))))
	var base_support := clampf(float(party.get("popularity", 10.0)), 0.0, 100.0)
	for state_name in rows:
		for row in assembly_office_constituencies(state_name):
			var seat_number := int(row.get("number", 0))
			var key := _assembly_office_key(state_name, seat_number)
			if offices.has(key):
				continue
			var constituency_name := str(row.get("name", "%s Assembly Constituency %03d" % [state_name, seat_number]))
			offices[key] = {
				"state": state_name, "constituency": constituency_name, "seat_number": seat_number,
				"record_status": str(row.get("record_status", "fictional_placeholder")),
				"established": true, "office_bearer": "Constituency office team",
				"members": initial_members, "active_workers": maxi(0, int(floor(float(initial_members) * 0.2))),
				"local_support": base_support, "organization_strength": 10.0,
				"monthly_cost": ASSEMBLY_CONSTITUENCY_OFFICE_MONTHLY_COST,
				"outreach_events": 0, "recruitment_drives": 0, "completed_activities": 0,
				"last_monthly_report": "Constituency party office established.", "activity_log": []
			}
	by_party[player_party_id] = offices
	world_state["party_assembly_constituency_offices"] = by_party
	_assembly_offices_ensured_party_id = player_party_id

func assembly_constituency_office_report(state_name: String, seat_number: int) -> String:
	ensure_party_assembly_constituency_offices()
	var by_party: Dictionary = world_state.get("party_assembly_constituency_offices", {})
	var offices: Dictionary = by_party.get(player_party_id, {})
	var key := _assembly_office_key(state_name, seat_number)
	var office: Dictionary = offices.get(key, {})
	if office.is_empty():
		return "No Assembly constituency office record found."
	var log_lines: Array[String] = []
	var log: Array = office.get("activity_log", [])
	for i in range(maxi(0, log.size() - 4), log.size()):
		log_lines.append("• " + str(log[i]))
	var status_note := "Verified constituency name" if str(office.get("record_status", "")) == "verified" else "Fictional placeholder name — not an official constituency name"
	return "%s, %s PARTY OFFICE\nStatus: %s\nName record: %s\nOffice team: %s\nParty members: %d\nActive workers: %d\nLocal support: %.1f / 100\nOrganization strength: %.1f / 100\nOutreach events: %d\nRecruitment drives: %d\nCompleted activities: %d\nMonthly operating cost: ₹%s\nLast report: %s\n\nRECENT ACTIVITY\n%s" % [
		str(office.get("constituency", "Assembly Constituency")), state_name,
		"Established" if bool(office.get("established", false)) else "Not established", status_note,
		str(office.get("office_bearer", "Constituency office team")), int(office.get("members", 0)),
		int(office.get("active_workers", 0)), float(office.get("local_support", 0.0)),
		float(office.get("organization_strength", 0.0)), int(office.get("outreach_events", 0)),
		int(office.get("recruitment_drives", 0)), int(office.get("completed_activities", 0)),
		_format_number(int(office.get("monthly_cost", ASSEMBLY_CONSTITUENCY_OFFICE_MONTHLY_COST))),
		str(office.get("last_monthly_report", "No monthly report yet.")), "\n".join(log_lines) if not log_lines.is_empty() else "No recorded office activities yet."
	]

func assembly_constituency_offices_state_report(state_name: String) -> String:
	ensure_party_assembly_constituency_offices()
	var by_party: Dictionary = world_state.get("party_assembly_constituency_offices", {})
	var offices: Dictionary = by_party.get(player_party_id, {})
	var total := 0
	var members := 0
	var workers := 0
	var cost := 0
	var support := 0.0
	var strength := 0.0
	var placeholders := 0
	for row in assembly_office_constituencies(state_name):
		var key := _assembly_office_key(state_name, int(row.get("number", 0)))
		var office: Dictionary = offices.get(key, {})
		if office.is_empty():
			continue
		total += 1
		members += int(office.get("members", 0))
		workers += int(office.get("active_workers", 0))
		cost += int(office.get("monthly_cost", ASSEMBLY_CONSTITUENCY_OFFICE_MONTHLY_COST))
		support += float(office.get("local_support", 0.0))
		strength += float(office.get("organization_strength", 0.0))
		if str(office.get("record_status", "")) != "verified":
			placeholders += 1
	if total > 0:
		support /= float(total)
		strength /= float(total)
	return "%s ASSEMBLY CONSTITUENCY OFFICE NETWORK\nOffices established: %d / %d\nParty members: %d\nActive workers: %d\nAverage local support: %.1f / 100\nAverage organization strength: %.1f / 100\nModeled monthly cost: ₹%s\nFictional placeholder names: %d (clearly marked; not official names)" % [state_name.to_upper(), total, assembly_office_constituencies(state_name).size(), members, workers, support, strength, _format_number(cost), placeholders]

func run_assembly_constituency_office_action(state_name: String, seat_number: int, action: String) -> String:
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return "Start or join a party before managing constituency offices."
	ensure_party_assembly_constituency_offices()
	var by_party: Dictionary = world_state.get("party_assembly_constituency_offices", {})
	var offices: Dictionary = by_party.get(player_party_id, {})
	var key := _assembly_office_key(state_name, seat_number)
	if not offices.has(key):
		return "Choose a valid non-Karnataka Assembly constituency."
	var party: Dictionary = parties[player_party_id]
	var office: Dictionary = offices[key]
	var cost := 0
	var result := ""
	match action:
		"outreach":
			cost = 50000
			if int(party.get("funds", 0)) < cost:
				return "Insufficient party funds. Constituency outreach costs ₹50,000."
			office["outreach_events"] = int(office.get("outreach_events", 0)) + 1
			office["completed_activities"] = int(office.get("completed_activities", 0)) + 1
			office["local_support"] = minf(100.0, float(office.get("local_support", 0.0)) + 1.2)
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 0.6)
			result = "Public outreach completed in %s, %s." % [str(office.get("constituency", "Assembly constituency")), state_name]
		"recruit":
			cost = 25000
			if int(party.get("funds", 0)) < cost:
				return "Insufficient party funds. A recruitment drive costs ₹25,000."
			office["recruitment_drives"] = int(office.get("recruitment_drives", 0)) + 1
			office["completed_activities"] = int(office.get("completed_activities", 0)) + 1
			office["members"] = int(office.get("members", 0)) + 5
			office["active_workers"] = int(office.get("active_workers", 0)) + 2
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 1.0)
			party["members"] = int(party.get("members", 0)) + 5
			result = "Five members and two active workers joined the %s constituency office." % str(office.get("constituency", "Assembly constituency"))
		_:
			return "Choose a supported constituency-office action."
	party["funds"] = int(party.get("funds", 0)) - cost
	parties[player_party_id] = party
	var log: Array = office.get("activity_log", [])
	log.append("%s — %s (₹%s)" % [date_label(), result, _format_number(cost)])
	while log.size() > 12:
		log.pop_front()
	office["activity_log"] = log
	office["last_monthly_report"] = result
	offices[key] = office
	by_party[player_party_id] = offices
	world_state["party_assembly_constituency_offices"] = by_party
	return result

func _process_party_assembly_constituency_offices_monthly() -> void:
	ensure_party_assembly_constituency_offices()
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return
	var by_party: Dictionary = world_state.get("party_assembly_constituency_offices", {})
	var offices: Dictionary = by_party.get(player_party_id, {})
	var total_cost := 0
	for key in offices:
		var office: Dictionary = offices[key]
		if bool(office.get("established", false)):
			total_cost += int(office.get("monthly_cost", ASSEMBLY_CONSTITUENCY_OFFICE_MONTHLY_COST))
	var party: Dictionary = parties[player_party_id]
	var paid := mini(int(party.get("funds", 0)), total_cost)
	party["funds"] = int(party.get("funds", 0)) - paid
	parties[player_party_id] = party
	var ratio := float(paid) / float(total_cost) if total_cost > 0 else 1.0
	for key in offices:
		var office: Dictionary = offices[key]
		if not bool(office.get("established", false)):
			continue
		if ratio >= 0.999:
			office["organization_strength"] = minf(100.0, float(office.get("organization_strength", 0.0)) + 0.04)
			office["local_support"] = minf(100.0, float(office.get("local_support", 0.0)) + 0.02)
			office["last_monthly_report"] = "Constituency office operating costs fully funded."
		else:
			office["organization_strength"] = maxf(0.0, float(office.get("organization_strength", 0.0)) - 0.2)
			office["last_monthly_report"] = "Party funds covered only part of the constituency office network costs."
		offices[key] = office
	by_party[player_party_id] = offices
	world_state["party_assembly_constituency_offices"] = by_party

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


func start_karnataka_auto_campaign() -> String:
	var plans: Dictionary = world_state.get("constituency_campaign_plans", {})
	if plans.size() < 224:
		return "Create plans for all 224 Karnataka constituencies before launching the statewide campaign."
	var campaign: Dictionary = world_state.get("karnataka_auto_campaign", {})
	if bool(campaign.get("active", false)):
		return "The Karnataka statewide campaign is already running."
	campaign = {
		"active": true,
		"started_month_index": year * 12 + month,
		"months_run": 0,
		"activities_completed": 0,
		"spend_crore": 0.0,
		"covered_seats": [],
		"log": ["Campaign launched in %s. Automatic constituency operations are now active." % date_label()]
	}
	world_state["karnataka_auto_campaign"] = campaign
	return "Statewide campaign launched. Constituency teams will begin automatic operations at the next monthly transition."


func stop_karnataka_auto_campaign() -> String:
	var campaign: Dictionary = world_state.get("karnataka_auto_campaign", {})
	if not bool(campaign.get("active", false)):
		return "The statewide campaign is not currently running."
	campaign["active"] = false
	var log: Array = campaign.get("log", [])
	log.append("Campaign paused in %s." % date_label())
	campaign["log"] = log
	world_state["karnataka_auto_campaign"] = campaign
	return "Statewide campaign paused. Recorded progress and spending have been preserved."


func _karnataka_campaign_timing() -> Dictionary:
	var months_remaining := 999
	for election_value in world_state.get("state_elections", []):
		if not election_value is Dictionary:
			continue
		if str(election_value.get("state", "")) != "Karnataka":
			continue
		months_remaining = _months_until_election(election_value)
		break
	var phase := "Long-term groundwork"
	var multiplier := 0.25
	if months_remaining <= 2:
		phase = "Final election push"
		multiplier = 1.0
	elif months_remaining <= 6:
		phase = "Election build-up"
		multiplier = 0.5
	return {
		"months_remaining": months_remaining,
		"phase": phase,
		"intensity": multiplier
	}


func karnataka_auto_campaign_summary() -> String:
	var campaign: Dictionary = world_state.get("karnataka_auto_campaign", {})
	var status := "RUNNING" if bool(campaign.get("active", false)) else ("PAUSED" if not campaign.is_empty() else "NOT STARTED")
	var covered: Array = campaign.get("covered_seats", [])
	var log: Array = campaign.get("log", [])
	var timing := _karnataka_campaign_timing()
	var remaining := int(timing.get("months_remaining", 999))
	var election_text := "Election date not available" if remaining == 999 else ("%d months to polling" % maxi(0, remaining))
	var plans: Dictionary = world_state.get("constituency_campaign_plans", {})
	var election_spend: Dictionary = {}
	var regional: Dictionary = world_state.get("regional_support", {}).get(player_party_id, {})
	var karnataka_support := float(regional.get("Karnataka", parties.get(player_party_id, {}).get("popularity", 0.0)))
	for election_variant in world_state.get("state_elections", []):
		if election_variant is Dictionary and str(election_variant.get("state", "")) == "Karnataka":
			election_spend = election_variant.get("campaign_spend_by_constituency", {})
			break
	var strong := 0
	var competitive := 0
	var needs_work := 0
	var ranked: Array[Dictionary] = []
	for seat_key_variant in plans.keys():
		var seat_key := str(seat_key_variant)
		var plan: Dictionary = plans.get(seat_key, {})
		var spent := int(election_spend.get(seat_key, 0))
		# Transparent planning indicator only; it is not a poll forecast or guaranteed result.
		var score := clampf(karnataka_support + minf(4.0, float(spent) / 2500000.0), 0.0, 100.0)
		if score >= 65.0:
			strong += 1
		elif score >= 45.0:
			competitive += 1
		else:
			needs_work += 1
		ranked.append({"key": seat_key, "name": _constituency_name_for_seat("Karnataka", int(seat_key)), "score": score, "priority": str(plan.get("priority", "Target"))})
	ranked.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a.get("score", 0.0)) < float(b.get("score", 0.0)))
	var attention_lines := ""
	for i in range(mini(5, ranked.size())):
		var row: Dictionary = ranked[i]
		attention_lines += "\n• %s — readiness %d/100 · %s" % [str(row.get("name", "Constituency " + str(row.get("key", "")))), roundi(float(row.get("score", 0.0))), str(row.get("priority", "Target"))]
	var recent := ""
	for i in range(maxi(0, log.size() - 5), log.size()):
		recent += "\n• " + str(log[i])
	return "CAMPAIGN STATUS: %s\nCampaign phase: %s\n%s\nMonthly intensity: %d%%\nConstituencies reached: %d / 224\nMonths executed: %d\nActivities completed: %d\nRecorded campaign spending: ₹%.1f crore\n\n224-SEAT READINESS INDICATOR\nStrong: %d · Competitive: %d · Needs work: %d\nLowest readiness seats (planning indicator, not a poll forecast):%s\n\n%s" % [
		status, str(timing.get("phase", "Long-term groundwork")), election_text,
		roundi(float(timing.get("intensity", 0.25)) * 100.0), covered.size(),
		int(campaign.get("months_run", 0)), int(campaign.get("activities_completed", 0)),
		float(campaign.get("spend_crore", 0.0)), strong, competitive, needs_work,
		attention_lines if not attention_lines.is_empty() else "\nNo constituency plans yet.",
		"RECENT OPERATIONS" + recent if not recent.is_empty() else "No campaign operations recorded yet."
	]


func _process_karnataka_auto_campaign_monthly() -> void:
	var campaign: Dictionary = world_state.get("karnataka_auto_campaign", {})
	if not bool(campaign.get("active", false)):
		return
	var plans: Dictionary = world_state.get("constituency_campaign_plans", {})
	if plans.is_empty():
		return
	var party: Dictionary = parties.get(player_party_id, {})
	if party.is_empty():
		return
	var command: Dictionary = world_state.get("high_command", {})
	var ceiling := _high_command_remaining_budget()
	var available := maxi(0, int(party.get("funds", 0)))
	var timing := _karnataka_campaign_timing()
	var intensity := float(timing.get("intensity", 0.25))
	var phase_name := str(timing.get("phase", "Long-term groundwork"))
	# Campaigns may run at any time; intensity scales spending as polling approaches.
	var phase_ceiling := roundi(float(ceiling) * intensity)
	# The High Command ceiling limits total campaign activity. Party funds cover 75%;
	# the pooled member-contribution ledger covers the remaining 25%.
	var spend := mini(phase_ceiling, floori(float(available) / 0.75))
	if spend <= 0:
		var no_funds_log: Array = campaign.get("log", [])
		no_funds_log.append("%s: Campaign teams stood down because no monthly campaign budget or party funds were available." % date_label())
		campaign["log"] = no_funds_log
		world_state["karnataka_auto_campaign"] = campaign
		return
	var covered: Array = campaign.get("covered_seats", [])
	var spend_by_seat: Dictionary = {}
	var existing_seat_spend: Dictionary = {}
	for election_variant in world_state.get("state_elections", []):
		if election_variant is Dictionary and str(election_variant.get("state", "")) == "Karnataka":
			existing_seat_spend = election_variant.get("campaign_spend_by_constituency", {})
			break
	var remaining_spend := spend
	var seat_keys: Array = plans.keys()
	seat_keys.sort()
	for key_variant in seat_keys:
		if remaining_spend <= 0:
			break
		var key := str(key_variant)
		var plan: Dictionary = plans.get(key, {})
		var allocation := maxi(0, roundi(float(plan.get("allocation_crore", 0.0)) * 10000000.0))
		var remaining_allocation := maxi(0, allocation - int(existing_seat_spend.get(key, 0)))
		if remaining_allocation <= 0:
			continue
		var priority := str(plan.get("priority", "Target"))
		var weight := 1.25 if priority == "Defend" else (0.5 if priority == "Low Priority" else 1.0)
		var seat_spend := mini(remaining_spend, maxi(1, roundi(float(spend) / float(maxi(1, plans.size())) * weight)))
		seat_spend = mini(seat_spend, remaining_allocation)
		if seat_spend <= 0:
			continue
		spend_by_seat[key] = seat_spend
		remaining_spend -= seat_spend
		if not covered.has(int(key)):
			covered.append(int(key))
	# Only charge what was assigned to actual constituency operations.
	var actual_spend := 0
	for value in spend_by_seat.values():
		actual_spend += int(value)
	if actual_spend > 0:
		var party_share := floori(float(actual_spend) * 0.75)
		var member_share := actual_spend - party_share
		party["funds"] = maxi(0, available - party_share)
		parties[player_party_id] = party
		campaign["party_funding_rupees"] = int(campaign.get("party_funding_rupees", 0)) + party_share
		campaign["member_contribution_pool_rupees"] = int(campaign.get("member_contribution_pool_rupees", 0)) + member_share
		campaign["funding_split_note"] = "75% party funds / 25% pooled member contributions"
		_record_high_command_campaign_spend(actual_spend)
		var elections: Array = world_state.get("state_elections", [])
		for i in range(elections.size()):
			if elections[i] is Dictionary and str(elections[i].get("state", "")) == "Karnataka":
				var election: Dictionary = elections[i]
				var seat_spending: Dictionary = election.get("campaign_spend_by_constituency", {})
				for seat_key in spend_by_seat:
					seat_spending[seat_key] = int(seat_spending.get(seat_key, 0)) + int(spend_by_seat[seat_key])
				election["campaign_spend_by_constituency"] = seat_spending
				elections[i] = election
				break
		world_state["state_elections"] = elections
	campaign["months_run"] = int(campaign.get("months_run", 0)) + 1
	campaign["activities_completed"] = int(campaign.get("activities_completed", 0)) + spend_by_seat.size()
	campaign["spend_crore"] = float(campaign.get("spend_crore", 0.0)) + float(actual_spend) / 10000000.0
	campaign["covered_seats"] = covered
	var log: Array = campaign.get("log", [])
	log.append("%s · %s: %d constituency operations; ₹%.2f crore spent (party ₹%.2f cr / member pool ₹%.2f cr; 75/25 split; %.0f%% intensity)." % [date_label(), phase_name, spend_by_seat.size(), float(actual_spend) / 10000000.0, float(floori(float(actual_spend) * 0.75)) / 10000000.0, float(actual_spend - floori(float(actual_spend) * 0.75)) / 10000000.0, intensity * 100.0])
	while log.size() > 30:
		log.pop_front()
	campaign["log"] = log
	world_state["karnataka_auto_campaign"] = campaign
	notifications.append("Karnataka campaign update: %d constituency operations completed; ₹%.2f crore recorded." % [spend_by_seat.size(), float(actual_spend) / 10000000.0])


func advance_month() -> Array[String]:
	notifications.clear()
	if career_started and not _create_career_recovery_point("monthly career transition"):
		notifications.append("Month not advanced: a verified recovery point could not be created. Please save space and try again.")
		return notifications.duplicate()
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
		_process_karnataka_auto_campaign_monthly()
		_process_party_district_offices_monthly()
		_process_party_assembly_constituency_offices_monthly()
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
	rival_candidate_name = _fictional_name_at(local_election_year + month)
	var local_candidate_rows: Array[Dictionary] = []
	var local_player_stood := local_candidate_selected and ticket_approved
	var local_player_candidate_name := character_name.strip_edges() if local_player_stood else ""
	var local_player_votes := 0
	var local_party_candidate_name := ""
	var local_party_candidate_votes := 0
	var local_rival_votes := 0

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
		local_player_votes = candidate_votes
		local_rival_votes = rival_votes
		local_candidate_rows = [
			{"member_id": "player_character", "candidate_name": character_name.strip_edges(), "party_id": player_party_id, "votes": candidate_votes, "vote_percent": float(candidate_votes) * 100.0 / float(maxi(1, election_turnout))},
			{"member_id": "", "candidate_name": rival_candidate_name, "party_id": "opposition", "votes": rival_votes, "vote_percent": float(rival_votes) * 100.0 / float(maxi(1, election_turnout))}
		]

		if candidate_votes > rival_votes:
			has_elected_office = true
			generate_monthly_office_missions()
			elected_office_name = "Local elected representative — %s" % home_city
			player_role = elected_office_name
			career_rank = elected_office_name
			register_authority_position(
				"local_representative",
				elected_office_name,
				"player",
				home_city,
				[
					"representative.submit_representation",
					"representative.request_report",
					"representative.raise_constituency_issue"
				],
				"local_election"
			)
			local_election_result = "WON"
			notifications.append(
				 "ELECTION RESULT — WON in %s. You received %s of %s votes (%.1f%%) with %d%% turnout. You are now a Local elected representative. Your authority is limited to this elected office." % [
					local_election_area(), _format_number(candidate_votes), _format_number(election_turnout),
					election_vote_share, roundi(float(election_turnout) / 100.0)
				]
			)
		else:
			local_election_result = "LOST"
			revoke_authority_position("local_representative", "Lost local election")
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
		local_party_candidate_name = _fictional_name_at(local_election_year + month + 2)
		local_party_candidate_votes = party_votes
		local_rival_votes = rival_votes
		local_candidate_rows = [
			{"member_id": "", "candidate_name": local_party_candidate_name, "party_id": player_party_id, "votes": party_votes, "vote_percent": float(party_votes) * 100.0 / float(maxi(1, election_turnout))},
			{"member_id": "", "candidate_name": rival_candidate_name, "party_id": "opposition", "votes": rival_votes, "vote_percent": float(rival_votes) * 100.0 / float(maxi(1, election_turnout))}
		]
		if party_votes > rival_votes:
			local_election_result = "modeled PARTY WON"
			party["popularity"] = minf(100.0, party_popularity + 0.6)
			party["members"] = party_members + maxi(1, roundi(float(party_members) * 0.002))
			notifications.append("modeled CAMPsimulationGN RESULT — Your party's candidate won in %s with %.1f%% of votes. Campaign spending: ₹%s. You did not stand, so you do not receive the elected office." % [local_election_area(), election_vote_share, _format_number(campaign_spend)])
		else:
			local_election_result = "modeled PARTY LOST"
			party["popularity"] = maxf(0.5, party_popularity - 0.4)
			notifications.append("modeled CAMPsimulationGN RESULT — Your party contested in %s but lost with %.1f%% of votes. Campaign spending: ₹%s. leadership will review the result." % [local_election_area(), election_vote_share, _format_number(campaign_spend)])
		parties[player_party_id] = party

	last_local_election_result = local_election_result
	var local_turnout_percent := float(election_turnout) / 100.0
	last_local_election_details = {
		"year": last_local_election_year,
		"month": month,
		"jurisdiction": local_election_area(),
		"player_stood": local_player_stood,
		"player_candidate_name": local_player_candidate_name,
		"player_votes": local_player_votes,
		"player_vote_share": election_vote_share if local_player_stood else 0.0,
		"party_candidate_name": local_party_candidate_name,
		"party_candidate_votes": local_party_candidate_votes,
		"rival_candidate_name": rival_candidate_name,
		"rival_votes": local_rival_votes,
		"candidate_rows": local_candidate_rows,
		"ballots_cast": election_turnout,
		"turnout_percent": local_turnout_percent,
		"eligible_voters": roundi(float(election_turnout) * 100.0 / maxf(1.0, local_turnout_percent))
	}
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
			return "modeled prepared Karnataka slate approved. Your party's planned campaign can now spend within the set budget."
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
		elif last_local_election_result == "modeled PARTY WON" or last_local_election_result == "modeled PARTY LOST":
			lines.append("Previous result (%d): Your party's party candidate %s — %.1f%% of votes. You did not stand." % [last_local_election_year, "won" if last_local_election_result == "modeled PARTY WON" else "lost", last_election_vote_share])
		else:
			lines.append("Previous result (%d): You were not an approved candidate." % last_local_election_year)
	if has_elected_office:
		lines.append("Current mandate: %s, through the next scheduled local election." % elected_office_name)
	return "\n".join(lines)

func apply_player_party_fund_grant_once() -> bool:
	# One-time career grant. Stored on the party record so it survives save/load
	# and cannot be applied again by repeated UI refreshes.
	if player_party_id.is_empty() or not parties.has(player_party_id):
		return false
	var party: Dictionary = parties[player_party_id]
	if bool(party.get("player_500_crore_grant_applied", false)):
		return false
	party["funds"] = int(party.get("funds", 0)) + 5000000000
	party["player_500_crore_grant_applied"] = true
	party["grant_history"] = party.get("grant_history", [])
	var history: Array = party["grant_history"]
	history.append({"type": "founder_support_grant", "amount": 5000000000, "year": year, "month": month})
	party["grant_history"] = history
	var funding_totals: Dictionary = party.get("funding_totals", {})
	funding_totals["one_time_grants"] = int(funding_totals.get("one_time_grants", 0)) + 5000000000
	party["funding_totals"] = funding_totals
	parties[player_party_id] = party
	notifications.append("₹500 crore one-time grant credited to your party treasury.")
	return true


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
const SAVE_BACKUP_PATH := "user://political_world_save.json.bak"
const SAVE_TEMP_PATH := "user://political_world_save.json.tmp"
const SAVE_DAMAGED_PATH := "user://political_world_save.json.damaged"
const SAVE_PREVIOUS_PATH := "user://political_world_save.json.previous"
const SAVE_CHECKPOINT_PATH := "user://political_world_save.json.checkpoint"
const SAVE_CHECKPOINT_PREVIOUS_PATH := "user://political_world_save.json.checkpoint.previous"

func _is_valid_save_file(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return false
	var text := file.get_as_text()
	file.close()
	if text.is_empty():
		return false
	var parser := JSON.new()
	if parser.parse(text) != OK:
		return false
	var data: Variant = parser.data
	if typeof(data) != TYPE_DICTIONARY or not bool(data.get("career_started", false)):
		return false
	# Reject parseable but structurally broken saves before they can replace a
	# known-good career. Older saves may omit these fields, so defaults remain
	# supported; when present, the calendar values must be numeric and sensible.
	if data.has("year"):
		var saved_year: Variant = data.get("year")
		if typeof(saved_year) not in [TYPE_INT, TYPE_FLOAT] or int(saved_year) < 1:
			return false
	if data.has("month"):
		var saved_month: Variant = data.get("month")
		if typeof(saved_month) not in [TYPE_INT, TYPE_FLOAT] or int(saved_month) < 1 or int(saved_month) > 12:
			return false
	if data.has("character_name") and typeof(data.get("character_name")) != TYPE_STRING:
		return false
	return true

func _create_career_recovery_point(reason: String) -> bool:
	# Persist the exact pre-transition state first; only checkpoint a validated save.
	if not career_started or not save_game():
		push_warning("Could not create recovery point before: " + reason)
		return false
	var source_path := ProjectSettings.globalize_path(SAVE_PATH)
	var checkpoint_path := ProjectSettings.globalize_path(SAVE_CHECKPOINT_PATH)
	var previous_path := ProjectSettings.globalize_path(SAVE_CHECKPOINT_PREVIOUS_PATH)
	if not _is_valid_save_file(SAVE_PATH):
		return false
	if FileAccess.file_exists(SAVE_CHECKPOINT_PATH):
		DirAccess.copy_absolute(checkpoint_path, previous_path)
	var copy_error := DirAccess.copy_absolute(source_path, checkpoint_path)
	if copy_error != OK or not _is_valid_save_file(SAVE_CHECKPOINT_PATH):
		push_warning("Recovery point could not be verified before: " + reason)
		return false
	return true

func save_game() -> bool:
	var save_data: Dictionary = {
		"save_version": 14,
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
		"last_local_election_details": last_local_election_details,
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
	var serialized := JSON.stringify(save_data)
	var temp_file := FileAccess.open(SAVE_TEMP_PATH, FileAccess.WRITE)
	if temp_file == null:
		return false
	temp_file.store_string(serialized)
	temp_file.flush()
	var write_error := temp_file.get_error()
	temp_file.close()
	if write_error != OK or not _is_valid_save_file(SAVE_TEMP_PATH):
		return false

	# Keep the last known-good career as a recovery copy before replacing it.
	if _is_valid_save_file(SAVE_PATH):
		if DirAccess.copy_absolute(ProjectSettings.globalize_path(SAVE_PATH), ProjectSettings.globalize_path(SAVE_BACKUP_PATH)) != OK:
			return false
	elif FileAccess.file_exists(SAVE_PATH) and not FileAccess.file_exists(SAVE_DAMAGED_PATH):
		# Preserve an already damaged primary for manual recovery; never call it a good backup.
		if DirAccess.copy_absolute(ProjectSettings.globalize_path(SAVE_PATH), ProjectSettings.globalize_path(SAVE_DAMAGED_PATH)) != OK:
			return false

	# Move the current primary aside instead of deleting it. This keeps a
	# rollback copy if promotion of the verified temporary save fails.
	var primary_exists := FileAccess.file_exists(SAVE_PATH)
	if FileAccess.file_exists(SAVE_PREVIOUS_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PREVIOUS_PATH))
	if primary_exists:
		var stage_error := DirAccess.rename_absolute(
			ProjectSettings.globalize_path(SAVE_PATH),
			ProjectSettings.globalize_path(SAVE_PREVIOUS_PATH)
		)
		if stage_error != OK:
			return false

	var promote_error := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(SAVE_TEMP_PATH),
		ProjectSettings.globalize_path(SAVE_PATH)
	)
	if promote_error != OK:
		# Restore the exact prior primary first; use the known-good backup only
		# when no staged primary is available.
		if FileAccess.file_exists(SAVE_PREVIOUS_PATH):
			DirAccess.rename_absolute(
				ProjectSettings.globalize_path(SAVE_PREVIOUS_PATH),
				ProjectSettings.globalize_path(SAVE_PATH)
			)
		elif FileAccess.file_exists(SAVE_BACKUP_PATH):
			DirAccess.copy_absolute(
				ProjectSettings.globalize_path(SAVE_BACKUP_PATH),
				ProjectSettings.globalize_path(SAVE_PATH)
			)
		return false

	if not _is_valid_save_file(SAVE_PATH):
		# A post-promotion validation failure also rolls back to the prior save.
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
		if FileAccess.file_exists(SAVE_PREVIOUS_PATH):
			DirAccess.rename_absolute(
				ProjectSettings.globalize_path(SAVE_PREVIOUS_PATH),
				ProjectSettings.globalize_path(SAVE_PATH)
			)
		return false

	# Keep the previous save as an additional recovery point. The primary and
	# last-known-good backup are both retained after a successful save.
	return true

func has_existing_save_data() -> bool:
	# Used by startup to distinguish a genuinely new game from a career that
	# exists on disk but could not be loaded. Never overwrite those files silently.
	for path in [SAVE_PATH, SAVE_BACKUP_PATH, SAVE_TEMP_PATH, SAVE_DAMAGED_PATH, SAVE_PREVIOUS_PATH, SAVE_CHECKPOINT_PATH, SAVE_CHECKPOINT_PREVIOUS_PATH]:
		if FileAccess.file_exists(path):
			return true
	return false

func load_game() -> bool:
	var load_path := SAVE_PATH
	if not _is_valid_save_file(load_path):
		if _is_valid_save_file(SAVE_BACKUP_PATH):
			load_path = SAVE_BACKUP_PATH
			push_warning("Primary career save is invalid. Loading the last known-good backup.")
		elif _is_valid_save_file(SAVE_PREVIOUS_PATH):
			load_path = SAVE_PREVIOUS_PATH
			push_warning("Primary and backup career saves are invalid. Loading the previous recovery copy.")
		elif _is_valid_save_file(SAVE_TEMP_PATH):
			# A crash may occur after the temporary save is fully written but before
			# it is promoted. It is safe to load only after the same validation used
			# during saving succeeds.
			load_path = SAVE_TEMP_PATH
			push_warning("Primary and backup career saves are invalid. Loading the verified temporary recovery copy.")
		elif _is_valid_save_file(SAVE_CHECKPOINT_PATH):
			# Transition checkpoints contain the last verified career state before
			# a major operation. Use one only after regular save copies fail.
			load_path = SAVE_CHECKPOINT_PATH
			push_warning("Primary save copies are invalid. Loading the verified career checkpoint.")
		elif _is_valid_save_file(SAVE_CHECKPOINT_PREVIOUS_PATH):
			load_path = SAVE_CHECKPOINT_PREVIOUS_PATH
			push_warning("Primary save copies and latest checkpoint are invalid. Loading the previous verified checkpoint.")
		else:
			return false
	var file := FileAccess.open(load_path, FileAccess.READ)
	if file == null:
		return false
	var save_text := file.get_as_text()
	file.close()
	var json := JSON.new()
	var parse_error := json.parse(save_text)
	if parse_error != OK:
		return false
	var parsed: Variant = json.data
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
	var saved_local_details: Variant = parsed.get("last_local_election_details", {})
	last_local_election_details = saved_local_details if saved_local_details is Dictionary else {}
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
	_ensure_authority_schema()
	for party_id_variant in parties.keys():
		_ensure_party_world_presence(str(party_id_variant))
		_ensure_party_roster(str(party_id_variant))
	_ensure_party_map_colors()
	_ensure_election_schema()
	if loaded_save_version < 14:
		var national_election_migration: Dictionary = world_state.get("national_election", {})
		national_election_migration.erase("player_candidate_slate")
		national_election_migration.erase("player_candidate_slate_key")
		world_state["national_election"] = national_election_migration
		var state_election_migration: Array = world_state.get("state_elections", [])
		for migration_index in range(state_election_migration.size()):
			var migration_election: Dictionary = state_election_migration[migration_index]
			migration_election.erase("player_candidate_slate")
			migration_election.erase("player_candidate_slate_key")
			state_election_migration[migration_index] = migration_election
		world_state["state_elections"] = state_election_migration
	_ensure_high_command_schema()
	_ensure_government_system()
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
	if has_elected_office:
		var saved_local_authority := _authority_record("local_representative")
		if not bool(saved_local_authority.get("active", false)):
			register_authority_position(
				"local_representative",
				elected_office_name if not elected_office_name.is_empty() else "Local elected representative — %s" % home_city,
				"player",
				home_city,
				[
					"representative.submit_representation",
					"representative.request_report",
					"representative.raise_constituency_issue"
				],
				"legacy_save_migration"
			)
	notifications = ["Saved career loaded."]
	return true
