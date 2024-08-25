class_name MovementController
extends Node

@export var speed:= Vector2(0, 300)

func get_velocity() -> Vector2:
	return speed