extends Node

const SAVE_PATH := "user://savegame.json"

func save_game(pos: Vector2, time: float) -> void:
	var save_data = {
		"player_position": {"x": pos.x, "y": pos.y},
		"stopwatch_time": time
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved to ", SAVE_PATH, " with data: ", save_data)

func load_player_position() -> Vector2:
	if not FileAccess.file_exists(SAVE_PATH):
		return Vector2(162, 482)  # default start position

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()

	if json.error != OK:
		print("Error parsing save file:", json.error_string)
		return Vector2(162, 482)

	var data = json.result
	if data and data.has("player_position"):
		var pos = data["player_position"]
		return Vector2(pos["x"], pos["y"])

	return Vector2(162, 482)  # fallback default start position

func load_stopwatch_time() -> float:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0.0

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()

	if json.error != OK:
		print("Error parsing save file:", json.error_string)
		return 0.0

	var data = json.result
	if data and data.has("stopwatch_time"):
		return data["stopwatch_time"]

	return 0.0
