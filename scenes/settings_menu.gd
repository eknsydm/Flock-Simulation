extends Window


@export var boid_settings: BoidSettings
@export var tilemap:TileMap

@onready var align_force_slider: HSlider = %AlignForceSlider
@onready var cohesion_force_slider: HSlider = %CohesionForceSlider
@onready var separation_force_slider: HSlider = %SeparationForceSlider
@onready var wall_force_slider: HSlider = %WallForceSlider
@onready var avoid_distance_slider: HSlider = %AvoidDistanceSlider
@onready var view_distance_slider: HSlider = %ViewDistanceSlider
@onready var max_speed_slider: HSlider = %MaxSpeedSlider


@onready var value_label: Label = %ValueLabel

var force_max :float = 0.5
var force_min :float = 0
var force_step :float = 0.01

func _ready() -> void:
	
	for f in [
		align_force_slider,
		cohesion_force_slider,
		separation_force_slider,
		wall_force_slider]:
		
		f.max_value = force_max
		f.min_value = force_min
		f.step = force_step

	align_force_slider.value = boid_settings.align_force
	cohesion_force_slider.value = boid_settings.cohesion_force
	separation_force_slider.value = boid_settings.separation_force
	wall_force_slider.value = boid_settings.wall_force
	
	avoid_distance_slider.max_value = 100
	avoid_distance_slider.min_value = 0
	avoid_distance_slider.step = 10
	avoid_distance_slider.value = boid_settings.avoid_distance

	max_speed_slider.max_value = 15
	max_speed_slider.min_value = 1
	max_speed_slider.step = 1
	max_speed_slider.value = boid_settings.max_speed


func _on_close_requested() -> void:
	visible = false


func _on_align_force_slider_value_changed(value: float) -> void:
	boid_settings.align_force = value


func _on_cohesion_force_slider_value_changed(value: float) -> void:
	boid_settings.cohesion_force = value



func _on_separation_force_slider_value_changed(value: float) -> void:
	boid_settings.separation_force = value


func _on_wall_force_slider_value_changed(value: float) -> void:
	boid_settings.wall_force = value


func _on_avoid_distance_slider_value_changed(value: float) -> void:
	boid_settings.avoid_distance = value


func _on_max_speed_slider_value_changed(value: float) -> void:
	boid_settings.max_speed = value


func _on_button_pressed() -> void:
	visible = true
