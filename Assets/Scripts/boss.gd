class_name Boss
extends CharacterBody2D

signal defeated

enum CurrentAttack {
    IDLE,
    PATROL,
    CHARGE,
    ANGRY,
}

const ATTACK_THRESHOLD = 1
const ANGRY_THRESHOLD = 0.5
const NORMAL_ATTACKS = ['charge', 'patrol']
const ANGRY_ATTACKS = ['charge', 'patrol', 'angry']
const EPSILON = 2

@export var score: int
@export var max_horizontal_range: int
@export var max_vertical_range: int
@export var move_speed:= Vector2(0, 300)

var _idle_count := 0
var _came_back_to_center_counter := 0
var _attack_set := NORMAL_ATTACKS
var _current_speed := Vector2(0, 0)

@onready var _anim_tree := $AnimationTree
@onready var _health_controller := $HealthController
@onready var _current_attack := CurrentAttack.IDLE
@onready var _initial_pos := position

func increase_idle_count():
    _idle_count += 1
    print("Idle count updated: "+str(_idle_count))
    if _idle_count > ATTACK_THRESHOLD:
        _idle_count = 0
        _attack()

func _ready():
    randomize()

func _physics_process(delta):
    match _current_attack:
        CurrentAttack.IDLE:
            _idle_process()
        CurrentAttack.CHARGE:
            _charge_process(delta)
        CurrentAttack.PATROL:
            _patrol_process(delta)
        CurrentAttack.ANGRY:
            _angry_process(delta)
        _:
            print('Unknow boss state')

func _idle_process():
    pass

func _charge_process(delta):
    position -= delta*_current_speed
    await get_tree().process_frame
    if absf(position.y - _initial_pos.y) >= max_vertical_range:
        _current_speed.y *= -1
    if absf(position.y - _initial_pos.y) <= EPSILON:
        _return_to_idle()

func _patrol_process(delta):
    position -= delta*_current_speed
    await get_tree().process_frame
    if absf(position.x - _initial_pos.x) >= max_horizontal_range:
        _current_speed.x *= -1
    if absf(position.x - _initial_pos.x) <= EPSILON:
        _came_back_to_center_counter += 1
        if _came_back_to_center_counter >= 2:
            _return_to_idle()

func _angry_process(delta):
    position -= delta*_current_speed
    await get_tree().process_frame
    if absf(position.y - _initial_pos.y) >= max_vertical_range:
        _current_speed.y *= -1
    if absf(position.y - _initial_pos.y) <= EPSILON:
        _return_to_idle()

func _return_to_idle():
    _anim_tree.set_condition('charge', false)
    _anim_tree.set_condition('patrol', false)
    _anim_tree.set_condition('angry', false)
    _anim_tree.set_condition('idle', true)
    _current_attack = CurrentAttack.IDLE


func _attack():
    print('Attacking')
    _came_back_to_center_counter = 0
    var attack_index = randi()%_attack_set.size()
    var cur_attack = _attack_set[attack_index]
    _current_attack = attack_index+1 as CurrentAttack
    print('Current attack: ' + str(_current_attack))
    _start_attack()
    _anim_tree.set_condition(cur_attack, true)


func _start_attack():
    match _current_attack:
        CurrentAttack.IDLE:
            _current_speed.x = 0
            _current_speed.y = 0
        CurrentAttack.CHARGE:
            _current_speed.x = 0
            _current_speed.y = move_speed.y
        CurrentAttack.PATROL:
            _current_speed.x = move_speed.x
            _current_speed.y = 0
        CurrentAttack.ANGRY:
            _current_speed.x = move_speed.x
            _current_speed.y = move_speed.y
        _:
            print('Unknow boss state')

func hit(damage):
    _health_controller.hit(damage)
    if _health_controller.health < _health_controller.max_health * ANGRY_THRESHOLD:
        _attack_set = ANGRY_ATTACKS

func _on_health_controller_get_sprite():
    $HealthController.set_sprite($Sprite2D)

func _on_health_controller_kill_parent():
    queue_free()

func _on_health_controller_get_material():
    material = material.duplicate()
    $HealthController.set_my_material(material)


func _on_health_controller_disable_node():
    _anim_tree.set_condition("dead", true)
    defeated.emit(score)
    $CollisionPolygon2D.set_deferred("disabled", true)