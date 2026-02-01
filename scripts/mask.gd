extends Area2D
class_name MaskPickup

@onready var sprite: Sprite2D = $Sprite2D

# CHANGE / ADD MASKS HERE ONLY
const MASKS := [
	{
		"id": "white",
		"region": Rect2(35, 0, 32, 32),
		"projectile_type": "neutral",
		"damage": 1,
		"fire_rate": 0.25,
		"projectile_speed": 300,
		"sprite_index": 0,
		"effect": "NONE"
	},
	{
		"id": "fire",
		"region": Rect2(0, 79, 32, 32),
		"projectile_type": "fire",
		"damage": 2,
		"fire_rate": 0.3,
		"projectile_speed": 350,
		"sprite_index": 1,
		"effect": "DOT"
	},
	{
		"id": "ice",
		"region": Rect2(35, 79, 32, 32),
		"projectile_type": "ice",
		"damage": 1,
		"fire_rate": 0.35,
		"projectile_speed": 400,
		"sprite_index": 2,
		"effect": "SLOW"
	}
]

var mask_data: Dictionary

func _ready() -> void:
	mask_data = MASKS.pick_random()

	sprite.region_enabled = true
	sprite.region_rect = mask_data.region

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.equip_mask(mask_data)
		queue_free()
