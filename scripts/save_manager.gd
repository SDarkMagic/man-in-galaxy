extends Node

const save_path = "user://save_main.json"
var save_data : Dictionary

func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var json = JSON.new()
	for key in save_data.keys():
		save_file.store_line(JSON.stringify({key: save_data.get(key)}))
	return
	
func load_save():
	if not FileAccess.file_exists(save_path):
		return
		
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var json = JSON.new()
	while save_file.get_position() < save_file.get_length():
		var current_line : String = save_file.get_line()
		var parse_res = json.parse(current_line)
		print(current_line)
		if not parse_res == OK:
			print("JSON parse error", json.get_error_message(), " in ", current_line, " at ", json.get_error_line())
		save_data.assign(json.data)
