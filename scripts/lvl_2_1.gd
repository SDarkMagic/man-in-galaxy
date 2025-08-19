extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("game_over", stop_background_music)
	EventController.connect("level_start", start_background_music)
	pass # Replace with function body.

func start_background_music(pos: Vector2) -> void:
	$BackgroundMusic.play()

func stop_background_music(death_source: String) -> void:
	$BackgroundMusic.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
