extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

@onready var interact_label = $InteractLabel
@onready var interaction_area = $InteractionArea

var has_interacted := false

func _ready():
	interact_label.visible = false
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is PlayerCat and not has_interacted:
		interact_label.visible = true

func _on_body_exited(body):
	if body is PlayerCat:
		interact_label.visible = false
		has_interacted = false  # Reset so it can show again next time
