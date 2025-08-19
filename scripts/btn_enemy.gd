class_name ButtonEnemy extends Control

@export var enemy_name_internal : String
@export var icon : Texture2D
@export var disabled_icon : Texture2D
@export var hover_icon : Texture2D

signal pressed(enemy_name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var seen_flag : String = "seen_enemy_" + enemy_name_internal
	$TextureButton.texture_normal = icon
	$TextureButton.texture_disabled = disabled_icon
	$TextureButton.texture_hover = hover_icon
	if not seen_flag in SaveManager.save_data.keys():
		$TextureButton.disabled = true
		return
	if SaveManager.save_data[seen_flag] == false:
		$TextureButton.disabled = true
	else:
		$TextureButton.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	emit_signal("pressed", enemy_name_internal)
