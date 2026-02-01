extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/loop.tscn")


func _on_exit_button_up() -> void:
	get_tree().quit()


func _on_about_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/credit.tscn")
	pass # Replace with function body.
