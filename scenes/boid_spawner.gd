extends Node2D

@export var num := 100
@export var margin := 100

@onready var boid_scene = preload("res://scenes/boid.tscn")

var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	randomize()
	for i in num:
		spawn_boid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_boid():
	var boid :Area2D = boid_scene.instantiate()
	add_child(boid)
	boid.modulate = Color(randf(),randf(),randf())
	boid.global_position = Vector2( 
		(randf_range(0 + margin, screen_size.x - margin)),
		(randf_range(0 + margin, screen_size.y - margin)))
	print(boid.global_position)
