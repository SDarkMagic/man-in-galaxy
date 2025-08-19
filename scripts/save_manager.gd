extends Node

const save_path = "user://save_main.json"
var save_data : Dictionary = {}

func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_data))
	save_file.close()
	return
	
func load_save():
	if not FileAccess.file_exists(save_path):
		return
		
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var json = JSON.new()
	var parse_res = json.parse(save_file.get_as_text())
	if parse_res != OK:
		push_error("JSON parse error", json.get_error_message(), " at ", json.get_error_line())
		return
	save_data.assign(json.data)
	return

func _init_save_data() -> void:
	# TODO: Add template save data, read it here, then populate save data with it
	var json = JSON.new()
	pass 
