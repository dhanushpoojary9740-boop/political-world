extends Control

const WorldSimulationScript = preload("res://scripts/world_simulation.gd")
var world: WorldSimulation

var date_label: Label
var career_label: Label
var party_label: Label
var election_label: Label
var office_tab: VBoxContainer
var office_label: Label
var office_log_label: Label
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

    var scroll := ScrollContainer.new()
    scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    scroll.offset_left = 12
    scroll.offset_right = -12
    scroll.offset_top = 12
    scroll.offset_bottom = -12
    add_child(scroll)

    var root := VBoxContainer.new()
    root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    root.add_theme_constant_override("separation", 12)
    scroll.add_child(root)

    var title := Label.new()
    title.text = "POLITICAL WORLD"
    title.add_theme_font_size_override("font_size", 28)
    title.add_theme_color_override("font_color", Color("#d9b56d"))
    root.add_child(title)

    date_label = Label.new()
    date_label.add_theme_font_size_override("font_size", 18)
    date_label.add_theme_color_override("font_color", Color("#ffffff"))
    root.add_child(date_label)

    var subtitle := Label.new()
    subtitle.text = "YOUR POLITICAL JOURNEY • INDIA"
    subtitle.add_theme_color_override("font_color", Color("#a9b6c2"))
    root.add_child(subtitle)

    setup_box = VBoxContainer.new()
    setup_box.add_theme_constant_override("separation", 10)
    root.add_child(setup_box)
    _build_setup()

    dashboard_box = TabContainer.new()
    dashboard_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    dashboard_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
    dashboard_box.custom_minimum_size = Vector2(0, 390)
    dashboard_box.tabs_visible = false
    dashboard_box.add_theme_constant_override("side_margin", 6)
    dashboard_box.visible = false
    root.add_child(dashboard_box)
    _build_dashboard()
    _build_bottom_navigation(root)

func _build_bottom_navigation(parent: VBoxContainer) -> void:
    main_tab_bar = ScrollContainer.new()
    main_tab_bar.name = "BottomNavigation"
    main_tab_bar.custom_minimum_size = Vector2(0, 60)
    main_tab_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_tab_bar.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
    main_tab_bar.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED\n    main_tab_bar.add_theme_stylebox_override("panel", _button_style("#101f2d"))
    main_tab_bar.visible = false
    parent.add_child(main_tab_bar)

    var nav_row := HBoxContainer.new()
    nav_row.add_theme_constant_override("separation", 8)
    nav_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    main_tab_bar.add_child(nav_row)

    var tab_names: Array[String] = ["Overview", "Career", "Party", "Elections", "Office"]
    for index in range(tab_names.size()):
        var tab_button := Button.new()
        tab_button.text = tab_names[index]
        tab_button.custom_minimum_size = Vector2(96, 46)
        tab_button.add_theme_font_size_override("font_size", 14)
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
    if index == 4 and not world.has_elected_office:
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

    office_tab = _new_tab(dashboard_box, "Elected Office")
    var office_tabs := TabContainer.new()
    office_tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    office_tabs.custom_minimum_size = Vector2(0, 320)
    office_tab.add_child(office_tabs)
    var office_responsibilities := _new_tab(office_tabs, "Responsibilities")
    _add_section_title(office_responsibilities, "YOUR ELECTED OFFICE")
    office_label = _add_body(office_responsibilities, "")
    _add_button(office_responsibilities, "Submit constituency development proposal", func(): _run_activity("office_proposal"))
    _add_button(office_responsibilities, "Raise constituency public-service issue", func(): _run_activity("office_issue"))
    _add_button(office_responsibilities, "Revise and resubmit returned proposal", func(): _run_activity("office_resubmit"))
    var office_log := _new_tab(office_tabs, "Work log")
    _add_section_title(office_log, "OFFICE WORK LOG")
    office_log_label = _add_body(office_log, "")
    _add_body(office_responsibilities, "Council review and routine administration remain with AI officials. Your authority is limited to representing constituents and submitting proposals or issues.")

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
    label.add_theme_color_override("font_color", Color("#d4dce3"))
    parent.add_child(label)
    return label

func _add_button(parent: VBoxContainer, text_value: String, callback: Callable) -> void:
    var button := Button.new()
    button.text = text_value
    button.custom_minimum_size = Vector2(0, 48)
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
        election_label.text = world.election_summary()
        office_tab.visible = world.has_elected_office
        if main_tab_buttons.size() > 4:
            main_tab_buttons[4].visible = world.has_elected_office
        if world.has_elected_office:
            office_label.text = world.office_summary()
            office_log_label.text = world.office_activity_summary()

func _notification(what: int) -> void:
    if not is_instance_valid(world) or not world.career_started:
        return
    if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
        world.save_game()
