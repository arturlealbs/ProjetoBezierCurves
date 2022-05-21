extends SpinBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_lineWidth_value_changed(value):
	CH.lineWidth = value
	CH.update()
