extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var ends_game: bool = false #

signal dialogue_finished
signal dialogue_started

func action() -> void:
	if ends_game:
		get_tree().change_scene_to_file("res://credits.tscn") 
		return

	dialogue_started.emit()
	var dialog = DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	var music = get_node("/root/Bgm")
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	DialogueManager.dialogue_ended.connect(_unpause)

func _unpause(resource: DialogueResource):
	get_tree().paused = false
	dialogue_finished.emit()
