extends ColorPickerButton

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_lineColorPicker_color_changed(color):
	CH.lineColorOfSelectedCurve = color
	CH.update()
