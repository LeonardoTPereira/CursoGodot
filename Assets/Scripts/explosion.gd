class_name ExplosionParticle
extends CPUParticles2D


func _ready():
	emitting = true


func _process(_delta):
	if emitting == false:
		queue_free()
