extends Node2D

var from 
var to
var current_point : Vector2
var speed = 25 #in pixel/second

@onready var line = $Line2D

func _ready():
	line.default_color = Color(0,0,1)
	line.width = 2
	pass

func _process(delta):
	if current_point.distance_to(to) > speed * delta:
		var direction = (to - current_point).normalized()
		current_point += direction * speed * delta
		
		line.clear_points()
		line.add_point(from)
		line.add_point(current_point)
	else:
		line.clear_points()
		line.add_point(from)
		line.add_point(to)
		set_process(false)

func set_node(from, to):
	var direction = (from - to).normalized()
	self.from = from - direction*3
	self.to = to + direction*3
	line.clear_points()
	line.add_point(from)
	current_point = from
