extends CheckBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_viewPolygon_pressed():
	CH.drawLines = !CH.drawLines
	CH.update()
