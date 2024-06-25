extends Node2D

var id: int
var is_hovering : bool = false
var selected : bool = false

const circle_radius : int = 3

func visualize(node):
	var text_position = Vector2(position.x, position.y)  # Adjust the offset as needed
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size	
	# here turn label on and off
	# ↓
	#node.draw_string(default_font, text_position, str(id),  HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size-3, Color(1, 0, 0))

	if(is_hovering):
		node.draw_circle(self.position, circle_radius*2, Color(1, 0, 0))  # Blue circle for the node
		is_hovering = false;
	else:
		node.draw_arc(self.position, circle_radius, 0, 360, 200, Color(0, 0, 0))  # Blue circle for the node
	#draw_string($Font, Vector2.ZERO, str(id), Color(1, 1, 1))  # Node ID

func equals(other_node) -> bool:
	if(self.id == other_node.id):
		return true
	else:
		return false
