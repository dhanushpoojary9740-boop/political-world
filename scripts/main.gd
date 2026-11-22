extends Control

const WorldSimulationScript = preload("res://scripts/world_simulation.gd")
var world: WorldSimulation

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
var report_label: Label
var name_input: LineEdit
var age_input: SpinBox
var city_input: LineEdit
var party_name_input: LineEdit
var setup_box: VBoxContainer
var dashboard_box: TabContainer
var main_tab_bar: ScrollContainer
var main_tab_buttons: Array[Button] = []

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

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("#0b1420")
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
    root.add_theme_constant_override("separation", 8)
    add_child(root)

    var header := VBoxContainer.new()
    header.name = "Header"
    header.add_theme_constant_override("separation", 3)
    root.add_child(header)

    var title := Label.new()
    title.text = "POLITICAL WORLD"
    title.add_theme_font_size_override("font_size", 24)
    title.add_theme_color_override("font_color", Color("#d9b56d"))
    header.add_child(title)

    date_label = Label.new()
    date_label.add_theme_font_size_override("font_size", 16)
    date_label.add_theme_color_override("font_color", Color("#ffffff"))
    header.add_child(date_label)

    var subtitle := Label.new()
    subtitle.text = "YOUR POLITICAL JOURNEY • INDIA"
    subtitle.add_theme_font_size_override("font_size", 12)
    subtitle.add_theme_color_override("font_color", Color("#a9b6c2"))
    header.add_child(subtitle)

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
    main_tab_bar.custom_minimum_size = Vector2(0, 64)
    main_tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_tab_bar.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    main_tab_bar.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    main_tab_bar.add_theme_stylebox_override("panel", _button_style("#101f2d"))
    main_tab_bar.size_flags_vertical = Control.SIZE_SHRINK_END
    main_tab_bar.visible = false
    parent.add_child(main_tab_bar)

    var nav_row := HBoxContainer.new()
    nav_row.add_theme_constant_override("separation", 8)
    nav_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_tab_bar.add_child(nav_row)

    var tab_names: Array[String] = ["Overview", "Career", "Party", "Elections", "District", "Office"]
    for index in range(tab_names.size()):
        var tab_button := Button.new()
        tab_button.text = tab_names[index]
        tab_button.custom_minimum_size = Vector2(104, 48)
        tab_button.add_theme_font_size_override("font_size", 13)
        tab_button.add_theme_color_override("font_color", Color("#f2e8d5"))
        tab_button.add_theme_stylebox_override("normal", _button_style("#1b2a38"))
        tab_button.add_theme_stylebox_override("hover", _button_style("#2c4354"))
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
    _add_section_title(overview, "WORLD REPORT")
    report_label = _add_body(overview, "Your political journey is ready to begin.")

    var career_page := _new_tab(dashboard_box, "Career")
    var career_tabs := TabContainer.new()
    career_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    career_tabs.custom_minimum_size = Vector2(0, 320)
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
    var party_tabs := TabContainer.new()
    party_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    party_tabs.custom_minimum_size = Vector2(0, 320)
    party_page.add_child(party_tabs)
    var party_profile := _new_tab(party_tabs, "Party profile")
    _add_section_title(party_profile, "YOUR PARTY")
    _add_body(party_profile, "Party membership, funds, popularity, and your party role are summarized on Overview.")
    var party_work := _new_tab(party_tabs, "Organization")
    _add_section_title(party_work, "PARTY ORGANIZATION")
    _add_body(party_work, "Grow your party through local activity and recruitment. The party's routine organization continues through the simulation.")
    _add_button(party_work, "Recruit a party member", func(): _run_activity("recruit"))

    var party_finances := _new_tab(party_tabs, "Finances")
    _add_section_title(party_finances, "PERSONAL, PARTY & CAMPAIGN ACCOUNTS")
    finance_label = _add_body(party_finances, "Financial accounts appear after your career begins.")
    _add_body(party_finances, "Personal cash, party funds, party debt, and election campaign spending are tracked separately. Values are a simplified game economy, not audited real-world party accounts.")

    var elections_page := _new_tab(dashboard_box, "Elections")
    var election_tabs := TabContainer.new()
    election_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    election_tabs.custom_minimum_size = Vector2(0, 320)
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
    style.bg_color = Color("#142333")
    style.border_color = Color("#30465a")
    style.set_border_width_all(1)
    style.set_corner_radius_all(12)
    style.set_content_margin_all(14)
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
    var label := Label.new()
    label.text = text_value
    label.add_theme_font_size_override("font_size", 18)
    label.add_theme_color_override("font_color", Color("#d9b56d"))
    parent.add_child(label)

func _add_body(parent: VBoxContainer, text_value: String) -> Label:
    var label := Label.new()
    label.text = text_value
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    label.add_theme_color_override("font_color", Color("#d4dce3"))
    parent.add_child(label)
    return label

func _add_button(parent: VBoxContainer, text_value: String, callback: Callable) -> void:
    var button := Button.new()
    button.text = text_value
    button.custom_minimum_size = Vector2(0, 46)
    button.add_theme_color_override("font_color", Color("#101820"))
    button.add_theme_stylebox_override("normal", _button_style("#e7bd62"))
    button.add_theme_stylebox_override("hover", _button_style("#f3d58f"))
    button.pressed.connect(callback)
    parent.add_child(button)

func _button_style(color_value: String) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(color_value)
    style.corner_radius_top_left = 10
    style.corner_radius_top_right = 10
    style.corner_radius_bottom_left = 10
    style.corner_radius_bottom_right = 10
    style.content_margin_left = 12
    style.content_margin_right = 12
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
        career_label.text = world.career_summary()
        party_label.text = world.party_summary()
        finance_label.text = world.finance_summary()
        election_label.text = world.election_summary()
        conditions_label.text = world.local_conditions_summary()
        office_tab.visible = world.has_elected_office
        if main_tab_buttons.size() > 5:
            main_tab_buttons[5].visible = world.has_elected_office
        if is_instance_valid(district_label):
            district_label.text = world.district_progression_summary()
        if world.has_elected_office:
            office_label.text = world.office_summary().replace("\\n", "\n")
            _refresh_office_missions()
            _refresh_office_log()

func _notification(what: int) -> void:
    if not is_instance_valid(world) or not world.career_started:
        return
    if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
        world.save_game()
