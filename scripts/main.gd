extends Control

const WorldSimulationScript = preload("res://scripts/world_simulation.gd")
var world: PoliticalWorldSimulation

var date_label: Label
var career_label: Label
var party_label: Label
var finance_label: Label
var election_label: Label
var conditions_label: Label
var office_tab: VBoxContainer
var office_label: Label
var office_log_list: VBoxContainer
var office_case_filter: String = "ALL"
var office_mission_list: VBoxContainer
var office_action_feedback: Label
var district_label: Label
var career_page_summary: Label
var party_page_summary: Label
var election_page_summary: Label
var report_label: Label
var world_politics_label: Label
var name_input: LineEdit
var age_input: SpinBox
var city_input: LineEdit
var party_name_input: LineEdit
var party_founder_contribution_input: SpinBox
var setup_box: VBoxContainer
var dashboard_box: TabContainer
var main_tab_bar: ScrollContainer
var main_tab_buttons: Array[Button] = []
var overview_metric_values: Array[Label] = []
var party_member_name_input: LineEdit
var party_member_area: VBoxContainer
var party_member_search: LineEdit
var party_member_count_label: Label
var duty_member_search: LineEdit
var duty_member_picker: OptionButton
var duty_role_picker: OptionButton
var party_member_status: Label
var constitution_model_picker: OptionButton
var constitution_term_picker: OptionButton
var constitution_status: Label
var internal_candidate_picker: OptionButton
var internal_candidate_search: LineEdit
var internal_ballot_picker: OptionButton
var internal_ballot_search: LineEdit
var internal_election_status: Label
var party_office_picker: OptionButton
var party_office_mode_picker: OptionButton
var office_ballot_picker: OptionButton
var office_ballot_search: LineEdit
var office_election_status: Label
var election_detail_labels: Dictionary = {}
var karnataka_command_status: Label
var karnataka_budget: SpinBox
var karnataka_priority: OptionButton

func _ready() -> void:
	world = WorldSimulationScript.new()
	world.initialize()
	var has_saved_game: bool = world.load_game()
	_build_ui()
	_configure_touch_scroll_passthrough(self)
	if has_saved_game and world.career_started:
		setup_box.visible = false
		dashboard_box.visible = true
		main_tab_bar.visible = true
		report_label.text = "Saved career restored automatically."
	_refresh()

func _apply_premium_theme() -> void:
	var premium := Theme.new()
	premium.default_font_size = 16
	premium.set_color("font_color", "Label", Color("#e8edf2"))
	premium.set_color("font_color", "Button", Color("#f4ead6"))
	premium.set_color("font_hover_color", "Button", Color("#ffffff"))
	premium.set_color("font_pressed_color", "Button", Color("#10202a"))
	premium.set_color("font_color", "LineEdit", Color("#f4ead6"))
	premium.set_color("font_color", "SpinBox", Color("#f4ead6"))
	premium.set_color("font_placeholder_color", "LineEdit", Color("#8193a5"))
	premium.set_color("caret_color", "LineEdit", Color("#e7bd62"))
	premium.set_color("selection_color", "LineEdit", Color("#6d572e"))
	premium.set_color("font_color", "TabBar", Color("#b9c6d2"))
	premium.set_color("font_selected_color", "TabBar", Color("#f0d18a"))
	premium.set_font_size("font_size", "Button", 15)
	premium.set_font_size("font_size", "Label", 15)

	var input_style := StyleBoxFlat.new()
	input_style.bg_color = Color("#111f2c")
	input_style.border_color = Color("#344b5e")
	input_style.set_border_width_all(1)
	input_style.set_corner_radius_all(10)
	input_style.set_content_margin_all(12)
	premium.set_stylebox("normal", "LineEdit", input_style)
	premium.set_stylebox("focus", "LineEdit", input_style)
	premium.set_stylebox("normal", "SpinBox", input_style)
	premium.set_stylebox("focus", "SpinBox", input_style)

	var button_normal := _button_style("#203345")
	button_normal.border_color = Color("#3a5265")
	button_normal.set_border_width_all(1)
	premium.set_stylebox("normal", "Button", button_normal)
	premium.set_stylebox("hover", "Button", _button_style("#2b465b"))
	premium.set_stylebox("pressed", "Button", _button_style("#b98b42"))
	premium.set_stylebox("disabled", "Button", _button_style("#172633"))

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#101d2a")
	panel_style.border_color = Color("#263b4d")
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(14)
	panel_style.set_content_margin_all(12)
	premium.set_stylebox("panel", "PanelContainer", panel_style)
	premium.set_stylebox("panel", "TabContainer", panel_style)
	theme = premium

func _build_ui() -> void:
	_apply_premium_theme()
	var background := ColorRect.new()
	background.color = Color("#08151d")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Fixed screen structure: header, scrollable page content, then bottom navigation.
	var root := VBoxContainer.new()
	root.name = "AppLayout"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 18
	root.offset_top = 16
	root.offset_right = -18
	root.offset_bottom = -16
	root.add_theme_constant_override("separation", 12)
	add_child(root)

	var header := VBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 5)
	root.add_child(header)

	var brand_row := HBoxContainer.new()
	brand_row.name = "BrandHeader"
	brand_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand_row.add_theme_constant_override("separation", 12)
	header.add_child(brand_row)

	var brand_mark := PanelContainer.new()
	brand_mark.custom_minimum_size = Vector2(44, 44)
	brand_mark.add_theme_stylebox_override("panel", _brand_mark_style())
	brand_row.add_child(brand_mark)
	var mark_label := Label.new()
	mark_label.text = "P"
	mark_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mark_label.add_theme_font_size_override("font_size", 25)
	mark_label.add_theme_color_override("font_color", Color("#e8c879"))
	brand_mark.add_child(mark_label)

	var brand_copy := VBoxContainer.new()
	brand_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand_copy.add_theme_constant_override("separation", 1)
	brand_row.add_child(brand_copy)
	var title := Label.new()
	title.text = "POLITICAL WORLD"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color("#f2e6c9"))
	brand_copy.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "YOUR POLITICAL JOURNEY  /  INDIA"
	subtitle.add_theme_font_size_override("font_size", 10)
	subtitle.add_theme_color_override("font_color", Color("#91a4b7"))
	brand_copy.add_child(subtitle)

	var date_capsule := PanelContainer.new()
	date_capsule.add_theme_stylebox_override("panel", _date_capsule_style())
	brand_row.add_child(date_capsule)
	date_label = Label.new()
	date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	date_label.add_theme_font_size_override("font_size", 12)
	date_label.add_theme_color_override("font_color", Color("#e6d6ad"))
	date_capsule.add_child(date_label)

	var header_rule := ColorRect.new()
	header_rule.color = Color("#b89a5a")
	header_rule.custom_minimum_size = Vector2(0, 1)
	header_rule.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(header_rule)

	var content_scroll := ScrollContainer.new()
	content_scroll.name = "PageContent"
	content_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	content_scroll.add_theme_stylebox_override("panel", _button_style("#0b1420"))
	root.add_child(content_scroll)

	setup_box = VBoxContainer.new()
	setup_box.name = "CareerSetup"
	setup_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	setup_box.add_theme_constant_override("separation", 10)
	content_scroll.add_child(setup_box)
	_build_setup()

	dashboard_box = TabContainer.new()
	dashboard_box.name = "DashboardPages"
	dashboard_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dashboard_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dashboard_box.custom_minimum_size = Vector2(0, 0)
	dashboard_box.tabs_visible = false
	dashboard_box.add_theme_constant_override("side_margin", 6)
	dashboard_box.visible = false
	content_scroll.add_child(dashboard_box)
	_build_dashboard()

	_build_bottom_navigation(root)

func _configure_touch_scroll_passthrough(node: Node) -> void:
	# Let drag gestures travel through cards, labels, and tab pages to the
	# nearest ScrollContainer. ScrollContainers remain the gesture handlers.
	if node is Control:
		var control := node as Control
		if control is ScrollContainer:
			control.mouse_filter = Control.MOUSE_FILTER_STOP
		elif control is ColorRect:
			control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			control.mouse_filter = Control.MOUSE_FILTER_PASS

	for child in node.get_children():
		_configure_touch_scroll_passthrough(child)

func _build_bottom_navigation(parent: VBoxContainer) -> void:
	main_tab_bar = ScrollContainer.new()
	main_tab_bar.name = "BottomNavigation"
	main_tab_bar.custom_minimum_size = Vector2(0, 76)
	main_tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_tab_bar.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_tab_bar.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_tab_bar.add_theme_stylebox_override("panel", _button_style("#10232b"))
	main_tab_bar.size_flags_vertical = Control.SIZE_SHRINK_END
	main_tab_bar.visible = false
	parent.add_child(main_tab_bar)

	var nav_row := HBoxContainer.new()
	nav_row.add_theme_constant_override("separation", 6)
	nav_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_tab_bar.add_child(nav_row)

	var tab_names: Array[String] = ["Overview", "Career", "Party", "Elections", "District", "Office"]
	for index in range(tab_names.size()):
		var tab_button := Button.new()
		tab_button.text = tab_names[index]
		tab_button.custom_minimum_size = Vector2(104, 56)
		tab_button.add_theme_font_size_override("font_size", 13)
		tab_button.add_theme_stylebox_override("normal", _button_style("#19333d"))
		tab_button.add_theme_stylebox_override("hover", _button_style("#294b53"))
		tab_button.add_theme_stylebox_override("pressed", _button_style("#d0ad62"))
		tab_button.add_theme_color_override("font_color", Color("#f2e8d5"))
		tab_button.add_theme_stylebox_override("normal", _button_style("#172a39"))
		tab_button.add_theme_stylebox_override("hover", _button_style("#29465a"))
		tab_button.add_theme_stylebox_override("pressed", _button_style("#b98b42"))
		tab_button.pressed.connect(_select_main_tab.bind(index))
		nav_row.add_child(tab_button)
		main_tab_buttons.append(tab_button)
	_update_bottom_navigation()

func _select_main_tab(index: int) -> void:
	if not is_instance_valid(dashboard_box):
		return
	if index < 0 or index >= dashboard_box.get_tab_count():
		return
	if index == 5 and not world.has_elected_office:
		return
	dashboard_box.current_tab = index
	_update_bottom_navigation()

func _update_bottom_navigation() -> void:
	for i in range(main_tab_buttons.size()):
		var button := main_tab_buttons[i]
		button.add_theme_stylebox_override(
			"normal",
			_button_style("#b98b42" if i == dashboard_box.current_tab else "#1b2a38")
		)
		button.add_theme_color_override("font_color", Color("#101820") if i == dashboard_box.current_tab else Color("#f2e8d5"))

func _build_setup() -> void:
	_clear_children(setup_box)
	_add_section_title(setup_box, "START FROM ZERO")
	_add_body(setup_box, "You begin as an ordinary citizen in Karnataka. No party, no seat, and no political authority.")

	name_input = _add_line_input(setup_box, "Character name", "Your name")
	age_input = SpinBox.new()
	age_input.min_value = 18
	age_input.max_value = 90
	age_input.value = 25
	age_input.prefix = "Age: "
	setup_box.add_child(age_input)
	city_input = _add_line_input(setup_box, "Hometown", "Brahmavara")
	party_name_input = _add_line_input(setup_box, "New party name (founding path only)", "Enter your party name")
	party_founder_contribution_input = SpinBox.new()
	party_founder_contribution_input.name = "FounderInitialContribution"
	party_founder_contribution_input.min_value = 0
	party_founder_contribution_input.max_value = 50000
	party_founder_contribution_input.step = 1000
	party_founder_contribution_input.value = 10000
	party_founder_contribution_input.prefix = "Founder contribution ₹"
	party_founder_contribution_input.tooltip_text = "Transferred from your personal savings into the party treasury when founding."
	setup_box.add_child(party_founder_contribution_input)

	_add_body(setup_box, "Choose your entry into politics:")
	_add_button(setup_box, "JOIN AN ESTABLISHED PARTY", _on_join_party)
	_add_button(setup_box, "FOUND MY OWN PARTY", _on_found_party)
	_add_body(setup_box, "Founding makes you party founder and president. Choose an initial contribution from personal savings; it transfers to party funds. Founding grants no elected office.")

func _build_dashboard() -> void:
	var overview := _new_tab(dashboard_box, "Overview")
	_add_dashboard_hero(overview)
	_add_section_title(overview, "YOUR STANDING")
	_add_overview_metrics(overview)
	_add_section_title(overview, "YOUR NEXT STEP")
	_add_body(overview, "Advance the simulation month by month. Detailed career, party, election, district, office, and world activity information lives in its own tab.")
	_add_button(overview, "ADVANCE ONE MONTH", _on_advance_month)
	_add_button(overview, "SAVE GAME NOW", _on_save_game)

	var career_page := _new_tab(dashboard_box, "Career")
	_add_section_title(career_page, "POLITICAL CAREER")
	career_page_summary = _add_page_summary(career_page, "CAREER PROFILE", "Your path into public life", "Your current rank, experience, reputation, and available personal funds.")
	var career_tabs := TabContainer.new()
	career_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	career_page.add_child(career_tabs)
	var career_profile := _new_tab(career_tabs, "Profile")
	_add_section_title(career_profile, "YOUR CAREER")
	var career_profile_label := _add_body(career_profile, "Career details are shown on Overview.")
	career_profile_label.text = "Your rank, experience, reputation, leadership relationship, and personal funds are summarized on Overview."
	var career_actions := _new_tab(career_tabs, "Activities")
	_add_section_title(career_actions, "BUILD YOUR CAREER")
	_add_body(career_actions, "Activities improve your standing over time. Your current political role limits what you can do.")
	_add_button(career_actions, "Volunteer in a local campaign", func(): _run_activity("volunteer"))
	_add_button(career_actions, "Organize community service", func(): _run_activity("community"))
	_add_button(career_actions, "Attend a party meeting", func(): _run_activity("meeting"))

	var party_page := _new_tab(dashboard_box, "Party")
	_add_section_title(party_page, "PARTY ORGANIZATION")
	party_page_summary = _add_page_summary(party_page, "PARTY AT A GLANCE", "Your organization", "Membership, party standing, leadership role, and finances.")
	var party_tabs := TabContainer.new()
	party_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	party_page.add_child(party_tabs)
	var party_profile := _new_tab(party_tabs, "Overview")
	_add_section_title(party_profile, "YOUR PARTY")
	_add_body(party_profile, "Party membership, funds, popularity, and your party role are summarized on Overview.")
	_add_button(party_profile, "Recruit through AI organization", func(): _run_activity("recruit"))

	var party_members := _new_tab(party_tabs, "Members")
	_add_section_title(party_members, "PARTY MEMBERS")
	_add_body(party_members, "Fictional Indian political members. Add members and manage party leadership through Constitution.")
	party_member_name_input = _add_line_input(party_members, "Member name", "Enter a fictional member name")
	_add_button(party_members, "ADD MEMBER", _on_add_party_member)
	party_member_status = _add_body(party_members, "")
	party_member_search = _add_line_input(party_members, "Search members", "Search by name or member ID")
	party_member_search.text_changed.connect(func(_value: String): _refresh_party_members())
	party_member_count_label = _add_body(party_members, "")
	party_member_area = VBoxContainer.new()
	party_member_area.add_theme_constant_override("separation", 8)
	party_members.add_child(party_member_area)

	var party_constitution := _new_tab(party_tabs, "Constitution")
	_add_section_title(party_constitution, "PARTY CONSTITUTION")
	_add_body(party_constitution, "Set internal leadership rules and appoint office bearers. These choices never grant elected government authority.")
	_add_body(party_constitution, "LEADERSHIP MODEL")
	constitution_model_picker = OptionButton.new()
	constitution_model_picker.custom_minimum_size = Vector2(0, 44)
	for model in ["Founder-led", "Member election", "Delegate election"]:
		constitution_model_picker.add_item(model)
	party_constitution.add_child(constitution_model_picker)
	_add_body(party_constitution, "PRESIDENTIAL TERM")
	constitution_term_picker = OptionButton.new()
	constitution_term_picker.custom_minimum_size = Vector2(0, 44)
	for term in ["2 years", "3 years", "4 years", "5 years", "6 years"]:
		constitution_term_picker.add_item(term)
	constitution_term_picker.select(3)
	party_constitution.add_child(constitution_term_picker)
	_add_button(party_constitution, "ADOPT / UPDATE CONSTITUTION", _on_adopt_constitution)
	constitution_status = _add_body(party_constitution, "No constitution adopted yet.")
	_add_section_title(party_constitution, "INTERNAL PRESIDENTIAL ELECTION")
	_add_body(party_constitution, "Use Member election or Delegate election for a contested vote. Nominate at least two candidates; current nominations and the most recent completed election are shown separately.")
	internal_candidate_search = _add_line_input(party_constitution, "Find a candidate", "Search party members")
	internal_candidate_search.text_changed.connect(func(_value: String): _refresh_party_members())
	internal_candidate_picker = OptionButton.new()
	internal_candidate_picker.custom_minimum_size = Vector2(0, 44)
	party_constitution.add_child(internal_candidate_picker)
	_add_button(party_constitution, "NOMINATE SELECTED CANDIDATE", _on_nominate_internal_candidate)
	_add_body(party_constitution, "YOUR BALLOT — choose one nominated candidate. Your vote is recorded as your own ballot and counted with the party members.")
	internal_ballot_search = _add_line_input(party_constitution, "Find ballot candidate", "Search nominated candidates")
	internal_ballot_search.text_changed.connect(func(_value: String): _refresh_party_members())
	internal_ballot_picker = OptionButton.new()
	internal_ballot_picker.custom_minimum_size = Vector2(0, 44)
	party_constitution.add_child(internal_ballot_picker)
	_add_button(party_constitution, "CAST MY VOTE & HOLD ELECTION", _on_hold_internal_election)
	internal_election_status = _add_body(party_constitution, "No internal election held yet.")
	_add_section_title(party_constitution, "PARTY OFFICE BEARERS")
	_add_body(party_constitution, "Choose how each office is filled: presidential appointment or internal member election. Search and select members here.")
	_add_body(party_constitution, "FIND PARTY MEMBER")
	duty_member_search = _add_line_input(party_constitution, "Search members", "Search by name or member ID")
	duty_member_search.text_changed.connect(func(_value: String): _refresh_party_members())
	duty_member_picker = OptionButton.new()
	duty_member_picker.custom_minimum_size = Vector2(0, 44)
	party_constitution.add_child(duty_member_picker)
	party_office_picker = OptionButton.new()
	party_office_picker.custom_minimum_size = Vector2(0, 44)
	for office in ["General Secretary", "Treasurer", "Vice President", "Organization Secretary"]:
		party_office_picker.add_item(office)
	party_constitution.add_child(party_office_picker)
	party_office_picker.item_selected.connect(func(_index: int): _refresh_party_members())
	party_office_mode_picker = OptionButton.new()
	party_office_mode_picker.custom_minimum_size = Vector2(0, 44)
	party_office_mode_picker.add_item("President appoints")
	party_office_mode_picker.add_item("Internal election")
	party_constitution.add_child(party_office_mode_picker)
	_add_button(party_constitution, "SAVE OFFICE SELECTION METHOD", _on_set_office_mode)
	_add_button(party_constitution, "APPOINT SELECTED MEMBER", _on_appoint_party_office)
	_add_button(party_constitution, "NOMINATE SELECTED MEMBER FOR OFFICE", _on_nominate_office_candidate)
	office_ballot_search = _add_line_input(party_constitution, "Find office-election nominee", "Search nominated members")
	office_ballot_search.text_changed.connect(func(_value: String): _refresh_party_members())
	_add_body(party_constitution, "YOUR BALLOT — choose a nominee to cast your own vote. The election cannot be held until you select a candidate.")
	office_ballot_picker = OptionButton.new()
	office_ballot_picker.custom_minimum_size = Vector2(0, 44)
	party_constitution.add_child(office_ballot_picker)
	_add_button(party_constitution, "CAST MY VOTE & HOLD OFFICE-BEARER ELECTION", _on_hold_office_election)
	office_election_status = _add_body(party_constitution, "No office-bearer election held yet.")
	_add_body(party_constitution, "Appointments are made by the president. Internal elections use member ballots. These are party roles, not government offices.")

	var party_finances := _new_tab(party_tabs, "Finances")
	_add_section_title(party_finances, "PERSONAL, PARTY & CAMPAIGN ACCOUNTS")
	finance_label = _add_body(party_finances, "Financial accounts appear after your career begins.")
	_add_body(party_finances, "Personal cash, party funds, party debt, and election campaign spending are tracked separately. Values are a simplified game economy, not audited real-world party accounts.")

	var elections_page := _new_tab(dashboard_box, "Elections")
	_add_section_title(elections_page, "ELECTIONS & CAMPAIGNS")
	election_page_summary = _add_page_summary(elections_page, "ELECTION BRIEFING", "Election calendar", "Each election type has its own schedule and campaign rules.")
	var election_tabs := TabContainer.new()
	election_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	election_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	elections_page.add_child(election_tabs)

	var local_elections := _new_tab(election_tabs, "Local bodies")
	_add_section_title(local_elections, "LOCAL-BODY ELECTION")
	election_detail_labels["local"] = _add_body(local_elections, "")
	_add_button(local_elections, "Apply for local election ticket", func(): _run_activity("request_ticket"))
	_add_button(local_elections, "Campaign as approved candidate", func(): _run_activity("campaign"))
	_add_body(local_elections, "If you do not register or receive a ticket, your party’s AI organization can still field a candidate and campaign. You do not gain office unless you personally contest and win.")

	var karnataka_elections := _new_tab(election_tabs, "Karnataka")
	_add_section_title(karnataka_elections, "KARNATAKA ASSEMBLY")
	election_detail_labels["karnataka"] = _add_body(karnataka_elections, "")
	_add_body(karnataka_elections, "Karnataka High Command: review the AI-prepared slate, set a campaign focus and monthly budget, and assign a party member to election duty. This prototype manages a state-level slate, not individual constituency candidates.")
	karnataka_command_status = _add_body(karnataka_elections, "")
	_add_button(karnataka_elections, "APPROVE AI-PREPARED KARNATAKA SLATE", _on_approve_karnataka_slate)
	_add_body(karnataka_elections, "CAMPAIGN PRIORITY")
	karnataka_priority = OptionButton.new()
	karnataka_priority.custom_minimum_size = Vector2(0, 44)
	for priority in ["Balanced outreach", "Public services", "Jobs & economy", "Rural development", "Youth engagement"]:
		karnataka_priority.add_item(priority)
	karnataka_elections.add_child(karnataka_priority)

	_add_body(karnataka_elections, "MONTHLY CAMPAIGN BUDGET (₹)")
	karnataka_budget = SpinBox.new()
	karnataka_budget.min_value = 0
	karnataka_budget.max_value = 200000
	karnataka_budget.step = 5000
	karnataka_budget.value = 50000
	karnataka_budget.custom_minimum_size = Vector2(0, 44)
	karnataka_elections.add_child(karnataka_budget)
	_add_button(karnataka_elections, "SAVE CAMPAIGN PLAN", _on_save_karnataka_plan)

	var other_states_elections := _new_tab(election_tabs, "Other states")
	_add_section_title(other_states_elections, "OTHER STATE ASSEMBLIES")
	election_detail_labels["other_states"] = _add_body(other_states_elections, "")

	var national_elections := _new_tab(election_tabs, "Lok Sabha")
	_add_section_title(national_elections, "LOK SABHA ELECTION")
	election_detail_labels["national"] = _add_body(national_elections, "")



	# District progression is an internal party path, not government authority.
	var district_page := _new_tab(dashboard_box, "District")
	_add_section_title(district_page, "DISTRICT ORGANIZATION")
	district_label = _add_page_summary(district_page, "DISTRICT PROGRESSION", "Build local standing", "Your district progression appears here.")
	_add_body(district_page, "District party positions are internal organization roles. They do not grant public office, government authority, or access to public funds.")
	_add_section_title(district_page, "PROGRESSION REQUIREMENTS")
	_add_body(district_page, "Build experience and reputation, strengthen your relationship with party leadership, grow party membership, complete local responsibilities, and establish local standing before requesting a district role.")
	_add_button(district_page, "REQUEST DISTRICT PARTY ROLE", _on_request_district_role)
	_add_section_title(district_page, "YOUR CURRENT PROGRESSION")
	var district_details := _add_body(district_page, "")
	district_details.name = "DistrictProgressDetails"

	# The Office page is available only after the player personally wins office.
	office_tab = _new_tab(dashboard_box, "Office")
	office_tab.visible = false
	_add_section_title(office_tab, "YOUR ELECTED OFFICE")
	office_label = _add_page_summary(office_tab, "REPRESENTATIVE BRIEFING", "Constituency responsibilities", "Win an election personally to unlock this page.")
	_add_body(office_tab, "You may represent residents and submit requests or proposals. Councils, civil servants, and competent departments retain their legal powers and operational duties.")
	_add_section_title(office_tab, "OFFICIAL ACTIONS")
	_add_office_action_card(office_tab, "Submit a development proposal", "File a proposal for council review. Approval and implementation are handled by the competent authorities.", "SUBMIT PROPOSAL", _on_submit_office_proposal)
	_add_office_action_card(office_tab, "Raise a public-service issue", "Refer a local service concern to the responsible department for follow-up.", "RAISE ISSUE", _on_raise_constituency_issue)
	office_action_feedback = _add_body(office_tab, "Action results will appear here after you submit a proposal or raise an issue.")
	office_action_feedback.name = "OfficeActionFeedback"
	office_action_feedback.add_theme_color_override("font_color", Color("#e7bd62"))
	_add_section_title(office_tab, "MONTHLY RESPONSIBILITIES")
	office_mission_list = VBoxContainer.new()
	office_mission_list.add_theme_constant_override("separation", 8)
	office_tab.add_child(office_mission_list)
	_add_section_title(office_tab, "OFFICE CASE REGISTER")
	_add_body(office_tab, "Review submitted matters by category. Statuses are updated by the existing council and departmental simulation.")
	var case_filter_row := HBoxContainer.new()
	case_filter_row.add_theme_constant_override("separation", 6)
	office_tab.add_child(case_filter_row)
	_add_case_filter_button(case_filter_row, "ALL", "ALL")
	_add_case_filter_button(case_filter_row, "PROPOSALS", "OFFICIAL REPRESENTATION")
	_add_case_filter_button(case_filter_row, "PUBLIC ISSUES", "PUBLIC SERVICE FOLLOW-UP")
	_add_case_filter_button(case_filter_row, "COMPLETED", "MONTHLY RESPONSIBILITY")
	office_log_list = VBoxContainer.new()
	office_log_list.add_theme_constant_override("separation", 8)
	office_tab.add_child(office_log_list)

	var reports_page := _new_tab(dashboard_box, "Reports")
	_add_section_title(reports_page, "WORLD POLITICS")
	world_politics_label = _add_body(reports_page, "India-wide political simulation will initialize with your career.")
	_add_section_title(reports_page, "WORLD & ACTIVITY REPORT")
	report_label = _add_body(reports_page, "Your political journey is ready to begin.")


	_configure_touch_scroll_passthrough(overview)

func _add_dashboard_hero(parent: VBoxContainer) -> void:
	var panel := PanelContainer.new()
	panel.name = "DashboardHero"
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 132)
	panel.add_theme_stylebox_override("panel", _hero_style())
	parent.add_child(panel)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 7)
	panel.add_child(content)

	var eyebrow := Label.new()
	eyebrow.text = "POLITICAL WORLD INDIA"
	eyebrow.add_theme_font_size_override("font_size", 11)
	eyebrow.add_theme_color_override("font_color", Color("#d0ad62"))
	content.add_child(eyebrow)

	var headline := Label.new()
	headline.text = "Your journey into public life"
	headline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	headline.add_theme_font_size_override("font_size", 23)
	headline.add_theme_color_override("font_color", Color("#f3e8d2"))
	content.add_child(headline)

	var supporting_text := Label.new()
	supporting_text.text = "Build trust, earn responsibility, and win authority through elections. The simulation advances month by month."
	supporting_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	supporting_text.add_theme_font_size_override("font_size", 13)
	supporting_text.add_theme_color_override("font_color", Color("#b8c6d3"))
	content.add_child(supporting_text)

	_configure_touch_scroll_passthrough(panel)

func _add_overview_metrics(parent: VBoxContainer) -> void:
	var grid := GridContainer.new()
	grid.name = "StandingMetricGrid"
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 9)
	grid.add_theme_constant_override("v_separation", 9)
	parent.add_child(grid)

	var metric_specs: Array[Dictionary] = [
		{"label": "CAREER RANK", "value": "Ordinary citizen", "hint": "Your current position"},
		{"label": "PERSONAL FUNDS", "value": "₹0", "hint": "Personal account"},
		{"label": "PARTY STANDING", "value": "No party", "hint": "Membership and support"},
		{"label": "PUBLIC TRUST", "value": "50 / 100", "hint": "Local confidence"}
	]
	for spec in metric_specs:
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.custom_minimum_size = Vector2(0, 112)
		card.add_theme_stylebox_override("panel", _metric_card_style())
		grid.add_child(card)

		var body := VBoxContainer.new()
		body.add_theme_constant_override("separation", 4)
		card.add_child(body)

		var label := Label.new()
		label.text = str(spec["label"])
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color("#a8b8c8"))
		body.add_child(label)

		var value := Label.new()
		value.text = str(spec["value"])
		value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		value.add_theme_font_size_override("font_size", 18)
		value.add_theme_color_override("font_color", Color("#f1e6cf"))
		body.add_child(value)
		overview_metric_values.append(value)

		var hint := Label.new()
		hint.text = str(spec["hint"])
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.add_theme_font_size_override("font_size", 10)
		hint.add_theme_color_override("font_color", Color("#8298ad"))
		body.add_child(hint)
		_configure_touch_scroll_passthrough(card)

func _hero_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#142538")
	style.border_color = Color("#52617a")
	style.set_border_width_all(1)
	style.border_width_left = 3
	style.border_color = Color("#c6a45d")
	style.set_corner_radius_all(16)
	style.set_content_margin_all(17)
	return style

func _metric_card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#132235")
	style.border_color = Color("#2c4056")
	style.set_border_width_all(1)
	style.set_corner_radius_all(13)
	style.set_content_margin_all(13)
	return style

func _add_page_summary(parent: VBoxContainer, eyebrow: String, title_text: String, initial_text: String) -> Label:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _card_style())
	parent.add_child(panel)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 7)
	panel.add_child(body)

	var eyebrow_label := Label.new()
	eyebrow_label.text = eyebrow.to_upper()
	eyebrow_label.add_theme_font_size_override("font_size", 11)
	eyebrow_label.add_theme_color_override("font_color", Color("#c6b06f"))
	body.add_child(eyebrow_label)

	var title_label := Label.new()
	title_label.text = title_text
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.add_theme_font_size_override("font_size", 21)
	title_label.add_theme_color_override("font_color", Color("#f0e7d4"))
	body.add_child(title_label)

	var detail_label := _add_body(body, initial_text)
	detail_label.add_theme_font_size_override("font_size", 14)
	_configure_touch_scroll_passthrough(panel)
	return detail_label

func _add_info_card(parent: VBoxContainer, title_text: String, detail_text: String, status_text: String) -> void:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", _card_style())
	parent.add_child(card)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 6)
	card.add_child(body)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("#f0d18a"))
	body.add_child(title)
	var detail := _add_body(body, detail_text)
	detail.add_theme_font_size_override("font_size", 14)
	var status := Label.new()
	status.text = status_text
	status.add_theme_font_size_override("font_size", 11)
	status.add_theme_color_override("font_color", Color("#9db5c8"))
	body.add_child(status)
	# These cards are created after the initial UI pass. Keep their controls
	# from swallowing touch-drag gestures intended for PageContent.
	_configure_touch_scroll_passthrough(card)

func _add_office_action_card(parent: VBoxContainer, title_text: String, detail_text: String, button_text: String, callback: Callable) -> void:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", _card_style())
	parent.add_child(card)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 7)
	card.add_child(body)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("#f0d18a"))
	body.add_child(title)
	var detail := _add_body(body, detail_text)
	detail.add_theme_font_size_override("font_size", 14)
	_add_button(body, button_text, callback)
	_configure_touch_scroll_passthrough(card)

func _card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#111e2d")
	style.border_color = Color("#2c3c52")
	style.set_border_width_all(1)
	style.border_width_left = 2
	style.border_color = Color("#34485c")
	style.border_width_left = 3
	style.set_corner_radius_all(15)
	style.set_content_margin_all(17)
	style.shadow_color = Color(0, 0, 0, 0.22)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0, 2)
	return style

func _brand_mark_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#101d2b")
	style.border_color = Color("#b89a5a")
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	style.set_content_margin_all(2)
	return style

func _date_capsule_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#142336")
	style.border_color = Color("#46566b")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.content_margin_left = 11
	style.content_margin_right = 11
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style

func _refresh_office_missions() -> void:
	if not is_instance_valid(office_mission_list):
		return
	_clear_children(office_mission_list)
	if world.office_missions.is_empty():
		_add_info_card(office_mission_list, "Monthly responsibilities are being prepared", "Your next set of local matters will appear after the next monthly transition.", "NO ACTIVE ASSIGNMENTS")
		return
	for mission_value in world.office_missions:
		var mission: Dictionary = mission_value
		var mission_id := int(mission.get("id", -1))
		var title_text := str(mission.get("title", "Constituency matter"))
		var department := str(mission.get("department", "District Administration"))
		var location := str(mission.get("location", world.local_election_area()))
		var detail := str(mission.get("detail", "Review this local matter and take the appropriate representative action."))
		var status := str(mission.get("status", "Available"))
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", _card_style())
		office_mission_list.add_child(card)
		var body := VBoxContainer.new()
		body.add_theme_constant_override("separation", 6)
		card.add_child(body)
		var title := Label.new()
		title.text = title_text
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title.add_theme_font_size_override("font_size", 16)
		title.add_theme_color_override("font_color", Color("#f0d18a"))
		body.add_child(title)
		var department_label := Label.new()
		department_label.text = department.to_upper()
		department_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		department_label.add_theme_font_size_override("font_size", 11)
		department_label.add_theme_color_override("font_color", Color("#9db5c8"))
		body.add_child(department_label)
		var place_label := Label.new()
		place_label.text = "AREA  •  %s     |     DUE  •  %s" % [location, str(mission.get("deadline", world.date_label()))]
		place_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		place_label.add_theme_font_size_override("font_size", 12)
		place_label.add_theme_color_override("font_color", Color("#d4dce3"))
		body.add_child(place_label)
		var detail_label := _add_body(body, detail)
		detail_label.add_theme_font_size_override("font_size", 14)
		var status_label := Label.new()
		status_label.text = "STATUS  •  %s" % status.to_upper()
		status_label.add_theme_font_size_override("font_size", 11)
		status_label.add_theme_color_override("font_color", Color("#e7bd62"))
		body.add_child(status_label)
		if status == "Available":
			_add_button(body, "TAKE ACTION", _on_complete_office_mission.bind(mission_id))
		else:
			var completed_label := Label.new()
			completed_label.text = "ACTION RECORDED"
			completed_label.add_theme_font_size_override("font_size", 11)
			completed_label.add_theme_color_override("font_color", Color("#8ab7a1"))
			body.add_child(completed_label)
		# Mission cards are rebuilt dynamically every refresh, so configure
		# their newly-created descendants each time.
		_configure_touch_scroll_passthrough(card)

func _add_case_filter_button(parent: HBoxContainer, button_text: String, filter_value: String) -> void:
	var button := Button.new()
	button.text = button_text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.custom_minimum_size = Vector2(0, 44)
	button.add_theme_font_size_override("font_size", 11)
	button.add_theme_color_override("font_color", Color("#f4ead6"))
	button.add_theme_stylebox_override("normal", _button_style("#203345"))
	button.add_theme_stylebox_override("hover", _button_style("#2b465b"))
	button.pressed.connect(_set_office_case_filter.bind(filter_value))
	parent.add_child(button)

func _set_office_case_filter(filter_value: String) -> void:
	office_case_filter = filter_value
	_refresh_office_log()

func _refresh_office_log() -> void:
	if not is_instance_valid(office_log_list):
		return
	_clear_children(office_log_list)
	var entries: Array[Dictionary] = []
	for proposal in world.office_proposals:
		entries.append({
			"kind": "OFFICIAL REPRESENTATION",
			"title": str(proposal.get("title", "Development proposal")),
			"department": str(proposal.get("department", "Council review")),
			"location": str(proposal.get("location", world.local_election_area())),
			"status": str(proposal.get("status", "Pending"))
		})
	for issue in world.constituency_issues:
		entries.append({
			"kind": "PUBLIC SERVICE FOLLOW-UP",
			"title": str(issue.get("topic", "Constituency issue")),
			"department": str(issue.get("department", "District Administration")),
			"location": str(issue.get("location", world.local_election_area())),
			"status": str(issue.get("status", "Submitted"))
		})
	for mission in world.office_mission_history:
		entries.append({
			"kind": "MONTHLY RESPONSIBILITY",
			"title": str(mission.get("title", "Office responsibility")),
			"department": str(mission.get("department", "District Administration")),
			"location": str(mission.get("location", world.local_election_area())),
			"status": str(mission.get("status", "Completed"))
		})
	var filtered_entries: Array[Dictionary] = []
	for entry_value in entries:
		var entry: Dictionary = entry_value
		if office_case_filter == "ALL" or str(entry.get("kind", "")) == office_case_filter:
			filtered_entries.append(entry)
	if filtered_entries.is_empty():
		_add_info_card(office_log_list, "No cases in this section", "New submissions and completed responsibilities will appear here when available.", "EMPTY REGISTER")
		return
	var start_index := maxi(0, filtered_entries.size() - 16)
	for i in range(start_index, filtered_entries.size()):
		var entry: Dictionary = filtered_entries[i]
		var detail_text := "%s\n%s" % [str(entry["department"]), str(entry["location"])]
		_add_info_card(office_log_list, str(entry["title"]), detail_text, "%s  •  %s" % [str(entry["kind"]), str(entry["status"]).to_upper()])

func _on_complete_office_mission(mission_id: int) -> void:
	report_label.text = "\n".join(PackedStringArray(world.complete_office_mission(mission_id)))
	_refresh()
	_save_progress()

func _on_request_district_role() -> void:
	world.request_district_party_role()
	report_label.text = "\\n".join(PackedStringArray(world.notifications))
	_refresh()
	_save_progress()

func _on_submit_office_proposal() -> void:
	world.submit_office_proposal()
	var result_text := str(world.notifications.back()) if not world.notifications.is_empty() else "Proposal action completed."
	if is_instance_valid(office_action_feedback):
		office_action_feedback.text = result_text
	report_label.text = result_text
	_refresh()
	_save_progress()

func _on_raise_constituency_issue() -> void:
	world.raise_constituency_issue()
	var result_text := str(world.notifications.back()) if not world.notifications.is_empty() else "Issue action completed."
	if is_instance_valid(office_action_feedback):
		office_action_feedback.text = result_text
	report_label.text = result_text
	_refresh()
	_save_progress()

func _new_tab(parent: TabContainer, tab_title: String) -> VBoxContainer:
	var page := VBoxContainer.new()
	page.name = tab_title
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.add_theme_constant_override("separation", 10)
	parent.add_child(page)
	parent.set_tab_title(parent.get_tab_count() - 1, tab_title)
	return page

func _add_line_input(parent: VBoxContainer, label_text: String, placeholder_text: String) -> LineEdit:
	var label := Label.new()
	label.text = label_text
	label.add_theme_color_override("font_color", Color("#d4dce3"))
	parent.add_child(label)
	var field := LineEdit.new()
	field.placeholder_text = placeholder_text
	field.custom_minimum_size = Vector2(0, 44)
	parent.add_child(field)
	return field

func _add_section_title(parent: VBoxContainer, text_value: String) -> void:
	var title_row := HBoxContainer.new()
	title_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_row.add_theme_constant_override("separation", 10)
	title_row.custom_minimum_size = Vector2(0, 28)

	var accent := ColorRect.new()
	accent.color = Color("#d0ad62")
	accent.custom_minimum_size = Vector2(3, 18)
	accent.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	title_row.add_child(accent)

	var label := Label.new()
	label.text = text_value.to_upper()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("#c6d0dc"))
	title_row.add_child(label)

	parent.add_child(title_row)

func _add_body(parent: VBoxContainer, text_value: String) -> Label:
	var label := Label.new()
	label.text = text_value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("#c7d1dd"))
	parent.add_child(label)
	return label

func _add_button(parent: VBoxContainer, text_value: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 50)
	button.add_theme_color_override("font_color", Color("#14232a"))
	button.add_theme_stylebox_override("normal", _button_style("#d5b36b"))
	button.add_theme_stylebox_override("hover", _button_style("#e8c879"))
	button.add_theme_stylebox_override("pressed", _button_style("#b18b45"))
	button.add_theme_color_override("font_hover_color", Color("#101820"))
	button.pressed.connect(callback)
	parent.add_child(button)

func _button_style(color_value: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(color_value)
	style.border_color = Color("#4a6267")
	style.set_border_width_all(1)
	style.set_corner_radius_all(13)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	style.shadow_color = Color(0, 0, 0, 0.24)
	style.shadow_size = 3
	style.shadow_offset = Vector2(0, 2)
	return style

func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func _on_join_party() -> void:
	var started: bool = world.start_career(name_input.text, int(age_input.value), city_input.text, "join")
	_after_start(started)

func _on_found_party() -> void:
	var started: bool = world.start_career(name_input.text, int(age_input.value), city_input.text, "found", party_name_input.text, int(party_founder_contribution_input.value))
	_after_start(started)

func _after_start(started: bool) -> void:
	if started:
		report_label.text = "\n".join(PackedStringArray(world.notifications))
		setup_box.visible = false
		dashboard_box.visible = true
		main_tab_bar.visible = true
		_refresh()
		_save_progress()
	else:
		report_label.text = "\n".join(PackedStringArray(world.notifications))

func _run_activity(activity: String) -> void:
	report_label.text = "\n".join(PackedStringArray(world.perform_activity(activity)))
	_refresh()
	_save_progress()

func _on_advance_month() -> void:
	report_label.text = "\n".join(PackedStringArray(world.advance_month()))
	_refresh()
	_save_progress()

func _on_save_game() -> void:
	if world.save_game():
		report_label.text = "Game saved successfully."
	else:
		report_label.text = "Save failed. Check available storage and try again."

func _save_progress() -> void:
	if is_instance_valid(world) and world.career_started:
		world.save_game()

func _refresh() -> void:
	date_label.text = world.date_label()
	if world.career_started:
		_refresh_overview_metrics()
		if is_instance_valid(career_page_summary):
			career_page_summary.text = world.career_summary()
		if is_instance_valid(party_page_summary):
			party_page_summary.text = world.party_summary()
		finance_label.text = world.finance_summary()
		_refresh_party_members()
		if is_instance_valid(election_page_summary):
			election_page_summary.text = world.election_summary()
		_refresh_election_tabs()
		if is_instance_valid(world_politics_label):
			world_politics_label.text = world.world_politics_summary()
		if is_instance_valid(office_tab):
			office_tab.visible = world.has_elected_office
		if main_tab_buttons.size() > 5 and is_instance_valid(main_tab_buttons[5]):
			main_tab_buttons[5].visible = world.has_elected_office
		if is_instance_valid(district_label):
			district_label.text = world.district_progression_summary()
		var district_details := dashboard_box.find_child("DistrictProgressDetails", true, false)
		if is_instance_valid(district_details) and district_details is Label:
			district_details.text = "Career rank: %s\\nExperience: %d / 30\\nReputation: %.1f / 10\\nParty leadership relationship: %.1f / 20\\nParty membership: %d / 50\\nLocal responsibilities completed: %d / 3\\nDistrict role: %s" % [
				world.career_rank, world.experience, world.reputation, world.local_leader_relationship,
				int(world.parties.get(world.player_party_id, {}).get("members", 0)),
				world.district_service_record,
				world.district_party_role if world.district_role_approved else ("Application pending" if world.district_role_application_pending else "Not appointed")
			]
		if world.has_elected_office:
			if is_instance_valid(office_label):
				office_label.text = world.office_summary()
			_refresh_office_missions()
			_refresh_office_log()


func _refresh_election_tabs() -> void:
	if election_detail_labels.is_empty() or world.world_state.is_empty():
		return
	var local_text := "Area: %s\nNext local election: December %d\nCurrent status: %s\nPrevious result: %s\nYour party’s AI campaign is the fallback if you do not register or receive approval. The AI result does not grant you an elected office." % [
		world.local_election_area(), world.local_election_year,
		"Completed" if world.local_election_completed else "Scheduled",
		world.last_local_election_result if world.last_local_election_year > 0 else "No result recorded"
	]
	if election_detail_labels.has("local") and is_instance_valid(election_detail_labels["local"]):
		election_detail_labels["local"].text = local_text

	var state_elections: Array = world.world_state.get("state_elections", [])
	var karnataka_text := "Karnataka Assembly election schedule and AI campaign status.\n"
	var other_text := "State | Next poll | Phase | Last result\n"
	for election_variant in state_elections:
		var election: Dictionary = election_variant
		var state_name := str(election.get("state", ""))
		var line := "%s | %s %d | %s | %s\n" % [
			state_name, world._month_name(int(election.get("month", 1))), int(election.get("next_year", world.year)),
			str(election.get("phase", "Scheduled")), str(election.get("last_result", "Not yet held"))
		]
		if state_name == "Karnataka":
			karnataka_text += line
		else:
			other_text += line
	var karnataka_election: Dictionary = {}
	for election_variant in state_elections:
		var item: Dictionary = election_variant
		if str(item.get("state", "")) == "Karnataka":
			karnataka_election = item
			break
	if is_instance_valid(karnataka_command_status):
		karnataka_command_status.text = "Slate: %s\nPriority: %s\nMonthly plan: ₹%s\nPhase: %s" % [
			"Approved" if bool(karnataka_election.get("high_command_slate_approved", false)) else "Awaiting your review",
			str(karnataka_election.get("high_command_priority", "Balanced outreach")),
			world._format_number(int(karnataka_election.get("high_command_monthly_budget", 50000))),
			str(karnataka_election.get("phase", "Scheduled"))
		]
		if is_instance_valid(karnataka_budget):
			karnataka_budget.value = int(karnataka_election.get("high_command_monthly_budget", 50000))
		if is_instance_valid(karnataka_priority):
			var selected_priority := str(karnataka_election.get("high_command_priority", "Balanced outreach"))
			for pi in range(karnataka_priority.item_count):
				if karnataka_priority.get_item_text(pi) == selected_priority:
					karnataka_priority.select(pi)
					break
	if election_detail_labels.has("karnataka") and is_instance_valid(election_detail_labels["karnataka"]):
		election_detail_labels["karnataka"].text = karnataka_text
	if election_detail_labels.has("other_states") and is_instance_valid(election_detail_labels["other_states"]):
		election_detail_labels["other_states"].text = other_text

	var national: Dictionary = world.world_state.get("national_election", {})
	if election_detail_labels.has("national") and is_instance_valid(election_detail_labels["national"]):
		election_detail_labels["national"].text = "Next Lok Sabha poll: %s %d\nPhase: %s\nSeats modeled: %d\nLast result: %s\nAI-managed national campaigning and participation." % [
			world._month_name(int(national.get("month", 5))), int(national.get("next_year", 2029)),
			str(national.get("phase", "Scheduled")), int(national.get("seats", 543)),
			str(national.get("last_result", "Not yet held"))
		]

func _on_approve_karnataka_slate() -> void:
	var result: String = world.set_karnataka_slate_approved(true)
	karnataka_command_status.text = result
	_refresh()
	_save_progress()

func _on_save_karnataka_plan() -> void:
	var priority := karnataka_priority.get_item_text(karnataka_priority.selected)
	var result: String = world.set_karnataka_campaign_plan(priority, int(karnataka_budget.value))
	karnataka_command_status.text = result
	_refresh()
	_save_progress()

func _refresh_overview_metrics() -> void:
	if overview_metric_values.size() < 4:
		return
	overview_metric_values[0].text = world.career_rank
	overview_metric_values[1].text = "₹" + world._format_number(world.personal_funds)
	var party_status := "No party"
	if world.player_party_id != "" and world.parties.has(world.player_party_id):
		var party: Dictionary = world.parties[world.player_party_id]
		party_status = "%s members" % world._format_number(int(party.get("members", 0)))
	overview_metric_values[2].text = party_status
	overview_metric_values[3].text = "%.0f / 100" % world.public_trust

func _on_add_party_member() -> void:
	var member_name := party_member_name_input.text.strip_edges()
	if member_name.is_empty():
		party_member_status.text = "Enter a member name first."
		return
	var result: String = world.add_party_member(member_name)
	party_member_status.text = result
	party_member_name_input.text = ""
	_refresh()
	_save_progress()

func _on_assign_party_duty() -> void:
	if duty_member_picker.item_count == 0:
		party_member_status.text = "Add or recruit a member first."
		return
	var member_id := str(duty_member_picker.get_item_metadata(duty_member_picker.selected))
	var duty := duty_role_picker.get_item_text(duty_role_picker.selected)
	party_member_status.text = world.assign_party_duty(member_id, duty)
	_refresh()
	_save_progress()

func _on_adopt_constitution() -> void:
	var model := constitution_model_picker.get_item_text(constitution_model_picker.selected)
	var term := constitution_term_picker.selected + 2
	constitution_status.text = world.adopt_party_constitution(model, term)
	_refresh()
	_save_progress()

func _on_appoint_party_office() -> void:
	if duty_member_picker.item_count == 0:
		constitution_status.text = "Add or recruit a member, then search and select them in Party > Constitution."
		return
	var member_id := str(duty_member_picker.get_item_metadata(duty_member_picker.selected))
	var office := party_office_picker.get_item_text(party_office_picker.selected)
	constitution_status.text = world.appoint_party_office_bearer(member_id, office)
	_refresh()
	_save_progress()

func _on_set_office_mode() -> void:
	var office := party_office_picker.get_item_text(party_office_picker.selected)
	var mode := party_office_mode_picker.get_item_text(party_office_mode_picker.selected)
	constitution_status.text = world.set_party_office_selection_mode(office, mode)
	_refresh_party_members()
	_save_progress()

func _on_nominate_office_candidate() -> void:
	if duty_member_picker.item_count == 0:
		office_election_status.text = "Search for and select a party member first."
		return
	var member_id := str(duty_member_picker.get_item_metadata(duty_member_picker.selected))
	var office := party_office_picker.get_item_text(party_office_picker.selected)
	office_election_status.text = world.nominate_party_office_candidate(member_id, office)
	_refresh_party_members()
	_save_progress()

func _on_hold_office_election() -> void:
	if office_ballot_picker.item_count < 2 or office_ballot_picker.selected <= 0:
		office_election_status.text = "Choose a nominee for your own ballot before holding the election."
		return
	var office := party_office_picker.get_item_text(party_office_picker.selected)
	var vote_id := str(office_ballot_picker.get_item_metadata(office_ballot_picker.selected))
	office_election_status.text = world.hold_party_office_election(office, vote_id)
	_refresh()
	_save_progress()

func _on_nominate_internal_candidate() -> void:
	if not is_instance_valid(internal_candidate_picker) or internal_candidate_picker.item_count == 0:
		internal_election_status.text = "Add party members or choose yourself as a candidate."
		return
	var candidate_id := str(internal_candidate_picker.get_item_metadata(internal_candidate_picker.selected))
	internal_election_status.text = world.nominate_party_president_candidate(candidate_id)
	_refresh_party_members()
	_save_progress()

func _on_hold_internal_election() -> void:
	if not is_instance_valid(internal_ballot_picker) or internal_ballot_picker.item_count == 0:
		internal_election_status.text = "Nominate at least two candidates, then select your ballot."
		return
	var selected_vote := str(internal_ballot_picker.get_item_metadata(internal_ballot_picker.selected))
	internal_election_status.text = world.hold_party_presidential_election(selected_vote)
	_refresh()
	_save_progress()

func _refresh_party_members() -> void:
	if not is_instance_valid(party_member_area) or not is_instance_valid(duty_member_picker):
		return
	for child in party_member_area.get_children():
		child.queue_free()
	duty_member_picker.clear()
	if is_instance_valid(internal_candidate_picker):
		internal_candidate_picker.clear()
		internal_candidate_picker.add_item("You (founder)")
		internal_candidate_picker.set_item_metadata(0, "founder")
	if is_instance_valid(internal_ballot_picker):
		internal_ballot_picker.clear()
	var constitution := world.party_constitution()
	var ballot_party: Dictionary = world.parties.get(world.player_party_id, {})
	var ballot_election: Dictionary = ballot_party.get("internal_election", {})
	for nomination_variant in ballot_election.get("nominations", []):
		var nomination: Dictionary = nomination_variant
		var ballot_name := str(nomination.get("candidate_name", "Candidate"))
		if is_instance_valid(internal_ballot_picker) and (internal_ballot_search.text.strip_edges().is_empty() or ballot_name.to_lower().contains(internal_ballot_search.text.strip_edges().to_lower())):
			internal_ballot_picker.add_item(ballot_name)
			internal_ballot_picker.set_item_metadata(internal_ballot_picker.item_count - 1, str(nomination.get("candidate_id", "")))
	var selected_office := party_office_picker.get_item_text(party_office_picker.selected) if party_office_picker.item_count > 0 else "General Secretary"
	var office_elections: Dictionary = ballot_party.get("office_elections", {})
	var selected_office_election: Dictionary = office_elections.get(selected_office, {"nominations": [], "history": []})
	if is_instance_valid(office_ballot_picker):
		office_ballot_picker.clear()
		office_ballot_picker.add_item("Choose your vote…")
		office_ballot_picker.set_item_metadata(0, "")
		office_ballot_picker.select(0)
		for office_nom_variant in selected_office_election.get("nominations", []):
			var office_nom: Dictionary = office_nom_variant
			var office_nom_name := str(office_nom.get("candidate_name", "Candidate"))
			var office_query := office_ballot_search.text.strip_edges().to_lower() if is_instance_valid(office_ballot_search) else ""
			if office_query.is_empty() or office_nom_name.to_lower().contains(office_query):
				office_ballot_picker.add_item(office_nom_name)
				office_ballot_picker.set_item_metadata(office_ballot_picker.item_count - 1, str(office_nom.get("candidate_id", "")))
	if is_instance_valid(party_office_mode_picker):
		var mode_map: Dictionary = ballot_party.get("office_selection_modes", {})
		var saved_mode := str(mode_map.get(selected_office, "President appoints"))
		party_office_mode_picker.select(1 if saved_mode == "Internal election" else 0)
	# Keep the controls synchronized with the saved constitution; never show a default
	# dropdown value that differs from the active party rules.
	if not constitution.is_empty():
		var saved_model := str(constitution.get("leadership_model", "Founder-led"))
		for model_index in range(constitution_model_picker.item_count):
			if constitution_model_picker.get_item_text(model_index) == saved_model:
				constitution_model_picker.select(model_index)
				break
		var saved_term := int(constitution.get("president_term_years", 5))
		var term_index := clampi(saved_term - 2, 0, constitution_term_picker.item_count - 1)
		constitution_term_picker.select(term_index)
	if is_instance_valid(constitution_status) and not constitution.is_empty():
		var bearers: Dictionary = constitution.get("office_bearers", {})
		var lines: Array[String] = []
		if bool(constitution.get("constitution_adopted", false)):
			lines.append("Adopted: %s leadership • %d-year term" % [str(constitution.get("leadership_model", "Founder-led")), int(constitution.get("president_term_years", 5))])
		else:
			lines.append("No constitution adopted yet.")
		for office in bearers.keys():
			var bearer: Dictionary = bearers[office]
			lines.append("%s: %s" % [str(office), str(bearer.get("name", "Unassigned"))])
		constitution_status.text = "\n".join(lines)
		if is_instance_valid(internal_election_status):
			internal_election_status.text = world.party_internal_election_summary()
		if is_instance_valid(office_election_status):
			var office_election: Dictionary = office_elections.get(selected_office, {})
			var office_noms: Array = office_election.get("nominations", [])
			var office_hist: Array = office_election.get("history", [])
			office_election_status.text = world.party_office_election_summary(selected_office)
	var roster: Array = world.get_player_party_members()
	var roster_query_for_count := party_member_search.text.strip_edges() if is_instance_valid(party_member_search) else ""
	var shown_member_rows := 0
	var matching_member_count := 0
	for member_variant in roster:
		var member: Dictionary = member_variant
		var member_name := str(member.get("name", "Member"))
		var roster_query := party_member_search.text.strip_edges().to_lower() if is_instance_valid(party_member_search) else ""
		var show_in_roster := roster_query.is_empty() or member_name.to_lower().contains(roster_query) or str(member.get("id", "")).to_lower().contains(roster_query)
		if show_in_roster:
			matching_member_count += 1
		if show_in_roster and (not roster_query_for_count.is_empty() or shown_member_rows < 50):
			shown_member_rows += 1
			var row := PanelContainer.new()
			var row_box := VBoxContainer.new()
			row_box.add_theme_constant_override("separation", 3)
			var name_label := Label.new()
			name_label.text = member_name
			name_label.add_theme_color_override("font_color", Color("#f0d18a"))
			row_box.add_child(name_label)
			var detail := Label.new()
			detail.text = "%s  •  %s" % [str(member.get("duty", "Volunteer")), str(member.get("region", "Karnataka"))]
			detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			row_box.add_child(detail)
			row.add_child(row_box)
			party_member_area.add_child(row)
		var duty_query := duty_member_search.text.strip_edges().to_lower() if is_instance_valid(duty_member_search) else ""
		if duty_query.is_empty() or member_name.to_lower().contains(duty_query) or str(member.get("id", "")).to_lower().contains(duty_query):
			duty_member_picker.add_item(member_name)
			duty_member_picker.set_item_metadata(duty_member_picker.item_count - 1, str(member.get("id", "")))
		var candidate_query := internal_candidate_search.text.strip_edges().to_lower() if is_instance_valid(internal_candidate_search) else ""
		if is_instance_valid(internal_candidate_picker) and (candidate_query.is_empty() or member_name.to_lower().contains(candidate_query) or str(member.get("id", "")).to_lower().contains(candidate_query)):
			internal_candidate_picker.add_item(member_name)
			internal_candidate_picker.set_item_metadata(internal_candidate_picker.item_count - 1, str(member.get("id", "")))
	if is_instance_valid(party_member_count_label):
		if roster_query_for_count.is_empty() and matching_member_count > 50:
			party_member_count_label.text = "Showing first 50 of %d members. Search by name or ID to find others." % roster.size()
		else:
			party_member_count_label.text = "%d matching members" % matching_member_count
	if roster.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No named roster records yet. Add a member above."
		party_member_area.add_child(empty_label)

func _notification(what: int) -> void:
	if not is_instance_valid(world) or not world.career_started:
		return
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		world.save_game()
