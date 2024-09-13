class_name ShootController
extends Node2D

signal get_guns
@export var my_bullet: PackedScene
@export var my_muzzle: PackedScene
@export var muzzle_color: Color
var can_shoot: bool
var guns: Array[Marker2D]


func _init():
	can_shoot = true


func _ready():
	get_guns.emit()


func _physics_process(_delta):
	if check_if_can_shoot():
		manage_shoot()


#Gambiarra: só funciona para números pares de armas
func manage_shoot():
	var len_guns = len(guns)
	for gun_index in range(len_guns):
		shoot(guns[gun_index], gun_index*2/len_guns)
	$ShotCooldown.start()
	can_shoot = false


func stop_shooting():
	$ShotCooldown.stop()
	can_shoot = false


func shoot(gun, side):
	var bullet := my_bullet.instantiate() as Bullet
	bullet.position = gun.global_position
	bullet.side = side
	get_tree().current_scene.add_child(bullet)
	var muzzle_flash := my_muzzle.instantiate() as MuzzleParticle
	muzzle_flash.position = gun.global_position
	muzzle_flash.color = muzzle_color
	get_tree().current_scene.add_child(muzzle_flash)


func set_guns(_guns: Array[Marker2D]):
	guns = _guns


func _on_shot_cooldown_timeout():
	can_shoot = true


func check_if_can_shoot():
	return can_shoot
