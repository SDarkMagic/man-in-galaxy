extends Control

@onready var label = $Label
@onready var helmet = $Helmet/HelmetAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventController.connect("attack_used", on_event_player_attacks)
	label.text = str(GameManager.MAX_HELMET_HEALTH)


func on_event_player_attacks(attacks_used: int) -> void:
	label.text = str(GameManager.MAX_HELMET_HEALTH - attacks_used)
	var anim_name : String = String("damage_" + str(attacks_used))
	if attacks_used == GameManager.MAX_HELMET_HEALTH:
		anim_name = "broken"
	helmet.play(anim_name)
