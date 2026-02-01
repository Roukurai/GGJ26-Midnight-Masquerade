class_name Player
extends CharacterBody2D

const SPEED = 150

@export var acceleration := 1.0
@export var projectile_scene: PackedScene
@export var fire_rate := 0.25  # 4 shots/sec
@export var attack_range := 250.0
@export var enemy_group := "Enemy"

@onready var fire_timer: Timer = $FireTimer
@onready var mask_sprite: AnimatedSprite2D = $Mask

var _current_mask: Dictionary = {
	"damage": 10,
	"projectile_speed": 300.0,
	"effect": "NONE"
}

# =====================
# BUILT-IN
# =====================
func _ready():
	randomize() # VERY important
	fire_timer.wait_time = fire_rate
	fire_timer.timeout.connect(_attack)
	fire_timer.start()
	
	# Hide mask initially
	mask_sprite.visible = false

func _physics_process(delta):
	_player_movement(delta)

# =====================
# PUBLIC
# =====================
func equip_mask(mask_data: Dictionary) -> void:
	"""Equip a mask, updating fire rate and visual."""
	_current_mask = mask_data
	
	# Update fire rate
	fire_rate = mask_data.fire_rate
	fire_timer.wait_time = fire_rate
	
	# Update mask visual
	_update_mask_visual(mask_data)

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

	var target = _get_random_nearby_enemy()
	
	if target:
		projectile.direction = (target.global_position - global_position).normalized()
	else:
		projectile.direction = _random_direction()

	# Configure projectile with current mask data (once, at spawn)
	projectile.setup(_current_mask)

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

func _update_mask_visual(mask_data: Dictionary) -> void:
	if mask_data.is_empty():
		mask_sprite.visible = false
		return
	
	mask_sprite.visible = true
	
	# Animation names based on sprite_index (must match SpriteFrames order in player.tscn)
	var animation_names := ["BASIC", "FIRE", "ICE", "NONE"]
	var sprite_index: int = mask_data.sprite_index
	
	if sprite_index >= 0 and sprite_index < animation_names.size():
		mask_sprite.play(animation_names[sprite_index])
