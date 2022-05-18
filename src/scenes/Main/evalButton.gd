extends SpinBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_evalButton_value_changed(value):
	CH.num_evals = value
	if CH.selectedCurveIndex >= 0:
		var selectedCurve: BezierCurve = CH.bezierCurves[CH.selectedCurveIndex]
		selectedCurve.updateCurvePoints(CH.num_evals)
	CH.update()
