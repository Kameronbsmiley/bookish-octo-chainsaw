extends TileMap

onready var firstarea = get_parent().get_node("FirstBlock")
var FirstBlocks = [Vector2(-16,-4),Vector2(-15,-4),Vector2(-14,-4),Vector2(-20,-37),Vector2(-19,-37),Vector2(-18,-37),Vector2(-17,-37)]
var SecondBlocks = [Vector2(-160,-16),Vector2(-159,-16),Vector2(-139,-18),Vector2(-138,-18),Vector2(-137,-18)]

func _ready():
	pass

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


func _block_first():
	for cell in FirstBlocks:
		set_cellv(cell, 0)


func _block_second():
	for cell in SecondBlocks:
		set_cellv(cell, 0)



func _on_Switch_body_entered(body):
	for cell in get_used_cells_by_id(2):
		set_cellv(cell, -1)


func _on_FirstBlock_body_entered(body):
	_block_first()


func _on_SecondBlock_body_entered(body):
	_block_second()

