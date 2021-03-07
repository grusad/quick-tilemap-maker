extends Stage
class_name StageOne

func execute():
	canvas.set_process_input(true)
	var tile = Tile.new(Vector2.ONE * settings.tile_size, settings.border_size, Tile.BITMASK_TYPE.NONE)
	canvas.add_child(tile)
	return tile
