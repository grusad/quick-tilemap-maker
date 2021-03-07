extends Node2D

var tiles = []
var previous_mouse_position = Vector2.ZERO
var previous_hovored_slot = null
var selected_tile : Tile = null


func _ready():
	set_process_input(false)

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
	var border_size = selected_tile.border_size
	draw_rect(Rect2(draw_start, draw_end), Color.blue, false, 1.0, true)
	draw_rect(Rect2(draw_start + Vector2(border_size, border_size), draw_end - (Vector2(border_size * 2, border_size * 2))), Color.blue, false, 1.0, true)

	

# tiles the mouse position (upper left is 0, 0 instead of center)
func get_tiled_mouse_position():
	var tile = get_child(0)
	if tile:
		return get_local_mouse_position().floor() + tile.size / 2
	return null

	
func get_hovered_tile():
	var mouse_position = get_tiled_mouse_position()
	for tile in get_children():
		
		var tile_bounds = Rect2(tile.position, tile.size)
		if tile_bounds.has_point(mouse_position):
			return tile
		
	return null
