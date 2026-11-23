extends Control
signal region_selected(region_name: String, region_state: String)

const STATE_PALETTE: Array[Color] = [
	Color("#d6b15a"), Color("#4c91c8"), Color("#2f9f8c"), Color("#b85b67"),
	Color("#8b78c6"), Color("#d58b48"), Color("#6b9b6d"), Color("#c16e9e")
]
const NEUTRAL := Color("#263b54")
const SELECTED := Color("#f2d27b")
const STROKE := Color("#9eb4ce")
const STATE_BORDER := Color("#d0dceb")
const DISTRICT_BORDER := Color("#8199b5")

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
var map_metrics: Dictionary = {}
var _screen_polygons: Array = []
var _bounds := Rect2()
var _cached_bounds := Rect2()
var _cached_bounds_level := -1
var _cached_bounds_state := ""
var _bounds_cache_valid := false
var _data_loaded := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(0, 760)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	_load_geojson()
	queue_redraw()

func set_map_state(level: int, state_name: String, district_name: String, layer: String,
		winners: Dictionary, supports: Dictionary, seats: Dictionary, phases: Dictionary,
		local_winners: Dictionary, colors_by_party: Dictionary, metrics_by_region: Dictionary = {}) -> void:
	if view_level != level or selected_state != state_name:
		_bounds_cache_valid = false
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
	map_metrics = metrics_by_region
	queue_redraw()

func _load_geojson() -> void:
	var file := FileAccess.open("res://Data/india.geojson", FileAccess.READ)
	if file == null:
		push_warning("India map data missing at res://Data/india.geojson")
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

	var boundary_records: Array = []
	var state_edge_counts: Dictionary = {}
	var state_edge_points: Dictionary = {}
	var state_rings: Dictionary = {}
	var state_vertices: Dictionary = {}
	var state_label_candidates: Dictionary = {}
	var district_label_candidates: Dictionary = {}

	# Paint all regions first. India overview intentionally hides district lines;
	# state outlines are reconstructed from the outside edges of each state's districts.
	for feature in features:
		var props: Dictionary = feature.get("properties", {})
		var state := str(props.get("st_nm", ""))
		var district := str(props.get("district", ""))
		if view_level > 0 and state != selected_state:
			continue
		var geometry: Dictionary = feature.get("geometry", {})
		for ring in _extract_polygons(geometry):
			if ring.size() < 3:
				continue
			var points := PackedVector2Array()
			var min_point := Vector2(INF, INF)
			var max_point := Vector2(-INF, -INF)
			for coord in ring:
				var lon := float(coord[0])
				var lat := float(coord[1])
				var point := Vector2(origin.x + (lon - bounds.position.x) * scale,
					origin.y + (bounds.end.y - lat) * scale)
				points.append(point)
				min_point.x = minf(min_point.x, point.x)
				min_point.y = minf(min_point.y, point.y)
				max_point.x = maxf(max_point.x, point.x)
				max_point.y = maxf(max_point.y, point.y)

			draw_colored_polygon(points, _feature_color(state, district))
			boundary_records.append({"points": points, "state": state, "district": district})
			_screen_polygons.append({"points": points, "state": state, "district": district})

			if view_level == 0:
				var rings: Array = state_rings.get(state, [])
				rings.append(points)
				state_rings[state] = rings
				var vertices: Array = state_vertices.get(state, [])
				for point in points:
					vertices.append(point)
				state_vertices[state] = vertices
				var previous_state_candidate: Dictionary = state_label_candidates.get(state, {})
				var polygon_area := (max_point.x - min_point.x) * (max_point.y - min_point.y)
				if polygon_area > float(previous_state_candidate.get("area", 0.0)):
					state_label_candidates[state] = _interior_label_candidate(points)
			elif view_level == 1:
				var previous_district_candidate: Dictionary = district_label_candidates.get(district, {})
				var district_polygon_area := (max_point.x - min_point.x) * (max_point.y - min_point.y)
				if district_polygon_area > float(previous_district_candidate.get("area", 0.0)):
					district_label_candidates[district] = _interior_label_candidate(points)

	if view_level == 0:
		# Fast edge counting: shared district edges cancel; only exterior state edges remain.
		# Avoid the previous all-vertices-against-all-edges splitting pass during every redraw.
		for state in state_rings:
			var edge_counts: Dictionary = {}
			var edge_points: Dictionary = {}
			for ring in state_rings[state]:
				for i in range(ring.size()):
					var a: Vector2 = ring[i]
					var b: Vector2 = ring[(i + 1) % ring.size()]
					var key := _edge_key(a, b)
					edge_counts[key] = int(edge_counts.get(key, 0)) + 1
					edge_points[key] = [a, b]
			for key in edge_counts:
				if int(edge_counts[key]) == 1:
					var edge: Array = edge_points[key]
					draw_line(edge[0], edge[1], Color("#07111f"), 5.0, true)
					draw_line(edge[0], edge[1], STATE_BORDER, 2.8, true)
		for state in state_label_candidates:
			var candidate: Dictionary = state_label_candidates[state]
			var font_size := _fit_label_font(str(state), candidate["rect"], float(candidate["clearance"]), 11, 6)
			if font_size >= 6:
				_draw_map_label(str(state), candidate["point"], font_size, candidate["rect"].size.x - 2.0)
	else:
		# District borders are only drawn inside a selected state.
		for record in boundary_records:
			var points: PackedVector2Array = record["points"]
			for i in range(points.size()):
				var a := points[i]
				var b := points[(i + 1) % points.size()]
				draw_line(a, b, Color("#07111f"), 4.2, true)
				draw_line(a, b, DISTRICT_BORDER, 2.0, true)
			if view_level == 2 and str(record["district"]) == selected_district:
				draw_polyline(points, SELECTED, 4.0, true)
		if view_level == 1:
			for district in district_label_candidates:
				var candidate: Dictionary = district_label_candidates[district]
				var font_size := _fit_label_font(str(district), candidate["rect"], float(candidate["clearance"]), 9, 4)
				if font_size >= 5:
					_draw_map_label(str(district), candidate["point"], font_size, candidate["rect"].size.x - 2.0)
		if view_level == 2:
			_draw_map_label(selected_district, Vector2(size.x * 0.5, size.y - 26.0), 12, size.x - 24.0)

	if view_level == 0:
		draw_string(ThemeDB.fallback_font, Vector2(12, size.y - 10), "Tap a state boundary", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#9fb2c9"))
	elif view_level == 1:
		draw_string(ThemeDB.fallback_font, Vector2(12, size.y - 10), "Tap a district boundary", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#9fb2c9"))

func _interior_label_candidate(points: PackedVector2Array) -> Dictionary:
	var min_point := Vector2(INF, INF)
	var max_point := Vector2(-INF, -INF)
	for point in points:
		min_point.x = minf(min_point.x, point.x)
		min_point.y = minf(min_point.y, point.y)
		max_point.x = maxf(max_point.x, point.x)
		max_point.y = maxf(max_point.y, point.y)
	var rect := Rect2(min_point, max_point - min_point)
	var best_point := rect.get_center()
	var best_clearance := -1.0
	# Sample a small grid for a label point; this runs during redraws, so keep it bounded.
	for gy in range(1, 8):
		for gx in range(1, 8):
			var point := Vector2(
				lerpf(rect.position.x, rect.end.x, float(gx) / 8.0),
				lerpf(rect.position.y, rect.end.y, float(gy) / 8.0))
			if not Geometry2D.is_point_in_polygon(point, points):
				continue
			var clearance := _distance_to_polygon_edges(point, points)
			if clearance > best_clearance:
				best_clearance = clearance
				best_point = point
	var area := rect.size.x * rect.size.y
	return {"point": best_point, "rect": rect, "area": area, "clearance": best_clearance}

func _distance_to_polygon_edges(point: Vector2, points: PackedVector2Array) -> float:
	var closest := INF
	for i in range(points.size()):
		var a := points[i]
		var b := points[(i + 1) % points.size()]
		var segment := b - a
		var length_sq := segment.length_squared()
		var t := 0.0
		if length_sq > 0.0001:
			t = clampf((point - a).dot(segment) / length_sq, 0.0, 1.0)
		var nearest := a + segment * t
		closest = minf(closest, point.distance_to(nearest))
	return closest

func _fit_label_font(label: String, rect: Rect2, clearance: float, preferred: int, minimum: int) -> int:
	var font := ThemeDB.fallback_font
	var available_width := maxf(0.0, rect.size.x - 4.0)
	var available_height := maxf(0.0, rect.size.y - 2.0)
	for font_size in range(preferred, minimum - 1, -1):
		var text_width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
		# Keep the whole label within the local region, not merely inside its bounding box.
		if text_width <= available_width and float(font_size) * 1.15 <= available_height:
			if clearance < 0.0 or text_width * 0.5 + 1.0 <= clearance and float(font_size) * 0.58 + 0.5 <= clearance:
				return font_size
	return 0

func _segment_parameter(a: Vector2, b: Vector2, point: Vector2) -> float:
	var segment := b - a
	var length_sq := segment.length_squared()
	if length_sq < 0.0001:
		return 0.0
	return (point - a).dot(segment) / length_sq

func _point_on_segment(a: Vector2, b: Vector2, point: Vector2) -> bool:
	var segment := b - a
	var length := segment.length()
	if length < 0.0001:
		return false
	var t := _segment_parameter(a, b, point)
	if t < 0.0 or t > 1.0:
		return false
	var projected := a + segment * t
	return projected.distance_to(point) <= 0.75

func _edge_key(a: Vector2, b: Vector2) -> String:
	var ax := int(round(a.x * 100.0))
	var ay := int(round(a.y * 100.0))
	var bx := int(round(b.x * 100.0))
	var by := int(round(b.y * 100.0))
	var first := "%d,%d" % [ax, ay]
	var second := "%d,%d" % [bx, by]
	return first + "|" + second if first < second else second + "|" + first

func _draw_map_label(label: String, center: Vector2, font_size: int, max_width: float) -> void:
	if label.strip_edges().is_empty() or max_width <= 0.0:
		return
	var font := ThemeDB.fallback_font
	var measured := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var width := minf(max_width, measured + 4.0)
	var baseline := center + Vector2(0.0, font_size * 0.35)
	for offset in [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]:
		draw_string(font, baseline + offset, label, HORIZONTAL_ALIGNMENT_CENTER, width, font_size, Color("#07111f"))
	draw_string(font, baseline, label, HORIZONTAL_ALIGNMENT_CENTER, width, font_size, Color("#f0f4fa"))

func _calculate_bounds() -> Rect2:
	if _bounds_cache_valid and _cached_bounds_level == view_level and _cached_bounds_state == selected_state:
		return _cached_bounds
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
		_cached_bounds = Rect2(68.0, 6.0, 30.0, 32.0)
	else:
		var margin_x := (max_x - min_x) * 0.015
		var margin_y := (max_y - min_y) * 0.015
		_cached_bounds = Rect2(min_x - margin_x, min_y - margin_y, max_x - min_x + margin_x * 2.0, max_y - min_y + margin_y * 2.0)
	_cached_bounds_level = view_level
	_cached_bounds_state = selected_state
	_bounds_cache_valid = true
	return _cached_bounds

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
	if layer_name != "Political control":
		var metric_key := state
		if view_level > 0:
			metric_key = "%s|%s" % [state, district]
		var region_metrics: Dictionary = map_metrics.get(metric_key, {})
		var metric_value := float(region_metrics.get(layer_name, -1.0))
		if metric_value < 0.0:
			return NEUTRAL
		return Color("#263b54").lerp(Color("#d6b15a"), clampf(metric_value / 100.0, 0.0, 1.0))
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
