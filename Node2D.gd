extends Node2D

var num_evals := 2
var bezierCurves := []
var selectedCurveIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true
var selectedPointIndex
var isSelected := false


func _on_addButton_pressed():
	print("Adicionou")
	bezierCurves.append(BezierCurve.new())
	selectedCurveIndex += 1
	update()

func _on_delButton_pressed():
	print("Deletou")
	if(selectedCurveIndex != -1):
		bezierCurves.pop_at(selectedCurveIndex)
		selectedCurveIndex = len(bezierCurves) - 1
	update()

func _on_prevButton_pressed():
	print("voltou")
	if selectedCurveIndex == 0:
		selectedCurveIndex = len(bezierCurves) - 1
	else:
		selectedCurveIndex -= 1
	update()

func _on_nextButton_pressed():
	print("avancou")
	if selectedCurveIndex == len(bezierCurves) - 1:
		selectedCurveIndex = 0
	else:
		selectedCurveIndex += 1
	update()

func _on_evalButton_value_changed(value):
	num_evals = value
	if selectedCurveIndex >= 0:
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		selectedCurve.updateCurvePoints(num_evals)
	update()

func _on_viewPoints_pressed():
	drawPoints = !drawPoints
	update()

func _on_viewPolygon_pressed():
	drawLines = !drawLines
	update()

func _on_viewCurve_pressed():
	drawCurve = !drawCurve
	update()

func getSelectedPointIndex(mousePosition: Vector2) -> int:
	# TODO: use squared distance
	# TODO: use for controlPoint in selectedCurve.controlPoints
	var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
	for i in range(len(selectedCurve.controlPoints)):
		if mousePosition.distance_to(selectedCurve.controlPoints[i]) < 7:
			return i
	return -1

func isCurveEdition(event: InputEvent) -> bool:
	return (event is InputEventMouseButton
		and event.pressed
		and event.position[0] > 115
		and selectedCurveIndex >= 0)

func isAddControlPoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_RIGHT

func isToggleDragPoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_LEFT

func isDeletePoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_MIDDLE

func _input(event):

	if isAddControlPoint(event):
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		selectedCurve.controlPoints.append(event.position)
		selectedCurve.updateCurvePoints(num_evals)
		update()
	
	elif isToggleDragPoint(event):
		selectedPointIndex = getSelectedPointIndex(event.position)
		if selectedPointIndex != -1:
			isSelected = !isSelected
	
	elif isDeletePoint(event):
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		for i in range(len(selectedCurve.controlPoints)):
			if event.position.distance_to(selectedCurve.controlPoints[i]) < 7:
				selectedCurve.controlPoints.remove(i)
				if len(selectedCurve.controlPoints) > 0:
					selectedCurve.updateCurvePoints(num_evals)
				else:
					bezierCurves.remove(selectedCurveIndex)
					selectedCurveIndex -= 1
					selectedCurve = bezierCurves[selectedCurveIndex]
				update()
				break

	if isSelected:
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		selectedCurve.controlPoints[selectedPointIndex] = event.position
		selectedCurve.updateCurvePoints(num_evals)
		update()

func _draw() -> void:
	for polygon in bezierCurves:
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		if selectedCurve == polygon:
			if drawCurve:
				if len(polygon.controlPoints) > 1:	
					for point in range(len(polygon.curvePoints) - 1):
						draw_line(polygon.curvePoints[point], polygon.curvePoints[point + 1], Color(0,1,0), 2)
			if drawPoints:
				for point in polygon.controlPoints:
					draw_circle(point, 5, Color(1,0,0))
			if drawLines:
				if len(polygon.controlPoints) > 1:
					for vertex in range (len(polygon.controlPoints) - 1):
						draw_line(polygon.controlPoints[vertex], polygon.controlPoints[vertex + 1], Color(1,0,0),1)
		else:
			if drawCurve:
				if len(polygon.controlPoints) > 1:
					for point in range(len(polygon.curvePoints) - 1):
						draw_line(polygon.curvePoints[point], polygon.curvePoints[point + 1], Color(0.35,0.35,0.35,1), 2)
			if drawPoints:
				for point in polygon.controlPoints:
					draw_circle(point, 5, Color(0.35, 0.35, 0.35, 1))
			if drawLines:
				if len(polygon.controlPoints) > 1:
					for vertex in range (len(polygon.controlPoints) - 1):
						draw_line(polygon.controlPoints[vertex], polygon.controlPoints[vertex + 1], Color(0.35, 0.35, 0.35, 1), 1)
