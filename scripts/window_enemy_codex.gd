class_name EnemyCodex extends Control

@export var tag_name : String
@export var tag_desc : String
@export var portrait : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update() -> void:
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Label.text = tr(tag_name)
	$MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/RichTextLabel.text = tr(tag_desc)
	$MarginContainer/HBoxContainer/TextureRect.texture = portrait


func _on_button_pressed() -> void:
	hide()
