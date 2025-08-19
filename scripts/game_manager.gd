extends Node

var coins_collected : int = 0
const PLAYER_TOTAL_HEALTH : int = 3
const MAX_HELMET_HEALTH : int = 7
const DEFAULT_GRAVITY: float  = 980.0
var player_current_health : int = PLAYER_TOTAL_HEALTH
var runtime_gamedata_flags : Dictionary
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
	else:
		print("Tree was null")
	
func load_scene(scene: PackedScene) -> void:
	var tree = get_tree()
	if tree == null:
		print("Tree was null")
		return
	tree.change_scene_to_packed(scene)

func game_over(source: String="") -> void:
	if game_overed:
		return
	allow_input = false
	game_overed = true
	if source != "voidout":
		await wait(2)
	reload_scene()
	allow_input = true

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("reload_scene", reload_scene)
	EventController.connect("game_over", game_over)
	SaveManager.load_save()

func disable_input() -> void:
	EventController.emit_signal("hide_ui")
	allow_input = false
	
func enable_input() -> void:
	EventController.emit_signal("show_ui")
	allow_input = true

func to_main_menu() -> void:
	var menu_scene = preload("res://UI/menu_main.tscn")
	load_scene(menu_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
