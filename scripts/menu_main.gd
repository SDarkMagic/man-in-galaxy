extends Control

@export var enemy_codex_scene : PackedScene
@export var level_select_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/PlayButton.pressed.connect(open_level_select)
	$VBoxContainer/CodexButton.pressed.connect(open_enemy_codex)

func open_enemy_codex() -> void:
	GameManager.load_scene(enemy_codex_scene)
	
func open_level_select() -> void:
	GameManager.load_scene(level_select_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
