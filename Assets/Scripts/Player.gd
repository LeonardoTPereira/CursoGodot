class_name Player
extends CharacterBody2D

@export var my_bullet: PackedScene
@export var speed: float = 300
var can_shoot: bool
var sprite: Sprite2D
var sprite_rect: Rect2
var left_gun: Marker2D
var right_gun: Marker2D

func _init():
	can_shoot = true


func _ready():
	sprite = $Sprite2D
	sprite_rect = sprite.get_rect()
	left_gun = $LeftGun
	right_gun = $RightGun


func _physics_process(_delta):
	get_movement_input_and_update_velocity()
	move_and_slide()
	get_shoot_input_and_shoot()
	check_bounds_and_clamp_position()


func get_movement_input_and_update_velocity():
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


func get_shoot_input_and_shoot():
	if Input.is_action_pressed("Shoot") and can_shoot:
		shoot(left_gun)
		shoot(right_gun)
		$ShotCooldown.start()
		can_shoot = false


func shoot(gun):
	var bullet := my_bullet.instantiate() as Bullet
	bullet.position = gun.global_position
	get_tree().current_scene.add_child(bullet)


func check_bounds_and_clamp_position():
	global_position.x = clamp(global_position.x, 0 + sprite_rect.size.x/2,
		get_viewport().get_visible_rect().size.x-sprite_rect.size.x/2)
	global_position.y = clamp(global_position.y, 0 + sprite_rect.size.y/2,
		get_viewport().get_visible_rect().size.y - sprite_rect.size.y/2)


func _on_shot_cooldown_timeout():
	can_shoot = true