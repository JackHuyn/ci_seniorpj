extends Node3D

@export var square_prefab: PackedScene = preload("res://square.tscn")

#make dict of the vars
var attack_board_dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(attack_board_dict == null):
		print("attack board is null!")
	
	var s
	var isStartLight = false
	
	for col in range(2):
		var isLight = isStartLight
		
		for row in range(2):
			s = square_prefab.instantiate()
			s.isWhite = isLight
			
			var xzy = Global.translate_attk_boards(col,row,attack_board_dict)
			
			s.position.x = xzy[0]
			s.position.z = xzy[1]
			s.position.y = xzy[2]
			
			s.set_notation(char(col+97), row+1, attack_board_dict['board'])
			
			isLight = !isLight
			add_child(s)
			
		isStartLight = !isStartLight

func set_attack_board_dict(dict_in):
	attack_board_dict = dict_in

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
