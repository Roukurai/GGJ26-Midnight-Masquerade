class_name Player extends CharacterBody2D

const SPEED = 150
@export var acceleration = 1
@export var player_data: Dictionary[String,Variant] = {
	"name" = "Player",
	"attack_damage" = 1,
	"health" = 10
}

#region BUILT-IN
func _ready():
	pass
	
func _physics_process(delta):
	_player_movement(delta)
#endregion BUILT-IN
#region PUBLIC_FUNCTIONS
func get_player_data() -> Dictionary[String,Variant]:
	return player_data

#endregion PUBLIC_FUNCTIONS
#region PRIVATE_FUNCTIONS
@warning_ignore("unused_parameter")
func _player_movement(delta):
	var axis_input = Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_up","ui_down"))
	var calculatedSpeed = SPEED * acceleration
	var testAxis =axis_input.normalized()
	var testVelocity = axis_input.normalized() * calculatedSpeed
	velocity = axis_input.normalized() * calculatedSpeed
	move_and_slide()

func _attack():
	var currAttack = player_data["attack"]
	print(currAttack)
#endregion PRIVATE_FUNCTIONS
