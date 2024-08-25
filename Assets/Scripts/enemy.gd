class_name Enemy
extends CharacterBody2D


@export var my_bullet: PackedScene
var left_gun: Marker2D
var right_gun: Marker2D
var health_controller: LivingUnit


func _ready():
	left_gun = $LeftGun
	right_gun = $RightGun
	health_controller = $HealthController


func hit(damage):
	health_controller.hit(damage)


func shoot(gun):
	var bullet := my_bullet.instantiate() as Bullet
	bullet.position = gun.global_position
	get_tree().current_scene.add_child(bullet)


func _on_shot_cooldown_timeout():
	shoot(left_gun)
	shoot(right_gun)
	$ShotCooldown.start()

func _on_health_controller_get_sprite():
	$HealthController.set_sprite($Sprite2D)


func _on_health_controller_kill_parent():
	queue_free()
