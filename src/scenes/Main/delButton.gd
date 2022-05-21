extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_delButton_pressed():
	if(CH.selectedCurveIndex != -1):
		CH.bezierCurves.remove(CH.selectedCurveIndex)
		CH.selectedCurveIndex = len(CH.bezierCurves) - 1
	CH.update()
