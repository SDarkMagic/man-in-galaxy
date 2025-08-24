extends VBoxContainer

@export var slider_label : String
@export var audio_bus : StringName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = slider_label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slider_drag_ended(value_changed: bool) -> void:
	if not value_changed:
		return
	GameManager.change_volume_for_bus(audio_bus, $Slider.value)
