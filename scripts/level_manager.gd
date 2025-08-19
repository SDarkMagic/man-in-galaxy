extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("level_start", start_music_playback)
	EventController.connect("game_over", stop_music_playback)

func start_music_playback(pos: Vector2) -> void:
	$BackgroundMusic.play()

func stop_music_playback(death_source: String) -> void:
	$BackgroundMusic.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
