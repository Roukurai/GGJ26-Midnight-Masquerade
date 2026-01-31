extends CharacterBody2D

var speed = 20

var vel = Vector2.ZERO

enum {
	SURROUND,
	ATTACK,
	HIT,
	DEATH,
}

var state = SURROUND

func _physics_process(delta):
	match state:
		SURROUND:
			pass

func  move(target, delta):
	var dir = (target - global_position).normalized()
	var desired_vel = dir * speed
	var steering = (desired_vel - vel) * delta * 2.5
	vel += steering
	vel = move_and_slide()
 
@onready var _animation_player = $AnimationPlayer
