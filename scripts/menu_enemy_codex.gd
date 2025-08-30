extends Control

@export var enemy_names : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_buttons()

func _setup_buttons() -> void:
	var button_scene = preload("res://UI/btn_enemy.tscn")
	for enemy in enemy_names:
		var button = button_scene.instantiate()
		var icon_path : String = "res://UI/icons/enemy_" + enemy
		button.icon = load(icon_path + ".png")
		button.disabled_icon = load(icon_path + "_disabled.png")
		button.hover_icon = load(icon_path + "_hover.png")
		button.enemy_name_internal = enemy
		$MarginContainer/VBoxContainer/GridContainer.add_child(button)
		button.connect("pressed", open_codex_for_enemy)

func open_codex_for_enemy(enemy_name: String) -> void:
	var msg_enemy_tag : String = "ENEMY_CODEX_" + enemy_name.to_upper()
	var window = $window_enemy_codex
	var enemy_image : Texture2D = load(String("res://UI/icons/enemy_" + enemy_name + ".png"))
	window.tag_name = msg_enemy_tag + "_NAME"
	window.tag_desc = msg_enemy_tag + "_DESC"
	window.portrait = enemy_image
	window.update()
	window.show()

func slide_in() -> void:
	$AnimationPlayer.play("slide_in")
	
func slide_out() -> void:
	$AnimationPlayer.play_backwards("slide_in")
