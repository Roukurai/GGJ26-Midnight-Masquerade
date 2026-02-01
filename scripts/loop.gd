extends Node2D

const PLAYER: PackedScene = preload('res://scenes/player.tscn')
var TOTEM: Node2D
@export var music: MusicController

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
	music.enter_map()


	
func on_wave_started():
	music.enemies_appear()

func on_wave_escalation():
	music.enemy_next_layer()

func on_wave_cleared():
	music.enemies_defeated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
