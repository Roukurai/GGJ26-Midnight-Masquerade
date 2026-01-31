extends CharacterBody2D

var speed = 20

var vel = Vector2.ZERO

@onready var _animation_player = $AnimationPlayer

func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		_animation_player.play("walk")
	else:
		_animation_player.stop()
