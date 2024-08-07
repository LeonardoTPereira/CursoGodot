class_name Player
extends CharacterBody2D

@export var speed: float = 300
var sprite: Sprite2D
var sprite_rect: Rect2

func _ready():
	sprite = $Sprite2D
	sprite_rect = sprite.get_rect()


func _physics_process(_delta):
	var movement := Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		movement.y = -1
	if Input.is_action_pressed("Down"):
		movement.y = 1
	if Input.is_action_pressed("Left"):
		movement.x = -1
	if Input.is_action_pressed("Right"):
		movement.x = 1

	movement = movement.normalized()
	velocity = movement*speed

	move_and_slide()
	
	global_position.x = clamp(global_position.x, 0 + sprite_rect.size.x/2,
			get_viewport().get_visible_rect().size.x-sprite_rect.size.x/2)
	global_position.y = clamp(global_position.y, 0 + sprite_rect.size.y/2, 
			get_viewport().get_visible_rect().size.y - sprite_rect.size.y/2)
