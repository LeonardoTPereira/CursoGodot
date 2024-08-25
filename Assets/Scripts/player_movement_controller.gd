extends MovementController

var movement := Vector2.ZERO


func _physics_process(_delta):
	movement = Vector2.ZERO
	if Input.is_action_pressed("Up"):
		movement.y = -1
	if Input.is_action_pressed("Down"):
		movement.y = 1
	if Input.is_action_pressed("Left"):
		movement.x = -1
	if Input.is_action_pressed("Right"):
		movement.x = 1


func get_velocity() -> Vector2:
	return movement.normalized() * speed
