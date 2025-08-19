extends Node2D

@export var connector_width : float = 1.0
@export var connector_dash_length : float = 50.0
@export var connector_dash_color : Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw() -> void:
	connect_planets()
	
func connect_planets() -> void:
	var planets : Array = self._find_planet_buttons()
	var current_planet : int = 0
	var start_point : Vector2
	var end_point : Vector2
	while current_planet < planets.size() - 1:
		start_point = calc_center(planets[current_planet])
		end_point = calc_center(planets[current_planet + 1])
		draw_dashed_line(to_local(start_point),
			to_local(end_point),
			connector_dash_color,
			connector_width,
			connector_dash_length,
			true,
			true)
		current_planet += 1

func calc_center(node: Control) -> Vector2:
	var pos : Vector2 = node.global_position
	var center : Vector2 = Vector2(0.0, 0.0)
	center.x = pos.x + (node.size.x / 2)
	center.y = pos.y + (node.size.y / 2)
	return center

func _find_planet_buttons() -> Array:
	var buttons : Array = []
	for node in $"..".get_children():
		if node.name.begins_with("btn_lvl"):
			buttons.append(node)
	return buttons

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#connect_planets()
	pass
