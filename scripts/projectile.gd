class_name Projectile
extends Area2D

# =====================
# CONFIGURATION
# =====================
@export var speed: float = 450.0
@export var damage: int = 1
@export var lifetime: float = 3.0        # seconds

# =====================
# STATE
# =====================
var direction: Vector2 = Vector2.ZERO
var _time_alive: float = 0.0

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
	if _time_alive >= lifetime:
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
