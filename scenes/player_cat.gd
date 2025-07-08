extends CharacterBody2D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var anim = $AnimatedSprite2D
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

#if you want to change horizontal speed
const SPEED = 150.0

#var jump_velocity : float = -300.0

var is_holding : bool = false
var time_held : float
var current_direction : float
func get_jump_height(delta):
	if Input.is_action_just_pressed("jump"):
		print("Spacebar is being held down")
		is_holding = true
		time_held = 0.0  # reset timer on press
		#change jump velocity if u wanna change jump height
		jump_velocity = -300.0
	if is_holding:
		time_held += delta  # accumulate time while holding
	
	if Input.is_action_just_released("jump"):
		is_holding = false
	
		if time_held >= 2.5:
			time_held = 2.5
		jump_velocity = -80 * time_held - 300
		print("JUMP_VELOCITY IS: ", jump_velocity)
		print("Space was held for ", time_held, " seconds")


func _physics_process(delta: float) -> void:
	
	if velocity.y > 600:
		velocity.y = 600
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	get_jump_height(delta)
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0 && is_on_floor():
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
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()
