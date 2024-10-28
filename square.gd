extends Node3D

@export var isWhite: bool

var notation = {
	'column': '',
	'row': -1,
	'board': Global.BOARD_TYPE.WHITE,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("square")
	if isWhite:
		$MeshInstance3D.material_override = preload("res://white_square_material.tres")
	else:
		$MeshInstance3D.material_override = preload("res://black_square_material.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_notation(col, r, board_type):
	notation.column = col
	notation.row = r
	notation.board = board_type

func print_notation():
	var board_string = ''
	match notation.board:
		Global.BOARD_TYPE.WHITE:
			board_string = 'W'
		Global.BOARD_TYPE.BLACK:
			board_string = 'B'
		Global.BOARD_TYPE.NEUTRAL:
			board_string = 'N'
		Global.BOARD_TYPE.WHITE_K_ATTACK:
			board_string = 'WKA'
		Global.BOARD_TYPE.WHITE_Q_ATTACK:
			board_string = 'WQA'
		Global.BOARD_TYPE.BLACK_K_ATTACK:
			board_string = 'BKA'
		Global.BOARD_TYPE.BLACK_Q_ATTACK:
			board_string = 'BQA'
	print(board_string, notation.column, notation.row)
