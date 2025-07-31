extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_cat_change_camera_pos(player_pos):
	print("b4: ", $Camera2D.position.y)
	$Camera2D.position.y += player_pos
	print("after: ", $Camera2D.position.y)


func _on_actionable_dialogue_finished() -> void:
	pass # Replace with function body.
