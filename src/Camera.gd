extends Camera2D

var viewport_container = null
var tween = null
var zoom_min = Vector2(0.005, 0.005)
var zoom_max = Vector2(2, 2)
var drag = false

func _ready():
	viewport_container = get_parent().get_parent()
	tween = Tween.new()
	add_child(tween)

func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("middle_mouse"):
			drag = true
		elif event.is_action_released("middle_mouse"):
			drag = false
		
		if event.button_index == BUTTON_WHEEL_UP:
			zoom_camera(-1, viewport_container.get_local_mouse_position())
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom_camera(1, viewport_container.get_local_mouse_position())
	
	if event is InputEventMagnifyGesture:
		zoom_camera(event.factor, viewport_container.get_local_mouse_position())
	
	if event is InputEventMouseMotion and drag:
		offset = offset - event.relative * zoom
	

func zoom_camera(dir, mouse_position):
	var viewport_size = viewport_container.rect_size
	var zoom_margin = zoom * dir / 5
	var new_zoom = zoom + zoom_margin
	if new_zoom > zoom_min && new_zoom < zoom_max:
		var new_offset = offset + (-0.5 * viewport_size + mouse_position) * (zoom - new_zoom)
		tween.interpolate_property(self, "zoom", zoom, new_zoom, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(self, "offset", offset, new_offset, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
