extends Node2D

const SAVE_LOCATION := "user://SaveFile.json"
# Called when the node enters the scene tree for the first time.
var contents_to_save : Dictionary = {
	"camera_position_y" = 0,
	"camera_limit_lower" = 527,
	"camera_limit_upper" = 196,
	"player_position_x" = 164.0,
	"player_position_y" = 482.0,
	"stopwatch_time" = 0
}
func _ready() -> void:
	_load()
func _save():
	var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.WRITE, "9284505@h4V")
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load(): 
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.READ, "9284505@h4V")
		var data = file.get_var()
		file.close()
	
		var save_data = data.duplicate()
		contents_to_save.player_position_x = save_data.player_position_x
		contents_to_save.player_position_y = save_data.player_position_y
		contents_to_save.camera_position_y = save_data.camera_position_y
		contents_to_save.camera_limit_lower = save_data.camera_limit_lower
		contents_to_save.camera_limit_upper = save_data.camera_limit_upper
		contents_to_save.stopwatch_time = save_data.stopwatch_time
	
