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

var is_holding : bool = false
var in_air: bool = false
var time_held : float
var direction = Input.get_axis("ui_left", "ui_right")
var current_direction : float = 1


func modified_get_gravity() -> Vector2:
	if velocity.y < 0:
		return Vector2(0, jump_gravity)
	else:
		return Vector2(0, fall_gravity)

func get_animation():
	if is_on_floor():
		if is_holding:
			anim.play("charge")
		elif direction:
			anim.play("run")
		else: 
			anim.play("idle")
	else:
		anim.play("jump")
	
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
		is_holding = false
		in_air = true
		if time_held >= max_time_held:
			time_held = max_time_held
		jump_height = coefficient * time_held - min_jump_height
		#print("JUMP_HEIGHT IS: ", jump_height)
		jump_velocity = ((2.0 * jump_height) / jump_time_to_peak)
		#print("JUMP_VELOCITY IS: ", jump_velocity)
		#print("Space was held for ", time_held, " seconds")

func _physics_process(delta: float) -> void:

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
		print("velocity.x = ", velocity.x)
	
	get_animation()
	
	move_and_slide()
