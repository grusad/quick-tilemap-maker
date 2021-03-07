extends VBoxContainer
class_name Settings

onready var tile_size_input = $GridContainer/TileSizeInput
onready var border_size_input = $GridContainer/BorderSizeInput

var tile_size = 0
var border_size = 0

func _ready():
	tile_size_input.connect("text_changed", self, "on_tile_size_changed")
	border_size_input.connect("text_changed", self, "on_border_size_changed")
	
	on_tile_size_changed(tile_size_input.text)
	on_border_size_changed(border_size_input.text)
	
func on_tile_size_changed(text):
	tile_size = int(text)

func on_border_size_changed(text):
	border_size = int(text)
