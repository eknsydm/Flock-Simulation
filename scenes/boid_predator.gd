class_name Predator
extends Area2D

var velocity := Vector2.UP
var acceleration := Vector2.ZERO
var boids := []
var predators := []
var screensize
var eating := false

@onready var ray_folder: Node2D = $RayFolder
@onready var view_collision: CollisionShape2D = $Vision/CollisionShape2D

@export var settings: BoidSettings
@onready var eating_timer: Timer = $EatingTimer
@onready var particles: CPUParticles2D = $CPUParticles2D



func _ready() -> void:

	velocity = velocity.rotated(PI * randi())
	screensize = get_viewport_rect().size
	#view_collision.shape.radius = settings.view_distance


func _physics_process(delta: float) -> void:
	
	rotation = Vector2(1, 0).angle_to(velocity)
	var acceleration = get_acceleration()
	
	velocity = (velocity + acceleration).limit_length(settings.max_speed * 1.5)
	
	if velocity.length_squared() < settings.min_speed:
		velocity = velocity.normalized() * settings.max_speed * 1.5
	
	if !eating:
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

func get_acceleration():
	var wall_status = get_wall_status(ray_folder)
	var wall_vector = wall_status * settings.wall_force
	var hunt_status = get_hunt_status(boids)
	var hunt_vector = hunt_status * 3.0
	var avoid_status = get_avoid_status(predators)
	var avoid_vector = avoid_status * settings.separation_force * 2
	return wall_vector + hunt_vector + avoid_vector #+ mouse_vector


func get_hunt_status(boids:Array):
	if boids.is_empty():
		return Vector2.ZERO
		
	var target
	var closest_distance:float = 0
	var hunt_vector:= Vector2.ZERO
	
	for b:Area2D in boids:
		var distance = position.distance_squared_to(b.position)
		if distance < closest_distance or closest_distance == 0:
			target = b
			closest_distance = distance
	
	hunt_vector = position.direction_to(target.position)
	return hunt_vector


func get_wall_status(rays:Node2D):
	var wall_vector:= Vector2.ZERO
	for r:RayCast2D in rays.get_children():
		if r.is_colliding():
			if r.get_collider() is TileMapLayer:
				var magi = 10/(r.get_collision_point() - global_position).length_squared()
				wall_vector += -r.target_position.rotated(rotation) * magi
	return wall_vector


func _on_vision_area_entered(area: Area2D) -> void:
	if area.is_in_group("boid") and area != self:
		boids.append(area)
	
	elif area is Predator and area != self:
		predators.append(area)
		print(area)

func _on_vision_area_exited(area: Area2D) -> void:
	if area.is_in_group("boid") and area != self:
		boids.erase(area)
		
	elif area is Predator and area != self:
		predators.erase(area)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("boid"):
		eat_boid(area)
		area.queue_free()
	
func eat_boid(area):
	eating = true
	eating_timer.start()
	particles.emitting = true

func _on_eating_timer_timeout() -> void:
	eating = false
	particles.emitting = false
	BoidSpawner.spawn_predator(global_position)

func get_avoid_status(flock: Array) -> Vector2:
	var avoid_vector := Vector2.ZERO
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position
		var d = global_position.distance_to(neighbor_pos)
		
		if d > 0 and d < settings.avoid_distance * 2:
			avoid_vector -= (neighbor_pos - global_position).normalized() * (settings.avoid_distance / d * settings.max_speed * 1.5) 
	
	return avoid_vector
