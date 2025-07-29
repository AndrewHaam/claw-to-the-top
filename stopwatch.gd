extends Node
class_name Stopwatch

var time = 0.0
var stopped = false

func _process(delta):
	if stopped:
		return
	time += delta

func reset():
	time = 0.0


func time_to_string(time: float) -> String:
	var total_seconds = int(time)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [hours, minutes, seconds]
	return actual_string
