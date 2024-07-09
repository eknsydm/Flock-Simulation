class_name Boid
extends Area2D

var velocity := Vector2.UP
var acceleration := Vector2.ZERO
var max_force := 1
var boids : Array[Boid]
var screensize

@export var cohesion_force: = 0.05
@export var algin_force: = 0.05
@export var separation_force: = 0.05

@export var avoid_distance :float = 20.0
@export var view_distance :float = 50.0

@export var max_speed :float = 8


func _ready() -> void:
	velocity = velocity.rotated(PI * randi())
	screensize = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	var acceleration = get_acceleration()
	
	velocity = (velocity + acceleration).limit_length(max_speed)
	position += velocity
	#rotation = lerp_angle(rotation, Vector2.ZERO.angle_to_point(velocity), 0.8)
	edges()

func edges():
	if global_position.x < 0:
		global_position.x = screensize.x
	if global_position.x > screensize.x:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screensize.y
	if global_position.y > screensize.y:
		global_position.y = 0

func get_flock_status(flock: Array[Boid]) -> Array[Vector2]:
	var center_vector:Vector2
	var flock_center:Vector2
	var align_vector: Vector2
	var avoid_vector: Vector2
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position

		align_vector += f.velocity
		flock_center += neighbor_pos

		var d = global_position.distance_to(neighbor_pos)
		#!
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (avoid_distance / d * max_speed)
		#!

	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_position.direction_to(flock_center)
		var center_speed = (max_speed * 
			(global_position.distance_to(flock_center) / 
			view_distance))
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]


func get_acceleration():
	var flock_status = get_flock_status(boids)
	
	var cohesion_vector = flock_status[0] * cohesion_force
	var align_vector = flock_status[1] * algin_force
	var separation_vector = flock_status[2] * separation_force

	return cohesion_vector + align_vector + separation_vector #+ mouse_vector


func _on_vision_area_entered(area: Area2D) -> void:
	if area is Boid and area != self:
		boids.append(area)

func _on_vision_area_exited(area: Area2D) -> void:
	if area is Boid:
		boids.erase(area)
