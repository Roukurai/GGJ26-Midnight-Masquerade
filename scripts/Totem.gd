extends Area2D 

@export var totemLife := 200
var damaged
var world

func _ready():
	world = get_tree().get_first_node_in_group("world")
	print(world)
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node):
	# Basic enemy check (duck typing)
	if body.has_method("take_damage"):		
		body.instant_kill()
		reduceLife(body.damage)
		
func reduceLife(life: int):
	if totemLife > 0:
		totemLife -= life
		print("life: ", totemLife)	
	elif totemLife <= 0:
		if world and world.has_method("_end_game"):
			world._end_game()
