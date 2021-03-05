extends Control

onready var canvas = $VBoxContainer/CenterContainer/HSplitContainer/ViewportContainer/Viewport/Canvas
onready var tile_size_input = $VBoxContainer/CenterContainer/ToolContainer/PanelContainer/ToolContainer/GridContainer/TileSizeInput
onready var border_size_input = $VBoxContainer/CenterContainer/ToolContainer/PanelContainer/ToolContainer/GridContainer/BorderSizeInput


func _on_GenerateButton_pressed():
	canvas.generate_template(Vector2(30, 30))
	
	
	
	


	
	

