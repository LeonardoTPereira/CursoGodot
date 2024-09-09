extends Control

var player: Player
var enemy: Enemy
var score_value: Label
var health_value: Label

func _ready():
	player = get_tree().get_root().get_node("Main/Player")
	enemy = get_tree().get_root().get_node("Main/Enemy")
	player.get_node("HealthController").health_changed.connect(update_health)
	enemy.defeated.connect(update_score)
	score_value = $UIContainer/UIVBoxContainer/ScoreContainer/ScoreValue
	score_value.text = '0'
	health_value = $UIContainer/UIVBoxContainer/HPContainer/HPValue


func update_health(health):
	health_value.text = str(health)

func update_score(score):
	score_value.text = str(int(score_value.text)+score)
