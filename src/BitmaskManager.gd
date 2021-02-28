extends Node


func get_bitmask_type(array_position, tile_template):
	
	var x = array_position.x
	var y = array_position.y
	
	var nw = 	1 if (tile_template[x - 1][y - 1]) else 0
	var n = 	1 if (tile_template[x][y - 1]) else 0
	var ne = 	1 if (tile_template[x + 1][y - 1]) else 0
	var w = 	1 if (tile_template[x - 1][y]) else 0
	var e = 	1 if (tile_template[x + 1][y]) else 0
	var sw = 	1 if (tile_template[x - 1][y + 1]) else 0
	var s = 	1 if (tile_template[x][y + 1]) else 0
	var se = 	1 if (tile_template[x + 1][y + 1]) else 0
	
	if(n and !e and !s and !w): return Tile.BITMASK_TYPE.N
	if(!n and e and !s and !w): return Tile.BITMASK_TYPE.E
	if(!n and !e and s and !w): return Tile.BITMASK_TYPE.S
	if(!n and !e and !s and w): return Tile.BITMASK_TYPE.W
	if(n and e and s and w):	return Tile.BITMASK_TYPE.N_E_W_S
	assert("Couldnt find shit.")


func process_relative_tiles(selected_tile):
	match tile.type:
		Tile.BITMASK_TYPE.S:
			
	
	
	
	
	
	
	
	
