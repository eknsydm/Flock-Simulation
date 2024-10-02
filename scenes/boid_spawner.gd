extends Node2D

@export var num := 100
@export var margin := 100

@onready var boid_scene = preload("res://scenes/boid.tscn")
@onready var predator_scene = preload("res://scenes/boid_predator.tscn")

var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_boid(_position:Vector2 = Vector2.ZERO):
	var boid :Area2D = boid_scene.instantiate()
	add_child(boid)
	boid.modulate = Color.GREEN_YELLOW 
	if _position == Vector2.ZERO:
		boid.global_position = Vector2( 
			(randf_range(0 + margin, screen_size.x - margin)),
			(randf_range(0 + margin, screen_size.y - margin)))
	else:
		boid.global_position = _position

func spawn_predator(_position:Vector2 = Vector2.ZERO):
	var predator :Area2D = predator_scene.instantiate()
	add_child(predator)
	if _position == Vector2.ZERO:
		predator.global_position = Vector2( 
			(randf_range(0 + margin, screen_size.x - margin)),
			(randf_range(0 + margin, screen_size.y - margin)))
	else:
		predator.global_position = _position
