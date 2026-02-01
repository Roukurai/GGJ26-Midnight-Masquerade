extends Area2D 

@export var totemLife := 200
var damaged
var world

func _ready():
	world = get_tree().get_first_node_in_group("world")
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node):
	# Basic enemy check (duck typing)
	if body.has_method("take_damage"):		
		body.instant_kill()
		reduceLife(body.damage)
		
func reduceLife(life: int):
	totemLife -= life
	print("life: ", totemLife)
	
	if totemLife <= 0:
		print("perdiste!")
		#world.has_method("end_game")
