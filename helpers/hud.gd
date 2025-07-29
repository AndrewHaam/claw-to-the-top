extends Control
class_name Hud

@export var stopwatch_label: Label
@export var progress_label: Label
@export var player_node_path: NodePath
var player: Node2D


var stopwatch : Stopwatch

func _ready():
	stopwatch = get_tree().get_first_node_in_group("stopwatch")
	player = get_tree().get_first_node_in_group("player") 

func _process(delta):
	update_stopwatch_label()

func update_stopwatch_label():
	stopwatch_label.text = stopwatch.time_to_string(stopwatch.time)
