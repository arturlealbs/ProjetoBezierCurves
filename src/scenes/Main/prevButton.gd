extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_prevButton_pressed():
	if CH.selectedCurveIndex == 0:
		CH.selectedCurveIndex = len(CH.bezierCurves) - 1
	else:
		CH.selectedCurveIndex -= 1
	CH.update()
