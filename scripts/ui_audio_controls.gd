extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$VBoxContainer/Music/Slider.value = 0.08128305161641 # Incredibly hacky workaround to make the music slider mirror the actual value used for the Music bus. Ideally the music files would be audio balanced properly instead of having to do this in engine
	pass
