extends Node2D

@export_file("*.ogv") var open_cutscene : String = ""
@export var current_level_name : String
@onready var cutscene_played_flag_name : String = "has_played_cutscene_" + current_level_name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if open_cutscene == "":
		$Node2D/Sprite2D/AnimationPlayer.play("set_crashed")
		EventController.emit_signal("level_start", global_position)
		return
		
	if not cutscene_played_flag_name in GameManager.runtime_gamedata_flags.keys():
		GameManager.runtime_gamedata_flags[cutscene_played_flag_name] = false
		
	if not GameManager.runtime_gamedata_flags[cutscene_played_flag_name]:
		GameManager.disable_input()
		get_tree().paused = true
		play_cutscene()
	else:
		$Node2D/Sprite2D/AnimationPlayer.play("set_crashed")
		EventController.emit_signal("level_start", global_position)
		
func play_cutscene() -> void:
	var player : VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer
	var video : VideoStreamTheora = VideoStreamTheora.new()
	video.file = open_cutscene
	player.stream = video
	player.finished.connect(cutscene_playback_finished.bind(player))
	player.play()
	return

func cutscene_playback_finished(player: VideoStreamPlayer) -> void:
	player.hide()
	$Node2D/Sprite2D/AnimationPlayer.play("crash")
	GameManager.runtime_gamedata_flags[cutscene_played_flag_name] = true
	return

func enable_gameplay() -> void:
	EventController.emit_signal("level_start", global_position)
	GameManager.enable_input()
	get_tree().paused = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
