extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_addButton_pressed():
	CH.bezierCurves.append(BezierCurve.new())
	CH.selectedCurveIndex = len(CH.bezierCurves) - 1
	CH.update()
