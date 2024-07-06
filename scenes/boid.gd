class_name Boid
extends Area2D

var velocity := Vector2.UP
var acceleration := Vector2.ZERO
var max_force := 0.3
var max_speed := 1
var boids : Array[Boid]
var screensize

func _ready() -> void:
	velocity = velocity.rotated(PI * randi())
	screensize = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	position += velocity
	velocity += acceleration
	rotation = lerp_angle(rotation, Vector2.ZERO.angle_to_point(velocity), 0.8)
	flock()
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

func align() -> Vector2:
	var steering = Vector2.ZERO
	for boid:Boid in boids:
		steering += boid.velocity
	
	if boids.size() > 0:
		steering /= boids.size()
		steering -= velocity
		if steering.length() != 0:
			steering = Vector2(
				steering.x * max_speed / steering.length(),
				steering.y * max_speed / steering.length())
		steering = steering.limit_length(max_force)
	return steering

func flock():
	var allignment = align()
	acceleration = allignment
	
func _init() -> void:
	pass


func _on_vision_area_entered(area: Area2D) -> void:
	if area is Boid and area != self:
		boids.append(area)

func _on_vision_area_exited(area: Area2D) -> void:
	if area is Boid:
		boids.erase(area)
