extends Node
class_name MusicController

@export var fade_time := 0.3

@onready var map_base := $Map_Back

@onready var bass_1: AudioStreamPlayer = $Bass_1
@onready var bass_2: AudioStreamPlayer = $Bass_2

@onready var map_layers: Array[AudioStreamPlayer] = [
	$Drum_1,
	$Drum_2,
	$Drum_3
]

@onready var enemy_layers := [
	$Enemy_Lyr1,
	$Enemy_Lyr2,
	$Enemy_Lyr3,
	$Enemy_Lyr4
]

var current_enemy_layer := 0

func fade_in(player: AudioStreamPlayer):
	player.play()
	player.volume_db = -80
	create_tween().tween_property(
		player,
		"volume_db",
		0,
		fade_time
	)

func fade_out(player: AudioStreamPlayer):
	create_tween() \
		.tween_property(player, "volume_db", -80, fade_time) \
		.finished.connect(func(): player.stop())

func enter_map():
	# Interlude ambience (no enemies)
	fade_in(map_base)

	# Player movement layers (always valid while alive)
	fade_in(bass_1)

	# Bass 2 is sporadic
	if randi() % 2 == 0:
		fade_in(bass_2)
	else:
		fade_out(bass_2)

	# Drums are random
	for layer in map_layers:
		if randi() % 2 == 0:
			fade_in(layer)
		else:
			fade_out(layer)

func enemies_appear():
	# Interlude ambience stops when enemies appear
	fade_out(map_base)

	# Start enemy music layers
	for layer in enemy_layers:
		fade_out(layer) # safety reset
		layer.volume_db = -80

	current_enemy_layer = 0
	play_next_enemy_layer()

func play_next_enemy_layer():
	if enemy_layers.is_empty():
		return

	# Fade out currently playing enemy layers
	for l in enemy_layers:
		if l.playing:
			fade_out(l)

	# Loop index
	if current_enemy_layer >= enemy_layers.size():
		current_enemy_layer = 0

	var layer: AudioStreamPlayer = enemy_layers[current_enemy_layer]
	print("[MUSIC] Playing enemy layer:", layer.name)

	fade_in(layer)

func enemy_next_layer():
	current_enemy_layer += 1
	play_next_enemy_layer()

func enemies_defeated():
	# Stop enemy layers
	for layer in enemy_layers:
		if layer.playing:
			fade_out(layer)

	# Return to interlude
	await get_tree().create_timer(fade_time).timeout
	enter_map()


func _ready():
	print("[MUSIC TEST] Controller ready")
	run_test_gameplay_loop()

func run_test_gameplay_loop() -> void:
	# Game start - enter exploration phase (interlude)
	print("[MUSIC TEST] Game start - entering exploration phase")
	enter_map()
	
	# Exploration phase - 10 seconds
	print("[MUSIC TEST] Exploration phase - waiting 10s")
	await get_tree().create_timer(10.0).timeout
	
	# Initiate wave - enemies appear
	print("[MUSIC TEST] Wave starts - enemies appear")
	enemies_appear()

	# Enemy Layer 1 plays (started by enemies_appear)
	print("[MUSIC TEST] Enemy Layer 1 playing - waiting 10s")
	await get_tree().create_timer(10.0).timeout

	# Advance through remaining enemy layers (Lyr2, Lyr3, Lyr4)
	for i in range(enemy_layers.size() - 1):
		print("[MUSIC TEST] Advancing to enemy layer ", current_enemy_layer + 2)
		enemy_next_layer()
		print("[MUSIC TEST] Waiting 10s")
		await get_tree().create_timer(10.0).timeout

	print("[MUSIC TEST] Wave defeated - returning to interlude")
	enemies_defeated()
