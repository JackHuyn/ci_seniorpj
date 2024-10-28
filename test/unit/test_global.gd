extends GutTest

# Load the scene we want to test
var global_script = load("res://global.gd")

# Create instance for testing
var global_instance = global_script.new()

func before_each():
	# This is only necessary if global_instance is a node
	# add_child(global_instance)
	pass

func after_each():
	# Clean up after each test
	global_instance.queue_free()

func test_translate_global():
	# Testing the translate function in global.gd
	var result = global_instance.translate("a", 1, global_instance.BOARD_TYPE.WHITE)
	assert_eq(result, [-1.5, -3.5, -2], "translate function in global.gd did not return the expected result.")
