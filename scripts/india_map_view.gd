extends Control
signal region_selected(region_name: String, region_state: String)

const STATE_PALETTE: Array[Color] = [
	Color("#d6b15a"), Color("#4c91c8"), Color("#2f9f8c"), Color("#b85b67"),
	Color("#8b78c6"), Color("#d58b48"), Color("#6b9b6d"), Color("#c16e9e")
]
const NEUTRAL := Color("#263b54")
const SELECTED := Color("#f2d27b")
const STROKE := Color("#091523")

var features: Array = []
var layer_name := "Political control"
var view_level := 0
var selected_state := ""
var selected_district := ""
var state_winners: Dictionary = {}
var state_support: Dictionary = {}
var state_seats: Dictionary = {}
var state_phases: Dictionary = {}
var district_winners: Dictionary = {}
var party_colors: Dictionary = {}
var _screen_polygons: Array = []
var _bounds := Rect2()
var _data_loaded := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(0, 620)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	_load_geojson()
	queue_redraw()

func set_map_state(level: int, state_name: String, district_name: String, layer: String,
		winners: Dictionary, supports: Dictionary, seats: Dictionary, phases: Dictionary,
		local_winners: Dictionary, colors_by_party: Dictionary) -> void:
	view_level = level
	selected_state = state_name
	selected_district = district_name
	layer_name = layer
	state_winners = winners
	state_support = supports
	state_seats = seats
	state_phases = phases
	district_winners = local_winners
	party_colors = colors_by_party
	queue_redraw()

func _load_geojson() -> void:
	var file := FileAccess.open("res://data/india.geojson", FileAccess.READ)
	if file == null:
		push_warning("India map data missing at res://data/india.geojson")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_warning("India map GeoJSON could not be parsed")
		return
	features = parsed.get("features", [])
	_data_loaded = not features.is_empty()

func _draw() -> void:
	_screen_polygons.clear()
	if not _data_loaded or size.x < 2.0 or size.y < 2.0:
		draw_string(ThemeDB.fallback_font, Vector2(16, 28), "India boundary data unavailable", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("#e7edf6"))
		return
	var bounds := _calculate_bounds()
	var pad := 8.0
	var scale := minf((size.x - pad * 2.0) / maxf(bounds.size.x, 0.01), (size.y - pad * 2.0) / maxf(bounds.size.y, 0.01))
	var drawn_size := bounds.size * scale
	var origin := Vector2((size.x - drawn_size.x) * 0.5, (size.y - drawn_size.y) * 0.5)
	for feature in features:
		var props: Dictionary = feature.get("properties", {})
		var state := str(props.get("st_nm", ""))
		var district := str(props.get("district", ""))
		if view_level > 0 and state != selected_state:
			continue
		var geometry: Dictionary = feature.get("geometry", {})
		var polygons := _extract_polygons(geometry)
		for ring in polygons:
			if ring.size() < 3:
				continue
			var points := PackedVector2Array()
			for coord in ring:
				var lon := float(coord[0])
				var lat := float(coord[1])
				points.append(Vector2(origin.x + (lon - bounds.position.x) * scale,
					origin.y + (bounds.end.y - lat) * scale))
			var fill := _feature_color(state, district)
			draw_colored_polygon(points, fill)
			for i in range(points.size()):
				draw_line(points[i], points[(i + 1) % points.size()], STROKE, 1.0, true)
			if view_level == 2 and district == selected_district:
				draw_polyline(points, SELECTED, 3.0, true)
			_screen_polygons.append({"points": points, "state": state, "district": district})
	if view_level == 0:
		draw_string(ThemeDB.fallback_font, Vector2(12, size.y - 10), "Tap a state boundary", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#9fb2c9"))
	elif view_level == 1:
		draw_string(ThemeDB.fallback_font, Vector2(12, size.y - 10), "Tap a district boundary", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#9fb2c9"))

func _calculate_bounds() -> Rect2:
	var min_x := 180.0
	var min_y := 90.0
	var max_x := -180.0
	var max_y := -90.0
	for feature in features:
		var props: Dictionary = feature.get("properties", {})
		if view_level > 0 and str(props.get("st_nm", "")) != selected_state:
			continue
		var geometry: Dictionary = feature.get("geometry", {})
		for ring in _extract_polygons(geometry):
			for coord in ring:
				min_x = minf(min_x, float(coord[0]))
				min_y = minf(min_y, float(coord[1]))
				max_x = maxf(max_x, float(coord[0]))
				max_y = maxf(max_y, float(coord[1]))
	if max_x <= min_x or max_y <= min_y:
		return Rect2(68.0, 6.0, 30.0, 32.0)
	var margin_x := (max_x - min_x) * 0.015
	var margin_y := (max_y - min_y) * 0.015
	return Rect2(min_x - margin_x, min_y - margin_y, max_x - min_x + margin_x * 2.0, max_y - min_y + margin_y * 2.0)

func _extract_polygons(geometry: Dictionary) -> Array:
	var result: Array = []
	var kind := str(geometry.get("type", ""))
	var coords: Variant = geometry.get("coordinates", [])
	if kind == "Polygon":
		for ring in coords:
			result.append(ring)
	elif kind == "MultiPolygon":
		for polygon in coords:
			if polygon.size() > 0:
				result.append(polygon[0])
	return result

func _feature_color(state: String, district: String) -> Color:
	if view_level == 2 and district == selected_district:
		return SELECTED
	if layer_name == "Regional support":
		var value := float(state_support.get(state, 0.0))
		return Color("#102036").lerp(Color("#d6b15a"), clampf(value / 100.0, 0.0, 1.0))
	if layer_name == "Assembly seats":
		var seats := float(state_seats.get(state, 0))
		return Color("#102036").lerp(Color("#4c91c8"), clampf(seats / 403.0, 0.0, 1.0))
	if layer_name == "Election status":
		var phase := str(state_phases.get(state, ""))
		if phase.to_lower().contains("completed") or phase.to_lower().contains("result"):
			return Color("#2f9f8c")
		if phase.to_lower().contains("campaign") or phase.to_lower().contains("open"):
			return Color("#d6b15a")
		return NEUTRAL
	var winner_id := str(state_winners.get(state, ""))
	if view_level > 0:
		var district_key := "%s|%s" % [state, district]
		winner_id = str(district_winners.get(district_key, ""))
	if winner_id.is_empty():
		return NEUTRAL
	var color_value := str(party_colors.get(winner_id, ""))
	if color_value.is_empty():
		return NEUTRAL
	return Color(color_value)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_select_at(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_select_at(event.position)

func _select_at(position: Vector2) -> void:
	for item in _screen_polygons:
		var points: PackedVector2Array = item["points"]
		if Geometry2D.is_point_in_polygon(position, points):
			var state := str(item["state"])
			var district := str(item["district"])
			if view_level == 0:
				region_selected.emit(state, "")
			elif view_level == 1:
				region_selected.emit(district, state)
			else:
				region_selected.emit(district, state)
			return
