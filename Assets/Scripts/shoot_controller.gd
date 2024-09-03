class_name ShootController
extends Node2D

signal get_guns
@export var my_bullet: PackedScene
@export var my_muzzle: PackedScene
var can_shoot: bool
var guns: Array[Marker2D]


func _init():
	can_shoot = true


func _ready():
	get_guns.emit()


func _physics_process(_delta):
	if check_if_can_shoot():
		manage_shoot()


func manage_shoot():
	for gun in guns:
		shoot(gun)
	$ShotCooldown.start()
	can_shoot = false


func stop_shooting():
	$ShotCooldown.stop()
	can_shoot = false


func shoot(gun):
	var bullet := my_bullet.instantiate() as Bullet
	bullet.position = gun.global_position
	get_tree().current_scene.add_child(bullet)
	var muzzle_flash := my_muzzle.instantiate() as MuzzleParticle
	muzzle_flash.position = gun.global_position
	get_tree().current_scene.add_child(muzzle_flash)


func set_guns(_guns: Array[Marker2D]):
	guns = _guns


func _on_shot_cooldown_timeout():
	can_shoot = true


func check_if_can_shoot():
	return can_shoot
