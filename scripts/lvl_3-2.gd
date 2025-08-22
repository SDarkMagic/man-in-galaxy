extends "res://scripts/level_manager.gd"

var level_start : Vector2 = Vector2(750.0, -4570.0)
@export var gumbo_theme : AudioStream
@export_file("*.ogv") var end_cutscene : String = ""

# Called when the node enters the scene tree for the first time.a
func _ready() -> void:
	EventController.connect("level_start", start_music_playback)
	EventController.connect("game_over", stop_music_playback)
	#EventController.emit_signal("level_start",level_start)
	EventController.emit_signal("level_start", Vector2(17000.0, -5500.0)) # Start at Great Gumbo fight
	$Goal.connect("level_complete", play_cutscene)

func play_cutscene() -> void:
	get_tree().paused = true
	GameManager.disable_input()
	var layer : CanvasLayer = CanvasLayer.new()
	layer.layer = 2
	layer.follow_viewport_enabled = false
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	var video_player : VideoStreamPlayer = VideoStreamPlayer.new()
	layer.add_child(video_player)
	get_tree().root.add_child(layer)
	var video : VideoStreamTheora = load(end_cutscene)
	video_player.stream = video
	video_player.expand = true
	video_player.bus = &"Music"
	video_player.size = Vector2(1920.0, 1080.0)
	video_player.finished.connect(cutscene_playback_finished.bind(video_player))
	#$CanvasLayer.hide()
	video_player.play()
	return

func cutscene_playback_finished(player: VideoStreamPlayer) -> void:
	player.hide()
	get_tree().paused = false
	GameManager.enable_input()
	GameManager.to_main_menu()
	return

func _on_fire_death_box_body_entered(body: Node2D) -> void:
	if body is Player:
		EventController.emit_signal("game_over", "voidout")


func _on_boss_area_body_entered(body: Node2D) -> void:
	if body is Player:
		# Send signal to start bss fight sequence
		var pan_duration : float = 0.9
		var target_pos : Vector2 = $BossArea.global_position
		target_pos.x += 650
		GameManager.disable_input()
		$BackgroundMusic.stop()
		$BackgroundMusic.stream = gumbo_theme
		$BackgroundMusic.play()
		body.pan_camera_to_pos(target_pos, pan_duration)
		await GameManager.wait(pan_duration)
		$Enemy_Gumbo.play_idle_sound()
		await GameManager.wait($Enemy_Gumbo.audio_files["idle"].get_length())
		body.reset_camera()
		$BossArea.monitoring = false
		$Enemy_Gumbo.paused = false
		GameManager.enable_input()
	pass # Replace with function body.
