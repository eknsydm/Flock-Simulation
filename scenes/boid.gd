class_name Boid
extends Area2D

var velocity := Vector2.UP
var acceleration := Vector2.ZERO
var boids : Array[Boid]
var predators := []
var screensize
var in_wall := false

@onready var ray_folder: Node2D = $RayFolder
@onready var view_collision: CollisionShape2D = $Vision/CollisionShape2D

@export var settings: BoidSettings

func _ready() -> void:

	velocity = velocity.rotated(PI * randi())
	screensize = get_viewport_rect().size
	view_collision.shape.radius = settings.view_distance


func _physics_process(delta: float) -> void:
	
	rotation = Vector2(1, 0).angle_to(velocity)
	var acceleration = get_acceleration()
	
	velocity = (velocity + acceleration).limit_length(settings.max_speed)
	if velocity.length_squared() < settings.min_speed:
		velocity = velocity.normalized() * settings.max_speed

	position += velocity
	#rotation = lerp_angle(rotation, Vector2.ZERO.angle_to_point(velocity), 0.8)
	move_in_edges()


func move_in_edges():
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
		
		if d > 0 and d < settings.avoid_distance:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (settings.avoid_distance / d * settings.max_speed) 
		

	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = global_position.direction_to(flock_center)
		var center_speed = (settings.max_speed * 
			(global_position.distance_to(flock_center) / 
			settings.view_distance))
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]


func get_acceleration():
	var flock_status = get_flock_status(boids)
	var wall_status = get_wall_status(ray_folder)
	var predator_status = get_predator_status(predators)
	
	var cohesion_vector = flock_status[0] * settings.cohesion_force
	var align_vector = flock_status[1] * settings.align_force
	var separation_vector = flock_status[2] * settings.separation_force
	var run_vector = predator_status * settings.run_force
	var wall_vector
	
	if in_wall:
		wall_vector = wall_status * settings.wall_force * 100
	else:
		wall_vector = wall_status * settings.wall_force
	
	return (
		cohesion_vector + 
		align_vector + 
		separation_vector + 
		run_vector +
		wall_vector
	) #+ mouse_vector


func get_predator_status(predators:Array):
	var run_vector := Vector2.ZERO
	
	for p:Area2D in predators:
		run_vector += p.position.direction_to(position)
	
	return run_vector

func get_wall_status(rays:Node2D):
	var wall_vector:= Vector2.ZERO
	for r:RayCast2D in rays.get_children():
		if r.is_colliding():
			if r.get_collider() is TileMapLayer:
				var magi = 20/(r.get_collision_point() - global_position).length_squared()
				wall_vector += -r.target_position.rotated(rotation) * magi
	return wall_vector


func _on_vision_area_entered(area: Area2D) -> void:
	if area is Boid and area != self:
		boids.append(area)
	elif area.is_in_group("predator"):
		predators.append(area)


func _on_vision_area_exited(area: Area2D) -> void:
	if area is Boid:
		boids.erase(area)
	elif area.is_in_group("predator"):
		predators.erase(area)

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		in_wall = true


func _on_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		in_wall = false
