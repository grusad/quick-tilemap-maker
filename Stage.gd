extends Node
class_name Stage

var canvas
var settings : Settings
var extra

func enter_stage(canvas, settings, extra = {}):
	self.canvas = canvas
	self.settings = settings
	self.extra = extra
	return self
	
func exit_stage():
	pass

func execute():
	pass
	
