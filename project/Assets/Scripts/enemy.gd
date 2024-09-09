class_name Enemy
extends CharacterBody2D

signal defeated
var health_controller: HealthController
var shoot_controller: ShootController
@export var score: int

func _physics_process(_delta):
	velocity = $MovementController.get_velocity()
	move_and_slide()


func _ready():
	shoot_controller = $ShootController
	health_controller = $HealthController


func hit(damage):
	health_controller.hit(damage)


func _on_health_controller_get_sprite():
	$HealthController.set_sprite($Sprite2D)


func _on_health_controller_kill_parent():
	queue_free()


func _on_shoot_controller_get_guns():
	var guns : Array[Marker2D] = [$LeftGun, $RightGun]
	$ShootController.set_guns(guns)


func _on_health_controller_get_material():
	material = material.duplicate()
	$HealthController.set_my_material(material)


func _on_health_controller_disable_node():
	defeated.emit(score)
	$CollisionPolygon2D.set_deferred("disabled", true)
	shoot_controller.stop_shooting()
