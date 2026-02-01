extends CharacterBody2D

@export var speed := 100.0
@export var attack_distance := 40.0
@export var attack_cooldown := 1.0
@export var health := 100

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
			health = 100
			speed = 25
		1: # Rouge
			health = 50
			speed = 100
		2: #Crow control
			health = 75
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
				
	for i in range(get_slide_collision_count()):
		#var collision = get_slide_collision(i)
		var collision = move_and_collide(velocity * delta)
		#var other = collision.get_collider()
		if collision:
			print("Choqué con un enemigo")
			collition_body(collision)

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

func take_damage(damage: int):
	if(damage > 0):
		health -= damage
		
	if(health <= 0):
		#animacion muerte
		print("Muerto")
		await get_tree().create_timer(attack_cooldown).timeout
		queue_free()
	pass
 


func collition_body(body: KinematicCollision2D):
	print(body)
