extends Node

enum window_types {WINDOWED, FULLSCREEN, BORDERLESS}

var coins_collected : int = 0
const PLAYER_TOTAL_HEALTH : int = 3
const MAX_HELMET_HEALTH : int = 7
const DEFAULT_GRAVITY: float  = 980.0
var player_current_health : int = PLAYER_TOTAL_HEALTH
var runtime_gamedata_flags : Dictionary
const controllable_audio_busses : Array[String] = [
	"Music",
	"Sound_Effects",
	"Master"
]
var persistent_gamedata_flags : Dictionary:
	get:
		return SaveManager.save_data
	set(val):
		SaveManager.save_data = val
@onready var allow_input : bool = true
@onready var game_overed = false

func coin_collected(value: int):
	coins_collected += value
	EventController.emit_signal("coin_collected", coins_collected)

func player_take_damage(value: int):
	player_current_health -= value
	EventController.emit_signal("player_damaged", player_current_health)

func reload_scene():
	var tree = get_tree()
	if tree != null:
		EventController.emit_signal("clear_projectiles")
		tree.reload_current_scene()
		game_overed = false
		allow_input = true
	else:
		print("Tree was null")
	
func load_scene(scene: PackedScene) -> void:
	var tree = get_tree()
	if tree == null:
		print("Tree was null")
		return
	allow_input = true
	game_overed = false
	tree.change_scene_to_packed(scene)

func game_over(source: String="") -> void:
	if game_overed:
		return
	allow_input = false
	game_overed = true
	if source != "voidout":
		await wait(2)
	EventController.emit_signal("show_game_over_screen")

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("reload_scene", reload_scene)
	EventController.connect("game_over", game_over)
	SaveManager.load_save()
	_update_volume_mix()
	_set_window_mode_from_save()

func disable_input() -> void:
	EventController.emit_signal("hide_ui")
	allow_input = false
	
func enable_input() -> void:
	EventController.emit_signal("show_ui")
	allow_input = true

func to_main_menu() -> void:
	var menu_scene = preload("res://UI/window_menu.tscn")
	load_scene(menu_scene)

func change_volume_for_bus(bus_name: String, volume: float) -> void:
	if bus_name not in controllable_audio_busses:
		push_error("Invalid audio bus name")
		return
	persistent_gamedata_flags["Volume_" + bus_name] = volume
	_update_volume_mix()

func _update_volume_mix() -> void:
	var current_bus_volume_flag : String
	for bus in controllable_audio_busses:
		current_bus_volume_flag = "Volume_" + bus
		if current_bus_volume_flag not in persistent_gamedata_flags.keys():
			continue
		var bus_index : int = AudioServer.get_bus_index(bus)
		if bus_index == -1:
			push_error("Attempted to access invalid audio bus: {0}".format([bus]))
			continue
		AudioServer.set_bus_volume_linear(bus_index, persistent_gamedata_flags[current_bus_volume_flag])

func _set_window_mode_from_save() -> void:
	if "window_mode" not in persistent_gamedata_flags.keys():
		return
	change_window_type(persistent_gamedata_flags["window_mode"])

func change_window_type(window_type: window_types) -> void:
	persistent_gamedata_flags["window_mode"] = window_type
	match window_type:
		window_types.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, false)
		window_types.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		window_types.BORDERLESS:
			DisplayServer.window_set_flag(DisplayServer.WindowFlags.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
