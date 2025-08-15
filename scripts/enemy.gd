class_name Enemy extends CharacterBody2D

@export var mass : float = 50.0
@export var width : float = 20.0
@export var enemy_name : String
var is_dead : bool = false

# Enemy Sound effects
@export var idle_delay_variance_min : float = 1.4
@export var idle_delay_variance_max : float = 5.9
@onready var audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var audio_files : Dictionary = {
	"die": null,
	"idle": null
}
@onready var idle_audio_delay : Timer = Timer.new()
var idle_audio_looping_auto : bool = true


func apply_gravity(vel: Vector2, delta: float) -> Vector2:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		vel.y += (mass * get_gravity().y) * delta
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * width))
		if vel.y > terminal_velocity:
			vel.y = terminal_velocity
	return vel	
			
func _physics_process(delta: float) -> void:
	# Add the gravity, capping at a terminal velocity
	if not is_on_floor():
		velocity.y += (mass * get_gravity().y) * delta
		var player_width = 20
		var terminal_velocity : float = sqrt((2 * mass * get_gravity().y) / (1 * 0.0001 * player_width))
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
	# Do necessary AI calcs here for enemy
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider().name
		if collider == "Player":
			EventController.emit_signal("damage_player", 1)
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_audio_player()
	pass
	
func kill():
	is_dead = true
	await play_death_sound()
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func register_enemy_seen() -> void:
	if enemy_name == "":
		return
	var enemy_seen_flag : String = "seen_enemy_" + enemy_name
	SaveManager.save_data[enemy_seen_flag] = true
	return
		
# Audio functions
func _init_audio_player() -> void:
	audio_player.set_bus("Enemy")
	var file_path : String
	for action in audio_files.keys():
		file_path = "res://sound/enemy_{name}_{identifier}.wav".format({"name": enemy_name, "identifier": action})
		if not ResourceLoader.exists(file_path):
			continue
		audio_files[action] = load(file_path)
	add_child(audio_player)
	add_child(idle_audio_delay)
	_init_idle_audio()
	return

func _init_idle_audio() -> void:
	if "idle" not in audio_files.keys():
		return
	if audio_files["idle"] == null:
		return
	idle_audio_delay.timeout.connect(play_idle_sound_for_timer)
	idle_audio_delay.wait_time = audio_files["idle"].get_length()
	idle_audio_delay.one_shot = true
	play_idle_sound_for_timer()

func disable_idle_timer() -> void:
	idle_audio_looping_auto = false
	idle_audio_delay.stop()

func add_audio_action(action: String) -> void:
	var file_path : String = "res://sound/enemy_{name}_{identifier}.wav".format({"name": enemy_name, "identifier": action})
	if not ResourceLoader.exists(file_path):
		push_error("Failed to load audio file for action: {action} on enemy: {enemy}".format([action, enemy_name]))
		return
	audio_files[action] = load(file_path)
	return
	
func play_sound_for_action(action: String) -> void:
	if action not in audio_files.keys():
		push_error("Specified action was not found for the given identifier while trying to play audio: {0}".format([action]))
		return
	if audio_files[action] == null:
		return
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = audio_files[action]
	audio_player.play()
	#print("Successfully played sound")
	return

func play_death_sound() -> void:
	play_sound_for_action("die")
	if audio_files["die"] == null:
		return
	await GameManager.wait(audio_files["die"].get_length())
	return

func play_idle_sound() -> void:
	if is_dead:
		return
	var duration : float = audio_files["idle"].get_length()
	var delay_variance : float = randf_range(idle_delay_variance_min, idle_delay_variance_max)
	idle_audio_delay.wait_time = duration + delay_variance
	play_sound_for_action("idle")

func play_idle_sound_for_timer() -> void:
	if idle_audio_looping_auto == false:
		return
	play_idle_sound()
	idle_audio_delay.start()
