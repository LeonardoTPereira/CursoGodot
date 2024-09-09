class_name Player
extends CharacterBody2D

var sprite: Sprite2D
var sprite_rect: Rect2
var health_controller: HealthController


func _ready():
	sprite = $Sprite2D
	sprite_rect = sprite.get_rect()
	health_controller = $HealthController


func hit(damage):
	health_controller.hit(damage)


func _physics_process(_delta):
	velocity = $MovementController.get_velocity()
	move_and_slide()
	check_bounds_and_clamp_position()


func check_bounds_and_clamp_position():
	global_position.x = clamp(global_position.x, 0 + sprite_rect.size.x/2,
		get_viewport().get_visible_rect().size.x-sprite_rect.size.x/2)
	global_position.y = clamp(global_position.y, 0 + sprite_rect.size.y/2,
		get_viewport().get_visible_rect().size.y - sprite_rect.size.y/2)


func _on_health_controller_get_sprite():
	$HealthController.set_sprite($Sprite2D)


func _on_shoot_controller_get_guns():
	var guns : Array[Marker2D] = [$LeftGun, $RightGun]
	$ShootController.set_guns(guns)


func _on_health_controller_kill_parent():
	queue_free()
