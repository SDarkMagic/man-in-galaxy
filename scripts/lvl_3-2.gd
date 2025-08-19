extends Node2D

var level_start : Vector2 = Vector2(750.0, -14570.0)
@export_file("*.ogv") var end_cutscene : String = ""

# Called when the node enters the scene tree for the first time.a
func _ready() -> void:
	EventController.emit_signal("level_start",level_start)
	#EventController.emit_signal("level_start", Vector2(18750.0, -5300.0))
	$Goal.connect("level_complete", play_cutscene)

func play_cutscene() -> void:
	var layer : CanvasLayer = CanvasLayer.new()
	var video_player : VideoStreamPlayer = VideoStreamPlayer.new()
	layer.add_child(video_player)
	get_tree().root.add_child(layer)
	var video : VideoStreamTheora = VideoStreamTheora.new()
	video.file = end_cutscene
	video_player.stream = video
	video_player.finished.connect(cutscene_playback_finished.bind(video_player))
	$CanvasLayer.hide()
	video_player.play()
	return

func cutscene_playback_finished(player: VideoStreamPlayer) -> void:
	player.hide()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fire_death_box_body_entered(body: Node2D) -> void:
	if body is Player:
		EventController.emit_signal("game_over", "voidout")
