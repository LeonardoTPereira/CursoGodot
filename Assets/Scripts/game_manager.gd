class_name GameManager
extends Node2D

signal enemySpawned
@export var spawn_list: SpawnList
@export var spawner_list: Array[Marker2D]
var current_spawn_index: int
var total_spawners: int

func _init():
	current_spawn_index = 0
	
func _ready():
	total_spawners = spawner_list.size()




func _on_spawn_timer_timeout():
	# if current_spawn_index >= spawn_list.enemy_formation.size():
	# 	return
	var formation = spawn_list.enemy_formations[current_spawn_index]
	spawner_list.shuffle()
	var total_spawns = 0
	for enemy_type_index in range(formation.enemy_count.size()):
		for enemy_index in range(formation.enemy_count[enemy_type_index]):
			var enemy = formation.enemy_list[enemy_type_index]
			enemy = enemy.instantiate() as Enemy
			var spawner_position = spawner_list[total_spawns%total_spawners].position
			enemy.position = spawner_position
			add_child(enemy)
			enemySpawned.emit(enemy)
			total_spawns+=1
	current_spawn_index= (current_spawn_index+1)%spawn_list.enemy_formations.size()
	$SpawnTimer.start()

