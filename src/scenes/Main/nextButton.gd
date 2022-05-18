extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_nextButton_pressed():
	print("avancou")
	if CH.selectedCurveIndex == len(CH.bezierCurves) - 1:
		CH.selectedCurveIndex = 0
	else:
		CH.selectedCurveIndex += 1
	update()
