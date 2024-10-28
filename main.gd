extends Node3D

@export var board_prefab: PackedScene
@export var attack_board_prefab : PackedScene
@export var camera: Camera3D

func CreateBoards():
	#var count = 0
	var numb_boards = 3
	var b
	
	#Main boards
	for board in numb_boards:
		b = board_prefab.instantiate()
		if(board == 0):
			b.board_type = Global.BOARD_TYPE.WHITE
		elif (board == 1):
			b.board_type = Global.BOARD_TYPE.NEUTRAL
		elif (board == 2):
			b.board_type = Global.BOARD_TYPE.BLACK
		add_child(b)

	#Attack boards
	for a_b in range(len(Global.attack_boards)):
		b = attack_board_prefab.instantiate()
		b.set_attack_board_dict(Global.attack_boards[a_b])
		add_child(b)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreateBoards()

# Moved to main to prevent it being called in every frame 3 times (one for each board)
# now it only prints once
func _process(delta: float) -> void:
	var rayOrigin = Vector3()
	var rayEnd = Vector3()
	# ray casting
	if Input.is_action_just_pressed("click"):
		var space_state = get_world_3d().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		rayOrigin = camera.project_ray_origin(mouse_position)
		rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 1000
		var ray_query = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
		var intersection = space_state.intersect_ray(ray_query)
		
		if intersection:
			var square = intersection["collider"].get_parent().get_parent()
			if square.is_in_group("square"):
				square.print_notation()
