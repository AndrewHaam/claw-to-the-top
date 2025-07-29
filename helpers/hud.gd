extends Control
class_name Hud

@export var stopwatch_label: Label
@export var progress_label: Label

@export var goal_y: float = -3998.0  # Top of map (highest point)
@export var start_y: float = 482.0   # Bottom of map (starting point)

var stopwatch: Stopwatch
var player: Node2D

func _ready():
	stopwatch = get_tree().get_first_node_in_group("stopwatch")
	player = get_tree().get_first_node_in_group("player")

func _process(delta):
	update_stopwatch_label()
	update_progress_label()

func update_stopwatch_label():
	if stopwatch:
		stopwatch_label.text = stopwatch.time_to_string(stopwatch.time)

func update_progress_label():
	if player:
		var y = clamp(player.position.y, goal_y, start_y)
		var percent = int(((start_y - y) / (start_y - goal_y)) * 100.0)
		progress_label.text = "%d%%" % percent
