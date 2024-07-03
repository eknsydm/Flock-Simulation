class_name Boid
extends Area2D

@onready var ray_folder := $RayFolder.get_children()

var boidsISee := []
var vel := Vector2.ONE
var speed := 7.0
var screensize : Vector2
var movv := 48 #-----------------------------------

func _ready() -> void:
	screensize = get_viewport_rect().size
	randomize()
	

func _physics_process(delta: float) -> void:
	boids()
	check_collision()
	vel = vel.normalized() * speed 
	move()
	rotation = lerp_angle(rotation, vel.angle_to_point(Vector2.ZERO),0.4)


func check_collision():
	for ray:RayCast2D in ray_folder:
		if ray.is_colliding():
			if ray.get_collider().is_in_group("blocks"):
				var magi := (100 / (ray.get_collision_point() - global_position).length_squared())
				vel += (ray.target_position.rotated(rotation) * magi)
		pass


func boids():
	if boidsISee:
		
		var num_of_boids := boidsISee.size()
		var avg_vel := Vector2.ZERO
		var avg_pos := Vector2.ZERO
		var steer_away := Vector2.ZERO
		
		for boid in boidsISee:
			avg_vel += boid.vel
			avg_pos += boid.position
			steer_away -= (boid.global_position - global_position) * (movv / (global_position - boid.global_position).length())
		
		avg_vel /= num_of_boids
		vel -= (avg_vel - vel) / 2
		
		avg_pos /= num_of_boids
		vel -= (avg_pos - position)  #-----------------------------
		
		steer_away /= num_of_boids
		vel -= (steer_away)
func move():
	global_position -= vel
	#
	#if global_position.x < 0:
		#global_position.x = screensize.x
	#if global_position.x > screensize.x:
		#global_position.x = 0
	#if global_position.y < 0:
		#global_position.y = screensize.y
	#if global_position.y > screensize.y:
		#global_position.y = 0


func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("boid"):
		boidsISee.append(area)


func _on_vision_area_exited(area: Area2D) -> void:
	boidsISee.erase(area)

func _draw() -> void:
	#draw_line(position,vel,Color.RED,2)
	pass
