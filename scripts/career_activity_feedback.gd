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
var career_activity_feedback: Label
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
var page_content_scroll: ScrollContainer
var main_tab_buttons: Array[Button] = []
var overview_metric_values: Array[Label] = []
var party_member_name_input: LineEdit
var party_member_state_picker: OptionButton
var party_member_area: VBoxContainer
var party_member_search: LineEdit
var party_member_count_label: Label
var duty_member_search: LineEdit
var duty_member_picker: OptionButton
var duty_role_picker: OptionButton
var party_member_status: Label
var organization_summary_label: Label
var organization_state_picker: OptionButton
var organization_profile_label: Label
var organization_member_picker: OptionButton
var organization_duty_picker: OptionButton
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
var state_election_cards: VBoxContainer
var high_command_status: Label
var high_command_analytics_label: Label
var high_command_readiness_label: Label
var high_command_budget: SpinBox
var high_command_priority: OptionButton
var high_command_focus: OptionButton
var high_command_coalition: OptionButton
var karnataka_candidate_picker: OptionButton
var karnataka_candidate_status: Label
var karnataka_candidate_summary: Label
var karnataka_candidate_search: LineEdit
var karnataka_candidate_filter: OptionButton
var karnataka_member_search: LineEdit
var karnataka_member_picker: OptionButton
var karnataka_candidate_contest_status: Label
var india_map_page: VBoxContainer
var india_map_grid
var india_map_details: Label
var india_map_breadcrumb: Label
var india_map_legend: GridContainer
var india_map_layer_picker: OptionButton
var india_map_selected_state: String = "Karnataka"
var india_map_selected_district: String = ""
var india_map_level: int = 0
var _page_touch_index: int = -1
var _page_touch_last_y: float = 0.0
var _page_touch_dragging: bool = false
var _page_touch_start_y: float = 0.0

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
	# A restrained executive palette: midnight navy, slate panels, and antique gold.
	var premium := Theme.new()
	premium.default_font_size = 16
	premium.set_color("font_color", "Label", Color("#e8edf5"))
	premium.set_color("font_color", "Button", Color("#e8edf5"))
	premium.set_color("font_hover_color", "Button", Color("#fffaf0"))
	premium.set_color("font_pressed_color", "Button", Color("#101b2b"))
	premium.set_color("font_color", "LineEdit", Color("#e8edf5"))
	premium.set_color("font_color", "SpinBox", Color("#e8edf5"))
	premium.set_color("font_placeholder_color", "LineEdit", Color("#8fa4bc"))
	premium.set_color("caret_color", "LineEdit", Color("#d9b45f"))
	premium.set_color("selection_color", "LineEdit", Color("#d9b45f"))
	premium.set_color("font_color", "TabBar", Color("#b5c2d2"))
	premium.set_color("font_selected_color", "TabBar", Color("#e0bd68"))
	premium.set_font_size("font_size", "Button", 14)
	premium.set_font_size("font_size", "Label", 15)

	var input_style := StyleBoxFlat.new()
	input_style.bg_color = Color("#111f32")
	input_style.border_color = Color("#354b66")
	input_style.set_border_width_all(1)
	input_style.set_corner_radius_all(12)
	input_style.set_content_margin_all(12)
	premium.set_stylebox("normal", "LineEdit", input_style)
	premium.set_stylebox("focus", "LineEdit", input_style)
	premium.set_stylebox("normal", "SpinBox", input_style)
	premium.set_stylebox("focus", "SpinBox", input_style)

	var button_normal := _button_style("#d9b45f")
	button_normal.border_color = Color("#8f733b")
	button_normal.set_border_width_all(1)
	premium.set_stylebox("normal", "Button", button_normal)
	premium.set_stylebox("hover", "Button", _button_style("#30435a"))
	premium.set_stylebox("pressed", "Button", _button_style("#b18b43"))
	premium.set_stylebox("disabled", "Button", _button_style("#24354a"))

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#101e30")
	panel_style.border_color = Color("#2d425b")
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(18)
	panel_style.set_content_margin_all(15)
	panel_style.shadow_color = Color(0.01, 0.025, 0.06, 0.32)
	panel_style.shadow_size = 6
	panel_style.shadow_offset = Vector2(0, 3)
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
	root.offset_left = 10
	root.offset_top = 9
	root.offset_right = -10
	root.offset_bottom = -9
	root.add_theme_constant_override("separation", 8)
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
	# Gentle live accent animation, kept subtle so it does not distract from reading.
	var accent_pulse := create_tween().set_loops()
	accent_pulse.tween_property(header_rule, "modulate:a", 0.62, 1.35).from(1.0)
	accent_pulse.tween_property(header_rule, "modulate:a", 1.0, 1.35)

	page_content_scroll = ScrollContainer.new()
	var content_scroll := page_content_scroll
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
	dashboard_box.tab_changed.connect(_on_dashboard_tab_changed)
	# Clamp every page descendant to the available viewport width. Without this,
	# intrinsic minimum widths from nested cards/labels can widen the disabled-
	# horizontal-scroll content and push the right edge off Android screens.
	_constrain_page_width(page_content_scroll)

	_build_bottom_navigation(root)

func _constrain_page_width(node: Node) -> void:
	# Keep nested election tabs, cards, and their controls within the page viewport.
	if node is Control:
		var control := node as Control
		control.custom_minimum_size = Vector2(0.0, control.custom_minimum_size.y)
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if control is Label:
			(control as Label).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if control is ScrollContainer or control is TabContainer:
			control.clip_contents = true
	for child in node.get_children():
		_constrain_page_width(child)

func _input(event: InputEvent) -> void:
	# Capture Android touch drags at viewport level so nested cards and tab
	# controls cannot swallow scrolling. Taps are not consumed.
	if not is_instance_valid(page_content_scroll) or not page_content_scroll.visible:
		return
	var page_rect := page_content_scroll.get_global_rect()
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if page_rect.has_point(touch.position):
				_page_touch_index = touch.index
				_page_touch_last_y = touch.position.y
				_page_touch_start_y = touch.position.y
				_page_touch_dragging = false
		elif touch.index == _page_touch_index:
			_page_touch_index = -1
			_page_touch_dragging = false
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index != _page_touch_index:
			return
		if not _page_touch_dragging and absf(drag.position.y - _page_touch_start_y) < 8.0:
			return
		_page_touch_dragging = true
		var delta_y := drag.position.y - _page_touch_last_y
		_page_touch_last_y = drag.position.y
		var bar := page_content_scroll.get_v_scroll_bar()
		var max_scroll := maxi(0, int(round(bar.max_value - bar.page)))
		page_content_scroll.scroll_vertical = clampi(page_content_scroll.scroll_vertical - int(round(delta_y)), 0, max_scroll)
		get_viewport().set_input_as_handled()

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
	main_tab_bar.custom_minimum_size = Vector2(0, 72)
	main_tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_tab_bar.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_tab_bar.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_tab_bar.add_theme_stylebox_override("panel", _button_style("#0d1a2b"))
	main_tab_bar.size_flags_vertical = Control.SIZE_SHRINK_END
	main_tab_bar.visible = false
	parent.add_child(main_tab_bar)

	var nav_row := HBoxContainer.new()
	nav_row.add_theme_constant_override("separation", 7)
	nav_row.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	main_tab_bar.add_child(nav_row)

	# Compact icon-led navigation; labels remain visible for clarity on phones.
	var tab_names: Array[String] = [
		"⌂\nHOME", "◷\nCAREER", "♟\nPARTY", "▤\nELECTIONS",
		"▦\nDISTRICT", "▣\nOFFICE", "▥\nREPORTS", "◎\nINDIA MAP"
	]
	for index in range(tab_names.size()):
		var tab_button := Button.new()
		tab_button.text = tab_names[index]
		tab_button.custom_minimum_size = Vector2(86, 58)
		tab_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tab_button.add_theme_font_size_override("font_size", 10)
		tab_button.add_theme_stylebox_override("normal", _nav_button_style(false))
		tab_button.add_theme_stylebox_override("hover", _nav_button_style(true))
		tab_button.add_theme_stylebox_override("pressed", _nav_button_style(true))
		tab_button.add_theme_color_override("font_color", Color("#b9c7d8"))
		tab_button.add_theme_color_override("font_hover_color", Color("#fff5d7"))
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
		_update_bottom_navigation()
		return
	# Switch pages immediately. The previous fade tween delayed input feedback and
	# could leave the bottom navigation highlighting the old page on mobile.
	dashboard_box.current_tab = target_index
	_update_bottom_navigation()

func _on_dashboard_tab_changed(_index: int) -> void:
	_update_bottom_navigation()
	if _get_current_page_name() == "India Map" and is_instance_valid(world) and world.career_started:
		_refresh_india_map()

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
	_add_section_title(overview, "COMMAND CENTER")
	_add_body(overview, "Jump to the areas that need your attention. Your political authority and available actions depend on your current elected or party role.")
	var command_row := GridContainer.new()
	command_row.name = "CommandCenterActions"
	command_row.columns = 2
	command_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	command_row.add_theme_constant_override("h_separation", 8)
	command_row.add_theme_constant_override("v_separation", 8)
	overview.add_child(command_row)
	var party_action := Button.new()
	party_action.text = "♟  PARTY\nManage members"
	party_action.custom_minimum_size = Vector2(0, 62)
	party_action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	party_action.add_theme_font_size_override("font_size", 12)
	party_action.add_theme_stylebox_override("normal", _nav_button_style(false))
	party_action.pressed.connect(_select_main_tab.bind(2))
	command_row.add_child(party_action)
	var election_action := Button.new()
	election_action.text = "▤  ELECTIONS\nReview contests"
	election_action.custom_minimum_size = Vector2(0, 62)
	election_action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	election_action.add_theme_font_size_override("font_size", 12)
	election_action.add_theme_stylebox_override("normal", _nav_button_style(false))
	election_action.pressed.connect(_select_main_tab.bind(3))
	command_row.add_child(election_action)
	var map_action := Button.new()
	map_action.text = "◎  INDIA MAP\nExplore states"
	map_action.custom_minimum_size = Vector2(0, 62)
	map_action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_action.add_theme_font_size_override("font_size", 12)
	map_action.add_theme_stylebox_override("normal", _nav_button_style(false))
	map_action.pressed.connect(_select_main_tab.bind(7))
	command_row.add_child(map_action)
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
	var career_profile_label := _add_body(career_profile, "Your career profile will appear here.")
	career_profile_label.name = "CareerProfileDetails"
	var career_actions := _new_tab(career_tabs, "Activities")
	_add_section_title(career_actions, "BUILD YOUR CAREER")
	_add_body(career_actions, "Activities improve your standing over time. Your current political role limits what you can do.")
	_add_button(career_actions, "Volunteer in a local campaign", func(): _run_activity("volunteer"))
	_add_button(career_actions, "Organize community service", func(): _run_activity("community"))
	_add_button(career_actions, "Attend a party meeting", func(): _run_activity("meeting"))
	career_activity_feedback = _add_body(career_actions, "Activity results will appear here after you take an action.")
	career_activity_feedback.name = "CareerActivityFeedback"

	var party_page := _new_tab(dashboard_box, "Party")
	_add_section_title(party_page, "PARTY ORGANIZATION")
	party_page_summary = _add_page_summary(party_page, "PARTY AT A GLANCE", "Your organization", "Membership, party standing, leadership role, and finances.")
	var party_tabs := TabContainer.new()
	party_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	party_page.add_child(party_tabs)
	var party_profile := _new_tab(party_tabs, "Overview")
	_add_section_title(party_profile, "YOUR PARTY")
	var party_overview_details := _add_body(party_profile, "Your organization overview will appear here.")
	party_overview_details.name = "PartyOverviewDetails"
	_add_button(party_profile, "Recruit party members", func(): _run_activity("recruit"))

	var party_members := _new_tab(party_tabs, "Members")
	_add_section_title(party_members, "PARTY MEMBERS")
	_add_body(party_members, "Fictional Indian political members. Add members and manage party leadership through Constitution.")
	party_member_name_input = _add_line_input(party_members, "Member name", "Enter a fictional member name")
	party_member_state_picker = OptionButton.new()
	party_member_state_picker.custom_minimum_size = Vector2(0, 44)
	for state_name in ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"]:
		party_member_state_picker.add_item(state_name)
	party_member_state_picker.select(10)
	party_members.add_child(party_member_state_picker)
	_add_button(party_members, "ADD MEMBER", _on_add_party_member)
	party_member_status = _add_body(party_members, "")
	party_member_search = _add_line_input(party_members, "Search members", "Search by name or member ID")
	party_member_search.text_changed.connect(func(_value: String): _refresh_party_members())
	_add_section_title(party_members, "REGIONAL ORGANIZATION")
	organization_summary_label = _add_body(party_members, "Regional coverage and duty distribution will appear here.")
	_add_section_title(party_members, "STATE ORGANIZATION COMMAND")
	_add_body(party_members, "Choose a state to inspect its ground network. Assigning members to state-level roles builds a measurable organization score and can improve your party’s modeled State Assembly election score by up to 2.5 points. It does not guarantee a victory.")
	organization_state_picker = OptionButton.new()
	organization_state_picker.custom_minimum_size = Vector2(0, 44)
	organization_state_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var organization_states: Array[String] = []
	for state_election_variant in world.world_state.get("state_elections", []):
		if state_election_variant is Dictionary:
			var organization_state := str(state_election_variant.get("state", ""))
			if not organization_state.is_empty():
				organization_states.append(organization_state)
	organization_states.sort_custom(func(a: String, b: String) -> bool:
		if a == "Karnataka" and b != "Karnataka":
			return true
		if b == "Karnataka":
			return false
		return a.naturalcasecmp_to(b) < 0
	)
	for organization_state in organization_states:
		organization_state_picker.add_item(organization_state)
	if organization_state_picker.item_count > 0:
		organization_state_picker.select(0)
	organization_state_picker.item_selected.connect(func(_index: int): _refresh_organization_profile())
	party_members.add_child(organization_state_picker)
	organization_profile_label = _add_body(party_members, "Select a state to inspect its organization network.")
	_add_section_title(party_members, "ASSIGN MEMBER TO STATE & DUTY")
	organization_member_picker = OptionButton.new()
	organization_member_picker.custom_minimum_size = Vector2(0, 44)
	organization_member_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	party_members.add_child(organization_member_picker)
	organization_duty_picker = OptionButton.new()
	organization_duty_picker.custom_minimum_size = Vector2(0, 44)
	organization_duty_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for duty in ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary", "State Organizer"]:
		organization_duty_picker.add_item(duty)
	party_members.add_child(organization_duty_picker)
	_add_button(party_members, "ASSIGN SELECTED MEMBER TO THIS STATE & DUTY", _on_assign_organization_duty)
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
	_add_section_title(elections_page, "ELECTIONS")
	election_page_summary = _add_page_summary(elections_page, "NEXT POLL / CURRENT PHASE", "Election briefing", "Schedules, campaign actions, and results are grouped by election type.")
	var election_tabs := TabContainer.new()
	election_tabs.name = "ElectionWorkspace"
	election_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	election_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	elections_page.add_child(election_tabs)

	var local_elections := _new_tab(election_tabs, "Local")
	_add_section_title(local_elections, "PERSONAL LOCAL CONTEST")
	var local_card := _new_election_card(local_elections, "Your constituency", "Personal ticket and campaign actions")
	election_detail_labels["local"] = _add_body(local_card, "")
	var local_ticket_button_text := "SELECT MYSELF AS LOCAL CANDIDATE" if world.player_role in ["Party President", "Founding President"] else "REQUEST LOCAL TICKET"
	_add_button(local_card, local_ticket_button_text, func(): _run_activity("request_ticket"))
	_add_button(local_card, "CAMPAIGN", func(): _run_activity("campaign"))
	_add_info_card(local_elections, "Model scope", "Local contests represent district-level local administration, not every individual ward or municipality.", "Party-wide local nominees are handled separately.")

	var high_command_page := _new_tab(party_tabs, "High Command")
	_add_section_title(high_command_page, "PARTY-WIDE STRATEGY")
	var command_card := _new_election_card(high_command_page, "High Command status", "Party-wide candidate deployment and campaign coordination")
	election_detail_labels["high_command"] = _add_body(command_card, "")
	var strategy_card := _new_election_card(high_command_page, "Campaign strategy", "Set the party’s monthly direction and spending ceiling")
	_add_body(strategy_card, "Priority")
	high_command_priority = OptionButton.new()
	high_command_priority.custom_minimum_size = Vector2(0, 44)
	high_command_priority.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for priority in ["Balanced outreach", "Jobs & economy", "Public services", "Rural development", "Welfare & inclusion", "Infrastructure", "Public safety", "Youth engagement"]:
		high_command_priority.add_item(priority)
	strategy_card.add_child(high_command_priority)
	_add_body(strategy_card, "Priority state for the next campaign cycle")
	high_command_focus = OptionButton.new()
	high_command_focus.custom_minimum_size = Vector2(0, 44)
	high_command_focus.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for focus_state in ["No state focus", "Karnataka", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"]:
		high_command_focus.add_item(focus_state)
	strategy_card.add_child(high_command_focus)
	_add_body(strategy_card, "Focused state receives a modest campaign score advantage when your party spends during its election campaign. This does not guarantee seats.")
	_add_body(strategy_card, "Monthly campaign spending ceiling (₹ crore)")
	high_command_budget = SpinBox.new()
	high_command_budget.min_value = 0
	high_command_budget.max_value = 200
	high_command_budget.step = 0.5
	high_command_budget.value = 5
	high_command_budget.custom_minimum_size = Vector2(0, 44)
	high_command_budget.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	strategy_card.add_child(high_command_budget)
	_add_body(strategy_card, "Coalition preference")
	high_command_coalition = OptionButton.new()
	high_command_coalition.custom_minimum_size = Vector2(0, 44)
	high_command_coalition.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for policy in ["Negotiate a working majority", "Prefer single-party government", "Avoid coalition agreements"]:
		high_command_coalition.add_item(policy)
	strategy_card.add_child(high_command_coalition)
	high_command_status = _add_body(strategy_card, "")
	_add_button(strategy_card, "SAVE PARTY DIRECTIVE", _on_save_high_command_policy)
	var review_card := _new_election_card(high_command_page, "Strategic performance review", "A persistent month-by-month record of party resources, organization, support, and election deployment")
	high_command_analytics_label = _add_body(review_card, "Your first monthly review will appear after advancing the simulation.")
	var candidate_review_card := _new_election_card(high_command_page, "Karnataka candidate review", "Review the party nominee assigned to each Assembly constituency")
	karnataka_candidate_summary = _add_body(candidate_review_card, "")
	_add_body(candidate_review_card, "Search nominees by name or constituency, review the selected ticket, then approve or reject. Bulk approval approves all currently pending tickets. Enable contesting to enter the next Karnataka Assembly election on behalf of your party; only approved tickets are eligible.")
	karnataka_candidate_picker = OptionButton.new()
	karnataka_candidate_picker.custom_minimum_size = Vector2(0, 48)
	karnataka_candidate_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	candidate_review_card.add_child(karnataka_candidate_picker)
	karnataka_candidate_picker.item_selected.connect(func(_index: int): _update_karnataka_candidate_detail())
	karnataka_candidate_status = _add_body(candidate_review_card, "")
	karnataka_candidate_search = _add_line_input(candidate_review_card, "Search constituency", "Find a Karnataka Assembly seat")
	karnataka_candidate_search.text_changed.connect(func(_value: String): _refresh_karnataka_candidate_review())
	_add_body(candidate_review_card, "FILTER TICKETS BY REVIEW STATUS")
	karnataka_candidate_filter = OptionButton.new()
	karnataka_candidate_filter.custom_minimum_size = Vector2(0, 44)
	karnataka_candidate_filter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for filter_label in ["All tickets", "Rejected only", "Pending only", "Approved only"]:
		karnataka_candidate_filter.add_item(filter_label)
	candidate_review_card.add_child(karnataka_candidate_filter)
	karnataka_candidate_filter.item_selected.connect(func(_index: int): _refresh_karnataka_candidate_review())
	_add_body(candidate_review_card, "PARTY MEMBER NOMINATION — choose a constituency above, then search your party roster below.")
	karnataka_member_search = _add_line_input(candidate_review_card, "Search party member by name", "Type a party member's name")
	karnataka_member_search.text_changed.connect(func(_value: String): _refresh_karnataka_member_picker())
	karnataka_member_picker = OptionButton.new()
	karnataka_member_picker.custom_minimum_size = Vector2(0, 48)
	karnataka_member_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	candidate_review_card.add_child(karnataka_member_picker)
	_add_button(candidate_review_card, "ASSIGN SELECTED PARTY MEMBER TO CONSTITUENCY", _on_assign_karnataka_candidate)
	_add_button(candidate_review_card, "APPROVE SELECTED", _on_approve_karnataka_candidate)
	_add_button(candidate_review_card, "REJECT SELECTED", _on_reject_karnataka_candidate)
	_add_button(candidate_review_card, "RESET SELECTED TO PENDING", _on_reset_karnataka_candidate)
	_add_button(candidate_review_card, "BULK APPROVE ALL PENDING", _on_bulk_approve_karnataka_candidates)
	karnataka_candidate_contest_status = _add_body(candidate_review_card, "")
	_add_button(candidate_review_card, "TOGGLE KARNATAKA ASSEMBLY CONTEST", _on_toggle_karnataka_contest)

	_add_info_card(high_command_page, "WHAT HAPPENS AFTER YOU SAVE", "Your directive is stored in this career save and remains active until you change it. The monthly ceiling is a limit, not an automatic payment; actual spending is recorded separately when campaign activity occurs.", "Candidate nominations and routine party operations follow the directive. Results, elected seats, and government formation are reported in their respective election tabs. Saving does not instantly spend money or appoint anyone to public office.")

	var other_states_elections := _new_tab(election_tabs, "State Assemblies")
	_add_section_title(other_states_elections, "STATE ASSEMBLIES  ·  INDIA")
	_add_body(other_states_elections, "Karnataka is shown first. Each state briefing separates election timing, party support, candidate coverage, campaign spending, result, and current government. Figures appear only when recorded in your career save.")
	var state_card := _new_election_card(other_states_elections, "State performance", "Your party’s footprint across every modeled state")
	var state_overview := _add_body(state_card, "")
	state_overview.text = "KARNATAKA FIRST  ·  STATE-BY-STATE BRIEFING"
	state_overview.add_theme_color_override("font_color", Color("#d6b15a"))
	state_overview.add_theme_font_size_override("font_size", 12)
	state_election_cards = VBoxContainer.new()
	state_election_cards.name = "StateElectionCards"
	state_election_cards.add_theme_constant_override("separation", 12)
	state_election_cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	state_election_cards.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	state_card.add_child(state_election_cards)

	var national_elections := _new_tab(election_tabs, "Lok Sabha")
	_add_section_title(national_elections, "LOK SABHA")
	var national_card := _new_election_card(national_elections, "National election tracker", "Constituency coverage, polling, count, and government formation")
	election_detail_labels["national"] = _add_body(national_card, "")



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
	for layer_name in ["Political control", "Development index", "Political influence", "Political power", "Economy", "Population", "Public welfare", "Infrastructure", "Election performance", "Public approval", "Social indicators", "Law & order"]:
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
	_add_body(india_map_page, "MAP KEY: Choose a layer to compare recorded political and administration indicators. Navy means no recorded data; gold marks the selected district. Population remains unavailable until the simulation includes population records.")
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
	_add_section_title(reports_page, "GOVERNMENTS & ADMINISTRATION")
	government_summary_label = _add_body(reports_page, "Union, state, and local administrations are led by recorded office-holders and governing parties. Your party’s authority depends on your elected office.")
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
	style.bg_color = Color("#101d2e")
	style.border_color = Color("#30445d")
	style.set_border_width_all(1)
	style.border_width_left = 3
	style.set_corner_radius_all(18)
	style.set_content_margin_all(19)
	style.shadow_color = Color(0.02, 0.06, 0.12, 0.32)
	style.shadow_size = 5
	style.shadow_offset = Vector2(0, 3)
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
	report_label.text = "\n".join(PackedStringArray(world.notifications))
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

func _new_election_card(parent: VBoxContainer, title_text: String, subtitle_text: String) -> VBoxContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _card_style())
	parent.add_child(panel)
	var body := VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 9)
	panel.add_child(body)
	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 17)
	title.add_theme_color_override("font_color", Color("#e7edf6"))
	body.add_child(title)
	var subtitle := Label.new()
	subtitle.text = subtitle_text
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 12)
	subtitle.add_theme_color_override("font_color", Color("#91a4ba"))
	body.add_child(subtitle)
	_configure_touch_scroll_passthrough(panel)
	return body

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
	var activity_result := PackedStringArray(world.perform_activity(activity))
	var result_text := "\n".join(activity_result)
	report_label.text = result_text
	if is_instance_valid(career_activity_feedback):
		career_activity_feedback.text = result_text
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
		if world.apply_player_party_fund_grant_once():
			_save_progress()
		_refresh_overview_metrics()
		if is_instance_valid(career_page_summary):
			career_page_summary.text = world.career_summary()
		var career_profile_details := dashboard_box.find_child("CareerProfileDetails", true, false)
		if is_instance_valid(career_profile_details) and career_profile_details is Label:
			career_profile_details.text = world.career_summary() + "\n\nNEXT STEP\nChoose a Career Activity to build experience and reputation, or review Elections to pursue a public ticket."
		if is_instance_valid(party_page_summary):
			party_page_summary.text = world.party_summary()
		var party_overview_details := dashboard_box.find_child("PartyOverviewDetails", true, false)
		if is_instance_valid(party_overview_details) and party_overview_details is Label:
			party_overview_details.text = world.party_summary() + "\n\nORGANIZATION\nUse Members to manage the roster, Constitution to set leadership rules, and Finances to track personal, party, and campaign accounts."
		finance_label.text = world.finance_summary()
		if _get_current_page_name() == "Party":
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
			district_details.text = "Career rank: %s\nExperience: %d / 30\nReputation: %.1f / 10\nParty leadership relationship: %.1f / 20\nParty membership: %d / 50\nLocal responsibilities completed: %d / 3\nDistrict role: %s" % [
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
		if _get_current_page_name() == "India Map":
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
		if _get_current_page_name() == "India Map":
			_refresh_india_map()

func _refresh_india_map() -> void:
	if not is_instance_valid(india_map_grid) or not is_instance_valid(india_map_details):
		return
	var layer := india_map_layer_picker.get_item_text(india_map_layer_picker.selected) if is_instance_valid(india_map_layer_picker) else "Political control"
	if not world.career_started:
		india_map_grid.set_map_state(india_map_level, india_map_selected_state, india_map_selected_district, layer, {}, {}, {}, {}, {}, world.party_map_colors(), {})
		india_map_details.text = "INDIA POLITICAL ATLAS\nStart a political career to initialize Union, state, and district administrations. The map shows the supplied boundaries; political control appears after your career begins."
		_refresh_india_map_legend(layer, {}, {}, world.party_map_colors())
		return
	var winners: Dictionary = {}
	var supports: Dictionary = {}
	var seats: Dictionary = {}
	var phases: Dictionary = {}
	var map_metrics: Dictionary = {}
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
		map_metrics[state_name] = _india_map_government_metrics(government, state_name, election)
		seats[state_name] = int(election.get("assembly_seats", 0))
		phases[state_name] = str(election.get("phase", "No assembly election record"))
	var local_winners: Dictionary = world.local_government_party_map(india_map_selected_state if india_map_level > 0 else "")
	if india_map_level > 0:
		for district_key_variant in local_winners.keys():
			var district_key := str(district_key_variant)
			var parts := district_key.split("|", false, 2)
			if parts.size() != 2:
				continue
			var local_government: Dictionary = world.get_local_government(parts[0], parts[1])
			map_metrics[district_key] = _india_map_government_metrics(local_government, parts[0], {})
	var party_colors: Dictionary = world.party_map_colors()
	india_map_grid.set_map_state(
		india_map_level, india_map_selected_state, india_map_selected_district,
		layer, winners, supports, seats, phases, local_winners, party_colors, map_metrics
	)
	_refresh_india_map_legend(layer, winners, local_winners, party_colors)
	var state_election := _india_map_state_election(india_map_selected_state)
	if india_map_level == 0:
		india_map_breadcrumb.text = "INDIA  /  STATES & UNION TERRITORIES"
		india_map_details.text = "INDIA-WIDE BRIEFING\n%s\nTap a state boundary on the map to open its state government and district map." % world.national_government_briefing()
	elif india_map_level == 1:
		india_map_breadcrumb.text = "INDIA  /  %s  /  DISTRICTS" % india_map_selected_state.to_upper()
		india_map_details.text = _india_map_state_summary(india_map_selected_state, state_election, layer) + "\n\nTap a district boundary to view its recorded local administration."
	else:
		india_map_breadcrumb.text = "INDIA  /  %s  /  %s" % [india_map_selected_state.to_upper(), india_map_selected_district.to_upper()]
		india_map_details.text = "DISTRICT / LOCAL GOVERNMENT BRIEFING\n%s, %s\n\n%s\n\nBoundary source: supplied district GeoJSON. Local political control reflects the recorded governing party and election history." % [
			india_map_selected_district, india_map_selected_state,
			world.local_government_briefing(india_map_selected_state, india_map_selected_district)
		]
	india_map_details.text += "\n\nMAP LAYER\n" + _india_map_layer_summary(layer)

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
	else:
		for i in range(5):
			var low := i * 20
			var high := (i + 1) * 20
			var sample := (float(low) + float(high)) * 0.5 / 100.0
			_add_india_map_legend_item(Color("#263b54").lerp(Color("#d6b15a"), sample), "%d–%d / 100" % [low, high])
		_add_india_map_legend_item(Color("#263b54"), "No recorded data")
		if india_map_level == 2:
			_add_india_map_legend_item(Color("#f2d27b"), "Selected district")

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

func _india_map_tile_text(state_name: String, layer: String) -> String:
	var government: Dictionary = world.get_state_government(state_name)
	var election := _india_map_state_election(state_name)
	var metrics := _india_map_government_metrics(government, state_name, election)
	if layer != "Political control":
		var value := float(metrics.get(layer, -1.0))
		return "%s\n%s" % [state_name, "%.0f/100" % value if value >= 0.0 else "No data"]
	var party_id := str(government.get("ruling_party_id", ""))
	return "%s\n%s" % [state_name, _india_map_party_name(party_id) if not party_id.is_empty() else "No government"]

func _india_map_government_metrics(government: Dictionary, state_name: String, election: Dictionary) -> Dictionary:
	var performance: Dictionary = government.get("performance", {})
	var service := float(performance.get("service_delivery", -1.0))
	var welfare := float(performance.get("welfare", -1.0))
	var economy := float(performance.get("economy", -1.0))
	var infrastructure := float(performance.get("infrastructure", -1.0))
	var safety := float(performance.get("public_safety", -1.0))
	var approval := float(performance.get("public_approval", -1.0))
	var result: Dictionary = {
		"Development index": _average_available([service, welfare, economy, infrastructure, safety]),
		"Political influence": _india_map_support(state_name),
		"Economy": economy,
		"Public welfare": welfare,
		"Infrastructure": infrastructure,
		"Public approval": approval,
		"Social indicators": service,
		"Law & order": safety
	}
	var assembly_seats := int(election.get("assembly_seats", 0))
	var coalition_seats := int(government.get("coalition_seats", 0))
	result["Political power"] = float(coalition_seats) / float(assembly_seats) * 100.0 if assembly_seats > 0 and coalition_seats > 0 else -1.0
	result["Election performance"] = float(election.get("player_party_vote_share", -1.0))
	# Population is intentionally unavailable until the simulation stores population data.
	result["Population"] = -1.0
	return result

func _average_available(values: Array) -> float:
	var total := 0.0
	var count := 0
	for value_variant in values:
		var value := float(value_variant)
		if value >= 0.0:
			total += value
			count += 1
	return total / float(count) if count > 0 else -1.0

func _india_map_party_name(party_id: String) -> String:
	if world.parties.has(party_id):
		return str(world.parties[party_id].get("name", party_id))
	return party_id

func _india_map_layer_summary(layer: String) -> String:
	match layer:
		"Development index":
			return "Composite of recorded economy, welfare, infrastructure, service delivery, and public-safety scores. Regions without these records are marked No data."
		"Political influence":
			return "Shows the strongest recorded regional party support, not a measure of legal authority."
		"Political power":
			return "Shows the governing coalition's recorded share of assembly seats where seat data exists."
		"Economy":
			return "Shows the recorded governing administration’s economy performance score."
		"Population":
			return "Population is not yet stored in this simulation, so regions show No data rather than invented figures."
		"Public welfare":
			return "Shows the recorded governing administration’s welfare performance score."
		"Infrastructure":
			return "Shows the recorded governing administration’s infrastructure performance score."
		"Election performance":
			return "Shows recorded player-party vote share when that value exists; otherwise the region is marked No data."
		"Public approval":
			return "Shows the recorded governing administration’s public-approval score."
		"Social indicators":
			return "Uses recorded service-delivery performance as the available social-services indicator."
		"Law & order":
			return "Shows the recorded governing administration’s public-safety score."
	return "Each region is coloured by its recorded ruling party. On state maps, district colours show the recorded local administration."

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
	var local_text := "AREA  %s\nCandidacy  %s\nNext poll  December %d\nLast result  %s\n\nLOCAL ADMINISTRATION\nRuling party  %s\nExecutive  %s\nNext modeled poll  %s %d\nLatest result  %s" % [
		world.local_election_area(),
		"You are contesting" if world.local_candidate_selected else ("Ticket requested" if world.ticket_requested else "No personal ticket selected"),
		world.local_election_year,
		world.last_local_election_result if world.last_local_election_year > 0 else "No personal result recorded",
		world._government_party_name(str(home_local_government.get("ruling_party_id", ""))),
		str(home_local_government.get("leader_name", "Office-holder not recorded")),
		world._month_name(int(home_local_government.get("next_election_month", 12))),
		int(home_local_government.get("next_election_year", world.year + 5)),
		str(home_local_government.get("last_local_election_result", "No district-local result recorded yet"))
	]
	if election_detail_labels.has("local") and is_instance_valid(election_detail_labels["local"]):
		election_detail_labels["local"].text = local_text

	var state_elections: Array = world.world_state.get("state_elections", [])
	_refresh_state_election_cards(state_elections)
	var high_command: Dictionary = world.world_state.get("high_command", {})
	if is_instance_valid(high_command_status):
		high_command_status.text = world.high_command_summary()
	_refresh_karnataka_candidate_review()
	if is_instance_valid(high_command_analytics_label):
		high_command_analytics_label.text = world.strategic_performance_summary()
	if is_instance_valid(high_command_readiness_label):
		high_command_readiness_label.text = world.election_readiness_summary()
	if is_instance_valid(high_command_budget):
		high_command_budget.value = float(int(high_command.get("monthly_campaign_budget", 500000000))) / 10000000.0
	if is_instance_valid(high_command_focus):
		var focus_value := str(high_command.get("campaign_focus_state", ""))
		var focus_label := focus_value if not focus_value.is_empty() else "No state focus"
		for fi in range(high_command_focus.item_count):
			if high_command_focus.get_item_text(fi) == focus_label:
				high_command_focus.select(fi)
				break
	if is_instance_valid(high_command_priority):
		var selected_priority := str(high_command.get("strategy", "Balanced outreach"))
		for pi in range(high_command_priority.item_count):
			if high_command_priority.get_item_text(pi) == selected_priority:
				high_command_priority.select(pi)
				break
	if is_instance_valid(high_command_coalition):
		var selected_coalition := str(high_command.get("coalition_policy", "Negotiate a working majority"))
		for ci in range(high_command_coalition.item_count):
			if high_command_coalition.get_item_text(ci) == selected_coalition:
				high_command_coalition.select(ci)
				break
	var national: Dictionary = world.world_state.get("national_election", {})
	if election_detail_labels.has("national") and is_instance_valid(election_detail_labels["national"]):
		var union_government: Dictionary = world.get_national_government()
		election_detail_labels["national"].text = "NEXT POLL  %s %d  ·  %s\nConstituencies  %d\nParty candidates  %d contested / %d elected\nLast eligible voters  %d  ·  Ballots cast  %d\nLast result  %s\n\nGOVERNMENT\nRuling party  %s\nExecutive leader  %s\nGovernment type  %s" % [
			world._month_name(int(national.get("month", 5))), int(national.get("next_year", 2029)),
			str(national.get("phase", "Scheduled")), int(national.get("seats", 543)),
			int(national.get("player_party_candidates_contested", 0)),
			int(national.get("player_party_candidates_elected", 0)),
			int(national.get("last_eligible_voters", 0)), int(national.get("last_ballots_cast", 0)),
			str(national.get("last_result", "Not yet held")),
			world._government_party_name(str(union_government.get("ruling_party_id", ""))),
			str(union_government.get("leader_name", "Leader not recorded")),
			str(union_government.get("formation_type", "Coalition administration"))
		]

func _refresh_state_election_cards(state_elections: Array) -> void:
	if not is_instance_valid(state_election_cards):
		return
	for child in state_election_cards.get_children():
		state_election_cards.remove_child(child)
		child.queue_free()

	var ordered: Array = state_elections.duplicate(true)
	ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var a_state := str(a.get("state", ""))
		var b_state := str(b.get("state", ""))
		if a_state == "Karnataka":
			return true
		if b_state == "Karnataka":
			return false
		return a_state.naturalcasecmp_to(b_state) < 0
	)

	for election_variant in ordered:
		if not election_variant is Dictionary:
			continue
		var election: Dictionary = election_variant
		var state_name := str(election.get("state", "Unknown state"))
		var is_home := state_name == "Karnataka"
		var state_government: Dictionary = world.get_state_government(state_name)
		var state_seats := int(election.get("assembly_seats", 0))
		var poll_month := int(election.get("month", 1))
		var poll_year := int(election.get("next_year", world.year))
		var phase := str(election.get("phase", "Scheduled"))
		var contested := int(election.get("player_party_candidates_contested", 0))
		var elected := int(election.get("player_party_candidates_elected", 0))
		var regional_support: Dictionary = world.world_state.get("regional_support", {})
		var support_by_party: Dictionary = regional_support.get(world.player_party_id, {})
		var support := float(support_by_party.get(state_name, 0.0))
		var organization_profile: Dictionary = world.party_organization_profile(state_name)
		var organization_score := int(organization_profile.get("readiness_score", 0))
		var organization_status := str(organization_profile.get("readiness", "No structure"))
		var organization_members := int(organization_profile.get("member_count", 0))
		var last_organization_bonus := float(election.get("last_player_organization_bonus", 0.0))
		var has_recorded_election := int(election.get("last_year", -1)) >= 0
		var spend_by_party: Dictionary = election.get("campaign_spend_by_party", {})
		var current_spend := int(spend_by_party.get(world.player_party_id, 0))
		var last_spend_by_party: Dictionary = election.get("last_campaign_spending", {})
		var last_spend := int(last_spend_by_party.get(world.player_party_id, 0))
		var seats_by_party: Dictionary = election.get("last_seats", {})
		var party_seats := int(seats_by_party.get(world.player_party_id, 0))
		var vote_shares: Dictionary = election.get("last_vote_shares", {})
		var vote_share := float(vote_shares.get(world.player_party_id, 0.0))
		var last_result := str(election.get("last_result", "No result recorded yet"))
		var organization_bonus_text := "+%.2f score points" % last_organization_bonus if has_recorded_election else "Not recorded"
		var winner_name := world._government_party_name(str(election.get("last_winner", "")))
		var leader := str(state_government.get("leader_name", "Not recorded"))
		var ruling_party := world._government_party_name(str(state_government.get("ruling_party_id", "")))
		var priority := str(election.get("high_command_priority", "Balanced outreach"))
		var slate_status := "Slate approved" if bool(election.get("high_command_slate_approved", false)) else "Slate not approved"
		var turnout := float(election.get("last_turnout_percent", 0.0))
		var eligible := int(election.get("last_eligible_voters", 0))
		var ballots := int(election.get("last_ballots_cast", 0))
		var campaign_months := int(election.get("campaign_months_run", 0))
		var phase_icon := "●" if phase == "Campaigning" else ("✓" if phase == "Completed" else "◷")

		var card := PanelContainer.new()
		card.name = "State_" + state_name.replace(" ", "_")
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.mouse_filter = Control.MOUSE_FILTER_PASS
		var style := _card_style()
		style.bg_color = Color("#17283b") if is_home else Color("#101d2e")
		style.border_color = Color("#d6b15a") if is_home else Color("#2b4058")
		style.border_width_left = 4 if is_home else 2
		card.add_theme_stylebox_override("panel", style)
		state_election_cards.add_child(card)
		var body := VBoxContainer.new()
		body.add_theme_constant_override("separation", 7)
		card.add_child(body)

		var heading := HBoxContainer.new()
		heading.add_theme_constant_override("separation", 8)
		body.add_child(heading)
		var title := Label.new()
		title.text = ("★  " if is_home else "◆  ") + state_name
		title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		title.add_theme_font_size_override("font_size", 17 if is_home else 15)
		title.add_theme_color_override("font_color", Color("#f0d58c") if is_home else Color("#e7edf6"))
		heading.add_child(title)
		var phase_label := Label.new()
		phase_label.text = phase_icon + "  " + phase
		phase_label.add_theme_font_size_override("font_size", 12)
		phase_label.add_theme_color_override("font_color", Color("#d6b15a") if phase == "Campaigning" else Color("#aebed1"))
		heading.add_child(phase_label)

		var schedule := Label.new()
		schedule.text = "%d seats   ·   Next poll: %s %d   ·   %s" % [state_seats, world._month_name(poll_month), poll_year, slate_status]
		schedule.add_theme_color_override("font_color", Color("#aebed1"))
		schedule.add_theme_font_size_override("font_size", 12)
		body.add_child(schedule)

		var metrics := Label.new()
		metrics.text = "PARTY FOOTPRINT   Support %.1f%%   ·   Ground network %s (%d/100, %d members)   ·   Candidates %d contested / %d elected   ·   Seats last won %d" % [support, organization_status, organization_score, organization_members, contested, elected, party_seats]
		metrics.add_theme_color_override("font_color", Color("#e7edf6"))
		metrics.add_theme_font_size_override("font_size", 13)
		metrics.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(metrics)

		var campaign_line := Label.new()
		campaign_line.text = "CAMPAIGN FINANCE   %s   ·   Current spend ₹%s   ·   Previous campaign spend ₹%s   ·   Active months %d" % [priority, world._format_number(current_spend), world._format_number(last_spend), campaign_months]
		campaign_line.add_theme_color_override("font_color", Color("#aebed1"))
		campaign_line.add_theme_font_size_override("font_size", 12)
		campaign_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(campaign_line)

		var result_line := Label.new()
		result_line.text = "LAST RESULT   %s   ·   Winner: %s   ·   Party vote share %.1f%%   ·   Turnout %.1f%%" % [last_result, winner_name, vote_share, turnout]
		result_line.add_theme_color_override("font_color", Color("#aebed1"))
		result_line.add_theme_font_size_override("font_size", 12)
		result_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(result_line)

		var governance := Label.new()
		governance.text = "GOVERNMENT   Ruling party: %s   ·   Executive: %s   ·   Eligible voters: %s   ·   Ballots: %s" % [ruling_party, leader, world._format_number(eligible), world._format_number(ballots)]
		governance.add_theme_color_override("font_color", Color("#8196ad"))
		governance.add_theme_font_size_override("font_size", 11)
		governance.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(governance)

		var detail_toggle := Button.new()
		detail_toggle.text = "VIEW STATE DOSSIER  +"
		detail_toggle.alignment = HORIZONTAL_ALIGNMENT_LEFT
		detail_toggle.add_theme_color_override("font_color", Color("#e0c16b"))
		detail_toggle.add_theme_font_size_override("font_size", 12)
		body.add_child(detail_toggle)

		var dossier := PanelContainer.new()
		dossier.visible = false
		dossier.add_theme_stylebox_override("panel", _card_style())
		body.add_child(dossier)
		var dossier_body := VBoxContainer.new()
		dossier_body.add_theme_constant_override("separation", 6)
		dossier.add_child(dossier_body)
		var dossier_title := Label.new()
		dossier_title.text = "STATE DOSSIER  ·  " + state_name.to_upper()
		dossier_title.add_theme_color_override("font_color", Color("#f0d58c"))
		dossier_title.add_theme_font_size_override("font_size", 13)
		dossier_body.add_child(dossier_title)
		var dossier_text := Label.new()
		dossier_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dossier_text.text = "ELECTION\nNext poll: %s %d  ·  Phase: %s  ·  Assembly seats: %d\n\nPARTY ORGANIZATION\nSupport: %.1f%%  ·  Slate: %s\nGround network: %s  ·  Readiness %d/100  ·  Named members %d\nLast poll organization effect: %s\nCandidates contested: %d  ·  Elected: %d  ·  Seats last won: %d\n\nCAMPAIGN FINANCE\nCurrent campaign spend: ₹%s  ·  Previous campaign spend: ₹%s\nStrategy: %s  ·  Campaign months active: %d\n\nLAST RESULT\n%s\nWinner: %s  ·  Party vote share: %.1f%%  ·  Turnout: %.1f%%\n\nGOVERNMENT & PARTICIPATION\nRuling party: %s  ·  Executive: %s\nEligible voters: %s  ·  Ballots cast: %s" % [
			world._month_name(poll_month), poll_year, phase, state_seats,
			support, slate_status, organization_status, organization_score, organization_members, organization_bonus_text, contested, elected, party_seats,
			world._format_number(current_spend), world._format_number(last_spend),
			priority, campaign_months, last_result, winner_name, vote_share, turnout,
			ruling_party, leader, world._format_number(eligible), world._format_number(ballots)
		]
		dossier_text.text += "\n\n" + _state_close_contest_brief(election)
		dossier_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dossier_text.add_theme_color_override("font_color", Color("#c2cedc"))
		dossier_body.add_child(dossier_text)
		detail_toggle.pressed.connect(func() -> void:
			dossier.visible = not dossier.visible
			detail_toggle.text = "HIDE STATE DOSSIER  −" if dossier.visible else "VIEW STATE DOSSIER  +"
		)

		card.modulate.a = 0.0
		var tween := create_tween()
		tween.tween_property(card, "modulate:a", 1.0, 0.22)

func _state_close_contest_brief(election: Dictionary) -> String:
	var results: Array = election.get("last_constituency_results", [])
	if results.is_empty():
		return "CLOSE CONTESTS & TARGET SEATS\nNo constituency-level result has been recorded yet."
	var contests: Array[Dictionary] = []
	for result_variant in results:
		if not result_variant is Dictionary:
			continue
		var result: Dictionary = result_variant
		var candidates: Array = result.get("candidates", [])
		var player_row: Dictionary = {}
		var ordered: Array[Dictionary] = []
		for candidate_variant in candidates:
			if not candidate_variant is Dictionary:
				continue
			var candidate: Dictionary = candidate_variant
			ordered.append(candidate)
			if str(candidate.get("party_id", "")) == world.player_party_id:
				player_row = candidate
		if player_row.is_empty() or ordered.size() < 2:
			continue
		ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return float(a.get("vote_percent", 0.0)) > float(b.get("vote_percent", 0.0))
		)
		var top_share := float(ordered[0].get("vote_percent", 0.0))
		var second_share := float(ordered[1].get("vote_percent", 0.0))
		var margin := maxf(0.0, top_share - second_share)
		var won := str(result.get("winner_party_id", "")) == world.player_party_id
		contests.append({
			"constituency": str(result.get("constituency", "Constituency")),
			"margin": margin,
			"won": won,
			"player_share": float(player_row.get("vote_percent", 0.0)),
			"winner": str(ordered[0].get("party_name", "Leading party"))
		})
	if contests.is_empty():
		return "CLOSE CONTESTS & TARGET SEATS\nNo player-party constituency results are available."
	contests.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("margin", 100.0)) < float(b.get("margin", 100.0))
	)
	var lines: Array[String] = ["CLOSE CONTESTS & TARGET SEATS", "Closest modeled races, ordered by winning margin:"]
	for index in range(mini(5, contests.size())):
		var item: Dictionary = contests[index]
		var label := "DEFEND" if bool(item.get("won", false)) else "TARGET"
		lines.append("%s · %s · margin %.1f pts · party vote %.1f%% · winner %s" % [
			label, str(item.get("constituency", "Constituency")),
			float(item.get("margin", 0.0)), float(item.get("player_share", 0.0)),
			str(item.get("winner", ""))
		])
	return "\n".join(lines)


func _refresh_karnataka_candidate_review() -> void:
	if not is_instance_valid(karnataka_candidate_picker):
		return
	var rows := world.karnataka_candidate_review_rows()
	var query := karnataka_candidate_search.text.strip_edges().to_lower() if is_instance_valid(karnataka_candidate_search) else ""
	var previous_seat := _selected_karnataka_seat_number()
	var status_filter := karnataka_candidate_filter.selected if is_instance_valid(karnataka_candidate_filter) else 0
	karnataka_candidate_picker.clear()
	var approved := 0
	var rejected := 0
	for row in rows:
		var decision := str(row.get("decision", "Pending"))
		if decision == "Approved": approved += 1
		elif decision == "Rejected": rejected += 1
		if status_filter == 1 and decision != "Rejected":
			continue
		if status_filter == 2 and decision != "Pending":
			continue
		if status_filter == 3 and decision != "Approved":
			continue
		var candidate_name := str(row.get("candidate_name", ""))
		var constituency := str(row.get("constituency", ""))
		if not query.is_empty() and not candidate_name.to_lower().contains(query) and not constituency.to_lower().contains(query):
			continue
		var caption := "%03d  ·  %s  —  %s [%s]" % [int(row.get("seat_number", 0)), constituency, candidate_name, decision]
		karnataka_candidate_picker.add_item(caption)
		karnataka_candidate_picker.set_item_metadata(karnataka_candidate_picker.item_count - 1, int(row.get("seat_number", 0)))
	if karnataka_candidate_picker.item_count == 0:
		karnataka_candidate_status.text = "No tickets match this status and search. Choose All tickets or change your search."
	if karnataka_candidate_picker.item_count > 0:
		var selected_index := 0
		for item_index in range(karnataka_candidate_picker.item_count):
			if int(karnataka_candidate_picker.get_item_metadata(item_index)) == previous_seat:
				selected_index = item_index
				break
		karnataka_candidate_picker.select(selected_index)
	_update_karnataka_candidate_detail()
	if is_instance_valid(karnataka_candidate_summary):
		karnataka_candidate_summary.text = "KARNATAKA ASSEMBLY  ·  224 SEATS\nApproved  %d  ·  Rejected  %d  ·  Pending  %d\nChanges are saved automatically with this career." % [approved, rejected, 224 - approved - rejected]
	if is_instance_valid(karnataka_candidate_contest_status):
		var contest_enabled := world.is_karnataka_contest_enabled()
		karnataka_candidate_contest_status.text = "YOUR PARTY: %s the next Karnataka Assembly election. Approve the nominees you want to field, then keep contesting enabled." % ("ENTERED IN" if contest_enabled else "NOT ENTERED IN")
	_refresh_karnataka_member_picker()


func _refresh_karnataka_member_picker() -> void:
	if not is_instance_valid(karnataka_member_picker):
		return
	var query := karnataka_member_search.text.strip_edges().to_lower() if is_instance_valid(karnataka_member_search) else ""
	var previous_id := str(karnataka_member_picker.get_item_metadata(karnataka_member_picker.selected)) if karnataka_member_picker.selected >= 0 else ""
	karnataka_member_picker.clear()
	for member in world.karnataka_party_member_search(query):
		karnataka_member_picker.add_item(str(member.get("name", "Party member")))
		karnataka_member_picker.set_item_metadata(karnataka_member_picker.item_count - 1, str(member.get("id", "")))
		if str(member.get("id", "")) == previous_id:
			karnataka_member_picker.select(karnataka_member_picker.item_count - 1)
	if karnataka_member_picker.item_count > 0 and karnataka_member_picker.selected < 0:
		karnataka_member_picker.select(0)


func _on_assign_karnataka_candidate() -> void:
	if not is_instance_valid(karnataka_member_picker) or karnataka_member_picker.selected < 0:
		report_label.text = "Search for and select a party member first."
		return
	var member_id := str(karnataka_member_picker.get_item_metadata(karnataka_member_picker.selected))
	var result := world.assign_karnataka_candidate(_selected_karnataka_seat_number(), member_id)
	report_label.text = result
	_refresh()
	_save_progress()


func _selected_karnataka_seat_number() -> int:
	if not is_instance_valid(karnataka_candidate_picker) or karnataka_candidate_picker.selected < 0:
		return 0
	return int(karnataka_candidate_picker.get_item_metadata(karnataka_candidate_picker.selected))


func _update_karnataka_candidate_detail() -> void:
	if not is_instance_valid(karnataka_candidate_status) or not is_instance_valid(karnataka_candidate_picker):
		return
	if karnataka_candidate_picker.item_count == 0 or karnataka_candidate_picker.selected < 0:
		karnataka_candidate_status.text = "No tickets match this status and search. Choose All tickets or change your search."
		return
	var seat_number := _selected_karnataka_seat_number()
	var rows := world.karnataka_candidate_review_rows()
	var row: Dictionary = {}
	for candidate_row in rows:
		if int(candidate_row.get("seat_number", 0)) == seat_number:
			row = candidate_row
			break
	if row.is_empty():
		karnataka_candidate_status.text = "No matching nominee. Clear the search or choose another constituency."
		return
	karnataka_candidate_status.text = "CONSTITUENCY  %s\nASSIGNED PARTY MEMBER  %s\nREVIEW  %s\nChoose a member below to replace this nominee." % [str(row.get("constituency", "")), str(row.get("candidate_name", "")), str(row.get("decision", "Pending"))]


func _set_selected_karnataka_candidate_decision(decision: String) -> void:
	if not is_instance_valid(karnataka_candidate_picker) or karnataka_candidate_picker.selected < 0:
		return
	var result := world.set_karnataka_candidate_decision(_selected_karnataka_seat_number(), decision)
	report_label.text = result
	_refresh()
	_save_progress()

func _on_approve_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Approved")

func _on_reject_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Rejected")

func _on_reset_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Pending")

func _on_bulk_approve_karnataka_candidates() -> void:
	var result := world.bulk_approve_karnataka_candidates()
	report_label.text = result
	_refresh()
	_save_progress()

func _on_toggle_karnataka_contest() -> void:
	var result := world.toggle_karnataka_contest()
	report_label.text = result
	_refresh()
	_save_progress()

func _on_save_high_command_policy() -> void:
	var strategy := high_command_priority.get_item_text(high_command_priority.selected) if is_instance_valid(high_command_priority) else "Balanced outreach"
	var coalition_policy := high_command_coalition.get_item_text(high_command_coalition.selected) if is_instance_valid(high_command_coalition) else "Negotiate a working majority"
	var budget := int(round(high_command_budget.value * 10000000.0)) if is_instance_valid(high_command_budget) else 50000000
	var focus_state := high_command_focus.get_item_text(high_command_focus.selected) if is_instance_valid(high_command_focus) and high_command_focus.selected >= 0 else "No state focus"
	if focus_state == "No state focus":
		focus_state = ""
	var result: String = world.set_high_command_policy(strategy, budget, coalition_policy, focus_state)
	_refresh()
	if is_instance_valid(high_command_status):
		high_command_status.text = "DIRECTIVE SAVED TO THIS CAREER\n\n" + result + "\n\n" + world.high_command_summary() + "\n\nNEXT: Review candidate deployment and state results in State Assemblies; national candidate coverage and results are in Lok Sabha. The ceiling is not deducted immediately—recorded campaign actions determine actual expenditure."
	report_label.text = "Party directive saved. It is active for this career until changed."
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
	var selected_state := party_member_state_picker.get_item_text(party_member_state_picker.selected) if party_member_state_picker.item_count > 0 else world.home_state
	var result: String = world.add_party_member(member_name, selected_state)
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

func _on_assign_organization_duty() -> void:
	if not is_instance_valid(organization_member_picker) or organization_member_picker.item_count == 0 or organization_member_picker.selected < 0:
		party_member_status.text = "Add or recruit a member before assigning an organization duty."
		return
	var member_id := str(organization_member_picker.get_item_metadata(organization_member_picker.selected))
	var duty := organization_duty_picker.get_item_text(organization_duty_picker.selected) if is_instance_valid(organization_duty_picker) and organization_duty_picker.item_count > 0 else "Volunteer"
	var target_state := organization_state_picker.get_item_text(organization_state_picker.selected) if is_instance_valid(organization_state_picker) and organization_state_picker.selected >= 0 else world.home_state
	party_member_status.text = world.assign_party_member_organization(member_id, target_state, duty)
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
	var player_added_roster: Array = []
	var organization_roster: Array = []
	for roster_item in roster:
		var roster_member: Dictionary = roster_item
		if bool(roster_member.get("is_player_added", false)):
			player_added_roster.append(roster_member)
		else:
			organization_roster.append(roster_member)
	roster = player_added_roster + organization_roster
	if is_instance_valid(organization_member_picker):
		organization_member_picker.clear()
		var organization_query := party_member_search.text.strip_edges().to_lower() if is_instance_valid(party_member_search) else ""
		for member_variant in roster:
			var member: Dictionary = member_variant
			var member_name := str(member.get("name", "Member"))
			if organization_query.is_empty() or member_name.to_lower().contains(organization_query) or str(member.get("id", "")).to_lower().contains(organization_query):
				organization_member_picker.add_item("%s · %s" % [member_name, str(member.get("region", "Karnataka"))])
				organization_member_picker.set_item_metadata(organization_member_picker.item_count - 1, str(member.get("id", "")))
		if organization_member_picker.item_count > 0:
			organization_member_picker.select(0)
	var state_counts: Dictionary = {}
	var duty_counts: Dictionary = {}
	for member_variant in roster:
		var member: Dictionary = member_variant
		var region := str(member.get("region", "Karnataka"))
		var duty := str(member.get("duty", "Volunteer"))
		state_counts[region] = int(state_counts.get(region, 0)) + 1
		duty_counts[duty] = int(duty_counts.get(duty, 0)) + 1
	var state_names: Array = state_counts.keys()
	state_names.sort_custom(func(a: String, b: String) -> bool:
		if int(state_counts[a]) == int(state_counts[b]):
			return a < b
		return int(state_counts[a]) > int(state_counts[b])
	)
	var duty_names: Array = duty_counts.keys()
	duty_names.sort()
	var coverage_lines: Array[String] = ["Named roster: %d members across %d regions." % [roster.size(), state_counts.size()], "Regional coverage: %s" % (", ".join(PackedStringArray(state_names.slice(0, mini(6, state_names.size())))) if not state_names.is_empty() else "No regional records")]
	var duty_parts: Array[String] = []
	for duty_name in duty_names:
		duty_parts.append("%s %d" % [str(duty_name), int(duty_counts[duty_name])])
	coverage_lines.append("Duty mix: %s" % (" · ".join(PackedStringArray(duty_parts)) if not duty_parts.is_empty() else "No assignments"))
	if is_instance_valid(organization_summary_label):
		organization_summary_label.text = "\n".join(coverage_lines)
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
			detail.text = "%s  •  %s%s" % [str(member.get("duty", "Volunteer")), str(member.get("region", "Karnataka")), "  •  Added by you" if bool(member.get("is_player_added", false)) else ""]
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
			party_member_count_label.text = "Your manually added members appear first. Showing first 50 of %d members; search by name or ID to find others." % roster.size()
		else:
			party_member_count_label.text = "%d matching members" % matching_member_count
	if roster.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No named roster records yet. Add a member above."
		party_member_area.add_child(empty_label)
	_refresh_organization_profile()

func _refresh_organization_profile() -> void:
	if not is_instance_valid(organization_state_picker) or not is_instance_valid(organization_profile_label):
		return
	if organization_state_picker.selected < 0 or organization_state_picker.item_count == 0:
		organization_profile_label.text = "No state organization profile is available."
		return
	var state_name := organization_state_picker.get_item_text(organization_state_picker.selected)
	var profile: Dictionary = world.party_organization_profile(state_name)
	if profile.is_empty():
		organization_profile_label.text = "Join or found a party to build a regional organization."
		return
	var duties: Dictionary = profile.get("duty_counts", {})
	var role_order: Array[String] = ["State Organizer", "District Secretary", "Ward Organizer", "Booth Coordinator", "Media Coordinator", "Treasurer", "Volunteer"]
	var role_parts: Array[String] = []
	for role_name in role_order:
		var count := int(duties.get(role_name, 0))
		if count > 0:
			role_parts.append("%s %d" % [role_name, count])
	var priorities: Array = profile.get("priorities", [])
	var priority_text := ", ".join(PackedStringArray(priorities)) if not priorities.is_empty() else "Core structure is in place; maintain local coverage."
	organization_profile_label.text = "READINESS  %d/100  ·  %s\nNAMED MEMBERS  %d  ·  MODELED ELECTION-SCORE EFFECT  +%.2f points (maximum +2.50)\nROLE COVERAGE  %s\nNEXT ORGANIZATION PRIORITIES  %s" % [
		int(profile.get("readiness_score", 0)), str(profile.get("readiness", "No structure")),
		int(profile.get("member_count", 0)), float(profile.get("election_score_bonus", 0.0)),
		" · ".join(PackedStringArray(role_parts)) if not role_parts.is_empty() else "No assigned duties",
		priority_text
	]

func _notification(what: int) -> void:
	if not is_instance_valid(world) or not world.career_started:
		return
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		world.save_game()
