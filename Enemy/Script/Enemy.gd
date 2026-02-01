extends CharacterBody2D

@export var speed := 100.0
@export var attack_distance := 40.0
@export var attack_cooldown := 1.0
@export var health := 100
@export var animated : AnimatedSprite2D

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
		var collision = get_slide_collision(i)
		var body := collision.get_collider()
		#var other = collision.get_collider()
		if body.is_in_group("player"):
			print("Choqué con el player")
			collition_body(collision)
			
		elif body.is_in_group("Defend"):
			print("Choqué con el totem")
			collition_totem(collision)
			
		

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
		speed = 0
		set_deferred("disable", true)
		#animacion muerte
		print("Muerto")
		animated.play("Death_S")
		await get_tree().create_timer(0.6).timeout
		queue_free()
		
	print(health)
	pass

func collition_body(body: KinematicCollision2D):	
	print(body)
	
func collition_totem(body: KinematicCollision2D):	
	print("muerto por totem")
	take_damage(health)
	print(body)
