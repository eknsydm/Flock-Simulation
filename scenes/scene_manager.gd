extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		BoidSpawner.spawn_boid(get_global_mouse_position())
	if Input.is_action_just_pressed("predator"):
		BoidSpawner.spawn_predator(get_global_mouse_position())
			
