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
var office_mission_list: VBoxContainer
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
var setup_box: VBoxContainer
var dashboard_box: TabContainer
var main_tab_bar: ScrollContainer
var main_tab_buttons: Array[Button] = []
var overview_metric_values: Array[Label] = []
var party_member_name_input: LineEdit
var party_member_area: VBoxContainer
var duty_member_picker: OptionButton
var duty_role_picker: OptionButton
var party_member_status: Label

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

    _add_body(setup_box, "Choose your entry into politics:")
    _add_button(setup_box, "JOIN AN ESTABLISHED PARTY", _on_join_party)
    _add_button(setup_box, "FOUND MY OWN PARTY", _on_found_party)
    _add_body(setup_box, "Joining starts you as a volunteer. Founding starts you with five supporters and limited funds. Neither path grants an elected office.")

func _build_dashboard() -> void:
    var overview := _new_tab(dashboard_box, "Overview")
    _add_dashboard_hero(overview)
    _add_section_title(overview, "YOUR STANDING")
    _add_overview_metrics(overview)
    _add_section_title(overview, "CAREER SNAPSHOT")
    career_label = _add_body(overview, "")
    _add_section_title(overview, "PARTY SNAPSHOT")
    party_label = _add_body(overview, "")
    _add_section_title(overview, "ELECTION SNAPSHOT")
    election_label = _add_body(overview, "")
    _add_section_title(overview, "LOCAL CONDITIONS")
    conditions_label = _add_body(overview, "")
    _add_button(overview, "ADVANCE ONE MONTH", _on_advance_month)
    _add_button(overview, "SAVE GAME NOW", _on_save_game)
    _add_section_title(overview, "WORLD POLITICS")
    world_politics_label = _add_body(overview, "India-wide political simulation will initialize with your career.")
    _add_section_title(overview, "WORLD REPORT")
    report_label = _add_body(overview, "Your political journey is ready to begin.")

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
    _add_body(party_members, "Fictional Indian political members. Add members manually and assign duties individually.")
    party_member_name_input = _add_line_input(party_members, "Member name", "Enter a fictional member name")
    _add_button(party_members, "ADD MEMBER", _on_add_party_member)
    party_member_status = _add_body(party_members, "")
    party_member_area = VBoxContainer.new()
    party_member_area.add_theme_constant_override("separation", 8)
    party_members.add_child(party_member_area)

    var party_duties := _new_tab(party_tabs, "Duties")
    _add_section_title(party_duties, "ASSIGN PARTY DUTIES")
    _add_body(party_duties, "Assign a role to an individual member. These are party responsibilities, not government powers.")
    duty_member_picker = OptionButton.new()
    duty_member_picker.custom_minimum_size = Vector2(0, 44)
    party_duties.add_child(duty_member_picker)
    duty_role_picker = OptionButton.new()
    duty_role_picker.custom_minimum_size = Vector2(0, 44)
    for duty in ["Volunteer", "Booth Coordinator", "Ward Organizer", "Media Coordinator", "Treasurer", "District Secretary", "State Organizer"]:
        duty_role_picker.add_item(duty)
    party_duties.add_child(duty_role_picker)
    _add_button(party_duties, "ASSIGN SELECTED DUTY", _on_assign_party_duty)

    var party_finances := _new_tab(party_tabs, "Finances")
    _add_section_title(party_finances, "PERSONAL, PARTY & CAMPAIGN ACCOUNTS")
    finance_label = _add_body(party_finances, "Financial accounts appear after your career begins.")
    _add_body(party_finances, "Personal cash, party funds, party debt, and election campaign spending are tracked separately. Values are a simplified game economy, not audited real-world party accounts.")

    var elections_page := _new_tab(dashboard_box, "Elections")
    _add_section_title(elections_page, "DEMOCRATIC COMPETITION")
    election_page_summary = _add_page_summary(elections_page, "ELECTION BRIEFING", "Your next contest", "Check the election schedule, ticket eligibility, and campaign status.")
    var election_tabs := TabContainer.new()
    election_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    elections_page.add_child(election_tabs)
    var election_status := _new_tab(election_tabs, "Election status")
    _add_section_title(election_status, "LOCAL ELECTION")
    _add_body(election_status, "Election date, ticket status, and result are summarized on Overview.")
    var election_campaign := _new_tab(election_tabs, "Campaign")
    _add_section_title(election_campaign, "CANDIDATE ACTIONS")
    _add_body(election_campaign, "Apply when eligible. Campaigning is available only after your party approves your ticket.")
    _add_button(election_campaign, "Apply for local election ticket", func(): _run_activity("request_ticket"))
    _add_button(election_campaign, "Campaign as approved candidate", func(): _run_activity("campaign"))

    var district_page := _new_tab(dashboard_box, "District")
    _add_section_title(district_page, "PARTY LEADERSHIP")
    _add_page_summary(district_page, "DISTRICT ORGANIZATION", "Build influence through service", "District party appointments are earned through experience and party standing. They do not confer government authority.")
    _add_section_title(district_page, "DISTRICT-LEVEL PARTY PROGRESSION")
    _add_body(district_page, "Build a record of service and party standing before applying for a district organization role. Party appointment is separate from election to public office.")
    district_label = _add_body(district_page, "")
    _add_info_card(district_page, "Authority boundary", "A district party role is internal party leadership. It does not grant a government seat, control over district officials, public money, or statutory decision-making powers.", "PARTY ORGANIZATION ONLY")
    _add_button(district_page, "Apply for district party role", func(): _run_activity("district_apply"))

    office_tab = _new_tab(dashboard_box, "Elected Office")
    var office_tabs := TabContainer.new()
    office_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    office_tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
    office_tabs.custom_minimum_size = Vector2(0, 320)
    office_tab.add_child(office_tabs)

    var office_responsibilities := _new_tab(office_tabs, "Responsibilities")
    _add_section_title(office_responsibilities, "YOUR ELECTED OFFICE")
    office_label = _add_body(office_responsibilities, "")
    _add_info_card(office_responsibilities, "Your mandate", "Represent residents, raise local concerns, and submit representations. Elected councils and competent departments retain their statutory powers and operational duties.", "REPRESENTATION • OVERSIGHT")
    _add_section_title(office_responsibilities, "THIS MONTH'S RESPONSIBILITIES")
    _add_body(office_responsibilities, "A small, refreshed set of local responsibilities appears each month. Choose which matters to pursue; submissions and follow-ups continue through the official process.")
    office_mission_list = VBoxContainer.new()
    office_mission_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    office_mission_list.add_theme_constant_override("separation", 10)
    office_responsibilities.add_child(office_mission_list)

    var office_log := _new_tab(office_tabs, "Work log")
    _add_section_title(office_log, "OFFICE WORK LOG")
    _add_body(office_log, "Track each submission from review to implementation.")
    office_log_list = VBoxContainer.new()
    office_log_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    office_log_list.add_theme_constant_override("separation", 10)
    office_log.add_child(office_log_list)

func _add_dashboard_hero(parent: VBoxContainer) -> void:
    var hero := PanelContainer.new()
    hero.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hero.add_theme_stylebox_override("panel", _hero_style())
    parent.add_child(hero)

    var copy := VBoxContainer.new()
    copy.add_theme_constant_override("separation", 5)
    hero.add_child(copy)

    var eyebrow := Label.new()
    eyebrow.text = "POLITICAL CAREER  /  INDIA"
    eyebrow.add_theme_font_size_override("font_size", 10)
    eyebrow.add_theme_color_override("font_color", Color("#c6b06f"))
    copy.add_child(eyebrow)

    var headline := Label.new()
    headline.text = "Your political journey"
    headline.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    headline.add_theme_font_size_override("font_size", 23)
    headline.add_theme_color_override("font_color", Color("#f2e9d7"))
    copy.add_child(headline)

    var supporting := Label.new()
    supporting.text = "Build trust, earn responsibility, and grow through public service."
    supporting.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    supporting.add_theme_font_size_override("font_size", 13)
    supporting.add_theme_color_override("font_color", Color("#aebdcb"))
    copy.add_child(supporting)
    _configure_touch_scroll_passthrough(hero)

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
    if entries.is_empty():
        _add_info_card(office_log_list, "No matters filed yet", "Submitted representations, service referrals, and official responses will be recorded here.", "READY")
        return
    var start_index := maxi(0, entries.size() - 16)
    for i in range(start_index, entries.size()):
        var entry: Dictionary = entries[i]
        var detail_text := "%s\n%s" % [str(entry["department"]), str(entry["location"])]
        _add_info_card(office_log_list, str(entry["title"]), detail_text, "%s  •  %s" % [str(entry["kind"]), str(entry["status"]).to_upper()])

func _on_complete_office_mission(mission_id: int) -> void:
    report_label.text = "\n".join(PackedStringArray(world.complete_office_mission(mission_id)))
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
    var started: bool = world.start_career(name_input.text, int(age_input.value), city_input.text, "found", party_name_input.text)
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
        career_label.text = world.career_summary()
        if is_instance_valid(career_page_summary):
            career_page_summary.text = world.career_summary()
        party_label.text = world.party_summary()
        if is_instance_valid(party_page_summary):
            party_page_summary.text = world.party_summary()
        finance_label.text = world.finance_summary()
        _refresh_party_members()
        election_label.text = world.election_summary()
        if is_instance_valid(election_page_summary):
            election_page_summary.text = world.election_summary()
        conditions_label.text = world.local_conditions_summary()
        if is_instance_valid(world_politics_label):
            world_politics_label.text = world.world_politics_summary()
        office_tab.visible = world.has_elected_office
        if main_tab_buttons.size() > 5:
            main_tab_buttons[5].visible = world.has_elected_office
        if is_instance_valid(district_label):
            district_label.text = world.district_progression_summary()
        if world.has_elected_office:
            office_label.text = world.office_summary().replace("\\n", "\n")
            _refresh_office_missions()
            _refresh_office_log()

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

func _refresh_party_members() -> void:
    if not is_instance_valid(party_member_area) or not is_instance_valid(duty_member_picker):
        return
    for child in party_member_area.get_children():
        child.queue_free()
    duty_member_picker.clear()
    var roster: Array = world.get_player_party_members()
    for member_variant in roster:
        var member: Dictionary = member_variant
        var row := PanelContainer.new()
        var row_box := VBoxContainer.new()
        row_box.add_theme_constant_override("separation", 3)
        var name_label := Label.new()
        name_label.text = str(member.get("name", "Unnamed member"))
        name_label.add_theme_color_override("font_color", Color("#f0d18a"))
        row_box.add_child(name_label)
        var detail := Label.new()
        detail.text = "%s  •  %s" % [str(member.get("duty", "Volunteer")), str(member.get("region", "Karnataka"))]
        detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        row_box.add_child(detail)
        row.add_child(row_box)
        party_member_area.add_child(row)
        duty_member_picker.add_item(str(member.get("name", "Member")))
        duty_member_picker.set_item_metadata(duty_member_picker.item_count - 1, str(member.get("id", "")))
    if roster.is_empty():
        var empty_label := Label.new()
        empty_label.text = "No named roster records yet. Add a member above."
        party_member_area.add_child(empty_label)

func _notification(what: int) -> void:
    if not is_instance_valid(world) or not world.career_started:
        return
    if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
        world.save_game()
