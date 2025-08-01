extends CanvasLayer

func _ready():
	get_tree().paused = false   # Just in case the game is paused
	$AnimationPlayer.play("scroll")  # Your animation name

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation finished:", anim_name)
	if anim_name == "scroll":
		print("Going to main menu")
		Bgm.stop_music()
		get_tree().change_scene_to_file("res://main menu/main_menu.tscn")
