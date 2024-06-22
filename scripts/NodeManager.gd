extends Node

var max_pressed_buttons = 2
var pressed_buttons = []
var node_visualizer

var num_toggled = 0
func _ready():
	# Assuming the NodeVisualizer node is a sibling of this node
	node_visualizer = get_node("/root/Main") 
	
# Function to handle button toggle events
func button_toggled(button: Button, pressed: bool):
	if pressed:
		if button not in pressed_buttons:
			pressed_buttons.append(button)
			if pressed_buttons.size() > max_pressed_buttons:
				var oldest_button = pressed_buttons.pop_front()
				oldest_button.set_pressed(false)
	else:
		pressed_buttons.erase(button)
	
	if(pressed_buttons.size() == 2):
		clear_console()
		print(str(num_toggled) + ". " + str(node_visualizer.path_exists(pressed_buttons[0].get_parent().get_parent(), pressed_buttons[1].get_parent().get_parent())))
		num_toggled+=1
		
func clear_console():
	for i in range(100):
		print(" \n")
