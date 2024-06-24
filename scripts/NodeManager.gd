extends Node2D

var max_pressed_buttons = 2
var pressed_buttons = []
var node_visualizer

var num_toggled = 0

var subgraph = []
var s_t_path = []
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
		var u = pressed_buttons[0].get_parent().get_parent()
		var v = pressed_buttons[1].get_parent().get_parent()
		print(str(num_toggled) + ". " + str(node_visualizer.path_exists(u, v)))
		var node_ids_in_component = node_visualizer.extract_nodeid_in_component(u)
		print("parent of u: " + str(node_visualizer.parent[u.id].id))
		var edges_in_component = node_visualizer.extract_edges_in_component(u, node_ids_in_component)

		var m = node_visualizer.m
		var n = node_visualizer.n
		var subgraph = node_visualizer.create_matrix(m*n + 1,m*n + 1)
		for edge in edges_in_component:
			subgraph[edge.x][edge.y] = 1
		print(edges_in_component)
		var path = node_visualizer.dfs_path(subgraph, node_ids_in_component, u.id, v.id)		
		var bfs_path = node_visualizer.bfs_path(subgraph, u.id, v.id)
		s_t_path = bfs_path
		queue_redraw()
		num_toggled+=1
		
func _draw():
	if(!s_t_path.is_empty()):
		for i in range(s_t_path.size() - 1):
			var from_node = s_t_path[i]
			var to_node = s_t_path[i + 1]
			var from_pos = node_visualizer.id_to_node[from_node].position
			var to_pos = node_visualizer.id_to_node[to_node].position
			draw_line(from_pos, to_pos, Color(0, 1, 0), 5) 

func clear_console():
	for i in range(100):
		print(" \n")
