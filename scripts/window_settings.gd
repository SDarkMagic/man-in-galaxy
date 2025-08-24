extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "window_mode" in SaveManager.save_data.keys():
		$MarginContainer/VBoxContainer/OptionButton.selected = $MarginContainer/VBoxContainer/OptionButton.get_item_index(SaveManager.save_data["window_mode"])

func slide_in() -> void:
	$AnimationPlayer.play("slide_in")

func slide_out() -> void:
	$AnimationPlayer.play_backwards("slide_in")

func _on_option_button_item_selected(index: int) -> void:
	var id : int = $MarginContainer/VBoxContainer/OptionButton.get_item_id(index)
	GameManager.change_window_type(id)


func _on_back_button_pressed() -> void:
	SaveManager.save_game() # Save the game to update the settings stored in the save file
