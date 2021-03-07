extends Stage
class_name StageTwo

var tile_size

func enter_stage(canvas, settings, extra = {}):
	return .enter_stage(canvas, settings, extra)
	

func execute():
	var data : Image = extra["tile"].data
	tile_size = extra["tile"].size
	var offset = Vector2(70, 0)
	
	var northTile = Tile.new(tile_size, settings.border_size, Tile.BITMASK_TYPE.S, get_section_of_data(data, [0, 1, 2, 3, 4, 5, 3, 4, 5]))
	canvas.add_child(northTile)
	northTile.position = Vector2(0, -17 * 2) + offset
	
	var southTile = Tile.new(tile_size,  settings.border_size, Tile.BITMASK_TYPE.N, get_section_of_data(data, [3, 4, 5, 3, 4, 5, 6, 7, 8]))
	canvas.add_child(southTile)
	southTile.position = Vector2(0, 17 * 2) + offset
	
	var westTile = Tile.new(tile_size, settings.border_size, Tile.BITMASK_TYPE.E, get_section_of_data(data, [0, 1, 1, 3, 4, 4, 6, 7, 7]))
	canvas.add_child(westTile)
	westTile.position = Vector2(-17 * 2, 0) + offset
	
	var centerTile = Tile.new(tile_size, settings.border_size, Tile.BITMASK_TYPE.N_E_W_S, get_section_of_data(data, [8, 4, 6, 4, 4, 4, 2, 4, 0]))
	canvas.add_child(centerTile)
	centerTile.position = Vector2.ZERO + offset
	
	
	var eastTile = Tile.new(tile_size, settings.border_size, Tile.BITMASK_TYPE, get_section_of_data(data, [1, 1, 2, 4, 4, 5, 7, 7, 8]))
	canvas.add_child(eastTile)
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
		
		match i:
			0: 
				part_placement = Vector2.ZERO
			1:
				part_placement = Vector2(1, 0)
			2: 
				part_placement = Vector2(2, 0)
			3:
				part_placement = Vector2(0, 1)
			4:
				part_placement = Vector2(1, 1)
			5: 
				part_placement = Vector2(2, 1)
			6: 
				part_placement = Vector2(0, 2)
			7: 
				part_placement = Vector2(1, 2)
			8: 
				part_placement = Vector2(2, 2)
		
		
		for x in part.get_width():
			for y in part.get_height():
				var current_pixel = part.get_pixel(x, y)
				if current_pixel.a == 0:
					part.set_pixel(x, y, data.get_pixel(x + start_position.x * default_size.x, y + start_position.y * default_size.y))
		
		part.unlock()
		new_sections.push_back([Vector2(part_placement * Vector2(default_size.x, default_size.y)), part])
		
	data.unlock()
	return new_sections
	
