extends Node2D

@export var explosion_duration : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if explosion_duration > 0.0:
		_retime_explosion_keys()


func _retime_explosion_keys() -> void:
	var explode : Animation = $AnimationPlayer.get_animation("explode")
	explode.length = explosion_duration
	explode.track_set_key_time(0, 1, explosion_duration) # Retime final frame of the animation to play at the end of the new duration
	explode.track_set_key_time(1, 0, (explosion_duration * 5) / 6) # Retime initial alpha self-modulate to correct proportional timing in the updated duration
	explode.track_set_key_time(1, 1, explosion_duration) # Set final alpha self-modulate key to end of the animation

func explode() -> void:
	show()
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer2D.play()
