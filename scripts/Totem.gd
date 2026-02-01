extends CharacterBody2D
	
func _physics_process(delta):
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body := collision.get_collider()
		if body.is_in_group("Enemy"):
			print("Choqué con el Enemy")
