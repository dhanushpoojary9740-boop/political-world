extends Control

const WorldSimulationScript = preload("res://scripts/world_simulation.gd")
var world: WorldSimulation

var date_label: Label
var party_label: Label
var authority_label: Label
var log_label: Label

func _ready() -> void:
    world = WorldSimulationScript.new()
    world.initialize()
    _build_ui()
    _refresh()

func _build_ui() -> void:
    var background := ColorRect.new()
    background.color = Color("#101820")
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 24)
    margin.add_theme_constant_override("margin_right", 24)
    margin.add_theme_constant_override("margin_top", 28)
    margin.add_theme_constant_override("margin_bottom", 24)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 16)
    margin.add_child(layout)

    var title := Label.new()
    title.text = "POLITICAL WORLD"
    title.add_theme_font_size_override("font_size", 30)
    title.add_theme_color_override("font_color", Color("#f1d28a"))
    layout.add_child(title)

    date_label = Label.new()
    date_label.add_theme_font_size_override("font_size", 20)
    date_label.add_theme_color_override("font_color", Color("#ffffff"))
    layout.add_child(date_label)

    var subtitle := Label.new()
    subtitle.text = "INDIA • POLITICAL SIMULATION"
    subtitle.add_theme_color_override("font_color", Color("#a9b6c2"))
    layout.add_child(subtitle)

    var divider := HSeparator.new()
    layout.add_child(divider)

    party_label = Label.new()
    party_label.add_theme_font_size_override("font_size", 18)
    party_label.add_theme_color_override("font_color", Color("#ffffff"))
    party_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    layout.add_child(party_label)

    authority_label = Label.new()
    authority_label.text = "YOUR ROLE\nParty High Command • Karnataka\nYou control major Karnataka strategy. AI administers other states."
    authority_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    authority_label.add_theme_color_override("font_color", Color("#d4dce3"))
    layout.add_child(authority_label)

    var advance_button := Button.new()
    advance_button.text = "ADVANCE ONE MONTH"
    advance_button.custom_minimum_size = Vector2(0, 58)
    advance_button.add_theme_color_override("font_color", Color("#101820"))
    advance_button.add_theme_color_override("font_pressed_color", Color("#101820"))
    advance_button.add_theme_stylebox_override("normal", _button_style("#e7bd62"))
    advance_button.add_theme_stylebox_override("hover", _button_style("#f3d58f"))
    advance_button.pressed.connect(_on_advance_month)
    layout.add_child(advance_button)

    var log_title := Label.new()
    log_title.text = "WORLD REPORT"
    log_title.add_theme_color_override("font_color", Color("#f1d28a"))
    log_title.add_theme_font_size_override("font_size", 18)
    layout.add_child(log_title)

    log_label = Label.new()
    log_label.text = "The simulation is ready."
    log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    log_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
    log_label.add_theme_color_override("font_color", Color("#d4dce3"))
    layout.add_child(log_label)

func _button_style(color_value: String) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = Color(color_value)
    style.corner_radius_top_left = 12
    style.corner_radius_top_right = 12
    style.corner_radius_bottom_left = 12
    style.corner_radius_bottom_right = 12
    style.content_margin_left = 12
    style.content_margin_right = 12
    return style

func _on_advance_month() -> void:
    var report := world.advance_month()
    log_label.text = "\n".join(PackedStringArray(report))
    _refresh()

func _refresh() -> void:
    date_label.text = world.date_label()
    party_label.text = world.party_summary()
