extends ColorPickerButton

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_pointColorPicker_color_changed(color):
	CH.pointColorOfSelectedCurve = color
	CH.update()
