extends Resource
class_name BoidSettings

@export var cohesion_force := 0.05
@export var align_force := 0.05
@export var separation_force := 0.05
@export var wall_force := 0.1
@export var run_force := 0.5
@export var avoid_distance :float = 20.0
@export var view_distance :float = 50.0

@export var max_speed :float = 3
@export var min_speed :float = 0.3
