extends Node2D

const tile_template = [
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 1, 0, 0, 0],
	[0, 0, 1, 1, 1, 0, 0],
	[0, 0, 0, 1, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0],
]


var tiles = []
var previous_mouse_position = Vector2.ZERO
var previous_hovored_slot = null
var tile_size = Vector2() 
var selected_tile : Tile = null
var tile = null
var border_width = 2


func _ready():
	set_process_input(false)
	
	
func generate_template(tile_size):
	
	self.tile_size = tile_size
	
	var tile = Tile.new(tile_size, Tile.BITMASK_TYPE.NONE)
	add_child(tile)
	self.tile = tile
	
	set_process_input(true)

func process_next_step():
	var data : Image = tile.data 
	var offset = Vector2(70, 0)
	var northTile = Tile.new(tile_size, Tile.BITMASK_TYPE.S, get_section_of_data(data, [0, 1, 2, 3, 4, 5, 3, 4, 5]))
	add_child(northTile)
	northTile.position = Vector2(0, -17 * 2) + offset
	
	var southTile = Tile.new(tile_size, Tile.BITMASK_TYPE.N, get_section_of_data(data, [3, 4, 5, 3, 4, 5, 6, 7, 8]))
	add_child(southTile)
	southTile.position = Vector2(0, 17 * 2) + offset
	
	var westTile = Tile.new(tile_size, Tile.BITMASK_TYPE.E, get_section_of_data(data, [0, 1, 1, 3, 4, 4, 6, 7, 7]))
	add_child(westTile)
	westTile.position = Vector2(-17 * 2, 0) + offset
	
	var centerTile = Tile.new(tile_size, Tile.BITMASK_TYPE.N_E_W_S, get_section_of_data(data, [8, 4, 6, 4, 4, 4, 2, 4, 0]))
	add_child(centerTile)
	centerTile.position = Vector2.ZERO + offset
	
	
	var eastTile = Tile.new(tile_size, Tile.BITMASK_TYPE, get_section_of_data(data, [1, 1, 2, 4, 4, 5, 7, 7, 8]))
	add_child(eastTile)
	eastTile.position = Vector2(17 * 2, 0) + offset
	
func crop(start_position, size, data, source, start_offset = Vector2.ZERO):
	start_position
	var start_x = start_position.x
	var start_y = start_position.y
	var part_size = int(tile_size.x / 3)
	var xa = 0
	var ya = 0
	if start_offset.x > 0:
		xa = 1
	if start_offset.y > 0:
		ya = 1
	for x in size.x:
		for y in size.y:
			source.set_pixel(x + start_offset.x , y + start_offset.y, data.get_pixel(x + start_x * part_size + start_offset.x, y + start_y * part_size + start_offset.y))

func get_section_of_data(data, sections):
	var new_sections = []
	data.lock()
	for i in range(sections.size()):
		var section = sections[i]
		var start_position = Vector2.ZERO
		var default_size = Vector2(int(tile_size.x / 3), int(tile_size.x / 3))
		print(tile_size)
		var part = Image.new()
		
		part.create(default_size.x, default_size.y, false, Image.FORMAT_RGBA8)
		var border_width_box = Vector2(2, default_size.y)
		var border_height_box = Vector2(default_size.x, 2)
		var start_offset_length = default_size.x - 2
		part.lock()
		match section:
			0: 
				start_position = Vector2.ZERO
				crop(start_position, border_width_box, data, part)
				crop(start_position, border_height_box, data, part)
				
			1: 
				start_position = Vector2(1, 0)
				crop(start_position, border_height_box, data, part)
				
			2: 
				start_position = Vector2(2, 0)
				crop(start_position, border_height_box, data, part)
				crop(start_position, border_width_box, data, part, Vector2(start_offset_length, 0))
				
			3: 
				start_position = Vector2(0, 1)
				crop(start_position, border_width_box, data, part)
				
			4: 
				start_position = Vector2(1, 1)
				crop(start_position, default_size, data, part) # FIX DIS
				
			5: 
				start_position = Vector2(2, 1)
				crop(start_position, border_width_box, data, part, Vector2(start_offset_length, 0))
				
			6: 
				start_position = Vector2(0, 2)
				crop(start_position, border_width_box, data, part)
				crop(start_position, border_height_box, data, part, Vector2(0, start_offset_length))
				
			7: 
				start_position = Vector2(1, 2)
				crop(start_position, border_height_box, data, part, Vector2(0, start_offset_length))
				
			8: 
				start_position = Vector2(2, 2)
				crop(start_position, border_width_box, data, part, Vector2(start_offset_length, 0))
				crop(start_position, border_height_box, data, part, Vector2(0, start_offset_length))
			
		var part_placement = Vector2.ZERO
		
		var t
		match i:
			0: 
				part_placement = Vector2.ZERO
				t = Color.red
			1:
				part_placement = Vector2(1, 0)
				t = Color.blue
			2: 
				part_placement = Vector2(2, 0)
				t = Color.green
			3:
				part_placement = Vector2(0, 1)
				t = Color.yellow
			4:
				part_placement = Vector2(1, 1)
				t = Color.brown
			5: 
				part_placement = Vector2(2, 1)
				t = Color.violet
			6: 
				part_placement = Vector2(0, 2)
				t = Color.sienna
			7: 
				part_placement = Vector2(1, 2)
				t = Color.salmon
			8: 
				part_placement = Vector2(2, 2)
				t = Color.coral
		
		
		for x in part.get_width():
			for y in part.get_height():
				var current_pixel = part.get_pixel(x, y)
				if current_pixel.a == 0:
					part.set_pixel(x, y, data.get_pixel(x + start_position.x * default_size.x, y + start_position.y * default_size.y))
		
		part.unlock()
		
		
		
		new_sections.push_back([Vector2(part_placement * Vector2(default_size.x, default_size.y)), part])
	data.unlock()
	return new_sections
				
	
	

func _process(delta):
	update()

func _input(event):
	if not event is InputEventMouse:
		return
	
	if Input.is_action_just_pressed("right_mouse_button"):
		var hovered_tile = get_hovered_tile()
		if get_hovered_tile() != null:
			selected_tile = hovered_tile
		
	if selected_tile != null:
		# correct local slot coordinates
		var local_tile_position = get_tiled_mouse_position() - selected_tile.position
		
		if Input.is_action_just_pressed("left_mouse_button"):
			previous_mouse_position = local_tile_position
		
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			selected_tile.lock_tile_data()
			selected_tile.draw_pixel_unlocked(local_tile_position) 
			selected_tile.fill_gaps(local_tile_position, previous_mouse_position, Color.black)
			selected_tile.unlock_tile_data()
			selected_tile.update_texture()
			
			
		if Input.is_action_just_released("left_mouse_button"):
			pass
			
		previous_hovored_slot = selected_tile
		previous_mouse_position = local_tile_position
	 
func _draw():
	if selected_tile:
		draw_selected_tile_hint()
		#draw_bitmasks_hint()
		
func draw_selected_tile_hint():
	var draw_start = selected_tile.position - selected_tile.size / 2
	var draw_end = selected_tile.size
	draw_rect(Rect2(draw_start, draw_end), Color.blue, false, 1.0, true)
	draw_rect(Rect2(draw_start + Vector2(border_width, border_width), draw_end - (Vector2(border_width * 2, border_width * 2))), Color.blue, false, 1.0, true)

func draw_bitmasks_hint():
	var bitmask = get_hovered_bitmask()
	var rect = Rect2(selected_tile.position + bitmask.position, bitmask.size)
	print("draw pos: ", bitmask.position)
	draw_rect(rect, Color.aqua, false, 1.0, true)
	

# tiles the mouse position (upper left is 0, 0 instead of center)
func get_tiled_mouse_position():
	return get_local_mouse_position().floor() + tile_size / 2

	
func get_hovered_tile():
	var mouse_position = get_tiled_mouse_position()
	for tile in get_children():
		
		var tile_bounds = Rect2(tile.position, tile_size)
		if tile_bounds.has_point(mouse_position):
			return tile
		
	return null
	
func get_hovered_bitmask():
	var local_tile_position = get_tiled_mouse_position() - selected_tile.position
	var pos = (local_tile_position / tile_size * 3).floor()
	return Bitmask.new(pos, (tile_size / 3).floor())
	


func _on_ContinueButton_pressed():
	process_next_step()
