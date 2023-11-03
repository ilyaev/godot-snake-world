class_name FieldMap extends Resource

var field
var rows = 20
var cols = 20
var grid = []
var visited = []
var islands = []
var dict = {}

func init(image : Image):
	rows = image.get_height()
	cols = image.get_width()
	visited = []
	islands = []
	dict = {}
	grid = []
	for y in range(0, rows):
		var row = []
		var v_row = []
		for x in range(0, cols):
			var is_empty = false
			var pixel = image.get_pixelv(Vector2(x, y)).r
			if pixel > .1:
				is_empty = true
			row.push_back(is_empty)
			v_row.push_back(false)
		grid.push_back(row)
		visited.push_back(v_row)
		
	find_islands()

func is_safe(row, col):
	if row >= 0 and row < rows and col >=0 and col < cols:
		return true
	return false

func dfs(row, col, island):
	visited[row][col] = true
	island.push_back([row, col])
	
	var neighbors = [
	  [-1, 0],
	  [1, 0],
	  [0, -1],
	  [0, 1],
	];
	
	for neighbor in neighbors:
		var new_row = row + neighbor[0]
		var new_col = col + neighbor[1]
		
		if is_safe(new_row, new_col) and grid[new_row][new_col] and !visited[new_row][new_col]:
			dfs(new_row, new_col, island)
			
func _hash(x,y):
	return 'x'+str(x)+'_y'+str(y)	
	
func find_islands():
	var id = 0
	for row in range(0, rows):
		for col in range(0, cols):
			if grid[row][col] and !visited[row][col]:
				var island = []
				id += 1
				dfs(row, col, island)
				for one in island:
					dict[_hash(one[1],one[0])] = id
				islands.push_back(island)

func project(cell_pos):
	return Vector2(cell_pos.x, cell_pos.y * -1) + Vector2(cols / 2, rows / 2) - Vector2(0, 1)

func unproject(pos):
	var res = Vector2(pos.x, pos.y) - Vector2(cols / 2, rows / 2) + Vector2(0, 1)
	res.y *= -1
	return res

func get_area(pos):
	return dict[_hash(pos.x, pos.y)]
	
func get_area_cells(area):
	var cells = []
	for key in dict.keys():
		if dict[key] == area:		
			var its = key.replace("x",'').replace("y",'').split('_')
			cells.push_back([int(its[0]), int(its[1])])
	return cells
