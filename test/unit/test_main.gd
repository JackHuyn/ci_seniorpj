# Unit Test for main.gd
extends GutTest

# Load the scene we want to test
var main_script = load("res://main.gd")
var board_scene = load("res://board.tscn")  # Load the board scene here
var attack_board_scene = load("res://attack_board.tscn")  # Load the attack board scene here

# Create instance for testing
var main_instance = main_script.new()

func before_each():
	# Assign test PackedScenes to main_instance
	main_instance.board_prefab = board_scene
	main_instance.attack_board_prefab = attack_board_scene
	
	# Add instance to scene tree for proper testing
	add_child(main_instance)

func after_each():
	# Clean up after each test
	main_instance.queue_free()

func test_create_boards():
	# Testing the CreateBoards function in main.gd
	main_instance.CreateBoards()
	var children = main_instance.get_children()

	# Ensure that 7 boards (3 main + 4 attack) are created
	assert_eq(children.size(), 7, "CreateBoards should create 7 boards (3 main boards + 4 attack boards).")
	
	# Variables to track the number of each type of board
	var main_board_count = 0
	var attack_board_count = 0

	# Verify that the boards are created and are of the correct type
	for board in children:
		if board.is_in_group("square"):
			# Check if it's one of the main boards
			if board.notation.board in [Global.BOARD_TYPE.WHITE, Global.BOARD_TYPE.NEUTRAL, Global.BOARD_TYPE.BLACK]:
				main_board_count += 1
				assert_true(board.notation.board in [Global.BOARD_TYPE.WHITE, Global.BOARD_TYPE.NEUTRAL, Global.BOARD_TYPE.BLACK], "Main board should be WHITE, NEUTRAL, or BLACK.")
			# Check if it's one of the attack boards
			elif board.notation.board in [Global.BOARD_TYPE.WHITE_K_ATTACK, Global.BOARD_TYPE.WHITE_Q_ATTACK, Global.BOARD_TYPE.BLACK_K_ATTACK, Global.BOARD_TYPE.BLACK_Q_ATTACK]:
				attack_board_count += 1
				assert_true(board.notation.board in [Global.BOARD_TYPE.WHITE_K_ATTACK, Global.BOARD_TYPE.WHITE_Q_ATTACK, Global.BOARD_TYPE.BLACK_K_ATTACK, Global.BOARD_TYPE.BLACK_Q_ATTACK], "Attack board should be a valid attack board type.")
	
	# Ensure that 3 main boards and 4 attack boards were created
	assert_eq(main_board_count, 3, "There should be exactly 3 main boards created.")
	assert_eq(attack_board_count, 4, "There should be exactly 4 attack boards created.")
