extends Control
@onready var panel_container: PanelContainer = $PanelContainer
@onready var options: Panel = $Options
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var main_buttons: VBoxContainer = $PanelContainer/MainButtons

func _ready():
	$AnimationPlayer.play("RESET")
	main_buttons.visible = true
	options.visible = false	
	hide()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

	
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		
		

func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _process(_delta):
	testEsc()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	panel_container.visible = false


func _on_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
	panel_container.visible = true


func _on_sfx_control_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value <.05)


func _on_music_control_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value <.05)
