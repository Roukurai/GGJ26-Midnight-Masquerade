extends CharacterBody2D

@export var speed := 100.0
@export var attack_distance := 40.0
@export var attack_cooldown := 1.0

var enemyType
var targets: Node2D
var can_attack := true
var state: State = State.MOVE

enum State {
	MOVE,
	ATTACK,
}

func set_enemy_type(type: int):
	enemyType = type
	apply_stats()
	print(type)
	
func set_target(target: Node2D):
	targets = target
	print(target)

func apply_stats():
	match enemyType:
		0: # Tank
			speed = 50
		1: # Rouge
			speed = 100
		2: #Crow control
			speed = 75
			
func _physics_process(delta):
	
	var dist := global_position.distance_to(targets.global_position)
	
	move_towards_target()
	match State:
		State.MOVE:
			if dist >= attack_distance:
				enter_attack()
			else:
				pass
		State.ATTACK:
			if dist > attack_distance:
				state = State.MOVE
				
func move_towards_target():
	var dir := (targets.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

func enter_attack():
	state = State.ATTACK
	velocity = Vector2.ZERO

	if can_attack:
		attack()

func attack():
	can_attack = false
	print("Attack!")
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
