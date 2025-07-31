extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

signal dialogue_finished
signal dialogue_started

func action() -> void:
	dialogue_started.emit()
	var dialog = DialogueManager. show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	var music = get_node("/root/Bgm")
	#dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	#get_tree().paused = true
	DialogueManager.dialogue_ended.connect(_unpause)
	

func _unpause(resource: DialogueResource):
	get_tree().paused = false
	dialogue_finished.emit()
