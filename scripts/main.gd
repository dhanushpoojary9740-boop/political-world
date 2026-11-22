extends Control

const WorldSimulationScript = preload("res://scripts/world_simulation.gd")
var world: WorldSimulation

var date_label: Label
var career_label: Label
var party_label: Label
var election_label: Label
var report_label: Label
var name_input: LineEdit
var age_input: SpinBox
var city_input: LineEdit
var party_name_input: LineEdit
var setup_box: VBoxContainer
var dashboard_box: VBoxContainer

func _ready() -> void:
    world = WorldSimulationScript.new()
    world.initialize()
    var has_saved_game: bool = world.load_game()
    _build_ui()
    if has_saved_game and world.career_started:
        setup_box.visible = false
        dashboard_box.visible = true
        report_label.text = "Saved career restored automatically."
    _refresh()

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("#101820")
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
    title.add_theme_color_override("font_color", Color("#f1d28a"))
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

    dashboard_box = VBoxContainer.new()
    dashboard_box.add_theme_constant_override("separation", 10)
    dashboard_box.visible = false
    root.add_child(dashboard_box)
    _build_dashboard()

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
    _add_section_title(dashboard_box, "YOUR CAREER")
    career_label = _add_body(dashboard_box, "")
    _add_section_title(dashboard_box, "YOUR PARTY")
    party_label = _add_body(dashboard_box, "")
    _add_section_title(dashboard_box, "LOCAL ELECTION")
    election_label = _add_body(dashboard_box, "")
    _add_button(dashboard_box, "Volunteer in a local campaign", func(): _run_activity("volunteer"))
    _add_button(dashboard_box, "Organize community service", func(): _run_activity("community"))
    _add_button(dashboard_box, "Attend a party meeting", func(): _run_activity("meeting"))
    _add_button(dashboard_box, "Recruit a party member", func(): _run_activity("recruit"))
    _add_button(dashboard_box, "Apply for local election ticket", func(): _run_activity("request_ticket"))
    _add_button(dashboard_box, "Campaign as approved candidate", func(): _run_activity("campaign"))
    _add_button(dashboard_box, "ADVANCE ONE MONTH", _on_advance_month)
    _add_button(dashboard_box, "SAVE GAME NOW", _on_save_game)
    _add_section_title(dashboard_box, "WORLD REPORT")
    report_label = _add_body(dashboard_box, "Your political journey is ready to begin.")

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
    label.add_theme_color_override("font_color", Color("#f1d28a"))
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

func _notification(what: int) -> void:
    if not is_instance_valid(world) or not world.career_started:
        return
    if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
        world.save_game()
