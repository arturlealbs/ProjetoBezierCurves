extends ColorPickerButton

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_curveColorPicker_color_changed(color):
	CH.curveColorOfSelectedCurve = color
	CH.update()
