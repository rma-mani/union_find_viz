extends Node2D

var circle_radius : int = 4
var nodes = []
var edges = []
var m = 12  #Number of rows, 12
var n = 22 #Number of columns, 22


var graph
var parent = []
var rank = []

var id_to_node = {}


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
			
			id_to_node[id] = temp
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
	
func get_path_from_to(u, v) -> Array:
	return []
	
func extract_nodeid_in_component(u) -> Array:
	var nodes = []
	var parent_of_u = parent[u.id]
	for i in range(parent.size()):
		if parent[i].equals(parent_of_u):
			nodes.append(i)
	return nodes
	
#edges are returned as the id of the nodes, so not [node_ref1, node_ref2] but [node_id1, node_id2]
func extract_edges_in_component(u, node_ids) -> Array:
	var edges = []
	for node_id in node_ids:
		for j in range(m*n+1):
			if(graph[node_id][j] != 0):
				edges.append(Vector2(node_id, j))
				edges.append(Vector2(j, node_id))
	return edges
	
func dfs_path(subgraph, nodes, s, t) -> Array:
	var stack =[[s, [s]]]
	var visited = {}
	for i in range(m*n+1):
		visited[i] = false
	while !stack.is_empty():
		var pop = stack.pop_front()  # Pop the top node and the path to reach it
		var node = pop[0]
		var path = pop[1]
		if node==t:
			return path # If node is the target, return the path
		if visited[node]:
			continue  # Skip visited nodes
		visited[node] = true  # Mark the node as visited
		for i in range(m*n+1):
			if subgraph[node][i] != 0 && visited[i] == false:
				var new_path = path.duplicate()
				new_path.append(i)
				stack.push_front([i, new_path]) # Push neighbor and updated path onto the stack
	return []  # Return None if no path is found

func bfs_path(graph, start, goal):
	var queue = []
	var visited = {}
	var predecessors = {}
	for i in range(m*n+1):
		visited[i] = false
	queue.append(start)
	visited[start] = true
	predecessors[start] = null
	while queue.size() > 0:
		var current = queue.pop_front()
		
		if current == goal:
			return reconstruct_path(predecessors, start, goal)
		
		for i in range(m*n + 1):
			if graph[current][i] != 0 && visited[i] == false:
				queue.append(i)
				visited[i] = true
				predecessors[i] = current
	
	return []

func reconstruct_path(predecessors, start, goal):
	var path = []
	var current = goal
	
	while current != null:
		path.append(current)
		current = predecessors[current]
	
	path.reverse()
	return path
