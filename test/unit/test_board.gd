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

func after_each():
	# Clean up after each test
	board_instance.queue_free()

# Test that the board initializes with the correct number of squares
func test_board_initialization():
	# Assuming Global.main_board_size defines the dimensions of the board (e.g., 4 for a 4x4 board)
	var expected_squares = Global.main_board_size * Global.main_board_size
	assert_eq(board_instance.get_child_count(), expected_squares, "The board should have exactly %s squares" % expected_squares)

	# Validate the alternation of square colors (light/dark)
	var is_start_light = false
	for col in range(Global.main_board_size):
		var is_light = is_start_light
		for row in range(Global.main_board_size):
			var square = board_instance.get_child((col * Global.main_board_size) + row)
			assert_eq(square.isWhite, is_light, "Square at column %s, row %s should be %s" % [col, row, "light" if is_light else "dark"])
			is_light = !is_light  # Toggle the color
		is_start_light = !is_start_light  # Toggle starting color for the next column

# Test that the squares are positioned correctly based on Global.translate
func test_square_positions():
	# Manually call _ready to initialize the board
	board_instance._ready()

	# Iterate through the board's children (squares) and validate their positions
	for square in board_instance.get_children():
		var notation = square.notation  # Assuming square's notation contains {column, row, board_type}
		var expected_position = Global.translate(notation["column"], notation["row"], board_instance.board_type)

		# Validate the square's position
		assert_eq(square.position.x, expected_position[0], "Square %s X position mismatch" % notation)
		assert_eq(square.position.z, expected_position[1], "Square %s Z position mismatch" % notation)
		assert_eq(square.position.y, expected_position[2], "Square %s Y position mismatch" % notation)

# Test that the correct number of squares are instantiated with valid notations
func test_square_notation():
	# Manually call _ready to initialize the board
	board_instance._ready()

	# Iterate through the board's children (squares) and validate their notations
	for square in board_instance.get_children():
		var notation = square.notation
		assert_true(notation.column != "", "Square notation should have a valid column.")
		assert_true(notation.row > 0, "Square notation should have a valid row number.")
		assert_true(notation.board in [Global.BOARD_TYPE.WHITE, Global.BOARD_TYPE.BLACK, Global.BOARD_TYPE.NEUTRAL], "Square should have a valid board type.")

# Additional Test: Ensure that squares alternate correctly even for different board types
func test_square_alternation_for_different_board_types():
	# Test for white board
	board_instance.board_type = Global.BOARD_TYPE.WHITE
	board_instance._ready()
	validate_square_color_alternation()

	# Test for neutral board
	board_instance.board_type = Global.BOARD_TYPE.NEUTRAL
	board_instance._ready()
	validate_square_color_alternation()

	# Test for black board
	board_instance.board_type = Global.BOARD_TYPE.BLACK
	board_instance._ready()
	validate_square_color_alternation()

# Helper function to validate the color alternation logic
func validate_square_color_alternation():
	var is_start_light = false
	for col in range(Global.main_board_size):
		var is_light = is_start_light
		for row in range(Global.main_board_size):
			var square = board_instance.get_child((col * Global.main_board_size) + row)
			assert_eq(square.isWhite, is_light, "Square at column %s, row %s should be %s" % [col, row, "light" if is_light else "dark"])
			is_light = !is_light  # Toggle the color
		is_start_light = !is_start_light  # Toggle starting color for the next column
