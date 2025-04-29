extends Control

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("player_health_updated", on_event_player_health_updated)


func on_event_player_health_updated(health: int) -> void:
	label.text = str(health)
