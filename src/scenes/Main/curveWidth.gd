extends SpinBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_curveWidth_value_changed(value):
	CH.curveWidth = value
	CH.update()
