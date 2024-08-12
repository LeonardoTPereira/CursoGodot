class_name Bullet
extends Area2D

@export var speed:= Vector2(0, 300)
@export var damage:= 1


func _physics_process(delta):
	position -= delta*speed


func _on_despawn_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if is_valid_hit(body):
		body.hit(damage)


func is_valid_hit(body) -> bool:
	if body.is_in_group("Player") and is_in_group("EnemyBullet"):
		return true
	if body.is_in_group("Enemy") and is_in_group("PlayerBullet"):
		return true
	return false