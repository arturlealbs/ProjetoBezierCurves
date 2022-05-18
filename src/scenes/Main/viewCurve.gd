extends CheckBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_viewCurve_pressed():
	CH.drawCurve = !CH.drawCurve
	CH.update()
