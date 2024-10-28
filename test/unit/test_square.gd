# Unit Test for square.gd

extends GutTest

# Load the scene we want to test
var square_script = load("res://square.gd")

# Create instance for testing
var square_instance = square_script.new()

func before_each():
	# Create a mock MeshInstance3D since it's expected in the square.gd script
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = "MeshInstance3D"
	square_instance.add_child(mesh_instance)
	
	# Add square instance to scene tree for proper testing
	add_child(square_instance)

func after_each():
	# Clean up after each test
	square_instance.queue_free()

func test_square_initialization():
	# Testing initialization of square.gd
	square_instance.isWhite = true
	square_instance._ready()
	
	# Check if the square is added to the 'square' group
	assert_true(square_instance.is_in_group("square"), "Square should be added to the 'square' group.")
	
	# Check if the correct material is applied to the mock MeshInstance3D
	var mesh_instance = square_instance.get_node("MeshInstance3D")
	assert_not_null(mesh_instance, "MeshInstance3D should exist.")
	
	var material = mesh_instance.material_override
	assert_not_null(material, "Material should be assigned to MeshInstance3D.")
	
	if square_instance.isWhite:
		assert_eq(material.resource_path, "res://white_square_material.tres", "White square should have white material.")
	else:
		assert_eq(material.resource_path, "res://black_square_material.tres", "Black square should have black material.")

func test_set_notation():
	# Testing the set_notation function in square.gd
	square_instance.set_notation("d", 4, Global.BOARD_TYPE.NEUTRAL)
	
	# Verify that the notation has been correctly set
	assert_eq(square_instance.notation.column, "d", "Column notation should be 'd'.")
	assert_eq(square_instance.notation.row, 4, "Row notation should be 4.")
	assert_eq(square_instance.notation.board, Global.BOARD_TYPE.NEUTRAL, "Board type should be NEUTRAL.")

func test_print_notation():
	# Testing the print_notation function in square.gd
	# You may need to check the console manually if needed
	square_instance.set_notation("b", 2, Global.BOARD_TYPE.BLACK)
	square_instance.print_notation()
	# For more complex scenarios, you could mock the output if necessary.
	# This is a placeholder for any advanced test logic needed to check printed output.
