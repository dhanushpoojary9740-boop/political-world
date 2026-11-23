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
var authority_summary_label: Label
var government_summary_label: Label
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
var high_command_status: Label
var high_command_budget: SpinBox
var high_command_priority: OptionButton
var high_command_coalition: OptionButton
var india_map_page: VBoxContainer
var india_map_grid
var india_map_details: Label
var india_map_breadcrumb: Label
var india_map_legend: GridContainer
var india_map_layer_picker: OptionButton
var india_map_selected_state: String = "Karnataka"
var india_map_selected_district: String = ""
var india_map_level: int = 0

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
	premium.set_color("font_color", "Label", Color("#e7edf6"))
	premium.set_color("font_color", "Button", Color("#e7edf6"))
	premium.set_color("font_hover_color", "Button", Color("#ffffff"))
	premium.set_color("font_pressed_color", "Button", Color("#0b1728"))
	premium.set_color("font_color", "LineEdit", Color("#e7edf6"))
	premium.set_color("font_color", "SpinBox", Color("#e7edf6"))
	premium.set_color("font_placeholder_color", "LineEdit", Color("#91a4ba"))
	premium.set_color("caret_color", "LineEdit", Color("#d6b15a"))
	premium.set_color("selection_color", "LineEdit", Color("#d6b15a"))
	premium.set_color("font_color", "TabBar", Color("#aebed1"))
	premium.set_color("font_selected_color", "TabBar", Color("#d6b15a"))
	premium.set_font_size("font_size", "Button", 15)
	premium.set_font_size("font_size", "Label", 15)

	var input_style := StyleBoxFlat.new()
	input_style.bg_color = Color("#102036")
	input_style.border_color = Color("#334a66")
	input_style.set_border_width_all(1)
	input_style.set_corner_radius_all(10)
	input_style.set_content_margin_all(12)
	premium.set_stylebox("normal", "LineEdit", input_style)
	premium.set_stylebox("focus", "LineEdit", input_style)
	premium.set_stylebox("normal", "SpinBox", input_style)
	premium.set_stylebox("focus", "SpinBox", input_style)

	var button_normal := _button_style("#d6b15a")
	button_normal.border_color = Color("#334a66")
	button_normal.set_border_width_all(1)
	premium.set_stylebox("normal", "Button", button_normal)
	premium.set_stylebox("hover", "Button", _button_style("#243b57"))
	premium.set_stylebox("pressed", "Button", _button_style("#b88b3b"))
	premium.set_stylebox("disabled", "Button", _button_style("#203650"))

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#102036")
	panel_style.border_color = Color("#334a66")
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(14)
	panel_style.set_content_margin_all(12)
	premium.set_stylebox("panel", "PanelContainer", panel_style)
	premium.set_stylebox("panel", "TabContainer", panel_style)
	theme = premium

func _build_ui() -> void:
	_apply_premium_theme()
	var background := ColorRect.new()
	background.color = Color("#081421")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Fixed screen structure: header, scrollable page content, then bottom navigation.
	var root := VBoxContainer.new()
	root.name = "AppLayout"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 14
	root.offset_top = 12
	root.offset_right = -14
	root.offset_bottom = -12
	root.add_theme_constant_override("separation", 10)
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
	mark_label.text = "PW"
	mark_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mark_label.add_theme_font_size_override("font_size", 19)
	mark_label.add_theme_color_override("font_color", Color("#d6b15a"))
	brand_mark.add_child(mark_label)

	var brand_copy := VBoxContainer.new()
	brand_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand_copy.add_theme_constant_override("separation", 1)
	brand_row.add_child(brand_copy)
	var title := Label.new()
	title.text = "POLITICAL WORLD"
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color("#e7edf6"))
	brand_copy.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "YOUR POLITICAL JOURNEY  /  INDIA"
	subtitle.add_theme_font_size_override("font_size", 10)
	subtitle.add_theme_color_override("font_color", Color("#91a4ba"))
	brand_copy.add_child(subtitle)

	var date_capsule := PanelContainer.new()
	date_capsule.add_theme_stylebox_override("panel", _date_capsule_style())
	brand_row.add_child(date_capsule)
	date_label = Label.new()
	date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	date_label.add_theme_font_size_override("font_size", 12)
	date_label.add_theme_color_override("font_color", Color("#d6b15a"))
	date_capsule.add_child(date_label)

	var header_rule := ColorRect.new()
	header_rule.color = Color("#d6b15a")
	header_rule.custom_minimum_size = Vector2(0, 1)
	header_rule.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(header_rule)

	var content_scroll := ScrollContainer.new()
	content_scroll.name = "PageContent"
	content_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	content_scroll.add_theme_stylebox_override("panel", _button_style("#14253a"))
	content_scroll.add_theme_constant_override("separation", 0)
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
	main_tab_bar.custom_minimum_size = Vector2(0, 68)
	main_tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_tab_bar.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_tab_bar.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_tab_bar.add_theme_stylebox_override("panel", _button_style("#182b43"))
	main_tab_bar.size_flags_vertical = Control.SIZE_SHRINK_END
	main_tab_bar.visible = false
	parent.add_child(main_tab_bar)

	var nav_row := HBoxContainer.new()
	nav_row.add_theme_constant_override("separation", 6)
	nav_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_tab_bar.add_child(nav_row)

	var tab_names: Array[String] = ["⌂  OVERVIEW", "◉  CAREER", "♟  PARTY", "▤  ELECTIONS", "▦  DISTRICT", "▣  OFFICE", "▥  REPORTS", "◎  INDIA MAP"]
	for index in range(tab_names.size()):
		var tab_button := Button.new()
		tab_button.text = tab_names[index]
		tab_button.custom_minimum_size = Vector2(116, 50)
		tab_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tab_button.add_theme_font_size_override("font_size", 11)
		tab_button.add_theme_stylebox_override("normal", _nav_button_style(false))
		tab_button.add_theme_stylebox_override("hover", _nav_button_style(true))
		tab_button.add_theme_stylebox_override("pressed", _nav_button_style(true))
		tab_button.add_theme_color_override("font_color", Color("#e8edf5"))
		tab_button.add_theme_color_override("font_hover_color", Color("#fff7df"))
		tab_button.pressed.connect(_select_main_tab.bind(index))
		nav_row.add_child(tab_button)
		main_tab_buttons.append(tab_button)
	_update_bottom_navigation()

func _navigation_page_names() -> Array[String]:
	return ["Overview", "Career", "Party", "Elections", "District", "Office", "Reports", "India Map"]


func _get_visible_tab_index(page_name: String) -> int:
	if not is_instance_valid(dashboard_box):
		return -1
	for tab_index in range(dashboard_box.get_tab_count()):
		var page := dashboard_box.get_tab_control(tab_index)
		if is_instance_valid(page) and page.name == page_name:
			return tab_index
	return -1


func _get_current_page_name() -> String:
	if not is_instance_valid(dashboard_box):
		return ""
	var tab_index := dashboard_box.current_tab
	if tab_index < 0 or tab_index >= dashboard_box.get_tab_count():
		return ""
	var page := dashboard_box.get_tab_control(tab_index)
	return page.name if is_instance_valid(page) else ""


func _restore_selected_page(page_name: String) -> void:
	if page_name.is_empty():
		return
	var target_index := _get_visible_tab_index(page_name)
	if target_index >= 0:
		dashboard_box.current_tab = target_index
	elif dashboard_box.get_tab_count() > 0:
		dashboard_box.current_tab = 0
	_update_bottom_navigation()


func _select_main_tab(index: int) -> void:
	if not is_instance_valid(dashboard_box):
		return
	var page_names := _navigation_page_names()
	if index < 0 or index >= page_names.size():
		return
	var target_index := _get_visible_tab_index(page_names[index])
	if target_index < 0:
		return
	if dashboard_box.current_tab == target_index:
		return
	var transition := create_tween()
	transition.set_trans(Tween.TRANS_SINE)
	transition.set_ease(Tween.EASE_OUT)
	transition.tween_property(dashboard_box, "modulate:a", 0.72, 0.07)
	transition.tween_callback(func():
		var latest_index := _get_visible_tab_index(page_names[index])
		if latest_index >= 0:
			dashboard_box.current_tab = latest_index
	)
	transition.tween_property(dashboard_box, "modulate:a", 1.0, 0.14)
	_update_bottom_navigation()

func _update_bottom_navigation() -> void:
	for i in range(main_tab_buttons.size()):
		var button := main_tab_buttons[i]
		var page_names := _navigation_page_names()
		var selected: bool = i < page_names.size() and page_names[i] == _get_current_page_name()
		button.add_theme_stylebox_override("normal", _nav_button_style(selected))
		button.add_theme_stylebox_override("hover", _nav_button_style(true))
		button.add_theme_color_override("font_color", Color("#101c2b") if selected else Color("#e8edf5"))
		button.add_theme_color_override("font_hover_color", Color("#101c2b") if selected else Color("#fff7df"))

func _nav_button_style(selected: bool) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#d6b15a") if selected else Color("#14253a")
	style.border_color = Color("#f0d18a") if selected else Color("#344b65")
	style.set_border_width_all(1 if selected else 1)
	style.set_corner_radius_all(13)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	style.shadow_color = Color(0, 0, 0, 0.28)
	style.shadow_size = 4 if selected else 2
	style.shadow_offset = Vector2(0, 2)
	return style

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
	_add_section_title(local_elections, "AI-MANAGED PARTY LOCAL CONTESTS")
	_add_body(local_elections, "AI High Command automatically selects a different party nominee for every modeled district-local contest, runs the campaign, and handles routine organization. A winning party controls that modeled local administration through an AI office-holder; it does not appoint you personally.")
	_add_body(local_elections, "MODEL LIMIT: these are district-level local-administration elections, not separate schedules for every real municipality, Gram Panchayat, ward, or corporation.")
	_add_section_title(local_elections, "OPTIONAL PERSONAL CANDIDACY")
	_add_body(local_elections, "These controls apply only if you personally choose to contest your separate home-area election. Your party's AI nominees continue to contest the nationwide modeled contests automatically either way.")
	election_detail_labels["local"] = _add_body(local_elections, "")
	_add_button(local_elections, "Apply for personal local election ticket", func(): _run_activity("request_ticket"))
	_add_button(local_elections, "Campaign as personal candidate", func(): _run_activity("campaign"))

	var high_command_page := _new_tab(election_tabs, "High Command")
	_add_section_title(high_command_page, "NATIONAL PARTY HIGH COMMAND")
	election_detail_labels["high_command"] = _add_body(high_command_page, "Your party’s nationwide high-command status will appear here.")
	_add_body(high_command_page, "You act as party High Command. The AI automatically nominates party members for every modeled Lok Sabha and state-assembly constituency, selects local nominees, runs campaigns, manages party resources, and handles routine organization. You make broad strategic and coalition-policy decisions only; you do not directly run a government unless separately elected to a specific office.")
	_add_body(high_command_page, "CAMPAIGN STRATEGY")
	high_command_priority = OptionButton.new()
	high_command_priority.custom_minimum_size = Vector2(0, 44)
	for priority in ["Balanced outreach", "Jobs & economy", "Public services", "Rural development", "Welfare & inclusion", "Infrastructure", "Public safety", "Youth engagement"]:
		high_command_priority.add_item(priority)
	high_command_page.add_child(high_command_priority)
	_add_body(high_command_page, "TOTAL MONTHLY CAMPAIGN BUDGET CEILING (₹)")
	high_command_budget = SpinBox.new()
	high_command_budget.min_value = 0
	high_command_budget.max_value = 200000
	high_command_budget.step = 5000
	high_command_budget.value = 50000
	high_command_budget.custom_minimum_size = Vector2(0, 44)
	high_command_page.add_child(high_command_budget)
	_add_body(high_command_page, "COALITION DIRECTIVE")
	high_command_coalition = OptionButton.new()
	high_command_coalition.custom_minimum_size = Vector2(0, 44)
	for policy in ["AI negotiate a working majority", "Prefer single-party government", "Avoid coalition agreements"]:
		high_command_coalition.add_item(policy)
	high_command_page.add_child(high_command_coalition)
	high_command_status = _add_body(high_command_page, "AI candidate selection and campaign operations are automatic.")
	_add_button(high_command_page, "SAVE HIGH COMMAND DIRECTIVE", _on_save_high_command_policy)

	var other_states_elections := _new_tab(election_tabs, "State Assemblies")
	_add_section_title(other_states_elections, "ALL STATE ASSEMBLIES")
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
	office_action_feedback.add_theme_color_override("font_color", Color("#d6b15a"))
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

	india_map_page = _new_tab(dashboard_box, "India Map")
	_add_section_title(india_map_page, "INDIA POLITICAL ATLAS")
	_add_body(india_map_page, "Explore the political simulation by state, then drill into available district records. Political control and election information come from the saved in-game simulation.")
	india_map_breadcrumb = _add_body(india_map_page, "INDIA  /  STATES")
	var map_controls := HBoxContainer.new()
	map_controls.add_theme_constant_override("separation", 8)
	india_map_page.add_child(map_controls)
	var map_back_button := Button.new()
	map_back_button.text = "← BACK"
	map_back_button.custom_minimum_size = Vector2(92, 42)
	map_back_button.pressed.connect(_on_map_back)
	map_controls.add_child(map_back_button)
	india_map_layer_picker = OptionButton.new()
	india_map_layer_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	india_map_layer_picker.custom_minimum_size = Vector2(0, 42)
	for layer_name in ["Political control", "Regional support", "Assembly seats", "Election status"]:
		india_map_layer_picker.add_item(layer_name)
	india_map_layer_picker.item_selected.connect(func(_index: int): _refresh_india_map())
	map_controls.add_child(india_map_layer_picker)
	_add_section_title(india_map_page, "MAP COLOUR KEY")
	india_map_legend = GridContainer.new()
	india_map_legend.name = "MapLegendGrid"
	india_map_legend.columns = 2
	india_map_legend.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	india_map_legend.add_theme_constant_override("h_separation", 10)
	india_map_legend.add_theme_constant_override("v_separation", 8)
	india_map_page.add_child(india_map_legend)
	_add_body(india_map_page, "MAP KEY: Each swatch identifies the party or value range shown on the map. At India level, political control shows the state / Union Territory government; inside a state, it shows the district-level AI administration. Navy means no recorded party; gold marks the selected district. Other layers use the ranges listed above.")
	india_map_grid = preload("res://scripts/india_map_view.gd").new()
	india_map_grid.name = "InteractiveIndiaMap"
	india_map_grid.custom_minimum_size = Vector2(0, 620)
	india_map_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	india_map_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	india_map_grid.region_selected.connect(_on_map_geometry_selected)
	india_map_page.add_child(india_map_grid)
	_add_section_title(india_map_page, "REGION BRIEFING")
	india_map_details = _add_body(india_map_page, "Select a state to view its political record.")
	_refresh_india_map()

	var reports_page := _new_tab(dashboard_box, "Reports")
	_add_section_title(reports_page, "WORLD POLITICS")
	world_politics_label = _add_body(reports_page, "India-wide political simulation will initialize with your career.")
	_add_section_title(reports_page, "YOUR LEGAL AUTHORITY")
	authority_summary_label = _add_body(reports_page, "Your current political office and permitted actions will appear here.")
	_add_section_title(reports_page, "AI GOVERNMENTS & ADMINISTRATION")
	government_summary_label = _add_body(reports_page, "Union, state, and local governments are administered by AI unless the player holds a specific executive office.")
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
	eyebrow.add_theme_color_override("font_color", Color("#d6b15a"))
	content.add_child(eyebrow)

	var headline := Label.new()
	headline.text = "Your journey into public life"
	headline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	headline.add_theme_font_size_override("font_size", 23)
	headline.add_theme_color_override("font_color", Color("#e7edf6"))
	content.add_child(headline)

	var supporting_text := Label.new()
	supporting_text.text = "Build trust, earn responsibility, and win authority through elections. The simulation advances month by month."
	supporting_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	supporting_text.add_theme_font_size_override("font_size", 13)
	supporting_text.add_theme_color_override("font_color", Color("#aebed1"))
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
		label.add_theme_color_override("font_color", Color("#aebed1"))
		body.add_child(label)

		var value := Label.new()
		value.text = str(spec["value"])
		value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		value.add_theme_font_size_override("font_size", 18)
		value.add_theme_color_override("font_color", Color("#e7edf6"))
		body.add_child(value)
		overview_metric_values.append(value)

		var hint := Label.new()
		hint.text = str(spec["hint"])
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.add_theme_font_size_override("font_size", 10)
		hint.add_theme_color_override("font_color", Color("#91a4ba"))
		body.add_child(hint)
		_configure_touch_scroll_passthrough(card)

func _hero_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#182b43")
	style.border_color = Color("#334a66")
	style.set_border_width_all(1)
	style.border_width_left = 3
	style.border_color = Color("#d6b15a")
	style.set_corner_radius_all(18)
	style.set_content_margin_all(18)
	return style

func _metric_card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#102036")
	style.border_color = Color("#334a66")
	style.set_border_width_all(1)
	style.set_corner_radius_all(16)
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
	eyebrow_label.add_theme_color_override("font_color", Color("#d6b15a"))
	body.add_child(eyebrow_label)

	var title_label := Label.new()
	title_label.text = title_text
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_label.add_theme_font_size_override("font_size", 21)
	title_label.add_theme_color_override("font_color", Color("#e7edf6"))
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
	title.add_theme_color_override("font_color", Color("#dce5f0"))
	body.add_child(title)
	var detail := _add_body(body, detail_text)
	detail.add_theme_font_size_override("font_size", 14)
	var status := Label.new()
	status.text = status_text
	status.add_theme_font_size_override("font_size", 11)
	status.add_theme_color_override("font_color", Color("#aebed1"))
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
	title.add_theme_color_override("font_color", Color("#dce5f0"))
	body.add_child(title)
	var detail := _add_body(body, detail_text)
	detail.add_theme_font_size_override("font_size", 14)
	_add_button(body, button_text, callback)
	_configure_touch_scroll_passthrough(card)

func _card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#102036")
	style.border_color = Color("#334a66")
	style.set_border_width_all(1)
	style.border_width_left = 2
	style.border_color = Color("#334a66")
	style.border_width_left = 3
	style.set_corner_radius_all(16)
	style.set_content_margin_all(17)
	style.shadow_color = Color(0.12, 0.19, 0.14, 0.08)
	style.shadow_size = 3
	style.shadow_offset = Vector2(0, 2)
	return style

func _brand_mark_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#102036")
	style.border_color = Color("#d6b15a")
	style.set_border_width_all(1)
	style.set_corner_radius_all(12)
	style.set_content_margin_all(2)
	return style

func _date_capsule_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#14253a")
	style.border_color = Color("#334a66")
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
		title.add_theme_color_override("font_color", Color("#d6b15a"))
		body.add_child(title)
		var department_label := Label.new()
		department_label.text = department.to_upper()
		department_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		department_label.add_theme_font_size_override("font_size", 11)
		department_label.add_theme_color_override("font_color", Color("#aebed1"))
		body.add_child(department_label)
		var place_label := Label.new()
		place_label.text = "AREA  •  %s     |     DUE  •  %s" % [location, str(mission.get("deadline", world.date_label()))]
		place_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		place_label.add_theme_font_size_override("font_size", 12)
		place_label.add_theme_color_override("font_color", Color("#aebed1"))
		body.add_child(place_label)
		var detail_label := _add_body(body, detail)
		detail_label.add_theme_font_size_override("font_size", 14)
		var status_label := Label.new()
		status_label.text = "STATUS  •  %s" % status.to_upper()
		status_label.add_theme_font_size_override("font_size", 11)
		status_label.add_theme_color_override("font_color", Color("#d6b15a"))
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
	button.add_theme_color_override("font_color", Color("#e7edf6"))
	button.add_theme_stylebox_override("normal", _button_style("#d6b15a"))
	button.add_theme_stylebox_override("hover", _button_style("#243b57"))
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
	label.add_theme_color_override("font_color", Color("#aebed1"))
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
	accent.color = Color("#d6b15a")
	accent.custom_minimum_size = Vector2(3, 18)
	accent.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	title_row.add_child(accent)

	var label := Label.new()
	label.text = text_value.to_upper()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#dce5f0"))
	title_row.add_child(label)

	parent.add_child(title_row)

func _add_body(parent: VBoxContainer, text_value: String) -> Label:
	var label := Label.new()
	label.text = text_value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("#aebed1"))
	parent.add_child(label)
	return label

func _add_button(parent: VBoxContainer, text_value: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 50)
	button.add_theme_color_override("font_color", Color("#081421"))
	button.add_theme_stylebox_override("normal", _button_style("#d6b15a"))
	button.add_theme_stylebox_override("hover", _button_style("#e6c978"))
	button.add_theme_stylebox_override("pressed", _button_style("#b88b3b"))
	button.add_theme_color_override("font_hover_color", Color("#081421"))
	button.pressed.connect(callback)
	parent.add_child(button)

func _button_style(color_value: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(color_value)
	style.border_color = Color("#334a66")
	style.set_border_width_all(1)
	style.set_corner_radius_all(16)
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
	# Keep the selected page by name while Office is shown/hidden. TabContainer
	# indexes shift when a page is hidden, so preserving a raw index can land on Office.
	var selected_page_name := _get_current_page_name()
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
		if is_instance_valid(authority_summary_label):
			authority_summary_label.text = world.player_authority_summary()
		if is_instance_valid(government_summary_label):
			government_summary_label.text = world.government_system_summary()
		if is_instance_valid(office_tab):
			office_tab.visible = world.has_elected_office
		if main_tab_buttons.size() > 5 and is_instance_valid(main_tab_buttons[5]):
			main_tab_buttons[5].visible = world.has_elected_office
		_restore_selected_page(selected_page_name)
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
		_refresh_india_map()


const INDIA_MAP_STATES: Array[String] = [
	"Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa",
	"Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala",
	"Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland",
	"Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
	"Uttar Pradesh", "Uttarakhand", "West Bengal", "Andaman and Nicobar Islands",
	"Chandigarh", "Dadra and Nagar Haveli and Daman and Diu", "Delhi",
	"Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
]
const KARNATAKA_MAP_DISTRICTS: Array[String] = [
	"Bagalkot", "Ballari", "Belagavi", "Bengaluru Rural", "Bengaluru Urban",
	"Bidar", "Chamarajanagar", "Chikkaballapura", "Chikkamagaluru", "Chitradurga",
	"Dakshina Kannada", "Davanagere", "Dharwad", "Gadag", "Hassan", "Haveri",
	"Kalaburagi", "Kodagu", "Kolar", "Koppal", "Mandya", "Mysuru", "Raichur",
	"Ramanagara", "Shivamogga", "Tumakuru", "Udupi", "Uttara Kannada",
	"Vijayapura", "Yadgir", "Vijayanagara"
]

func _on_map_back() -> void:
	if india_map_level == 2:
		india_map_level = 1
		india_map_selected_district = ""
	elif india_map_level == 1:
		india_map_level = 0
		india_map_selected_state = ""
		india_map_selected_district = ""
	_refresh_india_map()

func _on_map_state_selected(state_name: String) -> void:
	india_map_selected_state = state_name
	india_map_selected_district = ""
	india_map_level = 1
	_refresh_india_map()

func _on_map_district_selected(district_name: String) -> void:
	india_map_selected_district = district_name
	india_map_level = 2
	_refresh_india_map()

func _on_map_geometry_selected(region_name: String, state_name: String) -> void:
	if india_map_level == 0:
		_on_map_state_selected(region_name)
	elif india_map_level == 1:
		_on_map_district_selected(region_name)
	else:
		india_map_selected_district = region_name
		_refresh_india_map()

func _refresh_india_map() -> void:
	if not is_instance_valid(india_map_grid) or not is_instance_valid(india_map_details):
		return
	var layer := india_map_layer_picker.get_item_text(india_map_layer_picker.selected) if is_instance_valid(india_map_layer_picker) else "Political control"
	if not world.career_started:
		india_map_grid.set_map_state(india_map_level, india_map_selected_state, india_map_selected_district, layer, {}, {}, {}, {}, {}, world.party_map_colors())
		india_map_details.text = "INDIA POLITICAL ATLAS\nStart a political career to initialize the AI-managed Union, state, and district administrations. The map shows the real supplied boundaries; political control appears after your career begins."
		_refresh_india_map_legend(layer, {}, {}, world.party_map_colors())
		return
	var winners: Dictionary = {}
	var supports: Dictionary = {}
	var seats: Dictionary = {}
	var phases: Dictionary = {}
	var national_government: Dictionary = world.get_national_government()
	var national_party_id := str(national_government.get("ruling_party_id", ""))
	for state_variant in INDIA_MAP_STATES:
		var state_name := str(state_variant)
		var government: Dictionary = world.get_state_government(state_name)
		var winner_id := str(government.get("ruling_party_id", ""))
		# Union Territories use the Union administration as the simplified map fallback.
		if winner_id.is_empty():
			winner_id = national_party_id
		if not winner_id.is_empty():
			winners[state_name] = winner_id
		supports[state_name] = _india_map_support(state_name)
		var election := _india_map_state_election(state_name)
		seats[state_name] = int(election.get("assembly_seats", 0))
		phases[state_name] = str(election.get("phase", "No assembly election record"))
	var local_winners: Dictionary = world.local_government_party_map(india_map_selected_state if india_map_level > 0 else "")
	var party_colors: Dictionary = world.party_map_colors()
	india_map_grid.set_map_state(
		india_map_level, india_map_selected_state, india_map_selected_district,
		layer, winners, supports, seats, phases, local_winners, party_colors
	)
	_refresh_india_map_legend(layer, winners, local_winners, party_colors)
	var state_election := _india_map_state_election(india_map_selected_state)
	if india_map_level == 0:
		india_map_breadcrumb.text = "INDIA  /  STATES & UNION TERRITORIES"
		india_map_details.text = "INDIA-WIDE BRIEFING\n%s\nTap a state boundary on the map to open its state government and district map." % world.national_government_briefing()
	elif india_map_level == 1:
		india_map_breadcrumb.text = "INDIA  /  %s  /  DISTRICTS" % india_map_selected_state.to_upper()
		india_map_details.text = _india_map_state_summary(india_map_selected_state, state_election, layer) + "\n\nTap a district boundary to view its AI-managed local administration."
	else:
		india_map_breadcrumb.text = "INDIA  /  %s  /  %s" % [india_map_selected_state.to_upper(), india_map_selected_district.to_upper()]
		india_map_details.text = "DISTRICT / LOCAL GOVERNMENT BRIEFING\n%s, %s\n\n%s\n\nBoundary source: supplied district GeoJSON. Local political control is an AI-managed simulation baseline unless a future local-body election record replaces it." % [
			india_map_selected_district, india_map_selected_state,
			world.local_government_briefing(india_map_selected_state, india_map_selected_district)
		]

func _refresh_india_map_legend(layer: String, state_winners: Dictionary, local_winners: Dictionary, party_colors: Dictionary) -> void:
	if not is_instance_valid(india_map_legend):
		return
	_clear_children(india_map_legend)
	if layer == "Political control":
		var visible_party_ids: Dictionary = {}
		var source_map: Dictionary = state_winners if india_map_level == 0 else local_winners
		for party_id_variant in source_map.values():
			var candidate_party_id := str(party_id_variant)
			if not candidate_party_id.is_empty():
				visible_party_ids[candidate_party_id] = true
		var party_ids: Array = visible_party_ids.keys()
		party_ids.sort()
		for party_id_variant in party_ids:
			var legend_party_id := str(party_id_variant)
			var party: Dictionary = world.parties.get(legend_party_id, {})
			var color_hex := str(party_colors.get(legend_party_id, "#263b54"))
			_add_india_map_legend_item(Color(color_hex), str(party.get("name", legend_party_id)))
		_add_india_map_legend_item(Color("#263b54"), "No government record")
		if india_map_level == 2:
			_add_india_map_legend_item(Color("#f2d27b"), "Selected district")
	elif layer == "Regional support":
		for i in range(5):
			var support_low := i * 20
			var support_high := (i + 1) * 20
			var support_sample := (float(support_low) + float(support_high)) * 0.5 / 100.0
			_add_india_map_legend_item(Color("#102036").lerp(Color("#d6b15a"), support_sample), "%d–%d%%" % [support_low, support_high])
	elif layer == "Assembly seats":
		var seat_bands: Array[Vector2i] = [Vector2i(0, 80), Vector2i(81, 160), Vector2i(161, 240), Vector2i(241, 320), Vector2i(321, 403)]
		for band in seat_bands:
			var seats_sample := (float(band.x) + float(band.y)) * 0.5 / 403.0
			_add_india_map_legend_item(Color("#102036").lerp(Color("#4c91c8"), seats_sample), "%d–%d seats" % [band.x, band.y])
	else:
		_add_india_map_legend_item(Color("#263b54"), "Scheduled / no poll")
		_add_india_map_legend_item(Color("#d6b15a"), "Campaigning")
		_add_india_map_legend_item(Color("#2f9f8c"), "Completed")
		_add_india_map_legend_item(Color("#f2d27b"), "Selected region")

func _add_india_map_legend_item(swatch_color: Color, item_text: String) -> void:
	var item := PanelContainer.new()
	item.custom_minimum_size = Vector2(0, 38)
	item.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var chip_style := StyleBoxFlat.new()
	chip_style.bg_color = Color("#14263d")
	chip_style.border_color = Color("#2b405b")
	chip_style.set_border_width_all(1)
	chip_style.set_corner_radius_all(8)
	chip_style.set_content_margin_all(7)
	item.add_theme_stylebox_override("panel", chip_style)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item.add_child(row)
	var swatch := ColorRect.new()
	swatch.color = swatch_color
	swatch.custom_minimum_size = Vector2(18, 18)
	swatch.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(swatch)
	var text_label := Label.new()
	text_label.text = item_text
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.add_theme_font_size_override("font_size", 12)
	text_label.add_theme_color_override("font_color", Color("#e1e9f3"))
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	row.add_child(text_label)
	india_map_legend.add_child(item)

func _india_map_tile_text(state_name: String, layer: String) -> String:
	var election := _india_map_state_election(state_name)
	if layer == "Assembly seats":
		return "%s\n%d seats" % [state_name, int(election.get("assembly_seats", 0))]
	if layer == "Election status":
		return "%s\n%s" % [state_name, str(election.get("phase", "No record"))]
	if layer == "Regional support":
		return "%s\n%.1f%%" % [state_name, _india_map_support(state_name)]
	var government: Dictionary = world.get_state_government(state_name)
	var party_id := str(government.get("ruling_party_id", ""))
	return "%s\n%s" % [state_name, _india_map_party_name(party_id) if not party_id.is_empty() else "No government"]

func _india_map_state_election(state_name: String) -> Dictionary:
	for election_variant in world.world_state.get("state_elections", []):
		var election: Dictionary = election_variant
		if str(election.get("state", "")) == state_name:
			return election
	return {}

func _india_map_support(state_name: String) -> float:
	var support_by_party: Dictionary = world.world_state.get("regional_support", {})
	var best_support := 0.0
	for party_id_variant in support_by_party.keys():
		var party_id := str(party_id_variant)
		var by_state: Dictionary = support_by_party.get(party_id, {})
		best_support = maxf(best_support, float(by_state.get(state_name, 0.0)))
	return best_support

func _india_map_party_name(party_id: String) -> String:
	if world.parties.has(party_id):
		return str(world.parties[party_id].get("name", party_id))
	return party_id

func _india_map_layer_summary(layer: String) -> String:
	if layer == "Regional support":
		return "Colour intensity shows the strongest recorded regional party support: darker navy is lower support and gold is higher support."
	if layer == "Assembly seats":
		return "Colour intensity shows the modeled number of assembly seats: darker navy is fewer seats and blue is more seats."
	if layer == "Election status":
		return "Slate blue means scheduled or no poll, gold means campaigning, and teal means the modeled election is completed."
	return "Each state is coloured by its AI-managed ruling party. On a state map, district colours show the AI-managed local ruling party. Use the legend to identify each party."

func _india_map_state_summary(state_name: String, election: Dictionary, layer: String) -> String:
	var result := "STATE BRIEFING\n%s\nGOVERNMENT & ADMINISTRATION\n%s" % [state_name, world.state_government_briefing(state_name)]
	if election.is_empty():
		result += "\n\nAssembly election: this region has no modeled state-assembly election record (it may be a Union Territory)."
	else:
		result += "\n\nASSEMBLY ELECTION\nPhase: %s\nAssembly seats modeled: %d\nNext modeled election: %s %d\nLast result: %s" % [
			str(election.get("phase", "Scheduled")),
			int(election.get("assembly_seats", 0)),
			world._month_name(int(election.get("month", 1))),
			int(election.get("next_year", world.year)),
			str(election.get("last_result", "Not yet held"))
		]
	result += "\n\nStrongest recorded regional support: %.1f%%\nMap layer: %s" % [_india_map_support(state_name), layer]
	return result

func _refresh_election_tabs() -> void:
	if election_detail_labels.is_empty() or world.world_state.is_empty():
		return
	var home_local_government: Dictionary = world.get_local_government(world.home_state, world._home_district_name())
	var local_text := "YOUR PERSONAL LOCAL CONSTITUENCY\nArea: %s\nYour personal candidacy: %s\nNext personal election: December %d\nPrevious personal result: %s\n\nDISTRICT-LEVEL LOCAL ADMINISTRATION MODEL\nRuling party: %s\nAI executive leader: %s\nNext modeled district-local poll: %s %d\nLatest district-local result: %s\n\nAI High Command also fields party members in the other modeled district-local contests. An AI candidate’s victory gives the party local control, not personal office to you." % [
		world.local_election_area(),
		"You are contesting" if world.local_candidate_selected else ("Ticket requested" if world.ticket_requested else "No personal ticket selected"),
		world.local_election_year,
		world.last_local_election_result if world.last_local_election_year > 0 else "No personal result recorded",
		world._government_party_name(str(home_local_government.get("ruling_party_id", ""))),
		str(home_local_government.get("leader_name", "AI administrator pending")),
		world._month_name(int(home_local_government.get("next_election_month", 12))),
		int(home_local_government.get("next_election_year", world.year + 5)),
		str(home_local_government.get("last_local_election_result", "No district-local result recorded yet"))
	]
	if election_detail_labels.has("local") and is_instance_valid(election_detail_labels["local"]):
		election_detail_labels["local"].text = local_text

	var state_elections: Array = world.world_state.get("state_elections", [])
	var other_text := "State | AI ruling party | AI executive leader | Next poll | Phase | Last result | Your party candidates\n"
	for election_variant in state_elections:
		var election: Dictionary = election_variant
		var state_name := str(election.get("state", ""))
		var state_government: Dictionary = world.get_state_government(state_name)
		var line := "%s | %s | %s | %s %d | %s | %s | %d contested / %d elected\n" % [
			state_name,
			world._government_party_name(str(state_government.get("ruling_party_id", ""))),
			str(state_government.get("leader_name", "AI leader pending")),
			world._month_name(int(election.get("month", 1))), int(election.get("next_year", world.year)),
			str(election.get("phase", "Scheduled")), str(election.get("last_result", "Not yet held")),
			int(election.get("player_party_candidates_contested", 0)), int(election.get("player_party_candidates_elected", 0))
		]
		other_text += line
	var high_command: Dictionary = world.world_state.get("high_command", {})
	if is_instance_valid(high_command_status):
		high_command_status.text = world.high_command_summary()
	if is_instance_valid(high_command_budget):
		high_command_budget.value = int(high_command.get("monthly_campaign_budget", 50000))
	if is_instance_valid(high_command_priority):
		var selected_priority := str(high_command.get("strategy", "Balanced outreach"))
		for pi in range(high_command_priority.item_count):
			if high_command_priority.get_item_text(pi) == selected_priority:
				high_command_priority.select(pi)
				break
	if is_instance_valid(high_command_coalition):
		var selected_coalition := str(high_command.get("coalition_policy", "AI negotiate a working majority"))
		for ci in range(high_command_coalition.item_count):
			if high_command_coalition.get_item_text(ci) == selected_coalition:
				high_command_coalition.select(ci)
				break
	var home_state_election: Dictionary = {}
	for election_variant in state_elections:
		var home_election: Dictionary = election_variant
		if str(home_election.get("state", "")) == world.home_state:
			home_state_election = home_election
			break
	var candidate_contested := int(home_state_election.get("player_party_candidates_contested", 0))
	var candidate_elected := int(home_state_election.get("player_party_candidates_elected", 0))
	if election_detail_labels.has("high_command") and is_instance_valid(election_detail_labels["high_command"]):
		election_detail_labels["high_command"].text = "AI High Command automatically prepares the party slate in every election.\nYour home state: %s\nNext modeled poll: %s %d\nPhase: %s\nLatest player-party constituency candidates elected: %d / %d\nCurrent campaign directive: %s" % [
			world.home_state,
			world._month_name(int(home_state_election.get("month", 1))), int(home_state_election.get("next_year", world.year)),
			str(home_state_election.get("phase", "Scheduled")), candidate_elected, candidate_contested,
			str(high_command.get("strategy", "Balanced outreach"))
		]
	if election_detail_labels.has("other_states") and is_instance_valid(election_detail_labels["other_states"]):
		election_detail_labels["other_states"].text = other_text

	var national: Dictionary = world.world_state.get("national_election", {})
	if election_detail_labels.has("national") and is_instance_valid(election_detail_labels["national"]):
		var union_government: Dictionary = world.get_national_government()
		election_detail_labels["national"].text = "Next Lok Sabha poll: %s %d\nPhase: %s\nModeled constituencies: %d\nYour party's AI nominees contested: %d\nYour party candidates elected: %d\nLast eligible voters: %d\nLast ballots cast: %d\nLast result: %s\nCurrent ruling party: %s\nPrime Minister / executive leader (AI): %s\nGovernment type: %s\nAI-managed national administration; the player remains High Command and does not automatically become Prime Minister." % [
			world._month_name(int(national.get("month", 5))), int(national.get("next_year", 2029)),
			str(national.get("phase", "Scheduled")), int(national.get("seats", 543)),
			int(national.get("player_party_candidates_contested", 0)),
			int(national.get("player_party_candidates_elected", 0)),
			int(national.get("last_eligible_voters", 0)), int(national.get("last_ballots_cast", 0)),
			str(national.get("last_result", "Not yet held")),
			world._government_party_name(str(union_government.get("ruling_party_id", ""))),
			str(union_government.get("leader_name", "AI leader pending")),
			str(union_government.get("formation_type", "AI-managed administration"))
		]

func _on_save_high_command_policy() -> void:
	var strategy := high_command_priority.get_item_text(high_command_priority.selected) if is_instance_valid(high_command_priority) else "Balanced outreach"
	var coalition_policy := high_command_coalition.get_item_text(high_command_coalition.selected) if is_instance_valid(high_command_coalition) else "AI negotiate a working majority"
	var budget := int(high_command_budget.value) if is_instance_valid(high_command_budget) else 50000
	var result: String = world.set_high_command_policy(strategy, budget, coalition_policy)
	if is_instance_valid(high_command_status):
		high_command_status.text = result + "\n\n" + world.high_command_summary()
	report_label.text = result
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
			name_label.add_theme_color_override("font_color", Color("#d6b15a"))
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
