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


func after_each():
	# Clean up after each test
	main_instance.queue_free()

func test_create_boards():
	# Testing the CreateBoards function in main.gd
	main_instance.CreateBoards()
	
	# Get children of the main_instance
	var children = main_instance.get_children()

	# Expected counts for boards
	var expected_main_boards = 3
	var expected_attack_boards = 4
	var expected_total_boards = expected_main_boards + expected_attack_boards

	# Ensure that the correct number of boards are created
	assert_eq(children.size(), expected_total_boards, "CreateBoards should create %s boards (%s main boards + %s attack boards)." % [expected_total_boards, expected_main_boards, expected_attack_boards])
	
	# Variables to track the number of each type of board
	var main_board_count = 0
	var attack_board_count = 0

	# Verify the group assignments for each child
	for child in children:
		if child.is_in_group("main_board"):
			main_board_count += 1
			assert_true(child.board_type in [Global.BOARD_TYPE.WHITE, Global.BOARD_TYPE.NEUTRAL, Global.BOARD_TYPE.BLACK], "Main board should be WHITE, NEUTRAL, or BLACK.")
		elif child.is_in_group("attack_board"):
			attack_board_count += 1
			assert_true(child.board_type in [Global.BOARD_TYPE.WHITE_K_ATTACK, Global.BOARD_TYPE.WHITE_Q_ATTACK, Global.BOARD_TYPE.BLACK_K_ATTACK, Global.BOARD_TYPE.BLACK_Q_ATTACK], "Attack board should be a valid attack board type.")
	
	# Ensure that 3 main boards and 4 attack boards were created
	assert_eq(main_board_count, expected_main_boards, "There should be exactly %s main boards created." % expected_main_boards)
	assert_eq(attack_board_count, expected_attack_boards, "There should be exactly %s attack boards created." % expected_attack_boards)
