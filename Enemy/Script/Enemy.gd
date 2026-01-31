extends Node

@export var speed := 100.0
var enemyType
var targets: Node2D

func set_enemy_type(type):
	enemyType = type
	apply_stats()
	print(type)
	
func set_target(target: Node2D):
	targets = target

func apply_stats():
	match enemyType:
		0: # Tank
			speed = 50
		1: # Rouge
			speed = 100
		2: #Crow control
			speed = 75
			
func _physics_process(delta):
	if not targets:
		return
