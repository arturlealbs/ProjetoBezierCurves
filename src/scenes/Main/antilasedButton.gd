extends CheckBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_antilasedButton_pressed():
	CH.antialiased = !CH.antialiased
	CH.update()
