class_name Player
extends CharacterBody2D

const SPEED = 150

@export var acceleration := 1.0
@export var projectile_scene: PackedScene
@export var fire_rate := 0.25  # 4 shots/sec
@export var attack_range := 250.0
@export var enemy_group := "Enemy"
@export var iFrames_duration := 1.0

@export var player_data := {
	"name": "Player",
	"attack_damage": 1,
	"health": 10,
	"mask_type": ProjectileType.BASIC
}

@onready var fire_timer: Timer = $FireTimer
enum ProjectileType {
	BASIC,
	FIRE,
	ICE,
	LIGHTNING,
	POISON
}
enum EffectType {
	NONE,
	DOT,
	SLOW,
	STUN,
	CONFUSION
}


var projectile_data: Dictionary = {
	ProjectileType.BASIC: {
		"damage": 1,
		"effect": EffectType.NONE
	},
	ProjectileType.FIRE: {
		"damage": 2,
		"effect": EffectType.DOT
	},
	ProjectileType.ICE: {
		"damage": 1,
		"effect": EffectType.SLOW
	},
	ProjectileType.LIGHTNING: {
		"damage": 3,
		"effect": EffectType.STUN
	},	
	ProjectileType.POISON: {
		"damage": 1,
		"effect": EffectType.CONFUSION
	}
}
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
		push_warning("Player: projectile_scene is null!")
		return

	var projectile := projectile_scene.instantiate()
	
	# Add to tree FIRST, then set position as local coordinates
	# This avoids the global_position -> local conversion bug in add_child()
	add_child(projectile)
	
	# Set position as local coordinates relative to player (at origin = same as player position)
	projectile.position = Vector2.ZERO

	# DEBUG: Log enemy detection status
	var all_enemies := get_tree().get_nodes_in_group(enemy_group)
	
	var target = _get_random_nearby_enemy()
	
	if target:
		projectile.direction = (target.global_position - global_position).normalized()
	else:
		projectile.direction = _random_direction()

func _get_random_nearby_enemy():
	var nearby_enemies := []
	var all_group_enemies := get_tree().get_nodes_in_group(enemy_group)
	
	for enemy in all_group_enemies:
		# Skip invalid enemies (queued for deletion)
		if not is_instance_valid(enemy):
			continue

		var dist := global_position.distance_to(enemy.global_position)

		if dist <= attack_range:
			nearby_enemies.append(enemy)

	if nearby_enemies.is_empty():
		return null

	return nearby_enemies[randi() % nearby_enemies.size()]

func _random_direction() -> Vector2:
	var angle := randf_range(0.0, TAU)
	return Vector2(cos(angle), sin(angle))
