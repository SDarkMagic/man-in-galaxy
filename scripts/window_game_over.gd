extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	EventController.connect("show_game_over_screen", display_game_over)
	$MarginContainer/VBoxContainer/ContinueButton.pressed.connect(GameManager.reload_scene)
	$MarginContainer/VBoxContainer/QuitButton.pressed.connect(GameManager.to_main_menu)

func display_game_over() -> void:
	show()
	$AudioStreamPlayer.play()
