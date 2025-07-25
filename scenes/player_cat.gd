extends CharacterBody2D

@export var max_time_held : float
@export var min_jump_height : float 
@export var max_jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

#@export var camera_height : int = 400
#@export var camera_limit_lower : int = 400
#@export var camera_limit_upper : int = 0
@export var camera_height : int = 200
@export var camera_limit_lower : int = 527
@export var camera_limit_upper : int = 196

signal change_camera_pos

@onready var anim = $AnimatedSprite2D
@onready var jump_height : float = min_jump_height
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
@onready var coefficient = (min_jump_height - max_jump_height)/max_time_held
@onready var actionable_finder: Area2D = $Direction/ActionableFinder



#if you want to change horizontal speed
const SPEED = 150.0
var is_holding : bool = false
var in_air: bool = false
var time_held : float
var direction = Input.get_axis("ui_left", "ui_right")
var current_direction : float = 1
var fall_played = false
var squat_played = false
func modified_get_gravity() -> Vector2:
	if velocity.y < 0:
		return Vector2(0, jump_gravity)
	else:
		return Vector2(0, fall_gravity)

#this is used to talk dont delete
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables. size () > 0:
			actionables[0].action ()
			return

#this is to make sure i can't move while talking
#var can_move := true
#func _process(delta):
	#if can_move:
		# add like the movement shit here ??? 

#func _ready():
	#if DialogueManager:
		#DialogueManager.dialogue_started.connect(_on_dialogue_started)
		#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

#func _on_dialogue_started(_resource, _start_id):
	#can_move = false

#func _on_dialogue_ended():
	#can_move = true


func get_animation():
	
	if is_on_floor():
		fall_played = false
		if Input.is_action_just_released("jump"):
			anim.play("jump")
			squat_played = false
		elif squat_played:
			return
		elif is_holding:
			anim.play("squat")
			squat_played = true
		elif direction:
			anim.play("run")
		else: 
			anim.play("idle")
	else:
		squat_played = false
		if velocity.y >= 0 && !fall_played:
			anim.play("fall")
			fall_played = true
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

func get_x_movement():
	direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if is_holding or !direction:
			velocity.x = 0
		else:
			velocity.x = SPEED * direction
			current_direction = direction
	else:
		if velocity.x == 0:
			print("Wall bounce triggered")
			current_direction *= -1
		velocity.x = current_direction * SPEED

func get_jump_height(delta):
	if Input.is_action_just_pressed("jump"):
		#print("Spacebar is being held down")
		is_holding = true
		time_held = 0.0  # reset timer on press
	if is_holding:
		time_held += delta  # accumulate time while holdingx
	if Input.is_action_just_released("jump"):
		#anim.play("jump")
		is_holding = false
		in_air = true
		if time_held >= max_time_held:
			time_held = max_time_held
		jump_height = coefficient * time_held - min_jump_height
		#print("JUMP_HEIGHT IS: ", jump_height)
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak)
		#print("JUMP_VELOCITY IS: ", jump_velocity)
		#print("Space was held for ", time_held, " seconds")

func move_camera_to_match_player(): 
	#print("camera_limit_lower: ", camera_limit_lower, " | camera_limit_upper: ", camera_limit_upper)
	if position.y < camera_limit_upper:
		print(position.y)
		camera_limit_lower -= camera_height
		camera_limit_upper -= camera_height
		print("camera_limit_lower: ", camera_limit_lower, " | camera_limit_upper: ", camera_limit_upper)
		change_camera_pos.emit(-camera_height)
	
	elif position.y > camera_limit_lower:
		camera_limit_lower += camera_height
		camera_limit_upper += camera_height
		print("camera_limit_lower: ", camera_limit_lower, " | camera_limit_upper: ", camera_limit_upper)
		change_camera_pos.emit(+camera_height)
		
func _physics_process(delta: float) -> void:
	get_animation()
	if velocity.y > 600:
		velocity.y = 600
	# Add the gravity.
	if not is_on_floor():
		velocity += modified_get_gravity() * delta
	
	get_x_movement()
	
	# Handle jump.
	get_jump_height(delta)
	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = jump_velocity
		velocity.x = SPEED * current_direction
		#anim.play("jump")
		#print("velocity.x = ", velocity.x)
	

	move_camera_to_match_player()
	move_and_slide()


func _on_change_camera_pos() -> void:
	pass # Replace with function body.
