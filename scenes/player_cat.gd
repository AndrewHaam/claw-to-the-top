class_name PlayerCat


extends CharacterBody2D

@export var max_time_held : float
@export var min_jump_height : float 
@export var max_jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@export var camera_height : int = 331
@export var camera_limit_lower : int = 527
@export var camera_limit_upper : int = 196

signal change_camera_pos

@onready var anim = $AnimatedSprite2D
@onready var stopwatch = get_node("/root/Stopwatch")
@onready var jump_height : float = min_jump_height
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
@onready var coefficient = (min_jump_height - max_jump_height) / max_time_held
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var sfx_jump = $sfx_jump

const SPEED = 150.0
var is_holding : bool = false
var in_air: bool = false
var time_held : float
var direction = 0.0
var current_direction : float
var fall_played = false
var squat_played = false
var can_move := true

func _ready():
	#stopwatch.time = SaveManager.load_stopwatch_time()
	print("Loaded position:", position)
	#print("Loaded stopwatch time:", stopwatch.time)


func _unhandled_input(event):
	if event.is_action_pressed("save"):
		print("Save action triggered")
		if stopwatch:
			print("Game saved at position: ", position)
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			var target = actionables[0]
			target.action()

			# Hide the label if the target has the method
			if target.has_method("hide_interact_label"):
				target.hide_interact_label()



func modified_get_gravity() -> Vector2:
	if velocity.y < 0:
		return Vector2(0, jump_gravity)
	else:
		return Vector2(0, fall_gravity)

func get_animation():
	if is_on_floor():
		fall_played = false
		if Input.is_action_just_released("jump"):
			sfx_jump.play()
			anim.play("jump")
			squat_played = false
		elif squat_played:
			return
		elif is_holding:
			anim.play("squat")
			squat_played = true
		elif direction != 0:
			anim.play("run")
		else:
			anim.play("idle")
	else:
		squat_played = false
		if velocity.y >= 0 and !fall_played:
			anim.play("fall")
			fall_played = true

	if current_direction > 0:
		anim.flip_h = false
	elif current_direction < 0:
		anim.flip_h = true

func get_x_movement():
	direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if is_holding or direction == 0:
			velocity.x = 0
		else:
			velocity.x = SPEED * direction
			current_direction = direction
	else:
		if velocity.x == 0:
			current_direction *= -1
			#print("bounced")
		velocity.x = current_direction * SPEED

func get_jump_height(delta):
	if Input.is_action_just_pressed("jump"):
		is_holding = true
		time_held = 0.0
	if is_holding:
		time_held += delta
	if Input.is_action_just_released("jump"):
		is_holding = false
		in_air = true
		if time_held >= max_time_held:
			time_held = max_time_held
		jump_height = coefficient * time_held - min_jump_height
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak)

func move_camera_to_match_player(): 
	if position.y < camera_limit_upper:
		camera_limit_lower -= camera_height
		camera_limit_upper -= camera_height
		change_camera_pos.emit(-camera_height)
	elif position.y > camera_limit_lower:
		camera_limit_lower += camera_height
		camera_limit_upper += camera_height
		change_camera_pos.emit(+camera_height)
		
func _physics_process(delta: float) -> void:
	if not can_move:
		#anim.play("idle")
		#velocity = Vector2.ZERO
		#move_and_slide()
		return

	get_animation()

	if velocity.y > 600:
		velocity.y = 600

	if not is_on_floor():
		velocity += modified_get_gravity() * delta

	get_x_movement()
	get_jump_height(delta)

	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = jump_velocity
		velocity.x = SPEED * current_direction

	move_camera_to_match_player()
	move_and_slide()


func _on_actionable_dialogue_finished() -> void:
	can_move = true # Replace with function body.


func _on_actionable_dialogue_started() -> void:
	can_move = false
