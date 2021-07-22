extends TileMap


func break_blocks(tile_position: Vector2):
	if get_cellv(tile_position) == 1:
		set_cellv(tile_position, -1)
		tile_position.x += 1
		break_blocks(tile_position)
		tile_position.x -= 2
		break_blocks(tile_position)
		tile_position.y += 1
		break_blocks(tile_position)
		tile_position.y -= 2
		break_blocks(tile_position)




func _on_Switch_body_entered(body):
	for cell in get_used_cells_by_id(2):
		set_cellv(cell, -1)
