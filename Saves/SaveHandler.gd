extends Node
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveLoad._auto_save() # Or perform other shutdown tasks
		# get_tree().quit() # You might put this here to force the quit
