extends Control

@export var health_icon : Texture
@export var damaged_icon : Texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_health_display()
	EventController.connect("player_health_updated", on_event_player_health_updated)

func _init_health_display() -> void:
	for i in range(GameManager.PLAYER_TOTAL_HEALTH):
		var health = TextureRect.new()
		health.texture = health_icon
		health.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		health.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		health.custom_minimum_size = Vector2(100.0, 100.0)
		$GridContainer.add_child(health)

func on_event_player_health_updated(health: int) -> void:
	var children : Array = $GridContainer.get_children()
	for i in range(GameManager.PLAYER_TOTAL_HEALTH):
		if i >= children.size():
			push_error("Maximum health was greater than the amount of available icons")
			break # Catch any potential edge cases where there are somehow less icons in the grid than the player has max health
		if i >= health:
			children[i].texture = damaged_icon
