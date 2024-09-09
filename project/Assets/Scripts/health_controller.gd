class_name HealthController
extends Node2D

signal healthChanged
signal get_sprite
signal get_material
signal kill_parent
signal disable_node
@export var health: int = 1
@export var explosion_particle: PackedScene
var sprite: Sprite2D


func set_sprite(_sprite: Sprite2D):
	sprite = _sprite


func set_my_material(_material: Material):
	material = _material


func _ready():
	get_material.emit()
	get_sprite.emit()
	await get_tree().process_frame
	healthChanged.emit(health)

func hit(damage):
	health = max(health-damage, 0)
	healthChanged.emit(health)
	if health == 0:
		start_death()
		return
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE


func set_percent(percentage: float) -> void:
	material.set_shader_parameter('percentage', percentage)


func burn():
	var texture = NoiseTexture2D.new()
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.frequency = 0.032
	texture.noise = noise
	await texture.changed
	material.set_shader_parameter("burn_texture", texture)
	var tween = create_tween()
	tween.tween_method(set_percent, 1.0, 0.0, 0.5)
	tween.tween_callback(die)


func explode():
	var explosion = explosion_particle.instantiate() as ExplosionParticle
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)


func start_death():
	disable_node.emit()
	await get_tree().process_frame
	explode()
	burn()


func die():
	kill_parent.emit()
