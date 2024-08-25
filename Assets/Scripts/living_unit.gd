class_name LivingUnit
extends Node2D

signal get_sprite
signal kill_parent
@export var health: int = 1
var sprite: Sprite2D


func set_sprite(_sprite: Sprite2D):
	sprite = _sprite


func _ready():
	get_sprite.emit()


func hit(damage):
	health = max(health-damage, 0)
	if health == 0:
		die()
		return


func die():
	kill_parent.emit()
