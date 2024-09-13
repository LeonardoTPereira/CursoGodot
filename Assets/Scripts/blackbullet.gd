class_name BlackBullet
extends Bullet

@export var max_horizontal_range: int
@export var direction_cooldown: float
var initial_pos: Vector2

func _enter_tree():
	super()
	initial_pos = position
	

func _physics_process(delta):
	if absf(position.x - initial_pos.x) >= max_horizontal_range:
		speed.x *= -1
	super(delta)
