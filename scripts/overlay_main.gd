extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("hide_ui", hide)
	EventController.connect("show_ui", show)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
