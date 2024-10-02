extends TileMapLayer

@export var height:int
@export var width:int
@export var density:int = 58

enum tile{
	floor,
	wall
}

var grid :Array[Array]

func _ready() -> void:
	
	height = get_viewport_rect().size.y / 16 
	width = get_viewport_rect().size.x / 16 
	
	grid = make_noise_grid(density)
	#apply_cellular_automaton(grid,0)
	set_bounds()
	draw_tilemap(grid) 


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		apply_cellular_automaton(grid, 1)
		draw_tilemap(grid) 

func draw_tilemap(grid:Array[Array]):
	for y in range(grid.size()):
		for x in range(grid.front().size()):
			if grid[y][x] == tile.floor:
				erase_cell(Vector2(x,y))
			elif grid[y][x] == tile.wall:
				set_cell(Vector2(x,y),0,Vector2(1,1))


func make_noise_grid(density:int) -> Array[Array]:
	var noise_grid : Array[Array]
	for i in range(height):
		noise_grid.append([])
		for j in range(width):
			if randi_range(1,100) > density:
				noise_grid[i].append(tile.floor)
			else:
				noise_grid[i].append(tile.wall)

	return noise_grid


func apply_cellular_automaton(grid:Array[Array], count):
	for i in range(count):
		var temp_grid = grid.duplicate(true)
		
		for j in grid.size():
			for k in grid.front().size():
				var neighbor_wall_count = 0
				for y in range(j-1,j+2):
					for x in range(k-1,k+2):
						if is_within_map_bounds(x,y):
							if y != j or x != k:
								if temp_grid[y][x] == tile.wall:
									neighbor_wall_count += 1
						else:
							neighbor_wall_count += 1
				grid[j][k] = tile.wall if neighbor_wall_count > 4 else tile.floor
				
				
func is_within_map_bounds(x:int,y:int) -> bool:
	if x < width and x >= 1 and y < height and y >= 1:
		return true
	else:
		return false 
func set_bounds():
	for y in range(height):
		set_cell(Vector2(width,y),0,Vector2(1,1))
		set_cell(Vector2(0,y),0,Vector2(1,1))
	for x in range(width):
		set_cell(Vector2(x,height),0,Vector2(1,1))
		set_cell(Vector2(x,0),0,Vector2(1,1))
func get_empty_space(ratio:int):
	for y in grid:
		for x in y:
			if x == tile.floor:
				pass
				
		
func set_spawners(count:int):
	pass
	
