class_name Player
extends CharacterBody2D

const SPEED = 150

@export var acceleration := 1.0
@export var projectile_scene: PackedScene
@export var fire_rate := 0.25  # 4 shots/sec

@export var player_data := {
	"name": "Player",
	"attack_damage": 1,
	"health": 10
}

@onready var fire_timer: Timer = $FireTimer

# =====================
# BUILT-IN
# =====================
func _ready():
	randomize() # VERY important
	fire_timer.wait_time = fire_rate
	fire_timer.timeout.connect(_attack)
	fire_timer.start()

func _physics_process(delta):
	_player_movement(delta)

# =====================
# PRIVATE
# =====================
func _player_movement(delta):
	var axis := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	velocity = axis.normalized() * SPEED * acceleration
	move_and_slide()

func _attack():
	if projectile_scene == null:
		return

	var projectile := projectile_scene.instantiate()
	projectile.global_position = Vector2.ZERO
	projectile.direction = _random_direction()

	add_child(projectile)

func _random_direction() -> Vector2:
	var angle := randf_range(0.0, TAU)
	return Vector2(cos(angle), sin(angle))
