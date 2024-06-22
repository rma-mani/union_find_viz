extends Button

# Ready function to initialize the button
func _ready():
	self.toggle_mode = true  # Enable toggle mode for the button
	self.pressed.connect(self._button_pressed)

func _button_pressed():
	NodeManager.button_toggled(self, true)
