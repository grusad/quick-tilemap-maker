extends Control

onready var canvas = $VBoxContainer/CenterContainer/HSplitContainer/ViewportContainer/Viewport/Canvas
onready var settings = $VBoxContainer/CenterContainer/ToolContainer/PanelContainer/Settings

var stage_one_result = null
var stage_two_result = null

func _on_GenerateButton_pressed():
	stage_one_result = StageOne.new().enter_stage(canvas, settings).execute()

func _on_ContinueButton_pressed():
	var lol = StageTwo.new()
	stage_two_result = StageTwo.new().enter_stage(canvas, settings, {"tile": stage_one_result}).execute()
