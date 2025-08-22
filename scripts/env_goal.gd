extends Node2D

signal level_complete()
@export var target_scene : PackedScene
@export var next_level_name : String
var is_gumbo_defeated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("gumbo_down", gumbo_defeated)
	$Node2D/Fire/AudioStreamPlayer2D.stop()

func gumbo_defeated() -> void:
	is_gumbo_defeated = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	GameManager.disable_input()
	body.is_invuln = true
	body.hide()
	$Node2D/Sprite2D/AnimationPlayer.play("launch")
	self.save_progress()
	await GameManager.wait($Node2D/Sprite2D/AnimationPlayer.get_animation("launch").get_length() + 0.5)
	self.emit_signal("level_complete")
	if target_scene:
		GameManager.load_scene(target_scene)
		GameManager.enable_input()

func save_progress() -> void:
	if next_level_name != "":
		update_level_complete_flag()
	SaveManager.save_game() # Unconditionally save game here to update codex entries
	return

func update_level_complete_flag() -> void:
	var level_complete_flag : StringName = "unlocked_lvl_" + next_level_name
	SaveManager.save_data[level_complete_flag] = true
