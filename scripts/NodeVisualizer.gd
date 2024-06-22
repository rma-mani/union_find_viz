extends Node2D

var circle_radius : int = 4
var nodes = []
var edges = []
var m = 12  #Number of rows
var n = 22  #Number of columns


var graph
var parent = []
var rank = []


func _ready():
	var id : int = 0
	var pos : Vector2 = Vector2(0, 50)
	
	
	graph = create_matrix(m*n + 1,m*n + 1)
	for i in range(m):
		for j in range(n):
			var src = load("res://maze.tscn")
			var temp = src.instantiate()
			add_child.call_deferred(temp)
			nodes.append(temp)
			parent.append(temp) #initially each node is the parent of itself
			rank.append(0) #initially each node has rank 0 
			pos = Vector2(pos.x + 50, pos.y)
			temp.position = pos
			temp.id = id
			id += 1
		pos.x = 0
		pos.y += 50
	create_random_adjacent_edges()

func create_edge(start_node, end_node):
	var edge_scene = load("res://edge.tscn")
	var edge_instance = edge_scene.instantiate()
	add_child(edge_instance)
	edge_instance.set_node(start_node.position, end_node.position)
	edges.append(edge_instance)
	
	graph[start_node.id][end_node.id] = 1
	graph[end_node.id][start_node.id] = 1
	
	
func create_random_adjacent_edges():
	var potential_edges = []

	for i in range(m):
		for j in range(n):
			var current_index = i * n + j
			var current_node = nodes[current_index]
			#east
			if j < n - 1:
				var east_node = nodes[current_index + 1]
				potential_edges.append([current_node, east_node])
			#south
			if i < m - 1:
				var south_node = nodes[current_index + n]
				potential_edges.append([current_node, south_node])
			#west
			if j > 0:
				var west_node = nodes[current_index - 1]
				potential_edges.append([current_node, west_node])
			#North
			if i > 0:
				var north_node = nodes[current_index - n]
				potential_edges.append([current_node, north_node])
		potential_edges.shuffle()

	var index = 0
	for edge in potential_edges:
		if(index % 3 == 0 && graph[edge[0].id][edge[1].id] == 0 && graph[edge[1].id][edge[0].id] == 0):
			create_edge(edge[0], edge[1])
			union(edge[0], edge[1])
		index+=1

func _draw():
	for node in nodes:
		node.visualize(self)
		
func create_matrix(m, n):
	var matrix = []
	for i in range(m):
		var row = []
		for j in range(n):
			row.append(0)  # Initialize with zeros or any other value
		matrix.append(row)
	return matrix
	
func union(node_a, node_b):
	var absolute_parent_of_node_a = find(node_a)
	var absolute_parent_of_node_b = find(node_b)
	
	if(absolute_parent_of_node_a.equals(absolute_parent_of_node_b)):
		return
	if(rank[absolute_parent_of_node_a.id] < rank[absolute_parent_of_node_b.id]):
		parent[absolute_parent_of_node_a.id] = absolute_parent_of_node_b
	else:
		parent[absolute_parent_of_node_b.id] = absolute_parent_of_node_a
		rank[absolute_parent_of_node_a.id]+=1
	pass
	
# find absolute parent of node
func find(node):
	if parent[node.id].equals(node):
		return node
	var root = find(parent[node.id])
	parent[node.id] = root
	return root
	
func path_exists(node_a, node_b):
	return find(node_a).equals(find(node_b))
	
	
