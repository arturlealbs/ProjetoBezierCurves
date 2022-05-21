extends SpinBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_pointRadius_value_changed(value):
	CH.pointRadius = value
	CH.update()
