extends Sprite2D


func _ready() -> void:
	SaveLoad._load()
	$PlayerCat.position.y = SaveLoad.contents_to_save.player_position_y
	$PlayerCat.position.x = SaveLoad.contents_to_save.player_position_x
	$Camera2D.position.y = SaveLoad.contents_to_save.camera_position_y
	$PlayerCat.camera_limit_lower = SaveLoad.contents_to_save.camera_limit_lower
	$PlayerCat.camera_limit_upper = SaveLoad.contents_to_save.camera_limit_upper
	$Stopwatch.time = SaveLoad.contents_to_save.stopwatch_time
	print("stopwatch time: ", SaveLoad.contents_to_save.camera_limit_lower)
	print("loaded")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_auto_save()

func _auto_save() -> void:
	if Input.is_action_just_pressed("esc"):
		SaveLoad.contents_to_save.player_position_y = $PlayerCat.position.y
		SaveLoad.contents_to_save.stopwatch_time = $Stopwatch.time
		print("stopwatch time: ", $Stopwatch.time)
		SaveLoad.contents_to_save.player_position_x = $PlayerCat.position.x
		SaveLoad.contents_to_save.camera_position_y = $Camera2D.position.y
		SaveLoad.contents_to_save.camera_limit_lower = $PlayerCat.camera_limit_lower 
		SaveLoad.contents_to_save.camera_limit_upper = $PlayerCat.camera_limit_upper
		print("saved")
		SaveLoad._save()

func _on_player_cat_change_camera_pos(player_pos):
	print("b4: ", $Camera2D.position.y)
	$Camera2D.position.y += player_pos
	print("after: ", $Camera2D.position.y)


func _on_actionable_dialogue_finished() -> void:
	pass # Replace with function body.
