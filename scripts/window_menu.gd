extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu/MarginContainer/VBoxContainer/PlayButton.pressed.connect(from_main_to_level_select)
	$LevelSelect/BackButton.pressed.connect(from_level_select_to_main)
	$MainMenu/MarginContainer/VBoxContainer/CodexButton.pressed.connect(from_main_to_codex)
	$EnemyCodex/MarginContainer/VBoxContainer/HBoxContainer/BackButton.pressed.connect(from_codex_to_main)

func from_main_to_level_select() -> void:
	$MainMenu.slide_out()
	$LevelSelect.slide_in()

func from_level_select_to_main() -> void:
	$LevelSelect.slide_out()
	$MainMenu.slide_in()

func from_main_to_codex() -> void:
	$MainMenu.slide_out()
	$EnemyCodex.slide_in()

func from_codex_to_main() -> void:
	$EnemyCodex.slide_out()
	$MainMenu.slide_in()
