extends CharacterBody2D

@export var max_time_held : float
@export var min_jump_height : float 
@export var max_jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float


@onready var anim = $AnimatedSprite2D
@onready var jump_height : float = min_jump_height
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
@onready var coefficient = (min_jump_height - max_jump_height)/max_time_held

#if you want to change horizontal speed
const SPEED = 150.0

#var jump_velocity : float = -300.0

var is_holding : bool = false
var time_held : float
var current_direction : float

func modified_get_gravity() -> Vector2:
	if velocity.y < 0:
		return Vector2(0, jump_gravity)
	else:
		return Vector2(0, fall_gravity)

func get_jump_height(delta):
	if Input.is_action_just_pressed("jump"):
		print("Spacebar is being held down")
		is_holding = true
		time_held = 0.0  # reset timer on press
	if is_holding:
		time_held += delta  # accumulate time while holding
	#print(coefficient)
	if Input.is_action_just_released("jump"):
		is_holding = false
		if time_held >= max_time_held:
			time_held = max_time_held
		jump_height = coefficient * time_held - min_jump_height
		print("JUMP_HEIGHT IS: ", jump_height)
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak)
		print("JUMP_VELOCITY IS: ", jump_velocity)
		print("Space was held for ", time_held, " seconds")


func _physics_process(delta: float) -> void:
	
	if velocity.y > 600:
		velocity.y = 600
	# Add the gravity.
	if not is_on_floor():
		velocity += modified_get_gravity() * delta

	# Handle jump.
	get_jump_height(delta)
	if Input.is_action_just_released("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")

	if is_holding:
		# Prevent movement input while charging jump
		anim.play("idle")
		direction = 0
		velocity.x = 0
	else:
		if direction != 0 and is_on_floor():
			current_direction = direction

		if direction and is_on_floor():
			anim.play("run")
			velocity.x = direction * SPEED
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, SPEED)
				anim.play("idle")
			else:
				velocity.x = current_direction * SPEED
				anim.play("jump")

	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction != 0 && is_on_floor():
	#	current_direction = direction
	#
	#if direction and is_on_floor():
	#	anim.play("run")
	#	velocity.x = direction * SPEED
	#else:
	#	if is_on_floor():
	#		velocity.x = move_toward(velocity.x, 0, SPEED)
	#		anim.play("idle")
	#	else:
	#		velocity.x = current_direction * SPEED
	#		anim.play("jump")
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()
