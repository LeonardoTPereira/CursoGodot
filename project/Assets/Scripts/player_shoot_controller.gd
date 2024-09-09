extends ShootController


func check_if_can_shoot():
	return Input.is_action_pressed("Shoot") and can_shoot
