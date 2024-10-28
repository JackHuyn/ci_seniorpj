extends Node

enum BOARD_TYPE {
	BLACK,
	NEUTRAL,
	WHITE,
	WHITE_K_ATTACK,
	BLACK_K_ATTACK,
	WHITE_Q_ATTACK,
	BLACK_Q_ATTACK,
}

var main_board_size = 4
var attack_board_size = 2

func translate(column, row, board_type):
	var zOffset
	var yOffset
	
	if(board_type == BOARD_TYPE.WHITE):
		zOffset = -2
		yOffset = -2
	elif (board_type == BOARD_TYPE.NEUTRAL):
		zOffset = 0
		yOffset = 0
	elif (board_type == BOARD_TYPE.BLACK):
		zOffset = 2
		yOffset = 2
	else:
		yOffset = 0
		zOffset = 0
		print("Invalid Board Type")
	
	# the 1.5 values are to center the boards
	var x = -('a'.unicode_at(0)-column.unicode_at(0)+1.5)
	var z = -(row-4)-zOffset-1.5
	var y = yOffset
	return [x,z,y]
	
#a array of the attackB ditionariys
var attack_boards = [
	{
		'board': Global.BOARD_TYPE.WHITE_K_ATTACK,
		'corner_square': {
			'column': 'a',
			'row': 1,
			'board': Global.BOARD_TYPE.WHITE,
		},
		'is_up': false,
	},
	
	{
	'board': Global.BOARD_TYPE.WHITE_Q_ATTACK,
		'corner_square': {
			'column': 'd',
			'row': 1,       
			'board': Global.BOARD_TYPE.WHITE, 
		},
	'is_up': false,  # Maybe this board is currently active
	},
	
	{
	'board': Global.BOARD_TYPE.BLACK_K_ATTACK,
		'corner_square': {
			'column': 'a',
			'row': 4,       
			'board': Global.BOARD_TYPE.BLACK, 
		},
	'is_up': true,  # Maybe this board is currently active
	},
	
	{
	'board': Global.BOARD_TYPE.BLACK_Q_ATTACK,
		'corner_square': {
			'column': 'd',
			'row': 4,       
			'board': Global.BOARD_TYPE.BLACK, 
		},
	'is_up': true,  # Maybe this board is currently active
	}
]

func translate_attk_boards(column, row, board_dict):
	
	var x = 0
	var z = 0
	var y = 0
	
	var pos = translate(board_dict['corner_square']['column'], board_dict['corner_square']['row'],
	 board_dict['corner_square']['board'])
	
	#we want the boards to hang off the edge. so...
	if(board_dict['corner_square']['column'] == 'a'):
		x = pos[0] + column - 1
	else:
		x = pos[0] + column
	
	if(board_dict['corner_square']['row'] == 1):
		z = pos[1] - row + 1
	else:
		z = pos[1] - row
	
	#handle y axis
	if(board_dict['is_up'] == true):
		y = pos[2] + 1
	else:
		y = pos[2] - 1
	
	return [x,z,y]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
