
class_name Projectile
extends Area2D

# =====================
# CONFIGURATION (set via setup())
# =====================
var speed: float = 300.0
var damage: int = 1
var effect: String = "NONE"

# =====================
# STATE
# =====================
var direction: Vector2 = Vector2.ZERO
var _time_alive: float = 0.0

# =====================
# PUBLIC
# =====================
func setup(mask_data: Dictionary) -> void:
	"""Configure projectile once at spawn from Dictionary. Never called again."""
	var projectile_speed: float = mask_data.projectile_speed
	var dmg: int = mask_data.damage
	var eff: String = mask_data.effect
	
	speed = projectile_speed
	damage = dmg
	effect = eff

# =====================
# BUILT-IN
# =====================
func _ready():
	# Safety: normalize direction in case caller forgot
	if direction.length() == 0:
		direction = Vector2.RIGHT
	else:
		direction = direction.normalized()

	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Move
	self.position += direction * speed * delta

	# Lifetime handling
	_time_alive += delta
	if _time_alive >= 3.0:
		queue_free()

# =====================
# COLLISION
# =====================
func _on_body_entered(body: Node):
	# Basic enemy check (duck typing)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
	# Projectile destroyed on impact
	queue_free()
