extends Node

var coins_collected : int = 0
const PLAYER_TOTAL_HEALTH : int = 3
var player_current_health : int = PLAYER_TOTAL_HEALTH

func coin_collected(value: int):
	coins_collected += value
	EventController.emit_signal("coin_collected", coins_collected)

func player_take_damage(value: int):
	player_current_health -= value
	EventController.emit_signal("player_damaged", player_current_health)

func reload_scene():
	var tree = get_tree()
	if tree != null:
		tree.reload_current_scene()
	else:
		print("Tree was null")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("reload_scene", reload_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
