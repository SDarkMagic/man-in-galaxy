extends Control

@onready var label = $Label

func _ready() -> void:
	hide()
	EventController.connect("coin_collected", on_event_coin_collected)
	EventController.connect("level_start", show_ui)


func on_event_coin_collected(value: int) -> void:
	label.text = str(value)
	$AudioStreamPlayer.play()

func show_ui(pos: Vector2):
	show()
