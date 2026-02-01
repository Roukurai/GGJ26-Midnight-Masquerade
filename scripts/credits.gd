extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(15).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.

func _on_main_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	pass # Replace with function body.
