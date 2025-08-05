extends Node2D

const SAVE_LOCATION := "user://SaveFile6.json"
# Called when the node enters the scene tree for the first time.
var contents_to_save : Dictionary = {
	"player_velocity_x" = 0,
	"player_current_direction" = -1,
	"camera_position_y" = 0,
	"camera_limit_lower" = 527,
	"camera_limit_upper" = 196,
	"player_position_x" = 164.0,
	"player_position_y" = 482.0,
	"stopwatch_time" = 0
}
func _ready() -> void:
	_load()

func _auto_save():
	var player = get_tree().get_first_node_in_group("player")
	var camera = get_tree().get_first_node_in_group("camera")
	var stopwatch = get_tree().get_first_node_in_group("stopwatch")
	
	if not player or not camera or not stopwatch:
		#print("⚠Auto-save skipped: required nodes are missing.")
		return

	var save = SaveLoad.contents_to_save
	save.player_velocity_x = player.velocity.x
	save.player_current_direction = player.current_direction
	save.player_position_x = player.position.x
	save.player_position_y = player.position.y
	save.camera_position_y = camera.position.y
	save.camera_limit_lower = player.camera_limit_lower
	save.camera_limit_upper = player.camera_limit_upper
	save.stopwatch_time = stopwatch.time

	SaveLoad._save()
	#print("Saved (manual/ESC)")

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
		
		contents_to_save.player_velocity_x = save_data.player_velocity_x
		contents_to_save.player_current_direction = save_data.player_current_direction
		contents_to_save.player_position_x = save_data.player_position_x
		contents_to_save.player_position_y = save_data.player_position_y
		contents_to_save.camera_position_y = save_data.camera_position_y
		contents_to_save.camera_limit_lower = save_data.camera_limit_lower
		contents_to_save.camera_limit_upper = save_data.camera_limit_upper
		contents_to_save.stopwatch_time = save_data.stopwatch_time
		
		
func _reset_save_data():
	contents_to_save = {
		"player_velocity_x" = 0,
		"player_current_direction" = -1,
		"camera_position_y" = 0,
		"camera_limit_lower" = 527,
		"camera_limit_upper" = 196,
		"player_position_x" = 164.0,
		"player_position_y" = 482.0,
		"stopwatch_time" = 0
	}
