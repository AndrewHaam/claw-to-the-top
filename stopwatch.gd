extends Node
class_name Stopwatch

var time = 0.0
var stopped = false

#func _ready():
	#time = SaveManager.load_stopwatch_time()

func _process(delta):
	if stopped:
		return
	time += delta

#func reset():
	#time = 0.0

func time_to_string(time: float) -> String:
	var total_seconds = int(time)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]


func _on_actionable_dialogue_started() -> void:
	stopped = true # Replace with function body.


func _on_actionable_dialogue_finished() -> void:
	stopped = false # Replace with function body.
