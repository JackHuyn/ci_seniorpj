extends GutTest

# Load the scene we want to test
var board_script = load("res://board.gd")  # Load the script for the board
var square_scene = load("res://square.tscn")  # Load the square prefab (scene)

var board_instance

func before_each():
	# Create an instance of the board for each test
	board_instance = board_script.new()
	
	# Add board instance to the scene tree for proper initialization
	add_child(board_instance)

	# Manually call _ready() to initialize the board, as GUT does not handle lifecycle events automatically
	board_instance._ready()

func after_each():
	# Clean up after each test
	board_instance.queue_free()

# Test square positions (fix for global_transform access)
func test_square_positions():
	# Ensure that the board is initialized and squares are added
	assert_true(board_instance.get_child_count() > 0, "Board should have squares.")

	# Iterate through the squares and validate their positions
	for square in board_instance.get_children():
		assert_not_null(square, "Square instance should not be null.")
		assert_true(square.is_inside_tree(), "Square must be added to the scene tree before accessing global_transform.")

		# Now, safely access global_transform
		var notation = square.notation
		var expected_position = Global.translate(notation["column"], notation["row"], board_instance.board_type)

		# Validate the square's position using global_transform
		assert_eq(square.global_transform.origin.x, expected_position[0], "Square %s X position mismatch" % notation)
		assert_eq(square.global_transform.origin.z, expected_position[1], "Square %s Z position mismatch" % notation)
		assert_eq(square.global_transform.origin.y, expected_position[2], "Square %s Y position mismatch" % notation)
