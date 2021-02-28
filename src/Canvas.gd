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


func _ready():
	set_process_input(false)
	
	
func generate_template(tile_size):
	
	self.tile_size = tile_size
	
	for y in tile_template.size():
		for x in tile_template[y].size():
			var template_id = tile_template[y][x]
			if template_id == 1:
				var tile = Tile.new(tile_size, BitmaskManager.get_bitmask_type(Vector2(x, y)))
				tile.position = Vector2(x, y) * tile_size
				add_child(tile)
				tiles.push_back(tile)
	
	for tile in tiles:
		tile.relatives = BitmaskManager.get_relatives(tile, tiles)
	
	set_process_input(true)

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
	draw_rect(Rect2(selected_tile.position - selected_tile.size / 2, selected_tile.size), Color.blue, false, 1.0, true)

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
	
		
	
		
		
		
		
		
		
		
		
	
	
