extends Sprite2D

func _ready() -> void:
	await get_tree().process_frame
	SaveLoad._load()
	
	if $PlayerCat:
		$PlayerCat.velocity.x = SaveLoad.contents_to_save.player_velocity_x
		$PlayerCat.current_direction = SaveLoad.contents_to_save.player_current_direction
		$PlayerCat.position.y = SaveLoad.contents_to_save.player_position_y
		$PlayerCat.position.x = SaveLoad.contents_to_save.player_position_x
		$PlayerCat.camera_limit_lower = SaveLoad.contents_to_save.camera_limit_lower
		$PlayerCat.camera_limit_upper = SaveLoad.contents_to_save.camera_limit_upper

	if $Camera2D:
		$Camera2D.position.y = SaveLoad.contents_to_save.camera_position_y

	if $Stopwatch:
		$Stopwatch.time = SaveLoad.contents_to_save.stopwatch_time

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		SaveLoad._auto_save()

func _on_player_cat_change_camera_pos(player_pos):
	if $Camera2D:
		print("b4: ", $Camera2D.position.y)
		$Camera2D.position.y += player_pos
		print("after: ", $Camera2D.position.y)

func _on_actionable_dialogue_finished() -> void:
	pass
