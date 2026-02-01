extends Area2D

## The type of mask this pickup grants. Uses Player.ProjectileType enum.
@export var mask_type: Player.ProjectileType = Player.ProjectileType.BASIC


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Called when a physics body enters this Area2D's collision shape.
func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.player_data["mask_type"] = mask_type
		print("DEBUG: Player picked up mask type: ", mask_type)
		queue_free()  # Remove mask after pickup
