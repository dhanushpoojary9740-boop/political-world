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
var district_office_picker: OptionButton
var district_office_report: Label
var district_office_feedback: Label
var district_office_selected: String = "Udupi"
var assembly_office_state_picker: OptionButton
var assembly_office_constituency_picker: OptionButton
var assembly_office_report: Label
var assembly_office_feedback: Label
var assembly_office_selected_state: String = "Andhra Pradesh"
var assembly_office_selected_seat: int = 1
var career_page_summary: Label
var career_activity_feedback: Label
var party_page_summary: Label
var election_page_summary: Label
var report_label: Label
var automatic_records_label: Label
var inbox_list: VBoxContainer
var inbox_summary: Label
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
var member_details_search: LineEdit
var member_details_list: VBoxContainer
var member_details_dialog: AcceptDialog
var duty_member_search: LineEdit
var duty_member_picker: OptionButton
var duty_role_picker: OptionButton
var party_member_status: Label
var organization_summary_label: Label
var organization_state_picker: OptionButton
var organization_profile_label: Label
var organization_member_picker: OptionButton
var organization_member_search: LineEdit
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
var election_live_results_label: Label
var lok_sabha_polling_counting_label: Label
var election_recent_results_label: Label
var karnataka_formation_label: Label
var karnataka_formation_status: Label
var karnataka_coalition_list: ItemList
var karnataka_cm_picker: OptionButton
var karnataka_cabinet_pickers: Dictionary = {}
var karnataka_formation_dialog: ConfirmationDialog
var _last_karnataka_result_popup_key: String = ""
var election_command_center_label: Label
var election_command_center_progress: ProgressBar
var election_archive_tabs: TabContainer
var _election_results_render_key: String = ""
var _state_election_cards_render_key: String = ""
var _party_members_render_key: String = ""
var _member_details_render_key: String = ""
var _nav_style_cache: Dictionary = {}
var high_command_status: Label
var high_command_analytics_label: Label
var high_command_readiness_label: Label
var high_command_budget: SpinBox
var high_command_priority: OptionButton
var high_command_focus: OptionButton
var high_command_coalition: OptionButton
var karnataka_candidate_picker: OptionButton
var candidate_state_picker: OptionButton
var national_nomination_seat: OptionButton
var national_nomination_constituency_search: LineEdit
var national_nomination_bulk_confirm: ConfirmationDialog
var national_nomination_member_search: LineEdit
var national_nomination_member_picker: ItemList
var national_nomination_status: Label
var national_nomination_readiness: Label
var planner_state_picker: OptionButton
var karnataka_candidate_status: Label
var karnataka_candidate_summary: Label
var karnataka_candidate_search: LineEdit
var karnataka_candidate_filter: OptionButton
var karnataka_member_search: LineEdit
var karnataka_member_picker: ItemList
var karnataka_member_search_status: Label
var karnataka_assignment_status: Label
var karnataka_candidate_contest_status: Label
var karnataka_contest_toggle_button: Button
var constituency_plan_picker: OptionButton
var constituency_plan_search: LineEdit
var constituency_plan_priority: OptionButton
var constituency_plan_budget: SpinBox
var constituency_total_budget: SpinBox
var constituency_plan_detail: Label
var constituency_plan_summary: Label
var constituency_campaign_dashboard: Label
var statewide_campaign_status: Label
var campaign_activity_group: OptionButton
var campaign_activity_type: OptionButton
var campaign_activity_count: SpinBox
var campaign_activity_budget: SpinBox
var campaign_activity_summary: Label
var campaign_activity_plan_picker: OptionButton
var campaign_activity_status: OptionButton
var campaign_activity_actual_spend: SpinBox
var campaign_activity_management_summary: Label

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
var save_recovery_blocked: bool = false
var _tab_refresh_queued: bool = false

func _ready() -> void:
	world = WorldSimulationScript.new()
	world.initialize()
	var has_saved_game: bool = world.load_game()
	save_recovery_blocked = not has_saved_game and world.has_existing_save_data()
	_build_ui()
	_configure_touch_scroll_passthrough(self)
	if save_recovery_blocked:
		report_label.text = "EXISTING CAREER NEEDS RECOVERY. A save file was found but could not be loaded. Starting a new career is blocked to protect your data. Keep this project and its save files, then seek recovery before continuing."
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

func _build_premium_ambience() -> void:
	# Lightweight animated atmosphere behind the UI; no textures or external assets.
	var ambience := ColorRect.new()
	ambience.name = "PremiumAmbientBackground"
	ambience.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ambience.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var material := ShaderMaterial.new()
	var shader := Shader.new()
	shader.code = """
shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec2 uv = UV;
	float t = TIME * 0.10;
	vec2 gold_pos = vec2(0.16 + sin(t) * 0.12, 0.20 + cos(t * 0.73) * 0.10);
	vec2 blue_pos = vec2(0.88 + cos(t * 0.61) * 0.10, 0.78 + sin(t * 0.83) * 0.09);
	vec2 teal_pos = vec2(0.52 + sin(t * 0.42) * 0.15, 0.48 + cos(t * 0.55) * 0.13);

	float gold_glow = 1.0 - smoothstep(0.02, 0.78, distance(uv, gold_pos));
	float blue_glow = 1.0 - smoothstep(0.02, 0.88, distance(uv, blue_pos));
	float teal_glow = 1.0 - smoothstep(0.02, 0.70, distance(uv, teal_pos));
	float vertical_shade = smoothstep(0.0, 1.0, uv.y);

	vec3 base = mix(vec3(0.035, 0.065, 0.105), vec3(0.012, 0.025, 0.045), vertical_shade);
	vec3 gold = vec3(0.70, 0.43, 0.10) * gold_glow * 0.34;
	vec3 blue = vec3(0.05, 0.30, 0.48) * blue_glow * 0.42;
	vec3 teal = vec3(0.03, 0.22, 0.28) * teal_glow * 0.28;
	float shimmer = 0.5 + 0.5 * sin((uv.y * 2.0 + t * 0.18) * 6.28318);
	vec3 tint = base + gold + blue + teal + vec3(0.018, 0.025, 0.035) * shimmer;
	COLOR = vec4(tint, 1.0);
}
"""
	material.shader = shader
	ambience.material = material
	add_child(ambience)


func _build_ui() -> void:
	_apply_premium_theme()
	var background := ColorRect.new()
	background.color = Color("#081421")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	_build_premium_ambience()

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
	# Keep the header static; avoid a perpetual tween on low-power mobile rendering paths.

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
		"▣\nRESULTS", "▦\nPARTY ORG.", "▣\nOFFICE", "▥\nREPORTS", "◎\nINDIA MAP", "▤\nINBOX"
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
	return ["Overview", "Career", "Party", "Elections", "Election Results", "District", "Office", "Reports", "India Map", "Inbox"]


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
	if is_instance_valid(page):
		return str(page.name)
	return ""


func _restore_selected_page(page_name: String) -> void:
	if page_name.is_empty():
		return
	var target_index := _get_visible_tab_index(page_name)
	# Avoid assigning the same tab again during _refresh(). Setting current_tab
	# can emit tab_changed on some Godot paths, causing a nested refresh while
	# the Office page is rebuilding its cards and register.
	if target_index >= 0:
		if dashboard_box.current_tab != target_index:
			dashboard_box.current_tab = target_index
	elif dashboard_box.get_tab_count() > 0 and dashboard_box.current_tab != 0:
		dashboard_box.current_tab = 0
	_update_bottom_navigation()


func _select_main_tab(index: int) -> void:
	if not is_instance_valid(dashboard_box):
		return
	var page_names := _navigation_page_names()
	if index < 0 or index >= page_names.size():
		return
	var target_page_name := page_names[index]
	if target_page_name == "Office" and is_instance_valid(world) and not world.has_elected_office:
		return
	var target_index := _get_visible_tab_index(target_page_name)
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
	# Let the selected tab become visible before refreshing its content. If the
	# player taps several tabs quickly, coalesce those requests into one refresh
	# of the page that is selected when the deferred refresh runs.
	_queue_selected_tab_refresh()


func _queue_selected_tab_refresh() -> void:
	if _tab_refresh_queued:
		return
	_tab_refresh_queued = true
	call_deferred("_run_queued_tab_refresh")


func _run_queued_tab_refresh() -> void:
	# Wait until the next frame so tab selection and touch feedback can render
	# before a page performs its heavier content refresh.
	await get_tree().process_frame
	_tab_refresh_queued = false
	if is_instance_valid(world) and world.career_started:
		_refresh()

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
	var cache_key := "selected" if selected else "unselected"
	if _nav_style_cache.has(cache_key):
		return _nav_style_cache[cache_key] as StyleBoxFlat
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
	_nav_style_cache[cache_key] = style
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
	_add_button(party_profile, "Recruit through party organization", func(): _run_activity("recruit"))

	var party_members := _new_tab(party_tabs, "Members")
	var member_details_page := _new_tab(party_tabs, "Member Details")
	_add_section_title(member_details_page, "MEMBER DETAILS DIRECTORY")
	_add_body(member_details_page, "Search your party roster by name or member ID, then open a profile to review recorded party, organization, government, and election information.")
	member_details_search = _add_line_input(member_details_page, "Search members", "Name or member ID")
	member_details_search.text_changed.connect(func(_value: String): _refresh_member_details_directory())
	member_details_list = VBoxContainer.new()
	member_details_list.add_theme_constant_override("separation", 8)
	member_details_page.add_child(member_details_list)
	member_details_dialog = AcceptDialog.new()
	member_details_dialog.title = "Party Member Profile"
	member_details_dialog.dialog_text = "Member details"
	member_details_page.add_child(member_details_dialog)
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
	organization_member_search = _add_line_input(party_members, "Find a member to assign", "Search by member name or ID")
	organization_member_search.text_changed.connect(func(_value: String): _refresh_party_members())
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
	_add_section_title(party_finances, "PERSONAL, PARTY & CAMPsimulationGN ACCOUNTS")
	finance_label = _add_body(party_finances, "Financial accounts appear after your career begins.")
	_add_body(party_finances, "Personal cash, party funds, party debt, and election campaign spending are tracked separately. Values are a simplified game economy, not audited real-world party accounts.")

	var elections_page := _new_tab(dashboard_box, "Elections")
	_add_section_title(elections_page, "ELECTIONS")
	election_page_summary = _add_page_summary(elections_page, "NEXT POLL / CURRENT PHASE", "Election briefing", "Schedules and campaign actions are grouped by election type. Open the separate Election Results tab to review outcomes.")
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
	_add_button(local_card, "CAMPsimulationGN", func(): _run_activity("campaign"))
	_add_info_card(local_elections, "Model scope", "Local contests represent district-level local administration, not every individual ward or municipality.", "Party-wide local nominees are handled separately.")

	var planner_page := _new_tab(election_tabs, "Constituency Planner")
	_add_section_title(planner_page, "CONSTITUENCY INTELLIGENCE")
	_add_body(planner_page, "Prepare seat-by-seat plans for every state and union territory in the available constituency directory. Bulk setup distributes a total budget across every seat; individual allocations remain editable. Karnataka campaign execution is currently connected to the existing automated campaign system; other states can be planned here but are not yet launched through that system.")
	var planner_card := _new_election_card(planner_page, "Nationwide constituency campaign plan", "Select any state, then prepare all seat plans in one action or edit individual constituencies.")
	_add_body(planner_card, "SELECT STATE / UNION TERRITORY")
	planner_state_picker = OptionButton.new()
	planner_state_picker.custom_minimum_size = Vector2(0, 46)
	planner_state_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(planner_state_picker)
	_populate_assembly_state_picker(planner_state_picker, "Karnataka")
	planner_state_picker.item_selected.connect(func(_index: int): _refresh_constituency_planner())
	constituency_plan_summary = _add_body(planner_card, "Loading constituency plan…")
	_add_body(planner_card, "Search by constituency name or seat number")
	constituency_plan_search = LineEdit.new()
	constituency_plan_search.placeholder_text = "Search constituencies in selected state…"
	constituency_plan_search.clear_button_enabled = true
	constituency_plan_search.custom_minimum_size = Vector2(0, 44)
	constituency_plan_search.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(constituency_plan_search)
	constituency_plan_picker = OptionButton.new()
	constituency_plan_picker.custom_minimum_size = Vector2(0, 48)
	constituency_plan_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(constituency_plan_picker)
	_populate_constituency_plan_picker("")
	constituency_plan_search.text_changed.connect(func(query: String):
		_populate_constituency_plan_picker(query)
		_load_constituency_plan_controls()
	)
	constituency_plan_picker.item_selected.connect(func(_index: int): _load_constituency_plan_controls())
	constituency_plan_detail = _add_body(planner_card, "Select a seat to review its nominee and saved plan.")
	_add_body(planner_card, "Priority")
	constituency_plan_priority = OptionButton.new()
	constituency_plan_priority.custom_minimum_size = Vector2(0, 44)
	constituency_plan_priority.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for priority_label in ["Defend", "Target", "Low Priority"]:
		constituency_plan_priority.add_item(priority_label)
	planner_card.add_child(constituency_plan_priority)
	_add_body(planner_card, "Planned allocation (₹ crore)")
	constituency_plan_budget = SpinBox.new()
	constituency_plan_budget.min_value = 0
	constituency_plan_budget.max_value = 1000
	constituency_plan_budget.step = 0.1
	constituency_plan_budget.custom_minimum_size = Vector2(0, 44)
	constituency_plan_budget.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(constituency_plan_budget)
	_add_button(planner_card, "SAVE CONSTITUENCY PLAN", _save_constituency_plan)
	_add_body(planner_card, "Total statewide campaign budget (₹ crore)")
	constituency_total_budget = SpinBox.new()
	constituency_total_budget.min_value = 0
	constituency_total_budget.max_value = 100000
	constituency_total_budget.step = 1
	constituency_total_budget.value = 100
	constituency_total_budget.custom_minimum_size = Vector2(0, 44)
	constituency_total_budget.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(constituency_total_budget)
	_add_button(planner_card, "DISTRIBUTE TOTAL BUDGET ACROSS ALL CONSTITUENCIES", _auto_set_all_constituency_plans)
	_add_body(planner_card, "Actual seat spending is drawn from the statewide campaign budget. The funding split is 75% party treasury and 25% pooled member contributions. Defend seats receive a modestly higher share than Target; Low Priority receives less. Recorded spending gives a limited seat-specific campaign score bonus and never guarantees a win.")
	_add_body(planner_card, "CAMPAIGN PERFORMANCE · PLANNED VS RECORDED")
	constituency_campaign_dashboard = _add_body(planner_card, "No saved constituency plans yet.")
	_add_body(planner_card, "AUTOMATIC STATEWIDE CAMPAIGN")
	_add_body(planner_card, "Launch once to activate monthly campaign operations across the saved constituency plans. Teams use the High Command monthly ceiling; actual campaign costs are funded 75% by party funds and 25% by the member-contribution pool.")
	statewide_campaign_status = _add_body(planner_card, "Campaign not started.")
	_add_button(planner_card, "LAUNCH / PAUSE STATEWIDE CAMPAIGN", _toggle_statewide_campaign)

	_add_body(planner_card, "BULK CAMPAIGN ACTIVITY PLAN")
	_add_body(planner_card, "Schedule activities across a selected group of saved constituency plans. This records a plan only; it does not spend funds or change election results.")
	_add_body(planner_card, "Apply to constituency plans")
	campaign_activity_group = OptionButton.new()
	campaign_activity_group.custom_minimum_size = Vector2(0, 44)
	campaign_activity_group.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for group_label in ["All planned seats", "Defend seats", "Target seats", "Low Priority seats"]:
		campaign_activity_group.add_item(group_label)
	planner_card.add_child(campaign_activity_group)
	_add_body(planner_card, "Activity")
	campaign_activity_type = OptionButton.new()
	campaign_activity_type.custom_minimum_size = Vector2(0, 44)
	campaign_activity_type.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for activity_label in ["Candidate visit", "Public meeting", "Door-to-door drive"]:
		campaign_activity_type.add_item(activity_label)
	planner_card.add_child(campaign_activity_type)
	_add_body(planner_card, "Number of activities")
	campaign_activity_count = SpinBox.new()
	campaign_activity_count.min_value = 1
	campaign_activity_count.max_value = 224
	campaign_activity_count.step = 1
	campaign_activity_count.value = 10
	campaign_activity_count.custom_minimum_size = Vector2(0, 44)
	campaign_activity_count.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(campaign_activity_count)
	_add_body(planner_card, "Total planned budget (₹ crore)")
	campaign_activity_budget = SpinBox.new()
	campaign_activity_budget.min_value = 0
	campaign_activity_budget.max_value = 100
	campaign_activity_budget.step = 0.1
	campaign_activity_budget.custom_minimum_size = Vector2(0, 44)
	campaign_activity_budget.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(campaign_activity_budget)
	_add_button(planner_card, "CREATE BULK ACTIVITY PLAN", _create_bulk_campaign_activity_plan)
	campaign_activity_summary = _add_body(planner_card, "No bulk activity plans recorded yet.")

	_add_body(planner_card, "MANAGE SAVED ACTIVITY PLANS")
	_add_body(planner_card, "Select a plan to update its status or record actual spending. Actual spending is tracked separately and is not deducted from party funds by this control.")
	campaign_activity_plan_picker = OptionButton.new()
	campaign_activity_plan_picker.custom_minimum_size = Vector2(0, 44)
	campaign_activity_plan_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(campaign_activity_plan_picker)
	campaign_activity_plan_picker.item_selected.connect(_on_bulk_campaign_activity_plan_selected)
	_add_body(planner_card, "Plan status")
	campaign_activity_status = OptionButton.new()
	campaign_activity_status.custom_minimum_size = Vector2(0, 44)
	campaign_activity_status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for status_name in ["Planned", "In Progress", "Completed", "Cancelled"]:
		campaign_activity_status.add_item(status_name)
	planner_card.add_child(campaign_activity_status)
	_add_body(planner_card, "Actual spending (₹ crore)")
	campaign_activity_actual_spend = SpinBox.new()
	campaign_activity_actual_spend.min_value = 0
	campaign_activity_actual_spend.max_value = 100
	campaign_activity_actual_spend.step = 0.1
	campaign_activity_actual_spend.custom_minimum_size = Vector2(0, 44)
	campaign_activity_actual_spend.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	planner_card.add_child(campaign_activity_actual_spend)
	_add_button(planner_card, "SAVE PLAN STATUS & ACTUAL SPENDING", _save_bulk_campaign_activity_plan_management)
	campaign_activity_management_summary = _add_body(planner_card, "Select a saved plan to manage it.")


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
	var candidate_review_card := _new_election_card(high_command_page, "Nationwide candidate review", "Review and assign party nominees across state and union-territory Assembly constituencies")
	_add_body(candidate_review_card, "SELECT STATE / UNION TERRITORY")
	candidate_state_picker = OptionButton.new()
	candidate_state_picker.custom_minimum_size = Vector2(0, 46)
	candidate_state_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	candidate_review_card.add_child(candidate_state_picker)
	_populate_assembly_state_picker(candidate_state_picker, "Karnataka")
	candidate_state_picker.item_selected.connect(func(_index: int): _refresh_karnataka_candidate_review())
	karnataka_candidate_summary = _add_body(candidate_review_card, "")
	_add_body(candidate_review_card, "You are National High Command. Karnataka candidate assignment and approval remain under your direct control. In every other state, the state party president automatically assigns and approves Assembly tickets; you can review, reject, or replace any ticket here. The contest toggle below applies to Karnataka only.")
	karnataka_candidate_picker = OptionButton.new()
	karnataka_candidate_picker.custom_minimum_size = Vector2(0, 48)
	karnataka_candidate_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	candidate_review_card.add_child(karnataka_candidate_picker)
	karnataka_candidate_picker.item_selected.connect(func(_index: int): _update_karnataka_candidate_detail())
	karnataka_candidate_status = _add_body(candidate_review_card, "")
	karnataka_candidate_search = _add_line_input(candidate_review_card, "Search constituency", "Find a constituency in the selected state")
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
	karnataka_member_search_status = _add_body(candidate_review_card, "Type at least 2 characters to search the party roster.")
	karnataka_member_picker = ItemList.new()
	karnataka_member_picker.custom_minimum_size = Vector2(0, 160)
	karnataka_member_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	karnataka_member_picker.select_mode = ItemList.SELECT_SINGLE
	karnataka_member_picker.item_selected.connect(_on_karnataka_member_picker_selected)
	candidate_review_card.add_child(karnataka_member_picker)
	_add_button(candidate_review_card, "ASSIGN SELECTED PARTY MEMBER TO CONSTITUENCY", _on_assign_karnataka_candidate)
	karnataka_assignment_status = _add_body(candidate_review_card, "Assignment results will appear here.")
	_add_button(candidate_review_card, "APPROVE SELECTED", _on_approve_karnataka_candidate)
	_add_button(candidate_review_card, "REJECT SELECTED", _on_reject_karnataka_candidate)
	_add_button(candidate_review_card, "RESET SELECTED TO PENDING", _on_reset_karnataka_candidate)
	_add_button(candidate_review_card, "AUTO-ASSIGN ALL UNASSIGNED TICKETS", _on_bulk_assign_state_candidates)
	_add_button(candidate_review_card, "BULK APPROVE ALL PENDING", _on_bulk_approve_karnataka_candidates)
	karnataka_candidate_contest_status = _add_body(candidate_review_card, "")
	karnataka_contest_toggle_button = _add_button(candidate_review_card, "KARNATAKA ASSEMBLY CONTEST", _on_toggle_karnataka_contest)

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
	var national_nomination_card := _new_election_card(national_elections, "Lok Sabha ticket review", "Review and approve party nominees seat by seat before the national poll")
	_add_body(national_nomination_card, "NATIONAL TICKET READINESS")
	national_nomination_readiness = _add_body(national_nomination_card, "Checking nomination coverage…")
	_add_body(national_nomination_card, "SEARCH CONSTITUENCY")
	national_nomination_constituency_search = _add_line_input(national_nomination_card, "Name, seat number, or state", "Search the 543 Lok Sabha constituencies")
	national_nomination_constituency_search.text_changed.connect(func(_value: String): _refresh_lok_sabha_nomination_panel())
	_add_body(national_nomination_card, "CONSTITUENCY")
	national_nomination_seat = OptionButton.new()
	national_nomination_seat.custom_minimum_size = Vector2(0, 44)
	national_nomination_seat.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	national_nomination_card.add_child(national_nomination_seat)
	national_nomination_seat.item_selected.connect(func(_index: int): _refresh_lok_sabha_nomination_status())
	_add_body(national_nomination_card, "SEARCH PARTY MEMBER")
	national_nomination_member_search = _add_line_input(national_nomination_card, "Name or member ID", "Search your party roster")
	national_nomination_member_search.text_changed.connect(func(_value: String): _refresh_lok_sabha_nomination_members())
	national_nomination_member_picker = ItemList.new()
	national_nomination_member_picker.custom_minimum_size = Vector2(0, 150)
	national_nomination_member_picker.select_mode = ItemList.SELECT_SINGLE
	national_nomination_card.add_child(national_nomination_member_picker)
	national_nomination_status = _add_body(national_nomination_card, "Select a constituency to review its ticket.")
	_add_button(national_nomination_card, "ASSIGN SELECTED MEMBER", _on_assign_lok_sabha_candidate)
	_add_button(national_nomination_card, "APPROVE TICKET", func(): _set_lok_sabha_candidate_decision("Approved"))
	_add_button(national_nomination_card, "REJECT TICKET", func(): _set_lok_sabha_candidate_decision("Rejected"))
	_add_button(national_nomination_card, "RESET TO PENDING", func(): _set_lok_sabha_candidate_decision("Pending"))
	_add_button(national_nomination_card, "AUTO-ASSIGN ALL UNASSIGNED SEATS", _on_auto_assign_lok_sabha_candidates)
	_add_button(national_nomination_card, "BULK APPROVE ASSIGNED PENDING TICKETS", _on_bulk_approve_lok_sabha_candidates)
	national_nomination_bulk_confirm = ConfirmationDialog.new()
	national_nomination_bulk_confirm.title = "Bulk approve Lok Sabha tickets"
	national_nomination_bulk_confirm.dialog_text = "Approve all assigned tickets currently marked Pending? Unassigned tickets will remain pending."
	national_nomination_bulk_confirm.confirmed.connect(_confirm_bulk_approve_lok_sabha_candidates)
	national_nomination_card.add_child(national_nomination_bulk_confirm)

	# Election Results is a standalone dashboard destination, not nested under Elections.
	var election_results_page := _new_tab(dashboard_box, "Election Results")
	_add_section_title(election_results_page, "ELECTION RESULTS & COUNTING")
	_add_body(election_results_page, "Review recorded results separately from election scheduling and campaign management. Results update when the simulation advances; they are not real-world live counting.")
	var command_center_card := _new_election_card(election_results_page, "Election command center", "A premium overview of the modeled state assembly cycle")
	election_command_center_label = _add_body(command_center_card, "Waiting for election records…")
	election_command_center_label.add_theme_font_size_override("font_size", 14)
	election_command_center_label.add_theme_color_override("font_color", Color("#dce5f0"))
	election_command_center_progress = ProgressBar.new()
	election_command_center_progress.custom_minimum_size = Vector2(0, 16)
	election_command_center_progress.min_value = 0.0
	election_command_center_progress.max_value = 100.0
	election_command_center_progress.value = 0.0
	election_command_center_progress.show_percentage = false
	election_command_center_progress.add_theme_stylebox_override("background", _button_style("#17283b"))
	election_command_center_progress.add_theme_stylebox_override("fill", _button_style("#d6b15a"))
	command_center_card.add_child(election_command_center_progress)
	var recent_results_card := _new_election_card(election_results_page, "Recent Results", "Latest completed state assembly elections recorded in this career")
	election_recent_results_label = _add_body(recent_results_card, "Completed election results will appear here after the simulation records them.")
	var formation_card := _new_election_card(election_results_page, "Karnataka Government Formation", "High Command forms the Karnataka government after final results; appoint CM and cabinet")
	karnataka_formation_label = _add_body(formation_card, "No Karnataka government formation is pending.")
	_add_body(formation_card, "Coalition partners (select one or more if your party lacks a majority)")
	karnataka_coalition_list = ItemList.new()
	karnataka_coalition_list.custom_minimum_size = Vector2(0, 150)
	karnataka_coalition_list.select_mode = ItemList.SELECT_MULTI
	formation_card.add_child(karnataka_coalition_list)
	_add_body(formation_card, "Chief Minister")
	karnataka_cm_picker = OptionButton.new()
	karnataka_cm_picker.custom_minimum_size = Vector2(0, 44)
	formation_card.add_child(karnataka_cm_picker)
	_add_body(formation_card, "Ministerial portfolios")
	for portfolio in ["Finance", "Home Affairs", "Health", "Education"]:
		_add_body(formation_card, portfolio)
		var minister_picker := OptionButton.new()
		minister_picker.custom_minimum_size = Vector2(0, 42)
		formation_card.add_child(minister_picker)
		karnataka_cabinet_pickers[portfolio] = minister_picker
	karnataka_formation_status = _add_body(formation_card, "")
	_add_button(formation_card, "CONFIRM KARNATAKA GOVERNMENT", _on_confirm_karnataka_government)
	var live_results_card := _new_election_card(election_results_page, "Live election watch", "Campaigning, counting, and newly resolved contests")
	election_live_results_label = _add_body(live_results_card, "Live election records will appear here when an election enters an active phase.")
	var lok_sabha_counting_card := _new_election_card(election_results_page, "Lok Sabha polling & counting", "Modeled polling-day status, counting rounds, declared seats, and final turnout")
	lok_sabha_polling_counting_label = _add_body(lok_sabha_counting_card, "Lok Sabha polling and counting status will appear here.")
	var archive_results_card := _new_election_card(election_results_page, "Election-by-election results", "Choose an election type and a recorded contest to review its outcome and party standings.")
	election_archive_tabs = TabContainer.new()
	election_archive_tabs.name = "ElectionResultTabs"
	election_archive_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	election_archive_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	election_archive_tabs.custom_minimum_size = Vector2(0, 520)
	archive_results_card.add_child(election_archive_tabs)

	# District progression is an internal party path, not government authority.
	var district_page := _new_tab(dashboard_box, "District")
	_add_section_title(district_page, "PARTY ORGANIZATION")
	district_label = _add_page_summary(district_page, "DISTRICT PROGRESSION", "Build local standing", "Your district progression appears here.")
	_add_body(district_page, "District party positions are internal organization roles. They do not grant public office, government authority, or access to public funds.")
	_add_section_title(district_page, "PROGRESSION REQUIREMENTS")
	_add_body(district_page, "Build experience and reputation, strengthen your relationship with party leadership, grow party membership, complete local responsibilities, and establish local standing before requesting a district role.")
	_add_button(district_page, "REQUEST DISTRICT PARTY ROLE", _on_request_district_role)
	_add_section_title(district_page, "YOUR CURRENT PROGRESSION")
	var district_details := _add_body(district_page, "")
	district_details.name = "DistrictProgressDetails"

	_add_section_title(district_page, "KARNATAKA DISTRICT PARTY OFFICES")
	_add_body(district_page, "Your party maintains an office network across all 31 Karnataka districts. Select a district to review its organization, support, activity, and monthly operating costs. Outreach and recruitment are paid from party funds.")
	district_office_picker = OptionButton.new()
	district_office_picker.custom_minimum_size = Vector2(0, 48)
	district_office_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for district_name in KARNATAKA_MAP_DISTRICTS:
		district_office_picker.add_item(district_name)
	district_office_picker.select(KARNATAKA_MAP_DISTRICTS.find("Udupi"))
	district_office_picker.item_selected.connect(_on_district_office_selected)
	district_page.add_child(district_office_picker)
	var district_office_actions := HBoxContainer.new()
	district_office_actions.add_theme_constant_override("separation", 8)
	district_page.add_child(district_office_actions)
	var outreach_button := Button.new()
	outreach_button.text = "HOLD PUBLIC OUTREACH"
	outreach_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outreach_button.custom_minimum_size = Vector2(0, 48)
	outreach_button.pressed.connect(_on_district_office_action.bind("outreach"))
	district_office_actions.add_child(outreach_button)
	var recruit_button := Button.new()
	recruit_button.text = "RECRUIT VOLUNTEERS"
	recruit_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	recruit_button.custom_minimum_size = Vector2(0, 48)
	recruit_button.pressed.connect(_on_district_office_action.bind("recruit"))
	district_office_actions.add_child(recruit_button)
	district_office_feedback = _add_body(district_page, "Office actions and their results will appear here.")
	district_office_feedback.name = "DistrictOfficeFeedback"
	district_office_feedback.add_theme_color_override("font_color", Color("#d6b15a"))
	district_office_report = _add_body(district_page, "Select a district to view its office report.")
	district_office_report.name = "DistrictOfficeReport"

	_add_section_title(district_page, "OTHER STATES — ASSEMBLY CONSTITUENCY OFFICES")
	_add_body(district_page, "Party offices are created for every Assembly constituency outside Karnataka. Placeholder constituency names remain visibly marked as fictional, not official. Each office has its own membership, workers, support, activity log, and monthly cost.")
	assembly_office_state_picker = OptionButton.new()
	assembly_office_state_picker.custom_minimum_size = Vector2(0, 48)
	assembly_office_state_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for state_name in world.assembly_office_states():
		assembly_office_state_picker.add_item(state_name)
	assembly_office_state_picker.item_selected.connect(_on_assembly_office_state_selected)
	district_page.add_child(assembly_office_state_picker)
	assembly_office_constituency_picker = OptionButton.new()
	assembly_office_constituency_picker.custom_minimum_size = Vector2(0, 48)
	assembly_office_constituency_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	district_page.add_child(assembly_office_constituency_picker)
	assembly_office_constituency_picker.item_selected.connect(_on_assembly_office_constituency_selected)
	var assembly_office_actions := HBoxContainer.new()
	assembly_office_actions.add_theme_constant_override("separation", 8)
	district_page.add_child(assembly_office_actions)
	var assembly_outreach := Button.new()
	assembly_outreach.text = "HOLD OUTREACH"
	assembly_outreach.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	assembly_outreach.custom_minimum_size = Vector2(0, 48)
	assembly_outreach.pressed.connect(_on_assembly_office_action.bind("outreach"))
	assembly_office_actions.add_child(assembly_outreach)
	var assembly_recruit := Button.new()
	assembly_recruit.text = "RECRUIT VOLUNTEERS"
	assembly_recruit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	assembly_recruit.custom_minimum_size = Vector2(0, 48)
	assembly_recruit.pressed.connect(_on_assembly_office_action.bind("recruit"))
	assembly_office_actions.add_child(assembly_recruit)
	assembly_office_feedback = _add_body(district_page, "Constituency office actions will appear here.")
	assembly_office_feedback.add_theme_color_override("font_color", Color("#d6b15a"))
	assembly_office_report = _add_body(district_page, "Select a state and Assembly constituency.")
	_populate_assembly_office_constituencies()
	
	# The Office page is available only after the player personally wins office.
	office_tab = _new_tab(dashboard_box, "Office")
	office_tab.visible = false
	_add_section_title(office_tab, "YOUR ELECTED OFFICE")
	office_label = _add_page_summary(office_tab, "REPRESENTATIVE BRIEFING", "Constituency responsibilities", "Win an election personally to unlock this page.")
	_add_body(office_tab, "You may represent residents and submit requests or proposals. Councils, civil servants, and competent departments retain their legal powers and operational duties.")
	_add_section_title(office_tab, "OFFICIAL ACTIONS")
	_add_office_action_card(office_tab, "Submit a development proposal", "File a proposal for council review. Approval and implementation are handled by the competent authorities.", "SUBMIT PROPOSAL", _on_submit_office_proposal)
	_add_office_action_card(office_tab, "Raise a public-service issue", "Refer a local service concern to the responsible department for follow-up.", "RsimulationSE ISSUE", _on_raise_constituency_issue)
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
	_add_body(india_map_page, "MAP KEY: Political power and influence use party colours; other layers compare recorded indicators. Navy means no recorded data; gold marks the selected district.")
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
	government_summary_label = _add_body(reports_page, "Union, state, and local governments are administered by their elected leadership. Your party role alone does not grant executive office.")
	_add_section_title(reports_page, "MONTHLY TURN BRIEFING")
	report_label = _add_body(reports_page, "Your political journey is ready to begin.")
	_add_section_title(reports_page, "AUTOMATIC RECORDS")
	automatic_records_label = _add_body(reports_page, "Your activity history will be recorded automatically.")

	var inbox_page := _new_tab(dashboard_box, "Inbox")
	_add_section_title(inbox_page, "POLITICAL INBOX")
	_add_body(inbox_page, "A single review list for pending party and constituency matters. Items link to the system where they can be handled. The inbox does not grant powers your current role does not have.")
	inbox_summary = _add_body(inbox_page, "No pending matters.")
	inbox_list = VBoxContainer.new()
	inbox_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inbox_list.add_theme_constant_override("separation", 9)
	inbox_page.add_child(inbox_list)


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

	# The register is a recent-activity view. Walk the history backwards and
	# materialize only the newest 16 matching entries instead of duplicating
	# every historical record and then filtering the full list on each tab tap.
	const MAX_VISIBLE_OFFICE_CASES := 16
	var recent_entries: Array[Dictionary] = []

	var add_recent := func(kind: String, title: String, department: String, location: String, status: String) -> void:
		if office_case_filter != "ALL" and office_case_filter != kind:
			return
		if recent_entries.size() >= MAX_VISIBLE_OFFICE_CASES:
			return
		recent_entries.append({
			"kind": kind,
			"title": title,
			"department": department,
			"location": location,
			"status": status
		})

	# Reverse the original concatenation order (proposals, issues, missions)
	# so the most recently appended records are selected first.
	if office_case_filter == "ALL" or office_case_filter == "MONTHLY RESPONSIBILITY":
		for i in range(world.office_mission_history.size() - 1, -1, -1):
			var mission: Dictionary = world.office_mission_history[i]
			add_recent.call(
				"MONTHLY RESPONSIBILITY",
				str(mission.get("title", "Office responsibility")),
				str(mission.get("department", "District Administration")),
				str(mission.get("location", world.local_election_area())),
				str(mission.get("status", "Completed"))
			)
			if recent_entries.size() >= MAX_VISIBLE_OFFICE_CASES:
				break

	if recent_entries.size() < MAX_VISIBLE_OFFICE_CASES and (office_case_filter == "ALL" or office_case_filter == "PUBLIC SERVICE FOLLOW-UP"):
		for i in range(world.constituency_issues.size() - 1, -1, -1):
			var issue: Dictionary = world.constituency_issues[i]
			add_recent.call(
				"PUBLIC SERVICE FOLLOW-UP",
				str(issue.get("topic", "Constituency issue")),
				str(issue.get("department", "District Administration")),
				str(issue.get("location", world.local_election_area())),
				str(issue.get("status", "Submitted"))
			)
			if recent_entries.size() >= MAX_VISIBLE_OFFICE_CASES:
				break

	if recent_entries.size() < MAX_VISIBLE_OFFICE_CASES and (office_case_filter == "ALL" or office_case_filter == "OFFICIAL REPRESENTATION"):
		for i in range(world.office_proposals.size() - 1, -1, -1):
			var proposal: Dictionary = world.office_proposals[i]
			add_recent.call(
				"OFFICIAL REPRESENTATION",
				str(proposal.get("title", "Development proposal")),
				str(proposal.get("department", "Council review")),
				str(proposal.get("location", world.local_election_area())),
				str(proposal.get("status", "Pending"))
			)
			if recent_entries.size() >= MAX_VISIBLE_OFFICE_CASES:
				break

	if recent_entries.is_empty():
		_add_info_card(office_log_list, "No cases in this section", "New submissions and completed responsibilities will appear here when available.", "EMPTY REGISTER")
		return

	# Reverse into the same oldest-to-newest presentation order as the previous
	# register, while keeping the newest records visible.
	recent_entries.reverse()
	for entry in recent_entries:
		var detail_text := "%s\\n%s" % [str(entry["department"]), str(entry["location"])]
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

func _add_button(parent: VBoxContainer, text_value: String, callback: Callable) -> Button:
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
	return button

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
	if save_recovery_blocked:
		report_label.text = "New career blocked: existing save data needs recovery first. Your career files have been preserved."
		return
	var started: bool = world.start_career(name_input.text, int(age_input.value), city_input.text, "join")
	_after_start(started)

func _on_found_party() -> void:
	if save_recovery_blocked:
		report_label.text = "New career blocked: existing save data needs recovery first. Your career files have been preserved."
		return
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
	var monthly_events: Array[String] = world.advance_month()
	var report_lines := PackedStringArray()
	report_lines.append("MONTHLY TURN REPORT — " + world.date_label().to_upper())
	report_lines.append("")
	for event in monthly_events:
		report_lines.append("• " + event)
	report_lines.append("")
	report_lines.append("NEXT: Review Elections, Party Organization, Office, or Inbox for matters that need your attention.")
	report_label.text = "\n".join(report_lines)
	_refresh()
	_show_karnataka_result_popup_if_needed()
	_save_progress()

func _on_save_game() -> void:
	if world.save_game():
		report_label.text = "Game saved successfully."
	else:
		report_label.text = "Save failed. Check available storage and try again."

func _record_current_activity() -> void:
	if not is_instance_valid(world) or not world.career_started or not is_instance_valid(report_label):
		return
	var activity := report_label.text.strip_edges()
	if activity.is_empty():
		return
	var records: Array = world.world_state.get("automatic_activity_records", [])
	var entry := {
		"date": world.date_label(),
		"activity": activity
	}
	# Avoid duplicate entries when the same refresh/save path runs more than once.
	if records.is_empty() or str(records.back().get("activity", "")) != activity or str(records.back().get("date", "")) != world.date_label():
		records.append(entry)
	while records.size() > 150:
		records.pop_front()
	world.world_state["automatic_activity_records"] = records
	if is_instance_valid(automatic_records_label):
		var lines: Array[String] = []
		for i in range(maxi(0, records.size() - 20), records.size()):
			var row: Dictionary = records[i]
			lines.append("%s — %s" % [str(row.get("date", "")), str(row.get("activity", ""))])
		automatic_records_label.text = "\n\n".join(PackedStringArray(lines)) if not lines.is_empty() else "No recorded activities yet."

func _save_progress() -> void:
	if is_instance_valid(world) and world.career_started:
		_record_current_activity()
		if not world.save_game():
			push_error("Career save failed. The previous verified save was preserved.")
			if is_instance_valid(report_label):
				report_label.text = "SAVE FAILED — your previous verified save was preserved. Check available storage and do not start a new career."

func _refresh_automatic_records() -> void:
	if not is_instance_valid(world) or not is_instance_valid(automatic_records_label):
		return
	var records: Array = world.world_state.get("automatic_activity_records", [])
	var lines: Array[String] = []
	for i in range(maxi(0, records.size() - 20), records.size()):
		var row: Dictionary = records[i]
		if row is Dictionary:
			lines.append("%s — %s" % [str(row.get("date", "")), str(row.get("activity", ""))])
	automatic_records_label.text = "\n\n".join(PackedStringArray(lines)) if not lines.is_empty() else "No recorded activities yet."

func _refresh() -> void:
	_refresh_automatic_records()
	# Refresh shared date/status immediately, then update only the visible page.
	# This avoids rebuilding large rosters, election tickets, and office logs on unrelated taps.
	var selected_page_name := _get_current_page_name()
	date_label.text = world.date_label()
	if not world.career_started:
		return

	if world.apply_player_party_fund_grant_once():
		_save_progress()

	# Office visibility can change after an election; keep navigation accurate without
	# regenerating every page's content.
	if is_instance_valid(office_tab):
		office_tab.visible = world.has_elected_office
	if main_tab_buttons.size() > 6 and is_instance_valid(main_tab_buttons[6]):
		main_tab_buttons[6].visible = world.has_elected_office
	_restore_selected_page(selected_page_name)
	selected_page_name = _get_current_page_name()

	match selected_page_name:
		"Overview":
			_refresh_overview_metrics()
			if is_instance_valid(career_page_summary):
				career_page_summary.text = world.career_summary()
			if is_instance_valid(party_page_summary):
				party_page_summary.text = world.party_summary()
			if is_instance_valid(election_page_summary):
				election_page_summary.text = world.election_summary()
			if is_instance_valid(world_politics_label):
				world_politics_label.text = world.world_politics_summary()
			if is_instance_valid(authority_summary_label):
				authority_summary_label.text = world.player_authority_summary()
			if is_instance_valid(government_summary_label):
				government_summary_label.text = world.government_system_summary()
		"Career":
			if is_instance_valid(career_page_summary):
				career_page_summary.text = world.career_summary()
			var career_profile_details := dashboard_box.find_child("CareerProfileDetails", true, false)
			if is_instance_valid(career_profile_details) and career_profile_details is Label:
				career_profile_details.text = world.career_summary() + "\n\nNEXT STEP\nChoose a Career Activity to build experience and reputation, or review Elections to pursue a public ticket."
		"Party":
			if is_instance_valid(party_page_summary):
				party_page_summary.text = world.party_summary()
			var party_overview_details := dashboard_box.find_child("PartyOverviewDetails", true, false)
			if is_instance_valid(party_overview_details) and party_overview_details is Label:
				party_overview_details.text = world.party_summary() + "\n\nORGANIZATION\nUse Members to manage the roster, Constitution to set leadership rules, and Finances to track personal, party, and campaign accounts."
			finance_label.text = world.finance_summary()
			_refresh_party_members()
			_refresh_karnataka_candidate_review()
		"Elections":
			if is_instance_valid(election_page_summary):
				election_page_summary.text = world.election_summary()
			_refresh_election_tabs()
			_show_karnataka_result_popup_if_needed()
		"District":
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
			if is_instance_valid(district_office_picker):
				var selected_index := district_office_picker.selected
				if selected_index >= 0 and selected_index < district_office_picker.item_count:
					district_office_selected = district_office_picker.get_item_text(selected_index)
			if is_instance_valid(district_office_report):
				district_office_report.text = world.party_district_office_report(district_office_selected) + "\n\n" + world.party_district_offices_statewide_report()
			_refresh_assembly_office_report()
		"Reports":
			if is_instance_valid(world_politics_label):
				world_politics_label.text = world.world_politics_summary()
		"Office":
			if is_instance_valid(authority_summary_label):
				authority_summary_label.text = world.player_authority_summary()
			if is_instance_valid(government_summary_label):
				government_summary_label.text = world.government_system_summary()
			if world.has_elected_office:
				if is_instance_valid(office_label):
					office_label.text = world.office_summary()
				_refresh_office_missions()
				_refresh_office_log()
		"India Map":
			_refresh_india_map()
		"Inbox":
			_refresh_inbox()
		_:
			pass


func _refresh_inbox() -> void:
	if not is_instance_valid(inbox_list):
		return
	_clear_children(inbox_list)
	var items: Array[Dictionary] = []
	for proposal in world.office_proposals:
		var status := str(proposal.get("status", "Pending"))
		if status.to_lower().contains("pending") or status.to_lower().contains("awaiting"):
			items.append({"title": str(proposal.get("title", "Development proposal")), "detail": "Constituency proposal · Council review", "status": status, "page": "Office"})
	for issue in world.constituency_issues:
		var status := str(issue.get("status", "Submitted"))
		if status.to_lower().contains("pending") or status.to_lower().contains("submitted"):
			items.append({"title": str(issue.get("topic", "Public-service issue")), "detail": "Constituency issue · Department follow-up", "status": status, "page": "Office"})
	if world.is_karnataka_contest_enabled():
		var pending_tickets := 0
		for row in world.karnataka_candidate_review_rows():
			if str(row.get("decision", "Pending")) == "Pending":
				pending_tickets += 1
		if pending_tickets > 0:
			items.append({"title": "Karnataka candidate nominations", "detail": "Assembly election · %d tickets need party review" % pending_tickets, "status": "Pending party review", "page": "Elections"})
	if is_instance_valid(inbox_summary):
		inbox_summary.text = "%d pending item(s) · Select an item’s destination to review it." % items.size()
	if items.is_empty():
		_add_info_card(inbox_list, "You’re all caught up", "New pending proposals, constituency issues and candidate reviews will appear here when recorded.", "INBOX CLEAR")
		return
	for item in items:
		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.add_theme_stylebox_override("panel", _card_style())
		inbox_list.add_child(card)
		var body := VBoxContainer.new()
		body.add_theme_constant_override("separation", 6)
		card.add_child(body)
		var title := Label.new()
		title.text = str(item.title)
		title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		title.add_theme_font_size_override("font_size", 16)
		body.add_child(title)
		_add_body(body, str(item.detail) + "\nStatus: " + str(item.status))
		var destination := str(item.page)
		if destination == "Office" and not world.has_elected_office:
			_add_body(body, "LOCKED · Government office actions become available only after you personally win elected office. This item remains visible for reference.")
		else:
			var open_button := Button.new()
			open_button.text = "OPEN " + destination.to_upper()
			open_button.custom_minimum_size = Vector2(0, 42)
			open_button.pressed.connect(_open_inbox_destination.bind(destination))
			body.add_child(open_button)
		_configure_touch_scroll_passthrough(card)

func _open_inbox_destination(page_name: String) -> void:
	# Inbox destinations must respect the player's current role and visible pages.
	if page_name == "Office" and not world.has_elected_office:
		return
	var target_index := _get_visible_tab_index(page_name)
	if target_index >= 0:
		# The tab_changed signal schedules the refresh; do not refresh twice here.
		dashboard_box.current_tab = target_index
		_update_bottom_navigation()


func _populate_assembly_office_constituencies() -> void:
	if not is_instance_valid(assembly_office_constituency_picker):
		return
	assembly_office_constituency_picker.clear()
	var rows: Array = world.assembly_office_constituencies(assembly_office_selected_state)
	for row in rows:
		var name := str(row.get("name", "Assembly Constituency %03d" % int(row.get("number", 0))))
		var status := str(row.get("record_status", ""))
		if status != "verified":
			name += "  [FICTIONAL PLACEHOLDER]"
		assembly_office_constituency_picker.add_item("%03d — %s" % [int(row.get("number", 0)), name])
	if not rows.is_empty():
		assembly_office_constituency_picker.select(0)
		assembly_office_selected_seat = int(rows[0].get("number", 1))
	_refresh_assembly_office_report()

func _on_assembly_office_state_selected(index: int) -> void:
	if not is_instance_valid(assembly_office_state_picker) or index < 0 or index >= assembly_office_state_picker.item_count:
		return
	assembly_office_selected_state = assembly_office_state_picker.get_item_text(index)
	_populate_assembly_office_constituencies()

func _on_assembly_office_constituency_selected(index: int) -> void:
	var rows: Array = world.assembly_office_constituencies(assembly_office_selected_state)
	if index < 0 or index >= rows.size():
		return
	assembly_office_selected_seat = int(rows[index].get("number", 1))
	_refresh_assembly_office_report()

func _refresh_assembly_office_report() -> void:
	if not is_instance_valid(assembly_office_report) or not is_instance_valid(assembly_office_constituency_picker):
		return
	var rows: Array = world.assembly_office_constituencies(assembly_office_selected_state)
	var index := assembly_office_constituency_picker.selected
	if index >= 0 and index < rows.size():
		assembly_office_selected_seat = int(rows[index].get("number", 1))
		assembly_office_report.text = world.assembly_constituency_office_report(assembly_office_selected_state, assembly_office_selected_seat) + "\n\n" + world.assembly_constituency_offices_state_report(assembly_office_selected_state)

func _on_assembly_office_action(action: String) -> void:
	var result := world.run_assembly_constituency_office_action(assembly_office_selected_state, assembly_office_selected_seat, action)
	if is_instance_valid(assembly_office_feedback):
		assembly_office_feedback.text = result
	_refresh_assembly_office_report()
	_refresh()
	_save_progress()

func _on_district_office_selected(index: int) -> void:
	if not is_instance_valid(district_office_picker):
		return
	if index < 0 or index >= district_office_picker.item_count:
		return
	district_office_selected = district_office_picker.get_item_text(index)
	if is_instance_valid(district_office_report):
		district_office_report.text = world.party_district_office_report(district_office_selected) + "\n\n" + world.party_district_offices_statewide_report()

func _on_district_office_action(action: String) -> void:
	var result := world.run_party_district_office_action(district_office_selected, action)
	if is_instance_valid(district_office_feedback):
		district_office_feedback.text = result
	_refresh()
	_save_progress()

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
		india_map_details.text = "INDIA POLITICAL ATLAS\nStart a political career to initialize the Union, state, and district administrations. The map shows the real supplied boundaries; political control appears after your career begins."
		_refresh_india_map_legend(layer, {}, {}, world.party_map_colors())
		return
	var winners: Dictionary = {}
	var supports: Dictionary = {}
	var seats: Dictionary = {}
	var phases: Dictionary = {}
	var map_metrics: Dictionary = {}
	var needs_numeric_metrics := layer not in ["Political control", "Political influence", "Political power"]
	var national_government: Dictionary = world.get_national_government()
	var national_party_id := str(national_government.get("ruling_party_id", ""))
	# Index election records once per map refresh. Looking up each state by
	# scanning the full election array repeatedly adds avoidable work.
	var state_elections_by_name: Dictionary = {}
	for election_variant in world.world_state.get("state_elections", []):
		if election_variant is Dictionary:
			var election_record: Dictionary = election_variant
			var election_state := str(election_record.get("state", ""))
			if not election_state.is_empty():
				state_elections_by_name[election_state] = election_record
	for state_variant in INDIA_MAP_STATES:
		var state_name := str(state_variant)
		var government: Dictionary = world.get_state_government(state_name)
		var winner_id := str(government.get("ruling_party_id", ""))
		# Influence maps identify the party with the strongest recorded support;
		# power/control maps identify the party leading the government.
		if layer == "Political influence":
			winner_id = _india_map_most_supported_party(state_name)
		# Union Territories use the Union administration as the simplified map fallback.
		if winner_id.is_empty() and layer != "Political influence":
			winner_id = national_party_id
		if not winner_id.is_empty():
			winners[state_name] = winner_id
		if needs_numeric_metrics:
			supports[state_name] = _india_map_support(state_name)
			var election: Dictionary = state_elections_by_name.get(state_name, {})
			map_metrics[state_name] = _india_map_government_metrics(government, state_name, election)
			seats[state_name] = int(election.get("assembly_seats", 0))
			phases[state_name] = str(election.get("phase", "No assembly election record"))
	var local_winners: Dictionary = world.local_government_party_map(india_map_selected_state if india_map_level > 0 else "")
	if india_map_level > 0 and needs_numeric_metrics:
		# Build metric entries from the full district catalog, not only districts
		# with a recorded ruling-party winner. Metric layers are independent of
		# political-control records, so every district can show its saved
		# administration scores even when its party-control record is absent.
		var district_catalog: Array = world._load_india_district_catalog()
		for district_variant in district_catalog:
			if not district_variant is Dictionary:
				continue
			var district_entry: Dictionary = district_variant
			var district_state := str(district_entry.get("state", ""))
			var district_name := str(district_entry.get("district", ""))
			if district_state != india_map_selected_state or district_name.is_empty():
				continue
			var district_key := "%s|%s" % [district_state.strip_edges(), district_name.strip_edges()]
			var local_government: Dictionary = world.get_local_government(district_state, district_name)
			map_metrics[district_key] = _india_map_government_metrics(local_government, district_state, {})
	var party_colors: Dictionary = world.party_map_colors()
	india_map_grid.set_map_state(
		india_map_level, india_map_selected_state, india_map_selected_district,
		layer, winners, supports, seats, phases, local_winners, party_colors, map_metrics
	)
	_refresh_india_map_legend(layer, winners, local_winners, party_colors)
	var state_election: Dictionary = state_elections_by_name.get(india_map_selected_state, {})
	if india_map_level == 0:
		india_map_breadcrumb.text = "INDIA  /  STATES & UNION TERRITORIES"
		india_map_details.text = "INDIA-WIDE BRIEFING\n%s\nTap a state boundary on the map to open its state government and district map." % world.national_government_briefing()
	elif india_map_level == 1:
		india_map_breadcrumb.text = "INDIA  /  %s  /  DISTRICTS" % india_map_selected_state.to_upper()
		india_map_details.text = _india_map_state_summary(india_map_selected_state, state_election, layer) + "\n\nTap a district boundary to view its local administration."
	else:
		india_map_breadcrumb.text = "INDIA  /  %s  /  %s" % [india_map_selected_state.to_upper(), india_map_selected_district.to_upper()]
		india_map_details.text = "DISTRICT / LOCAL GOVERNMENT BRIEFING\n%s, %s\n\n%s\n\nBoundary source: supplied district GeoJSON. Local political control is an simulation baseline unless a future local-body election record replaces it." % [
			india_map_selected_district, india_map_selected_state,
			world.local_government_briefing(india_map_selected_state, india_map_selected_district)
		]
	india_map_details.text += "\n\nMAP LAYER\n" + _india_map_layer_summary(layer)

func _refresh_india_map_legend(layer: String, state_winners: Dictionary, local_winners: Dictionary, party_colors: Dictionary) -> void:
	if not is_instance_valid(india_map_legend):
		return
	_clear_children(india_map_legend)
	if layer in ["Political control", "Political influence", "Political power"]:
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
		_add_india_map_legend_item(Color("#263b54"), "No party record")
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

func _india_map_most_supported_party(state_name: String) -> String:
	var support_by_party: Dictionary = world.world_state.get("regional_support", {})
	var best_party_id := ""
	var best_support := -1.0
	for party_id_variant in support_by_party.keys():
		var party_id := str(party_id_variant)
		var by_state: Dictionary = support_by_party.get(party_id, {})
		var support := float(by_state.get(state_name, 0.0))
		if support > best_support:
			best_support = support
			best_party_id = party_id
	return best_party_id if best_support > 0.0 else ""

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
	# Legacy/local government records may exist without a populated performance
	# dictionary. Use a neutral baseline for simulation metrics so map layers
	# remain meaningful; keep Population explicitly unavailable below.
	var service := float(performance.get("service_delivery", 50.0))
	var welfare := float(performance.get("welfare", 50.0))
	var economy := float(performance.get("economy", 50.0))
	var infrastructure := float(performance.get("infrastructure", 50.0))
	var safety := float(performance.get("public_safety", 50.0))
	var approval := float(performance.get("public_approval", 50.0))
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
			return "Colors each state by the party with the strongest recorded regional support. Districts use the recorded local ruling party where available."
		"Political power":
			return "Colors each state by its ruling party and each district by its recorded local ruling party, rather than showing a numeric score."
		"Economy":
			return "Shows the government's recorded economy performance score."
		"Population":
			return "Population is not yet stored in this simulation, so regions show No data rather than invented figures."
		"Public welfare":
			return "Shows the government's recorded welfare performance score."
		"Infrastructure":
			return "Shows the government's recorded infrastructure performance score."
		"Election performance":
			return "Shows recorded player-party vote share when that value exists; otherwise the region is marked No data."
		"Public approval":
			return "Shows the government's recorded public-approval score."
		"Social indicators":
			return "Uses recorded service-delivery performance as the available social-services indicator."
		"Law & order":
			return "Shows the government's recorded public-safety score."
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
		str(home_local_government.get("leader_name", "Administrator not recorded")),
		world._month_name(int(home_local_government.get("next_election_month", 12))),
		int(home_local_government.get("next_election_year", world.year + 5)),
		str(home_local_government.get("last_local_election_result", "No district-local result recorded yet"))
	]
	if election_detail_labels.has("local") and is_instance_valid(election_detail_labels["local"]):
		election_detail_labels["local"].text = local_text

	# Ensure legacy saves are migrated before the state cards read their election list.
	world._ensure_election_schema()
	var state_elections: Array = world.world_state.get("state_elections", [])
	_refresh_state_election_cards(state_elections)
	_refresh_election_results(state_elections)
	_refresh_karnataka_formation_controls()
	var high_command: Dictionary = world.world_state.get("high_command", {})
	if is_instance_valid(high_command_status):
		high_command_status.text = world.high_command_summary()
	_refresh_karnataka_candidate_review()
	_refresh_constituency_planner()
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
		var national_last_result := str(national.get("last_result", "Not yet held"))
		var national_last_year := int(national.get("last_year", 0))
		var national_phase := str(national.get("phase", "Scheduled"))
		var national_poll_heading := "UPCOMING LOK SABHA POLL"
		var national_poll_year := int(national.get("next_year", 2029))
		var national_poll_month := int(national.get("month", 5))
		if national_phase in ["Polling", "Counting"]:
			national_poll_heading = "CURRENT LOK SABHA POLL"
			national_poll_year = int(national.get("polling_year", national_poll_year))
			national_poll_month = int(national.get("polling_month", national_poll_month))
		elif national_phase == "Completed":
			national_poll_heading = "NEXT LOK SABHA POLL"
		var last_election_label := "No completed Lok Sabha election recorded"
		if not national_last_result.is_empty() and national_last_result != "Not yet held" and national_last_year > 0:
			last_election_label = "LAST ELECTION  %d" % national_last_year
		var last_candidate_stats := "No previous candidate totals recorded"
		if national_last_year > 0:
			last_candidate_stats = "Last election party candidates  %d contested / %d elected" % [
				int(national.get("player_party_candidates_contested", 0)),
				int(national.get("player_party_candidates_elected", 0))
			]
		var nomination_hold_line := "NOMINATION HOLD  %s" % str(national.get("nomination_hold_reason", "")) if bool(national.get("nomination_hold", false)) else ""
		election_detail_labels["national"].text = "%s  %s %d  ·  %s\n%s\nConstituencies  %d\n%s\nLast eligible voters  %d  ·  Ballots cast  %d\n%s\n%s\n\nGOVERNMENT\nRuling party  %s\nExecutive leader  %s\nGovernment type  %s" % [
			national_poll_heading, world._month_name(national_poll_month), national_poll_year,
			national_phase, nomination_hold_line, int(national.get("seats", 543)),
			last_candidate_stats,
			int(national.get("last_eligible_voters", 0)), int(national.get("last_ballots_cast", 0)),
			last_election_label + " · " + national_last_result,
			world.lok_sabha_integrity_summary(),
			world._government_party_name(str(union_government.get("ruling_party_id", ""))),
			str(union_government.get("leader_name", "leader pending")),
			str(union_government.get("formation_type", "Coalition administration"))
		]

	_refresh_lok_sabha_nomination_panel()

func _refresh_lok_sabha_nomination_readiness(rows: Array[Dictionary]) -> void:
	if not is_instance_valid(national_nomination_readiness):
		return
	var total_seats := rows.size()
	var assigned_count := 0
	var vacant_count := 0
	var approved_count := 0
	var pending_count := 0
	var rejected_count := 0
	var duplicate_count := 0
	var seen_member_ids: Dictionary = {}

	for row in rows:
		var member_id := str(row.get("member_id", "")).strip_edges()
		var decision := str(row.get("decision", "Pending"))
		if member_id.is_empty():
			vacant_count += 1
			continue
		assigned_count += 1
		if seen_member_ids.has(member_id):
			duplicate_count += 1
		else:
			seen_member_ids[member_id] = true
		match decision:
			"Approved":
				approved_count += 1
			"Rejected":
				rejected_count += 1
			_:
				pending_count += 1

	var readiness := "REVIEW REQUIRED"
	if total_seats == 543 and assigned_count == 543 and approved_count == 543 and duplicate_count == 0:
		readiness = "READY FOR NATIONAL CAMPAIGN"
	national_nomination_readiness.text = "%s\nSeats  %d / 543\nAssigned  %d · Vacant  %d\nApproved  %d · Pending  %d · Rejected  %d\nDuplicate member assignments  %d" % [
		readiness, total_seats, assigned_count, vacant_count, approved_count, pending_count, rejected_count, duplicate_count
	]

func _refresh_lok_sabha_nomination_panel() -> void:
	if not is_instance_valid(national_nomination_seat):
		return
	# Fetch the 543-seat review list once and share it across the readiness,
	# constituency picker, and selected-seat status refreshes.
	var rows: Array[Dictionary] = world.lok_sabha_candidate_review_rows()
	_refresh_lok_sabha_nomination_readiness(rows)
	var previous_seat := _selected_lok_sabha_seat()
	var query := national_nomination_constituency_search.text.strip_edges().to_lower() if is_instance_valid(national_nomination_constituency_search) else ""
	national_nomination_seat.clear()
	for row in rows:
		var seat_number := int(row.get("seat_number", 0))
		var label := "%03d · %s, %s" % [seat_number, str(row.get("constituency", "")), str(row.get("state", ""))]
		if not query.is_empty() and not label.to_lower().contains(query):
			continue
		national_nomination_seat.add_item(label)
		national_nomination_seat.set_item_metadata(national_nomination_seat.item_count - 1, seat_number)
		if seat_number == previous_seat:
			national_nomination_seat.select(national_nomination_seat.item_count - 1)
	if national_nomination_seat.selected < 0 and national_nomination_seat.item_count > 0:
		national_nomination_seat.select(0)
	_refresh_lok_sabha_nomination_members()
	_refresh_lok_sabha_nomination_status(rows)

func _refresh_lok_sabha_nomination_members() -> void:
	if not is_instance_valid(national_nomination_member_picker):
		return
	var query := national_nomination_member_search.text if is_instance_valid(national_nomination_member_search) else ""
	var previous_id := ""
	var selected := national_nomination_member_picker.get_selected_items()
	if not selected.is_empty():
		previous_id = str(national_nomination_member_picker.get_item_metadata(selected[0]))
	national_nomination_member_picker.clear()
	var members := world.lok_sabha_party_member_search(query)
	for i in range(mini(50, members.size())):
		var member: Dictionary = members[i]
		national_nomination_member_picker.add_item(str(member.get("name", "Party member")))
		national_nomination_member_picker.set_item_metadata(national_nomination_member_picker.item_count - 1, str(member.get("id", "")))
		if str(member.get("id", "")) == previous_id:
			national_nomination_member_picker.select(national_nomination_member_picker.item_count - 1)
	if national_nomination_member_picker.get_selected_items().is_empty() and national_nomination_member_picker.item_count > 0:
		national_nomination_member_picker.select(0)

func _selected_lok_sabha_seat() -> int:
	if not is_instance_valid(national_nomination_seat) or national_nomination_seat.selected < 0:
		return 0
	return int(national_nomination_seat.get_item_metadata(national_nomination_seat.selected))

func _refresh_lok_sabha_nomination_status(rows: Array[Dictionary] = []) -> void:
	if not is_instance_valid(national_nomination_status):
		return
	var seat := _selected_lok_sabha_seat()
	if rows.is_empty():
		rows = world.lok_sabha_candidate_review_rows()
	for row in rows:
		if int(row.get("seat_number", 0)) == seat:
			national_nomination_status.text = "CONSTITUENCY  %s, %s\nNOMINEE  %s\nMEMBER ID  %s\nREVIEW  %s\nTickets remain pending until approved. Duplicate member assignments to another seat are blocked." % [str(row.get("constituency", "")), str(row.get("state", "")), str(row.get("candidate_name", "")), str(row.get("member_id", "")), str(row.get("decision", "Pending"))]
			return
	national_nomination_status.text = "Choose a constituency."

func _on_assign_lok_sabha_candidate() -> void:
	if not is_instance_valid(national_nomination_member_picker):
		return
	var selected := national_nomination_member_picker.get_selected_items()
	if selected.is_empty():
		report_label.text = "Select a party member first."
		return
	var member_id := str(national_nomination_member_picker.get_item_metadata(selected[0]))
	report_label.text = world.assign_lok_sabha_candidate(_selected_lok_sabha_seat(), member_id)
	_refresh_lok_sabha_nomination_panel()
	_save_progress()

func _set_lok_sabha_candidate_decision(decision: String) -> void:
	report_label.text = world.set_lok_sabha_candidate_decision(_selected_lok_sabha_seat(), decision)
	_refresh_lok_sabha_nomination_panel()
	_save_progress()

func _on_auto_assign_lok_sabha_candidates() -> void:
	report_label.text = world.auto_assign_unassigned_lok_sabha_candidates()
	_refresh_lok_sabha_nomination_panel()
	_save_progress()


func _on_bulk_approve_lok_sabha_candidates() -> void:
	if is_instance_valid(national_nomination_bulk_confirm):
		national_nomination_bulk_confirm.popup_centered()


func _confirm_bulk_approve_lok_sabha_candidates() -> void:
	report_label.text = world.bulk_approve_assigned_lok_sabha_candidates()
	_refresh_lok_sabha_nomination_panel()
	_save_progress()

func _refresh_karnataka_formation_controls() -> void:
	if not is_instance_valid(karnataka_formation_label) or not is_instance_valid(karnataka_coalition_list) or not is_instance_valid(karnataka_cm_picker):
		return
	var pending := world.karnataka_government_formation_pending()
	karnataka_formation_label.text = world.karnataka_government_formation_summary()
	karnataka_coalition_list.clear()
	for option in world.karnataka_coalition_options():
		karnataka_coalition_list.add_item("%s — %d seats" % [str(option.get("name", "Party")), int(option.get("seats", 0))])
		karnataka_coalition_list.set_item_metadata(karnataka_coalition_list.item_count - 1, str(option.get("id", "")))
	karnataka_cm_picker.clear()
	karnataka_cm_picker.add_item(world.character_name + " (you)")
	karnataka_cm_picker.set_item_metadata(0, world.character_name)
	for member_variant in world.get_player_party_members():
		if member_variant is Dictionary:
			var member_name := str(member_variant.get("name", "")).strip_edges()
			if not member_name.is_empty() and member_name != world.character_name:
				karnataka_cm_picker.add_item(member_name)
				karnataka_cm_picker.set_item_metadata(karnataka_cm_picker.item_count - 1, member_name)
	var cabinet_candidates := world.karnataka_cabinet_candidates()
	for portfolio_variant in karnataka_cabinet_pickers.keys():
		var picker: OptionButton = karnataka_cabinet_pickers[portfolio_variant]
		picker.clear()
		picker.add_item("Select minister")
		picker.set_item_metadata(0, "")
		for candidate_name in cabinet_candidates:
			picker.add_item(candidate_name)
			picker.set_item_metadata(picker.item_count - 1, candidate_name)
		picker.visible = pending
	karnataka_formation_status.text = "Formation is pending. Select coalition partners if needed and appoint a Chief Minister." if pending else "Government formation is not currently pending."
	karnataka_coalition_list.visible = pending
	karnataka_cm_picker.visible = pending

func _on_confirm_karnataka_government() -> void:
	if not world.karnataka_government_formation_pending():
		if is_instance_valid(karnataka_formation_status):
			karnataka_formation_status.text = "No pending Karnataka election result requires formation."
		return
	var coalition_ids: Array = []
	for selected_index in karnataka_coalition_list.get_selected_items():
		var metadata: Variant = karnataka_coalition_list.get_item_metadata(selected_index)
		coalition_ids.append(str(metadata))
	var cm_name := str(karnataka_cm_picker.get_item_metadata(karnataka_cm_picker.selected)) if karnataka_cm_picker.item_count > 0 else ""
	var cabinet: Dictionary = {}
	for portfolio_variant in karnataka_cabinet_pickers.keys():
		var portfolio := str(portfolio_variant)
		var picker: OptionButton = karnataka_cabinet_pickers[portfolio]
		if picker.selected > 0:
			cabinet[portfolio] = str(picker.get_item_metadata(picker.selected))
	var result := world.form_karnataka_government(coalition_ids, cm_name, cabinet)
	karnataka_formation_status.text = result
	_refresh()
	_save_progress()

func _show_karnataka_result_popup_if_needed() -> void:
	if not world.karnataka_government_formation_pending():
		return
	var pending: Dictionary = world.world_state.get("pending_karnataka_government_formation", {})
	var key := "%d-%d" % [int(pending.get("year", 0)), int(pending.get("month", 0))]
	if key == _last_karnataka_result_popup_key:
		return
	_last_karnataka_result_popup_key = key
	if not is_instance_valid(karnataka_formation_dialog):
		karnataka_formation_dialog = ConfirmationDialog.new()
		karnataka_formation_dialog.title = "Karnataka Assembly Result"
		karnataka_formation_dialog.get_ok_button().text = "REVIEW FORMATION"
		karnataka_formation_dialog.get_cancel_button().text = "LATER"
		add_child(karnataka_formation_dialog)
		karnataka_formation_dialog.confirmed.connect(_open_karnataka_formation)
	karnataka_formation_dialog.dialog_text = world.karnataka_government_formation_summary() + "\n\nForm the government now, or return later from Election Results."
	karnataka_formation_dialog.popup_centered(Vector2i(620, 440))

func _open_karnataka_formation() -> void:
	var idx := _get_visible_tab_index("Election Results")
	if idx >= 0:
		dashboard_box.current_tab = idx
	_refresh()

func _format_election_number(value: int) -> String:
	var raw := str(maxi(0, value))
	var output := ""
	var group_count := 0
	for index in range(raw.length() - 1, -1, -1):
		output = raw.substr(index, 1) + output
		group_count += 1
		if group_count == 3 and index > 0:
			output = "," + output
			group_count = 0
	return output


func _add_personal_and_manual_member_results(parent: Control, constituency_results: Array) -> void:
	var personal_lines: PackedStringArray = []
	var manual_lines: PackedStringArray = []
	var player_party: Dictionary = world.parties.get(world.player_party_id, {})
	var member_records: Array = player_party.get("member_records", [])
	var manual_member_ids: Dictionary = {}
	for member_variant in member_records:
		if not member_variant is Dictionary:
			continue
		var member: Dictionary = member_variant
		var member_id := str(member.get("id", ""))
		if bool(member.get("is_player_added", false)) and not bool(member.get("is_player_character", false)) and not member_id.is_empty():
			manual_member_ids[member_id] = str(member.get("name", "Party member"))

	for seat_variant in constituency_results:
		if not seat_variant is Dictionary:
			continue
		var seat: Dictionary = seat_variant
		var candidates: Array = seat.get("candidates", [])
		var personal_candidate: Dictionary = {}
		for candidate_variant in candidates:
			if candidate_variant is Dictionary and str(candidate_variant.get("member_id", "")) == "player_character":
				personal_candidate = candidate_variant
				break
		if not personal_candidate.is_empty():
			var personal_name := str(personal_candidate.get("candidate_name", world.character_name))
			var personal_party := world._government_party_name(str(personal_candidate.get("party_id", "")))
			var personal_votes := int(personal_candidate.get("votes", 0))
			var personal_share := float(personal_candidate.get("vote_percent", personal_candidate.get("vote_share", 0.0)))
			var winner_party_id := str(seat.get("winner_party_id", ""))
			var winner_votes := 0
			var seat_ballots := int(seat.get("ballots_cast", 0))
			if seat_ballots <= 0:
				for ballot_candidate_variant in candidates:
					if ballot_candidate_variant is Dictionary:
						seat_ballots += int(ballot_candidate_variant.get("votes", 0))
			var seat_eligible := int(seat.get("eligible_voters", 0))
			var seat_turnout := float(seat.get("turnout_percent", 0.0))
			var seat_eligible_text := _format_election_number(seat_eligible) if seat_eligible > 0 else "Not saved"
			var seat_turnout_text := "%.1f%%" % seat_turnout if seat_turnout > 0.0 else "Not saved"
			var competitors: PackedStringArray = []
			for competitor_variant in candidates:
				if not competitor_variant is Dictionary:
					continue
				var competitor: Dictionary = competitor_variant
				if str(competitor.get("party_id", "")) == winner_party_id:
					winner_votes = int(competitor.get("votes", 0))
				if str(competitor.get("member_id", "")) == "player_character":
					continue
				competitors.append("%s (%s) — %s votes · %.1f%%" % [
					str(competitor.get("candidate_name", "Candidate")),
					world._government_party_name(str(competitor.get("party_id", ""))),
					_format_election_number(int(competitor.get("votes", 0))),
					float(competitor.get("vote_percent", competitor.get("vote_share", 0.0)))
				])
			personal_lines.append("%s · %s\n%s (%s) — %s votes · %.1f%% · %s\nCompetitors:\n%s\nMargin: %s votes\nConstituency ballots: %s · Eligible voters: %s · Turnout: %s" % [
				str(seat.get("constituency", "Constituency")), str(seat.get("state", "")),
				personal_name, personal_party, _format_election_number(personal_votes), personal_share,
				"WON" if str(personal_candidate.get("party_id", "")) == winner_party_id else "LOST",
				"\n".join(competitors) if not competitors.is_empty() else "No competitor records saved.",
				_format_election_number(abs(winner_votes - personal_votes)),
				_format_election_number(seat_ballots),
				seat_eligible_text,
				seat_turnout_text
			])

		for candidate_variant in candidates:
			if not candidate_variant is Dictionary:
				continue
			var candidate: Dictionary = candidate_variant
			var member_id := str(candidate.get("member_id", ""))
			if not manual_member_ids.has(member_id):
				continue
			var manual_competitor_lines: PackedStringArray = []
			for manual_competitor_variant in candidates:
				if not manual_competitor_variant is Dictionary:
					continue
				var manual_competitor: Dictionary = manual_competitor_variant
				manual_competitor_lines.append("%s (%s): %s votes · %.1f%%" % [
					str(manual_competitor.get("candidate_name", "Candidate")),
					world._government_party_name(str(manual_competitor.get("party_id", ""))),
					_format_election_number(int(manual_competitor.get("votes", 0))),
					float(manual_competitor.get("vote_percent", manual_competitor.get("vote_share", 0.0)))
				])
			manual_lines.append("%s · %s\n%s (%s) — %s votes · %.1f%% · %s\nCompetitors and candidate totals:\n%s" % [
				str(seat.get("constituency", "Constituency")), str(seat.get("state", "")),
				str(candidate.get("candidate_name", manual_member_ids.get(member_id, "Party member"))),
				world._government_party_name(str(candidate.get("party_id", ""))),
				_format_election_number(int(candidate.get("votes", 0))),
				float(candidate.get("vote_percent", candidate.get("vote_share", 0.0))),
				"WON" if str(candidate.get("party_id", "")) == str(seat.get("winner_party_id", "")) else "LOST",
				"\n".join(manual_competitor_lines)
			])

	var personal_card := _new_election_card(parent, "Your personal election result", "Your own recorded candidacy and competitors")
	_add_body(personal_card, "\n\n".join(personal_lines) if not personal_lines.is_empty() else "No personal candidate ballot is recorded for this election.")
	var manual_card := _new_election_card(parent, "Manually added party members", "Recorded votes for members you added to the party roster")
	_add_body(manual_card, "\n\n".join(manual_lines) if not manual_lines.is_empty() else "No manually added party member candidacies are recorded in this election.")


func _refresh_election_results(state_elections: Array) -> void:
	# Command center summarizes only the simulation's saved state-assembly records.
	var total_records := 0
	var campaigning_count := 0
	var polling_count := 0
	var counting_count := 0
	var completed_count := 0
	var candidates_contested := 0
	var candidates_elected := 0
	for command_item_variant in state_elections:
		if not command_item_variant is Dictionary:
			continue
		var command_item: Dictionary = command_item_variant
		total_records += 1
		var command_phase := str(command_item.get("phase", "Scheduled"))
		if command_phase == "Campaigning":
			campaigning_count += 1
		elif command_phase == "Polling":
			polling_count += 1
		elif command_phase == "Counting":
			counting_count += 1
		elif command_phase in ["Results", "Completed"]:
			completed_count += 1
		candidates_contested += int(command_item.get("player_party_candidates_contested", 0))
		candidates_elected += int(command_item.get("player_party_candidates_elected", 0))
	if is_instance_valid(election_command_center_label):
		election_command_center_label.text = "ACTIVE CAMPAIGNS  %d     •     POLLING  %d     •     COUNTING  %d     •     RESULTS FILED  %d / %d\nYOUR PARTY  %d candidates contested  •  %d elected so far\nCounting rounds are simulated monthly stages; constituency winners are shown only after the final round." % [campaigning_count, polling_count, counting_count, completed_count, total_records, candidates_contested, candidates_elected]
		if total_records == 0:
			election_command_center_label.text = "No state assembly election records are available in this career yet."
	if is_instance_valid(election_command_center_progress):
		election_command_center_progress.value = 100.0 * float(completed_count) / float(maxi(1, total_records))
	if is_instance_valid(election_recent_results_label):
		var recent_items: Array[Dictionary] = []
		for recent_variant in state_elections:
			if not recent_variant is Dictionary:
				continue
			var recent_item: Dictionary = recent_variant
			if int(recent_item.get("last_year", -1)) < 0:
				continue
			recent_items.append(recent_item)
		recent_items.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			var a_year := int(a.get("last_year", -1))
			var b_year := int(b.get("last_year", -1))
			if a_year == b_year:
				return int(a.get("last_month", 0)) > int(b.get("last_month", 0))
			return a_year > b_year
		)
		var recent_lines: PackedStringArray = []
		for recent_index in range(mini(5, recent_items.size())):
			var recent_item: Dictionary = recent_items[recent_index]
			var recent_state := str(recent_item.get("state", "State"))
			var recent_year := int(recent_item.get("last_year", world.year))
			var recent_month := int(recent_item.get("last_month", recent_item.get("month", world.month)))
			var recent_winner := world._government_party_name(str(recent_item.get("last_winner", "")))
			var recent_seats: Dictionary = recent_item.get("last_seats", {})
			var recent_player_seats := int(recent_seats.get(world.player_party_id, 0))
			var recent_total_seats := int(recent_item.get("assembly_seats", 0))
			var recent_shares: Dictionary = recent_item.get("last_vote_shares", {})
			var recent_player_share := float(recent_shares.get(world.player_party_id, 0.0))
			var recent_turnout := float(recent_item.get("last_turnout_percent", 0.0))
			recent_lines.append("%s · %s %d\nWinner: %s\nYour party: %d/%d seats · %.1f%% vote share\nTurnout: %.1f%%" % [recent_state, world._month_name(recent_month), recent_year, recent_winner, recent_player_seats, recent_total_seats, recent_player_share, recent_turnout])
		election_recent_results_label.text = "\n\n".join(recent_lines) if not recent_lines.is_empty() else "No completed state assembly results have been recorded yet."

	if is_instance_valid(election_live_results_label):
		var live_lines: PackedStringArray = []
		for item in state_elections:
			if not item is Dictionary:
				continue
			var phase := str(item.get("phase", "Scheduled"))
			if phase not in ["Campaigning", "Polling", "Counting", "Results"]:
				continue
			var state_name := str(item.get("state", "State"))
			var year := int(item.get("next_year", world.year))
			var month := int(item.get("month", world.month))
			var contested := int(item.get("player_party_candidates_contested", 0))
			var elected := int(item.get("player_party_candidates_elected", 0))
			var seats := int(item.get("assembly_seats", 0))
			var vote_shares: Dictionary = item.get("last_vote_shares", {})
			var player_share := float(vote_shares.get(world.player_party_id, 0.0))
			var result_text := str(item.get("last_result", "No previous result recorded"))
			var round_text := ""
			if phase == "Counting":
				round_text = "\nCounting round: %d / %d · constituencies declared: %d / %d" % [int(item.get("counting_round", 0)), int(item.get("counting_rounds_total", 4)), int(item.get("counted_constituencies", 0)), int(item.get("counting_total_constituencies", seats))]
			elif phase == "Polling":
				round_text = "\nPolling is underway; counting has not started."
			live_lines.append("%s — %s %d\nPhase: %s%s\nAssembly seats: %d\nThe current election's winners and vote totals are not declared yet.\nPrevious completed result: %s" % [state_name, world._month_name(month), year, phase, round_text, seats, result_text])
		election_live_results_label.text = "\n\n".join(live_lines) if not live_lines.is_empty() else "No state assembly election is currently campaigning or counting. Upcoming elections remain listed under State Assemblies."

	if is_instance_valid(lok_sabha_polling_counting_label):
		lok_sabha_polling_counting_label.text = world.lok_sabha_polling_counting_summary()

	if not is_instance_valid(election_archive_tabs):
		return

	# Building detailed constituency cards creates a large Control tree. Reuse it
	# when the saved election records have not changed instead of rebuilding on
	# every visit to the Elections page.
	var result_party_for_cache: Dictionary = world.parties.get(world.player_party_id, {})
	var result_key_parts: PackedStringArray = [
		world.player_party_id,
		str(result_party_for_cache.get("member_records", [])),
		str(world.last_local_election_year),
		world.last_local_election_result
	]
	for cache_item_variant in state_elections:
		if not cache_item_variant is Dictionary:
			continue
		var cache_item: Dictionary = cache_item_variant
		var cache_seats: Dictionary = cache_item.get("last_seats", {})
		var cache_shares: Dictionary = cache_item.get("last_vote_shares", {})
		var cache_constituencies: Array = cache_item.get("last_constituency_results", [])
		result_key_parts.append("%s|%s|%s|%s|%d|%s|%s|%s|%d|%d|%.2f" % [
			str(cache_item.get("state", "")),
			str(cache_item.get("phase", "")),
			str(cache_item.get("last_year", "")),
			str(cache_item.get("last_result", "")),
			cache_constituencies.size(),
			str(cache_seats),
			str(cache_shares),
			str(cache_constituencies),
			int(cache_item.get("last_ballots_cast", 0)),
			int(cache_item.get("last_eligible_voters", 0)),
			float(cache_item.get("last_turnout_percent", 0.0))
		])
	var national_cache_data: Dictionary = world.world_state.get("national_election", {})
	result_key_parts.append("%s|%s|%s|%s|%s" % [
		str(national_cache_data.get("last_year", "")),
		str(national_cache_data.get("last_result", "")),
		str(national_cache_data.get("last_winner", "")),
		str(national_cache_data.get("last_seats", {})),
		str(national_cache_data.get("last_constituency_results", []))
	])
	var result_cache_key := "\n".join(result_key_parts)
	if result_cache_key == _election_results_render_key:
		return
	_election_results_render_key = result_cache_key

	for child in election_archive_tabs.get_children():
		election_archive_tabs.remove_child(child)
		child.queue_free()

	var local_page := _new_tab(election_archive_tabs, "Local Elections")
	_add_section_title(local_page, "LOCAL ELECTION RESULTS")
	var state_page := _new_tab(election_archive_tabs, "State Assembly")
	_add_section_title(state_page, "STATE ASSEMBLY RESULTS")
	var state_result_tabs := TabContainer.new()
	state_result_tabs.name = "StateAssemblyResultTabs"
	state_result_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	state_result_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	state_result_tabs.custom_minimum_size = Vector2(0, 460)
	state_page.add_child(state_result_tabs)
	var national_page := _new_tab(election_archive_tabs, "Lok Sabha")
	_add_section_title(national_page, "LOK SABHA RESULTS")

	var ordered: Array = state_elections.duplicate()
	ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var ay := int(a.get("last_year", a.get("next_year", 0)))
		var by := int(b.get("last_year", b.get("next_year", 0)))
		if ay == by:
			return str(a.get("state", "")) < str(b.get("state", ""))
		return ay > by
	)

	var added_count := 0
	for item_variant in ordered:
		if not item_variant is Dictionary:
			continue
		var item: Dictionary = item_variant
		var state_name := str(item.get("state", "State"))
		var completed_year := int(item.get("last_year", -1))
		var phase := str(item.get("phase", "Scheduled"))
		var election_year := completed_year if completed_year >= 0 else int(item.get("next_year", world.year))
		var tab_title := "%s %d" % [state_name, election_year]
		if completed_year < 0:
			tab_title = "%s · %s" % [state_name, phase]
		var election_page := _new_tab(state_result_tabs, tab_title)
		added_count += 1

		_add_section_title(election_page, "%s STATE ASSEMBLY ELECTION" % state_name.to_upper())
		if completed_year < 0:
			var upcoming_card := _new_election_card(election_page, "Election status", "No completed result is saved for this election")
			_add_body(upcoming_card, "Scheduled: %s %d\nCurrent phase: %s\nAssembly seats: %d\nResults will appear here after the simulation resolves this election." % [world._month_name(int(item.get("month", world.month))), election_year, phase, int(item.get("assembly_seats", 0))])
			continue

		var winner_id := str(item.get("last_winner", ""))
		var winner := world._government_party_name(winner_id)
		var result_summary := str(item.get("last_result", "Result recorded"))
		var seats: Dictionary = item.get("last_seats", {})
		var total_seats := int(item.get("assembly_seats", 0))
		var majority := int(floor(float(total_seats) / 2.0)) + 1
		var player_seats := int(seats.get(world.player_party_id, 0))
		var vote_shares: Dictionary = item.get("last_vote_shares", {})
		var ballots := int(item.get("last_ballots_cast", 0))
		var eligible := int(item.get("last_eligible_voters", 0))
		var turnout := float(item.get("last_turnout_percent", 0.0))
		var player_share := float(vote_shares.get(world.player_party_id, 0.0))
		var spending_by_party: Dictionary = item.get("last_campaign_spending", {})
		var player_spending := int(spending_by_party.get(world.player_party_id, 0))
		var constituency_results: Array = item.get("last_constituency_results", [])

		var party_votes: Dictionary = {}
		var player_contested := 0
		var player_won := 0
		var player_lost := 0
		for seat_variant in constituency_results:
			if not seat_variant is Dictionary:
				continue
			var seat_record: Dictionary = seat_variant
			var winner_party_id := str(seat_record.get("winner_party_id", ""))
			var candidates: Array = seat_record.get("candidates", [])
			var player_candidate_found := false
			for candidate_variant in candidates:
				if not candidate_variant is Dictionary:
					continue
				var candidate_row: Dictionary = candidate_variant
				var party_id := str(candidate_row.get("party_id", ""))
				party_votes[party_id] = int(party_votes.get(party_id, 0)) + int(candidate_row.get("votes", 0))
				if party_id == world.player_party_id:
					player_candidate_found = true
			if player_candidate_found:
				player_contested += 1
				if winner_party_id == world.player_party_id:
					player_won += 1
				else:
					player_lost += 1

		var overview_card := _new_election_card(election_page, "Election outcome", "Recorded result · %d seats · majority mark %d" % [total_seats, majority])
		_add_body(overview_card, "WINNING PARTY\n%s\n\nRESULT\n%s\n\nYOUR PARTY\n%d seats · %.1f%% recorded vote share\n%d contested · %d won · %d lost\n\nTURNOUT\n%.1f%% · %s ballots cast from %s eligible voters\n\nYOUR CAMPAIGN SPENDING\n₹%s" % [winner, result_summary, player_seats, player_share, player_contested, player_won, player_lost, turnout, _format_election_number(ballots), _format_election_number(eligible), _format_election_number(player_spending)])

		var standings_card := _new_election_card(election_page, "Party standings", "Seats, recorded vote share, and votes counted from constituency candidate records")
		var standings: Array[Dictionary] = []
		for party_id_variant in seats.keys():
			var party_id := str(party_id_variant)
			var vote_total := int(party_votes.get(party_id, 0))
			var share := float(vote_total) * 100.0 / float(maxi(1, ballots))
			standings.append({"id": party_id, "name": world._government_party_name(party_id), "seats": int(seats.get(party_id_variant, 0)), "votes": vote_total, "share": share})
		standings.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			if int(a.get("seats", 0)) == int(b.get("seats", 0)):
				return int(a.get("votes", 0)) > int(b.get("votes", 0))
			return int(a.get("seats", 0)) > int(b.get("seats", 0))
		)
		var standings_lines: PackedStringArray = []
		for rank in range(standings.size()):
			var standing: Dictionary = standings[rank]
			standings_lines.append("%d. %s\n%d seats · %s votes · %.1f%%" % [rank + 1, str(standing.get("name", "Party")), int(standing.get("seats", 0)), _format_election_number(int(standing.get("votes", 0))), float(standing.get("share", 0.0))])
		_add_body(standings_card, "\n\n".join(standings_lines) if not standings_lines.is_empty() else "Party standings were not saved.")

		var constituency_card := _new_election_card(election_page, "Constituency results", "Recorded candidate results · each constituency shown separately")
		var constituency_list := VBoxContainer.new()
		constituency_list.add_theme_constant_override("separation", 8)
		constituency_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		constituency_card.add_child(constituency_list)
		if constituency_results.is_empty():
			_add_body(constituency_card, "Constituency-level candidate records were not saved for this election.")
		else:
			for seat_variant in constituency_results:
				if not seat_variant is Dictionary:
					continue
				var seat_record: Dictionary = seat_variant
				var constituency_name := str(seat_record.get("constituency", "Constituency %d" % int(seat_record.get("seat_number", 0))))
				var winner_party_id := str(seat_record.get("winner_party_id", ""))
				var winner_party_name := world._government_party_name(winner_party_id)
				var winner_candidate := str(seat_record.get("winner_candidate_name", "Winner not recorded"))
				var candidates: Array = seat_record.get("candidates", [])
				var winner_votes := 0
				var player_candidate_name := ""
				var player_candidate_votes := 0
				var candidate_name_counts: Dictionary = {}
				for candidate_variant in candidates:
					if not candidate_variant is Dictionary:
						continue
					var candidate_row: Dictionary = candidate_variant
					var candidate_party_id := str(candidate_row.get("party_id", ""))
					var candidate_votes := int(candidate_row.get("votes", 0))
					var candidate_name := str(candidate_row.get("candidate_name", "")).strip_edges()
					candidate_name_counts[candidate_name] = int(candidate_name_counts.get(candidate_name, 0)) + 1
					if candidate_party_id == winner_party_id:
						winner_votes = candidate_votes
				if int(candidate_name_counts.get(winner_candidate, 0)) > 1:
					winner_candidate = "Candidate name ambiguous in saved record"
				for candidate_variant in candidates:
					if not candidate_variant is Dictionary:
						continue
					var candidate_row: Dictionary = candidate_variant
					if str(candidate_row.get("party_id", "")) == world.player_party_id:
						player_candidate_name = str(candidate_row.get("candidate_name", ""))
						player_candidate_votes = int(candidate_row.get("votes", 0))
						if int(candidate_name_counts.get(player_candidate_name, 0)) > 1:
							player_candidate_name = "Candidate name ambiguous in saved record"
				var player_party_name := world._government_party_name(world.player_party_id)
				var player_result_text := "No candidate result recorded."
				if not player_candidate_name.is_empty():
					if winner_party_id == world.player_party_id:
						player_result_text = "%s (%s) · %s votes · WON" % [player_candidate_name, player_party_name, _format_election_number(player_candidate_votes)]
					else:
						player_result_text = "%s (%s) · %s votes · lost by %s votes" % [player_candidate_name, player_party_name, _format_election_number(player_candidate_votes), _format_election_number(maxi(0, winner_votes - player_candidate_votes))]
				var outcome_label := "Your party won" if winner_party_id == world.player_party_id else "Your party lost" if not player_candidate_name.is_empty() else "No party candidate recorded"
				var constituency_card_row := _new_election_card(constituency_list, constituency_name, "%s · %s" % [winner_party_name, outcome_label])
				var candidate_lines: PackedStringArray = []
				for candidate_variant in candidates:
					if not candidate_variant is Dictionary:
						continue
					var candidate: Dictionary = candidate_variant
					var candidate_party := world._government_party_name(str(candidate.get("party_id", "")))
					var candidate_name := str(candidate.get("candidate_name", "Candidate not recorded"))
					var candidate_vote_count := int(candidate.get("votes", 0))
					var candidate_share := float(candidate.get("vote_percent", candidate.get("vote_share", 0.0)))
					var candidate_status := "WINNER" if str(candidate.get("party_id", "")) == winner_party_id else ""
					candidate_lines.append("%s — %s — %s votes · %.1f%%%s" % [candidate_name, candidate_party, _format_election_number(candidate_vote_count), candidate_share, " · " + candidate_status if not candidate_status.is_empty() else ""])
				_add_body(constituency_card_row, "WINNER\n%s (%s) · %s votes\n\nYOUR PARTY\n%s\n\nALL CANDIDATES\n%s" % [winner_candidate, winner_party_name, _format_election_number(winner_votes), player_result_text, "\n".join(candidate_lines) if not candidate_lines.is_empty() else "Candidate vote records unavailable."])

		_add_personal_and_manual_member_results(election_page, constituency_results)
	# National and local contests get their own result tabs too; only fields actually saved by the career are displayed.
	var national: Dictionary = world.world_state.get("national_election", {})
	var national_year := int(national.get("last_year", -1))
	 
	var national_card := _new_election_card(national_page, "National result", "Recorded parliamentary election outcome")
	if national_year >= 0:
		var national_winner_id := str(national.get("last_winner", ""))
		var national_winner := world._government_party_name(national_winner_id)
		var national_seats: Dictionary = national.get("last_seats", {})
		var national_total_seats := int(national.get("seats", 543))
		var national_majority := int(floor(float(national_total_seats) / 2.0)) + 1
		var national_result := str(national.get("last_result", "Result recorded"))
		var national_standings: PackedStringArray = []
		for party_id_variant in national_seats.keys():
			var party_id := str(party_id_variant)
			national_standings.append("%s — %d seats" % [world._government_party_name(party_id), int(national_seats.get(party_id_variant, 0))])
		national_standings.sort()
		_add_body(national_card, "Election year: %d\nWinning party: %s\nSeats: %d · Majority mark: %d\n\n%s\n\nPARTY SEATS\n%s" % [national_year, national_winner, national_total_seats, national_majority, national_result, "\n".join(national_standings) if not national_standings.is_empty() else "Party seat totals not recorded."])
		_add_personal_and_manual_member_results(national_page, national.get("last_constituency_results", []))
	else:
		_add_body(national_card, "Next modeled election: %s %d\nNo completed Lok Sabha result is recorded in this career yet." % [world._month_name(int(national.get("month", 5))), int(national.get("next_year", world.year))])

	 
	var local_card := _new_election_card(local_page, "Local contest record", "Personal local election outcome")
	var local_year := int(world.last_local_election_year)
	if local_year > 0:
		var local_details: Dictionary = world.last_local_election_details
		var local_rows: Array = local_details.get("candidate_rows", [])
		var local_candidate_lines: PackedStringArray = []
		var local_winner_name := "Not recorded"
		var local_winner_votes := -1
		var local_runner_up_votes := 0
		for local_candidate_variant in local_rows:
			if not local_candidate_variant is Dictionary:
				continue
			var local_candidate: Dictionary = local_candidate_variant
			var local_candidate_votes := int(local_candidate.get("votes", 0))
			if local_candidate_votes > local_winner_votes:
				local_runner_up_votes = maxi(0, local_winner_votes)
				local_winner_votes = local_candidate_votes
				local_winner_name = str(local_candidate.get("candidate_name", "Candidate"))
			elif local_candidate_votes > local_runner_up_votes:
				local_runner_up_votes = local_candidate_votes
			local_candidate_lines.append("%s (%s) — %s votes · %.1f%%" % [
				str(local_candidate.get("candidate_name", "Candidate")),
				world._government_party_name(str(local_candidate.get("party_id", ""))),
				_format_election_number(int(local_candidate.get("votes", 0))),
				float(local_candidate.get("vote_percent", 0.0))
			])
		var local_personal_line := "You did not stand in this local election."
		if bool(local_details.get("player_stood", false)):
			local_personal_line = "%s — %s votes · %.1f%% · %s" % [
				str(local_details.get("player_candidate_name", world.character_name)),
				_format_election_number(int(local_details.get("player_votes", 0))),
				float(local_details.get("player_vote_share", world.last_election_vote_share)),
				"WON" if str(world.last_local_election_result) == "WON" else "LOST"
			]
		_add_body(local_card, "Election year: %d\nArea: %s\nResult: %s\nWinner: %s · Margin: %s votes\n\nYOUR PERSONAL VOTE\n%s\n\nCOMPETITORS\n%s\n\nBallots cast: %s / %s eligible · Turnout: %.1f%%" % [
			local_year, str(local_details.get("jurisdiction", world.local_election_area())),
			str(world.last_local_election_result), local_winner_name,
			_format_election_number(maxi(0, local_winner_votes - local_runner_up_votes)), local_personal_line,
			"\n".join(local_candidate_lines) if not local_candidate_lines.is_empty() else "Candidate vote details unavailable.",
			_format_election_number(int(local_details.get("ballots_cast", world.election_turnout))),
			_format_election_number(int(local_details.get("eligible_voters", 0))),
			float(local_details.get("turnout_percent", 0.0))
		])
		var local_manual_card := _new_election_card(local_page, "Manually added party members", "Recorded candidacies in the local contest")
		_add_body(local_manual_card, "No manually added party member candidacies are recorded in this personal local contest.")
	else:
		_add_body(local_card, "No completed personal local election result is recorded yet.\nNext modeled election year: %d" % int(world.local_election_year))
	if added_count == 0:
		var empty_page := _new_tab(state_result_tabs, "No records")
		_add_section_title(empty_page, "NO STATE ASSEMBLY RECORDS")
		_add_body(empty_page, "No state assembly election records are available in this career yet.")

func _refresh_state_election_cards(state_elections: Array) -> void:
	if not is_instance_valid(state_election_cards):
		return
	# Election cards contain many controls. Skip rebuilding them when the saved
	# election data is unchanged; the full results archive has its own cache.
	# A compact UI cache key based on the complete saved election records prevents
	# rebuilding hundreds of controls when the player returns to an unchanged page.
	var player_party: Dictionary = world.parties.get(world.player_party_id, {})
	var active_members_by_state: Dictionary = player_party.get("state_active_members", {})
	var render_key := "%d|%d|%s|%s|%d" % [world.year, world.month, str(state_elections), str(active_members_by_state), int(player_party.get("members", 0))]
	if render_key == _state_election_cards_render_key:
		return
	_state_election_cards_render_key = render_key
	for child in state_election_cards.get_children():
		state_election_cards.remove_child(child)
		child.queue_free()

	var ordered: Array = state_elections.duplicate(true)
	# UI-level fallback: older or malformed saves can still contain only a subset.
	# Keep every saved record, then add only missing modeled states.
	var known_states: Dictionary = {}
	for saved_variant in ordered:
		if saved_variant is Dictionary:
			var saved_name := str(saved_variant.get("state", "")).strip_edges()
			if not saved_name.is_empty():
				known_states[saved_name] = true
	var modeled_states: Array[String] = [
		"Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
		"Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
		"Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram",
		"Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu",
		"Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"
	]
	var modeled_seats: Dictionary = {
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
	for state_index in range(modeled_states.size()):
		var modeled_name := modeled_states[state_index]
		if known_states.has(modeled_name):
			continue
		ordered.append({
			"state": modeled_name,
			"next_year": 2028 + (state_index % 4),
			"month": 5 if state_index % 2 == 0 else 11,
			"assembly_seats": int(modeled_seats.get(modeled_name, 60)),
			"last_result": "Not yet held",
			"last_winner": "",
			"phase": "Scheduled",
			"campaign_spend_by_party": {}
		})
	# Persist the repaired list so other election summaries see the same records.
	world.world_state["state_elections"] = ordered
	ordered.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var a_state := str(a.get("state", ""))
		var b_state := str(b.get("state", ""))
		if a_state == b_state:
			return false
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
		metrics.text = "PARTY FOOTPRINT   Support %.1f%%   ·   ACTIVE MEMBERS %s   ·   Organization %s (%d/100)   ·   Candidates %d contested / %d elected   ·   Seats last won %d" % [support, world._format_number(organization_members), organization_status, organization_score, contested, elected, party_seats]
		metrics.add_theme_color_override("font_color", Color("#e7edf6"))
		metrics.add_theme_font_size_override("font_size", 13)
		metrics.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(metrics)

		var campaign_line := Label.new()
		campaign_line.text = "CAMPsimulationGN FINANCE   %s   ·   Current spend ₹%s   ·   Previous campaign spend ₹%s   ·   Active months %d" % [priority, world._format_number(current_spend), world._format_number(last_spend), campaign_months]
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
		dossier_text.text = "ELECTION\nNext poll: %s %d  ·  Phase: %s  ·  Assembly seats: %d\n\nPARTY ORGANIZATION\nSupport: %.1f%%  ·  Slate: %s\nActive members in state: %s  ·  Organization: %s  ·  Readiness %d/100\nLast poll organization effect: %s\nCandidates contested: %d  ·  Elected: %d  ·  Seats last won: %d\n\nCAMPsimulationGN FINANCE\nCurrent campaign spend: ₹%s  ·  Previous campaign spend: ₹%s\nStrategy: %s  ·  Campaign months active: %d\n\nLAST RESULT\n%s\nWinner: %s  ·  Party vote share: %.1f%%  ·  Turnout: %.1f%%\n\nGOVERNMENT & PARTICIPATION\nRuling party: %s  ·  Executive: %s\nEligible voters: %s  ·  Ballots cast: %s" % [
			world._month_name(poll_month), poll_year, phase, state_seats,
			support, slate_status, world._format_number(organization_members), organization_status, organization_score, organization_bonus_text, contested, elected, party_seats,
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



func _populate_assembly_state_picker(picker: OptionButton, preferred_state: String) -> void:
	if not is_instance_valid(picker):
		return
	picker.clear()
	var names: Array[String] = world.assembly_state_names()
	var selected_index := 0
	for state_index in range(names.size()):
		picker.add_item(names[state_index])
		picker.set_item_metadata(state_index, names[state_index])
		if names[state_index] == preferred_state:
			selected_index = state_index
	if picker.item_count > 0:
		picker.select(selected_index)

func _selected_candidate_state() -> String:
	if is_instance_valid(candidate_state_picker) and candidate_state_picker.selected >= 0:
		return str(candidate_state_picker.get_item_metadata(candidate_state_picker.selected))
	return "Karnataka"

func _selected_planner_state() -> String:
	if is_instance_valid(planner_state_picker) and planner_state_picker.selected >= 0:
		return str(planner_state_picker.get_item_metadata(planner_state_picker.selected))
	return "Karnataka"

func _get_state_campaign_plans(state_name: String) -> Dictionary:
	if state_name == "Karnataka":
		return world.world_state.get("constituency_campaign_plans", {})
	var all_plans: Dictionary = world.world_state.get("state_constituency_campaign_plans", {})
	return all_plans.get(state_name, {})

func _set_state_campaign_plans(state_name: String, plans: Dictionary) -> void:
	if state_name == "Karnataka":
		world.world_state["constituency_campaign_plans"] = plans
	else:
		var all_plans: Dictionary = world.world_state.get("state_constituency_campaign_plans", {})
		all_plans[state_name] = plans
		world.world_state["state_constituency_campaign_plans"] = all_plans

func _populate_constituency_plan_picker(query: String) -> void:
	if not is_instance_valid(constituency_plan_picker):
		return
	var previous_seat := -1
	if constituency_plan_picker.selected >= 0:
		previous_seat = int(constituency_plan_picker.get_item_metadata(constituency_plan_picker.selected))
	var needle := query.strip_edges().to_lower()
	constituency_plan_picker.clear()
	var selected_index := -1
	var state_name := _selected_planner_state()
	var seat_count := world.assembly_seat_count(state_name)
	for seat_number in range(1, seat_count + 1):
		var seat_name := world._constituency_name_for_seat(state_name, seat_number)
		var label := "%03d  ·  %s" % [seat_number, seat_name]
		if needle != "" and not label.to_lower().contains(needle) and not seat_name.to_lower().contains(needle):
			continue
		constituency_plan_picker.add_item(label)
		constituency_plan_picker.set_item_metadata(constituency_plan_picker.item_count - 1, seat_number)
		if seat_number == previous_seat:
			selected_index = constituency_plan_picker.item_count - 1
	if constituency_plan_picker.item_count == 0:
		constituency_plan_picker.add_item("No matching constituencies")
		constituency_plan_picker.set_item_metadata(0, -1)
		constituency_plan_picker.select(0)
		if is_instance_valid(constituency_plan_detail):
			constituency_plan_detail.text = "No constituency matches that search. Try a seat number or part of its name."
		return
	if selected_index < 0:
		selected_index = 0
	constituency_plan_picker.select(selected_index)

func _refresh_constituency_planner() -> void:
	if not is_instance_valid(constituency_plan_picker):
		return
	var query := ""
	if is_instance_valid(constituency_plan_search):
		query = constituency_plan_search.text
	_populate_constituency_plan_picker(query)
	var state_name := _selected_planner_state()
	var plans: Dictionary = _get_state_campaign_plans(state_name)
	var seat_count := world.assembly_seat_count(state_name)
	var planned_count := 0
	var total_allocation := 0.0
	for value in plans.values():
		if value is Dictionary:
			planned_count += 1
			total_allocation += float(value.get("allocation_crore", 0.0))
	var spending_summary: Dictionary = world.karnataka_constituency_campaign_spending_summary() if state_name == "Karnataka" else {"current": 0, "previous": 0}
	var current_spend := int(spending_summary.get("current", 0))
	var previous_spend := int(spending_summary.get("previous", 0))
	if is_instance_valid(constituency_plan_summary):
		constituency_plan_summary.text = "%s  ·  %d SEATS\nPlans recorded  %d / %d  ·  Total planned allocation  ₹%.1f crore\nRecorded spend this campaign  ₹%s  ·  Previous campaign  ₹%s" % [state_name.to_upper(), seat_count, planned_count, seat_count, total_allocation, world._format_number(current_spend), world._format_number(previous_spend)]
	if is_instance_valid(constituency_campaign_dashboard):
		var dashboard_lines: PackedStringArray = []
		dashboard_lines.append("Seat | Priority | Planned | Recorded | Remaining | Progress")
		var dashboard_count := 0
		for seat_number in range(1, seat_count + 1):
			var plan_value = plans.get(str(seat_number), null)
			if not (plan_value is Dictionary):
				continue
			var allocation_crore := float(plan_value.get("allocation_crore", 0.0))
			var seat_spending: Dictionary = world.karnataka_constituency_campaign_spend(seat_number) if state_name == "Karnataka" else {"current": 0, "previous": 0}
			var recorded_rupees := int(seat_spending.get("current", 0))
			var recorded_crore := float(recorded_rupees) / 10000000.0
			var remaining_crore := maxf(0.0, allocation_crore - recorded_crore)
			var progress_percent := 0
			if allocation_crore > 0.0:
				progress_percent = clampi(roundi(recorded_crore / allocation_crore * 100.0), 0, 100)
			var seat_name := world._constituency_name_for_seat(state_name, seat_number)
			var priority_name := str(plan_value.get("priority", "Target"))
			dashboard_lines.append("%03d %s | %s | ₹%.1f cr | ₹%.2f cr | ₹%.2f cr | %d percent" % [seat_number, seat_name, priority_name, allocation_crore, recorded_crore, remaining_crore, progress_percent])
			dashboard_count += 1
		if dashboard_count == 0:
			dashboard_lines.append("No saved constituency plans yet.")
		constituency_campaign_dashboard.text = "\n".join(dashboard_lines)
	if is_instance_valid(statewide_campaign_status):
		statewide_campaign_status.text = world.karnataka_auto_campaign_summary() if state_name == "Karnataka" else "Plans are saved for %s. Automated campaign launch and spending are currently connected to Karnataka only." % state_name
	_load_constituency_plan_controls()
	_refresh_bulk_campaign_activity_summary()

func _create_bulk_campaign_activity_plan() -> void:
	var plans: Dictionary = world.world_state.get("constituency_campaign_plans", {})
	var group_index := campaign_activity_group.selected if is_instance_valid(campaign_activity_group) else 0
	var selected_priority: String = ["", "Defend", "Target", "Low Priority"][clampi(group_index, 0, 3)]
	var eligible_seats: Array[int] = []
	for seat_number in range(1, 225):
		var plan_value = plans.get(str(seat_number), null)
		if not (plan_value is Dictionary):
			continue
		if selected_priority != "" and str(plan_value.get("priority", "Target")) != selected_priority:
			continue
		eligible_seats.append(seat_number)
	if eligible_seats.is_empty():
		report_label.text = "No saved constituency plans match this group. Save constituency plans first."
		return
	var requested_count := clampi(roundi(campaign_activity_count.value), 1, 224)
	var activity_count := mini(requested_count, eligible_seats.size())
	var activity_name := campaign_activity_type.get_item_text(campaign_activity_type.selected) if is_instance_valid(campaign_activity_type) and campaign_activity_type.selected >= 0 else "Candidate visit"
	var total_budget_crore := snappedf(campaign_activity_budget.value, 0.1)
	var assignments: Array[Dictionary] = []
	for i in range(activity_count):
		var seat_number := eligible_seats[i % eligible_seats.size()]
		assignments.append({
			"seat_number": seat_number,
			"constituency": world._constituency_name_for_seat("Karnataka", seat_number),
			"activity": activity_name,
			"planned_budget_crore": total_budget_crore / float(activity_count),
			"status": "Planned"
		})
	var activity_plans: Array = world.world_state.get("bulk_campaign_activity_plans", [])
	activity_plans.append({
		"created_month_index": world.year * 12 + world.month,
		"group": campaign_activity_group.get_item_text(group_index),
		"activity": activity_name,
		"activity_count": activity_count,
		"total_budget_crore": total_budget_crore,
		"actual_spend_crore": 0.0,
		"status": "Planned",
		"assignments": assignments
	})
	world.world_state["bulk_campaign_activity_plans"] = activity_plans
	_save_progress()
	_refresh_bulk_campaign_activity_summary()
	report_label.text = "Bulk campaign activity plan saved for %d constituencies." % activity_count


func _refresh_bulk_campaign_activity_summary() -> void:
	if not is_instance_valid(campaign_activity_summary):
		return
	var activity_plans: Array = world.world_state.get("bulk_campaign_activity_plans", [])
	var summary_lines: PackedStringArray = []
	summary_lines.append("Saved bulk plans: %d" % activity_plans.size())
	var shown := 0
	for plan_value in activity_plans:
		if not (plan_value is Dictionary):
			continue
		var assignments: Array = plan_value.get("assignments", [])
		summary_lines.append("%s · %s · %d activities · ₹%.1f crore planned · %s" % [
			str(plan_value.get("group", "Selected seats")),
			str(plan_value.get("activity", "Campaign activity")),
			int(plan_value.get("activity_count", assignments.size())),
			float(plan_value.get("total_budget_crore", 0.0)),
			str(plan_value.get("status", "Planned"))
		])
		shown += 1
		if shown >= 5:
			break
	if activity_plans.is_empty():
		summary_lines.append("No bulk activity plans recorded yet.")
	elif activity_plans.size() > shown:
		summary_lines.append("Showing the 5 most recent plans.")
	campaign_activity_summary.text = "\n".join(summary_lines)

	if is_instance_valid(campaign_activity_plan_picker):
		var previous_index := -1
		if campaign_activity_plan_picker.selected >= 0:
			previous_index = int(campaign_activity_plan_picker.get_item_metadata(campaign_activity_plan_picker.selected))
		campaign_activity_plan_picker.clear()
		for plan_index in range(activity_plans.size()):
			var plan_value = activity_plans[plan_index]
			if not (plan_value is Dictionary):
				continue
			var assignments: Array = plan_value.get("assignments", [])
			var caption := "%s · %s · %d activities · %s" % [
				str(plan_value.get("group", "Selected seats")),
				str(plan_value.get("activity", "Activity")),
				int(plan_value.get("activity_count", assignments.size())),
				str(plan_value.get("status", "Planned"))
			]
			campaign_activity_plan_picker.add_item(caption)
			campaign_activity_plan_picker.set_item_metadata(campaign_activity_plan_picker.item_count - 1, plan_index)
		if campaign_activity_plan_picker.item_count > 0:
			var selected_item := 0
			for item_index in range(campaign_activity_plan_picker.item_count):
				if int(campaign_activity_plan_picker.get_item_metadata(item_index)) == previous_index:
					selected_item = item_index
					break
			campaign_activity_plan_picker.select(selected_item)
		_load_selected_bulk_campaign_activity_plan()


func _on_bulk_campaign_activity_plan_selected(_index: int) -> void:
	_load_selected_bulk_campaign_activity_plan()


func _load_selected_bulk_campaign_activity_plan() -> void:
	if not is_instance_valid(campaign_activity_plan_picker):
		return
	var plans: Array = world.world_state.get("bulk_campaign_activity_plans", [])
	if campaign_activity_plan_picker.selected < 0:
		if is_instance_valid(campaign_activity_management_summary):
			campaign_activity_management_summary.text = "No saved activity plans to manage."
		return
	var plan_index := int(campaign_activity_plan_picker.get_item_metadata(campaign_activity_plan_picker.selected))
	if plan_index < 0 or plan_index >= plans.size() or not (plans[plan_index] is Dictionary):
		return
	var plan_value: Dictionary = plans[plan_index]
	var status_name := str(plan_value.get("status", "Planned"))
	if is_instance_valid(campaign_activity_status):
		for i in range(campaign_activity_status.item_count):
			if campaign_activity_status.get_item_text(i) == status_name:
				campaign_activity_status.select(i)
				break
	if is_instance_valid(campaign_activity_actual_spend):
		campaign_activity_actual_spend.value = float(plan_value.get("actual_spend_crore", 0.0))
	if is_instance_valid(campaign_activity_management_summary):
		var assignments: Array = plan_value.get("assignments", [])
		var seat_names: PackedStringArray = []
		for assignment in assignments:
			if assignment is Dictionary:
				seat_names.append(str(assignment.get("constituency", "Seat")))
		campaign_activity_management_summary.text = "Activities: %d · Planned budget: ₹%.1f crore · Actual spend recorded: ₹%.1f crore\nIncluded seats: %s" % [
			int(plan_value.get("activity_count", assignments.size())),
			float(plan_value.get("total_budget_crore", 0.0)),
			float(plan_value.get("actual_spend_crore", 0.0)),
			", ".join(seat_names)
		]


func _save_bulk_campaign_activity_plan_management() -> void:
	if not is_instance_valid(campaign_activity_plan_picker) or campaign_activity_plan_picker.selected < 0:
		report_label.text = "Create a bulk activity plan before managing one."
		return
	var plans: Array = world.world_state.get("bulk_campaign_activity_plans", [])
	var plan_index := int(campaign_activity_plan_picker.get_item_metadata(campaign_activity_plan_picker.selected))
	if plan_index < 0 or plan_index >= plans.size() or not (plans[plan_index] is Dictionary):
		report_label.text = "The selected activity plan could not be found."
		return
	var plan_value: Dictionary = plans[plan_index]
	plan_value["status"] = campaign_activity_status.get_item_text(campaign_activity_status.selected)
	plan_value["actual_spend_crore"] = snappedf(campaign_activity_actual_spend.value, 0.1)
	plans[plan_index] = plan_value
	world.world_state["bulk_campaign_activity_plans"] = plans
	_save_progress()
	_refresh_bulk_campaign_activity_summary()
	report_label.text = "Activity plan status and actual spending saved."


func _load_constituency_plan_controls() -> void:
	if not is_instance_valid(constituency_plan_picker) or constituency_plan_picker.selected < 0:
		return
	var seat_number := int(constituency_plan_picker.get_item_metadata(constituency_plan_picker.selected))
	if seat_number < 1:
		return
	var state_name := _selected_planner_state()
	var plans: Dictionary = _get_state_campaign_plans(state_name)
	var plan: Dictionary = plans.get(str(seat_number), {})
	var priority := str(plan.get("priority", "Target"))
	for i in range(constituency_plan_priority.item_count):
		if constituency_plan_priority.get_item_text(i) == priority:
			constituency_plan_priority.select(i)
			break
	constituency_plan_budget.value = float(plan.get("allocation_crore", 0.0))
	var candidate_name := "No nominee assigned"
	var review_status := "No ticket review recorded"
	for row in world.state_candidate_review_rows(state_name):
		if int(row.get("seat_number", 0)) == seat_number:
			candidate_name = str(row.get("candidate_name", candidate_name))
			review_status = str(row.get("decision", review_status))
			break
	var seat_spending: Dictionary = world.karnataka_constituency_campaign_spend(seat_number) if state_name == "Karnataka" else {"current": 0, "previous": 0}
	var current_spend := int(seat_spending.get("current", 0))
	var previous_spend := int(seat_spending.get("previous", 0))
	constituency_plan_detail.text = "STATE  %s\nSEAT  %03d  ·  %s\nPARTY NOMINEE  %s\nTICKET REVIEW  %s\nCURRENT PLAN  %s  ·  ₹%.1f crore\nACTUAL SPEND  ₹%s this campaign  ·  ₹%s previous campaign" % [state_name, seat_number, world._constituency_name_for_seat(state_name, seat_number), candidate_name, review_status, priority, float(plan.get("allocation_crore", 0.0)), world._format_number(current_spend), world._format_number(previous_spend)]

func _auto_set_all_constituency_plans() -> void:
	var state_name := _selected_planner_state()
	var plans: Dictionary = _get_state_campaign_plans(state_name)
	var seat_count := world.assembly_seat_count(state_name)
	if seat_count <= 0:
		report_label.text = "No constituency records are available for %s." % state_name
		return
	var total_budget_crore := maxf(0.0, constituency_total_budget.value if is_instance_valid(constituency_total_budget) else 0.0)
	var per_seat_budget := total_budget_crore / float(seat_count)
	for seat_number in range(1, seat_count + 1):
		var key := str(seat_number)
		var existing: Dictionary = plans.get(key, {})
		plans[key] = {
			"seat_number": seat_number,
			"constituency": world._constituency_name_for_seat(state_name, seat_number),
			"priority": str(existing.get("priority", "Target")),
			"allocation_crore": per_seat_budget
		}
	_set_state_campaign_plans(state_name, plans)
	_save_progress()
	_refresh_constituency_planner()
	report_label.text = "₹%.2f crore distributed across %d %s constituencies (about ₹%.4f crore per seat). Existing priorities were preserved." % [total_budget_crore, seat_count, state_name, per_seat_budget]

func _toggle_statewide_campaign() -> void:
	var campaign: Dictionary = world.world_state.get("karnataka_auto_campaign", {})
	var message := world.stop_karnataka_auto_campaign() if bool(campaign.get("active", false)) else world.start_karnataka_auto_campaign()
	report_label.text = message
	_refresh()
	_save_progress()


func _save_constituency_plan() -> void:
	if not is_instance_valid(constituency_plan_picker) or constituency_plan_picker.selected < 0:
		return
	var seat_number := int(constituency_plan_picker.get_item_metadata(constituency_plan_picker.selected))
	if seat_number < 1:
		return
	var state_name := _selected_planner_state()
	var plans: Dictionary = _get_state_campaign_plans(state_name)
	var priority := constituency_plan_priority.get_item_text(constituency_plan_priority.selected) if constituency_plan_priority.selected >= 0 else "Target"
	plans[str(seat_number)] = {"seat_number": seat_number, "constituency": world._constituency_name_for_seat(state_name, seat_number), "priority": priority, "allocation_crore": snappedf(constituency_plan_budget.value, 0.1)}
	_set_state_campaign_plans(state_name, plans)
	_save_progress()
	_refresh_constituency_planner()
	report_label.text = "Constituency plan saved for %s, %s." % [world._constituency_name_for_seat(state_name, seat_number), state_name]


func _refresh_karnataka_candidate_review() -> void:
	if not is_instance_valid(karnataka_candidate_picker):
		return
	var state_name := _selected_candidate_state()
	var seat_count := world.assembly_seat_count(state_name)
	var rows := world.state_candidate_review_rows(state_name)
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
		karnataka_candidate_summary.text = "%s  ·  %d SEATS\nApproved  %d  ·  Rejected  %d  ·  Pending  %d\nChanges are saved automatically with this career." % [state_name.to_upper(), seat_count, approved, rejected, seat_count - approved - rejected]
	if is_instance_valid(karnataka_candidate_contest_status):
		var contest_enabled := world.is_karnataka_contest_enabled()
		karnataka_candidate_contest_status.text = "KARNATAKA ASSEMBLY CONTEST: %s\n%s" % ["ENABLED" if contest_enabled else "DISABLED", "Your party is eligible to contest Karnataka Assembly elections." if contest_enabled else "Your party will not contest Karnataka Assembly elections while this is disabled."]
	if is_instance_valid(karnataka_contest_toggle_button):
		var contest_on := world.is_karnataka_contest_enabled()
		karnataka_contest_toggle_button.text = "KARNATAKA ASSEMBLY CONTEST: %s  ·  TAP TO %s" % ["ON" if contest_on else "OFF", "DISABLE" if contest_on else "ENABLE"]
	_refresh_karnataka_member_picker()


func _refresh_karnataka_member_picker() -> void:
	if not is_instance_valid(karnataka_member_picker):
		return
	var query := karnataka_member_search.text.strip_edges().to_lower() if is_instance_valid(karnataka_member_search) else ""
	var previous_id := ""
	var previous_selection := karnataka_member_picker.get_selected_items()
	if not previous_selection.is_empty():
		previous_id = str(karnataka_member_picker.get_item_metadata(previous_selection[0]))
	karnataka_member_picker.clear()
	var matching_members: Array = world.state_party_member_search(_selected_candidate_state(), query)
	var visible_count := mini(matching_members.size(), 50)
	for index in range(visible_count):
		var member: Dictionary = matching_members[index]
		var member_name := str(member.get("name", "Party member"))
		var member_id := str(member.get("id", ""))
		karnataka_member_picker.add_item(member_name)
		karnataka_member_picker.set_item_metadata(karnataka_member_picker.item_count - 1, member_id)
		if member_id == previous_id:
			karnataka_member_picker.select(karnataka_member_picker.item_count - 1)
	if is_instance_valid(karnataka_member_search_status):
		if query.length() < 2:
			karnataka_member_search_status.text = "Showing %d of %d party members. Type a name to narrow the list." % [visible_count, matching_members.size()]
		elif matching_members.is_empty():
			karnataka_member_search_status.text = "No party members match “%s”. Check the spelling or search by a shorter name." % query
		else:
			karnataka_member_search_status.text = "%d matching party member(s). Select a name below, then assign it to the selected constituency." % matching_members.size()
	if karnataka_member_picker.get_selected_items().is_empty() and karnataka_member_picker.item_count > 0:
		karnataka_member_picker.select(0)
	var selected_items := karnataka_member_picker.get_selected_items()
	if not selected_items.is_empty():
		_on_karnataka_member_picker_selected(selected_items[0])


func _on_karnataka_member_picker_selected(index: int) -> void:
	if not is_instance_valid(karnataka_member_picker):
		return
	if index < 0 or index >= karnataka_member_picker.item_count:
		return
	var member_name := karnataka_member_picker.get_item_text(index)
	if is_instance_valid(karnataka_member_search_status):
		karnataka_member_search_status.text = "Selected: %s. Press Assign Selected Party Member to Constituency." % member_name


func _on_assign_karnataka_candidate() -> void:
	if not is_instance_valid(karnataka_member_picker):
		report_label.text = "Search for and select a party member first."
		return
	var selected_members := karnataka_member_picker.get_selected_items()
	if selected_members.is_empty():
		report_label.text = "Select a party member from the visible search results first."
		return
	var member_id := str(karnataka_member_picker.get_item_metadata(selected_members[0]))
	var seat_number := _selected_karnataka_seat_number()
	var result := world.assign_state_candidate(_selected_candidate_state(), seat_number, member_id)
	if is_instance_valid(karnataka_assignment_status):
		karnataka_assignment_status.text = result
		karnataka_assignment_status.add_theme_color_override("font_color", Color("#d6b15a") if result.contains("assigned to contest") else Color("#ff9b91"))
	_refresh_karnataka_candidate_review()
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
	var rows := world.state_candidate_review_rows(_selected_candidate_state())
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
		if is_instance_valid(karnataka_candidate_status):
			karnataka_candidate_status.text = "Select a constituency ticket first."
		return
	var result := world.set_state_candidate_decision(_selected_candidate_state(), _selected_karnataka_seat_number(), decision)
	report_label.text = result
	_refresh()
	if is_instance_valid(karnataka_candidate_status):
		karnataka_candidate_status.text = result
	_save_progress()

func _on_approve_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Approved")

func _on_reject_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Rejected")

func _on_reset_karnataka_candidate() -> void:
	_set_selected_karnataka_candidate_decision("Pending")

func _on_bulk_assign_state_candidates() -> void:
	var state_name := _selected_candidate_state()
	var result := world.bulk_assign_state_candidates(state_name)
	report_label.text = result
	if is_instance_valid(karnataka_candidate_status):
		karnataka_candidate_status.text = result
	_refresh_karnataka_candidate_review()
	_save_progress()


func _on_bulk_approve_karnataka_candidates() -> void:
	var result := world.bulk_approve_state_candidates(_selected_candidate_state())
	report_label.text = result
	_refresh()
	if is_instance_valid(karnataka_candidate_status):
		karnataka_candidate_status.text = result
	_save_progress()

func _on_toggle_karnataka_contest() -> void:
	var result := world.toggle_karnataka_contest()
	report_label.text = result
	_refresh()
	if is_instance_valid(karnataka_candidate_contest_status):
		karnataka_candidate_contest_status.text = "%s\nCurrent status: %s" % [result, "ENABLED" if world.is_karnataka_contest_enabled() else "DISABLED"]
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

func _party_roster_render_signature(roster: Array) -> String:
	# Keep the cache signature compact: serializing every full member Dictionary
	# on each tab visit was itself expensive for large rosters.
	var parts := PackedStringArray()
	parts.resize(roster.size())
	for index in range(roster.size()):
		var item: Variant = roster[index]
		if not item is Dictionary:
			parts[index] = "<invalid>"
			continue
		var member: Dictionary = item
		parts[index] = "%s~%s~%s~%s~%s~%s" % [
			str(member.get("id", "")),
			str(member.get("name", "")),
			str(member.get("duty", "Volunteer")),
			str(member.get("region", "Karnataka")),
			str(member.get("party_post", member.get("party_role", "Not assigned"))),
			str(bool(member.get("is_player_added", false)))
		]
	return "|".join(parts)

func _refresh_party_members() -> void:
	if not is_instance_valid(party_member_area) or not is_instance_valid(duty_member_picker):
		return
	# Party pages can contain hundreds of roster entries and several selection lists.
	# Rebuilding them on every page visit was a major source of tab-switch latency.
	# Keep the rendered controls when the underlying roster and filters are unchanged.
	var roster: Array = world.get_player_party_members()
	var party_for_cache: Dictionary = world.parties.get(world.player_party_id, {})
	var selected_office_for_cache := party_office_picker.get_item_text(party_office_picker.selected) if is_instance_valid(party_office_picker) and party_office_picker.item_count > 0 else "General Secretary"
	var member_render_key := "%s|%s|%s|%s|%s|%s|%s|%s|%s" % [
		_party_roster_render_signature(roster),
		str(party_for_cache.get("constitution", {})),
		str(party_for_cache.get("internal_election", {})),
		str(party_for_cache.get("office_elections", {})),
		selected_office_for_cache,
		party_member_search.text if is_instance_valid(party_member_search) else "",
		organization_member_search.text if is_instance_valid(organization_member_search) else "",
		duty_member_search.text if is_instance_valid(duty_member_search) else "",
		internal_candidate_search.text if is_instance_valid(internal_candidate_search) else ""
	]
	member_render_key += "|" + (internal_ballot_search.text if is_instance_valid(internal_ballot_search) else "")
	member_render_key += "|" + (office_ballot_search.text if is_instance_valid(office_ballot_search) else "")
	if member_render_key == _party_members_render_key:
		return
	_party_members_render_key = member_render_key
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
		var organization_query := organization_member_search.text.strip_edges().to_lower() if is_instance_valid(organization_member_search) else ""
		for member_variant in roster:
			if organization_member_picker.item_count >= 300:
				break
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
		if duty_member_picker.item_count < 300 and (duty_query.is_empty() or member_name.to_lower().contains(duty_query) or str(member.get("id", "")).to_lower().contains(duty_query)):
			duty_member_picker.add_item(member_name)
			duty_member_picker.set_item_metadata(duty_member_picker.item_count - 1, str(member.get("id", "")))
		var candidate_query := internal_candidate_search.text.strip_edges().to_lower() if is_instance_valid(internal_candidate_search) else ""
		if is_instance_valid(internal_candidate_picker) and internal_candidate_picker.item_count < 300 and (candidate_query.is_empty() or member_name.to_lower().contains(candidate_query) or str(member.get("id", "")).to_lower().contains(candidate_query)):
			internal_candidate_picker.add_item(member_name)
			internal_candidate_picker.set_item_metadata(internal_candidate_picker.item_count - 1, str(member.get("id", "")))
	if is_instance_valid(party_member_count_label):
		if roster_query_for_count.is_empty() and matching_member_count > 50:
			party_member_count_label.text = "Your manually added members appear first. Showing first 50 of %d members; search by name or ID to find others. Selection lists show up to 300 matches; narrow your search for more precise results." % roster.size()
		else:
			party_member_count_label.text = "%d matching members" % matching_member_count
	if roster.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No named roster records yet. Add a member above."
		party_member_area.add_child(empty_label)
	_refresh_organization_profile()
	_refresh_member_details_directory(roster)

func _refresh_member_details_directory(roster: Array = []) -> void:
	if not is_instance_valid(member_details_list) or not is_instance_valid(member_details_search):
		return
	var query := member_details_search.text.strip_edges().to_lower()
	if roster.is_empty():
		roster = world.get_player_party_members()
	var details_render_key := "%s|%s" % [_party_roster_render_signature(roster), query]
	if details_render_key == _member_details_render_key:
		return
	_member_details_render_key = details_render_key
	for child in member_details_list.get_children():
		child.queue_free()
	var matches := 0
	for item in roster:
		if not item is Dictionary:
			continue
		var member: Dictionary = item
		var name := str(member.get("name", "Member"))
		var member_id := str(member.get("id", ""))
		if not query.is_empty() and not name.to_lower().contains(query) and not member_id.to_lower().contains(query):
			continue
		matches += 1
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = "%s · %s · %s" % [name, str(member.get("duty", "Volunteer")), str(member.get("region", "Karnataka"))]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(label)
		var view := Button.new()
		view.text = "VIEW PROFILE"
		view.pressed.connect(func(): _show_member_detail_profile(member))
		row.add_child(view)
		member_details_list.add_child(row)
	if matches == 0:
		var empty := Label.new()
		empty.text = "No matching members. Try a name or member ID."
		member_details_list.add_child(empty)

func _member_current_government_assignment(member: Dictionary) -> Dictionary:
	# Resolve by stable member ID whenever government records contain one.
	# Legacy government records may only contain names; never assign an office
	# from a name-only match when that name appears in multiple jurisdictions.
	var member_id := str(member.get("id", "")).strip_edges()
	var member_name := str(member.get("name", "")).strip_edges()
	if member_name.is_empty():
		return {}
	var system: Dictionary = world.world_state.get("governments", {})
	var national: Dictionary = system.get("national", {})
	var states: Dictionary = system.get("states", {})
	var matches: Array[Dictionary] = []

	var national_id := str(national.get("leader_member_id", "")).strip_edges()
	var national_name := str(national.get("leader_name", "")).strip_edges()
	if (not member_id.is_empty() and not national_id.is_empty() and member_id == national_id) or (national_id.is_empty() and national_name.to_lower() == member_name.to_lower()):
		matches.append({"post": str(national.get("leader_title", "Prime Minister")), "jurisdiction": "India", "member_id": national_id})

	for state_variant in states.keys():
		var state_name := str(state_variant)
		var government: Dictionary = states.get(state_variant, {})
		var leader_id := str(government.get("leader_member_id", "")).strip_edges()
		var leader_name := str(government.get("leader_name", "")).strip_edges()
		if (not member_id.is_empty() and not leader_id.is_empty() and member_id == leader_id) or (leader_id.is_empty() and leader_name.to_lower() == member_name.to_lower()):
			matches.append({"post": str(government.get("leader_title", "Chief Minister")), "jurisdiction": state_name, "member_id": leader_id})
		var appointments: Dictionary = government.get("cabinet_appointments", {})
		for portfolio_variant in appointments.keys():
			var appointment: Variant = appointments[portfolio_variant]
			var appointee_id := str(appointment.get("member_id", "")).strip_edges() if appointment is Dictionary else ""
			var appointee_name := str(appointment.get("member_name", appointment.get("name", ""))).strip_edges() if appointment is Dictionary else str(appointment).strip_edges()
			if (not member_id.is_empty() and not appointee_id.is_empty() and member_id == appointee_id) or (appointee_id.is_empty() and appointee_name.to_lower() == member_name.to_lower()):
				matches.append({"post": str(portfolio_variant), "jurisdiction": state_name, "member_id": appointee_id})

	if matches.size() == 1:
		return matches[0]
	if matches.size() > 1:
		# Name-only legacy matches are not enough to distinguish same-name people.
		for match_variant in matches:
			var match: Dictionary = match_variant
			if not str(match.get("member_id", "")).is_empty() and str(match.get("member_id", "")) == member_id:
				return match
		return {"ambiguous": true}
	return {}

func _show_member_detail_profile(member: Dictionary) -> void:
	var name := str(member.get("name", "Member"))
	var lines: Array[String] = []
	lines.append("NAME: %s" % name)
	lines.append("MEMBER ID: %s" % str(member.get("id", "Not recorded")))
	lines.append("PARTY: %s" % str(world.parties.get(world.player_party_id, {}).get("name", world._government_party_name(world.player_party_id))))
	lines.append("PARTY POST: %s" % str(member.get("party_post", member.get("party_role", "Not assigned"))))
	var current_office := _member_current_government_assignment(member)
	var office_label := str(current_office.get("post", "Not recorded"))
	if bool(current_office.get("ambiguous", false)):
		office_label = "Not resolved (duplicate name; office record has no member ID)"
	lines.append("GOVERNMENT POST: %s" % office_label)
	var constituency_text := str(member.get("constituency", member.get("region", "Not recorded")))
	if not current_office.is_empty() and not bool(current_office.get("ambiguous", false)):
		var office_jurisdiction := str(current_office.get("jurisdiction", ""))
		if office_jurisdiction.to_lower() == "india":
			constituency_text = "India"
		elif not office_jurisdiction.is_empty():
			constituency_text = office_jurisdiction
			var recorded_constituency := str(member.get("constituency", "")).strip_edges()
			if not recorded_constituency.is_empty():
				constituency_text += " · " + recorded_constituency
	lines.append("REGION / CONSTITUENCY: %s" % constituency_text)
	lines.append("ORGANIZATION DUTY: %s" % str(member.get("duty", "Volunteer")))
	lines.append("MEMBERSHIP: %s" % ("Manually added" if bool(member.get("is_player_added", false)) else "Party roster"))
	for field in ["status", "experience", "loyalty", "reputation", "election_history"]:
		if member.has(field):
			lines.append("%s: %s" % [field.replace("_", " ").capitalize(), str(member[field])])
	member_details_dialog.dialog_text = "\n".join(lines)
	member_details_dialog.popup_centered(Vector2i(560, 520))

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
	organization_profile_label.text = "READINESS  %d/100  ·  %s\nACTIVE MEMBERS IN STATE  %s  ·  NAMED ROSTER  %s  ·  MODELED ELECTION-SCORE EFFECT  +%.2f points (maximum +2.50)\nROLE COVERAGE  %s\nNEXT ORGANIZATION PRIORITIES  %s" % [
		int(profile.get("readiness_score", 0)), str(profile.get("readiness", "No structure")),
		world._format_number(int(profile.get("member_count", 0))), world._format_number(int(profile.get("named_member_count", 0))), float(profile.get("election_score_bonus", 0.0)),
		" · ".join(PackedStringArray(role_parts)) if not role_parts.is_empty() else "No assigned duties",
		priority_text
	]

func _notification(what: int) -> void:
	if not is_instance_valid(world) or not world.career_started:
		return
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		world.save_game()
