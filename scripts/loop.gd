extends Node2D

const PLAYER: PackedScene = preload('res://scenes/player.tscn')
var TOTEM: Node2D


func _ready() -> void:
	TOTEM = get_tree().get_first_node_in_group("Totem")
	var radius := 100.0  # pixels around the totem
	var offset := Vector2(
	randf_range(-radius, radius),
	randf_range(-radius, radius)
	)
	var player = PLAYER.instantiate()
	player.global_position = TOTEM.global_position + offset
	add_child(player)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
