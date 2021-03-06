class_name Tile extends Sprite

enum BITMASK_TYPE {
	S, W, N, E, N_E_W_S, NONE,
}

var data : Image = null
var size = Vector2()
var bitmask_type = null
var border_size = 0

func _init(size, border_size, bitmask_type, sections : Array = []):
	self.size = size
	self.bitmask_type = bitmask_type
	self.border_size = border_size
	self.show_behind_parent = true
	data = Image.new()
	data.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	if not sections.empty():
		fill_pixels_by_sections(sections)
	else:
		data.lock()
		for x in size.x:
			for y in size.y:
				data.set_pixel(x, y, Color.white)
		data.unlock()
		update_texture()

func update_texture():
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(data)
	image_texture.flags = 2
	texture = image_texture

func unlock_tile_data():
	data.unlock()
	
func lock_tile_data():
	data.lock()
	
func draw_pixel_unlocked(pixel):
	if pixel.x >= 0 and pixel.x < size.x and pixel.y >= 0 and pixel.y < size.y:
		data.set_pixelv(pixel, Color.black)
		
	
func fill_gaps(end_pos : Vector2, start_pos : Vector2, color : Color) -> void:
	var previous_mouse_pos_floored = start_pos.floor()
	var mouse_pos_floored = end_pos.floor()
	var dx := int(abs(mouse_pos_floored.x - previous_mouse_pos_floored.x))
	var dy := int(-abs(mouse_pos_floored.y - previous_mouse_pos_floored.y))
	var err := dx + dy
	var e2 := err << 1 # err * 2
	var sx = 1 if previous_mouse_pos_floored.x < mouse_pos_floored.x else -1
	var sy = 1 if previous_mouse_pos_floored.y < mouse_pos_floored.y else -1
	var x = previous_mouse_pos_floored.x
	var y = previous_mouse_pos_floored.y
	while !(x == mouse_pos_floored.x && y == mouse_pos_floored.y):
		draw_pixel_unlocked(Vector2(x, y))
		e2 = err << 1
		if e2 >= dy:
			err += dy
			x += sx
		if e2 <= dx:
			err += dx
			y += sy

func fill_pixels_by_sections(sections: Array):
	self.data.lock()
	for section in sections:
		var position = section[0]
		var part = section[1]
		var start_x = int(position.x)
		var start_y = int(position.y)
		var end_x = int(size.x / 3) 
		var end_y = int(size.y / 3)
		

		part.lock()
		for x in end_x:
			for y in end_y:
				data.set_pixel(x + start_x, y + start_y, part.get_pixel(x , y))
		part.unlock()
	self.data.unlock()
	update_texture()
		
		
		
		
	
			
			
			
			
			
			
			
