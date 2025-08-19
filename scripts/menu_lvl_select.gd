extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level_unlock_flag_template : String = "unlocked_lvl_"
	for node in self.get_children():
		if node is not LevelSelectButton:
			continue
		if self._has_unlocked_level(level_unlock_flag_template + node.level_name):
			node.disabled = false

func _has_unlocked_level(level_name: String) -> bool:
	if level_name not in SaveManager.save_data.keys():
		return false
	return SaveManager.save_data[level_name]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func slide_in() -> void:
	$AnimationPlayer.play("slide_in")
	
func slide_out() -> void:
	$AnimationPlayer.play_backwards("slide_in")
