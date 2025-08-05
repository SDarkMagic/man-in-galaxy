class_name  LevelSelectButton extends TextureButton

@export var level : PackedScene
@export var level_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(start_level)
	pass # Replace with function body.

func start_level() -> void:
	GameManager.load_scene(level)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
