extends Node2D

var num_evals := 2
var bezierCurves := []
var selectedIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true
var selectedPointIndex
var isSelected := false


func _on_addButton_pressed():
	print("Adicionou")
	bezierCurves.append(BezierCurve.new())
	selectedIndex += 1
	update()

func _on_delButton_pressed():
	print("Deletou")
	if(selectedIndex != -1):
		bezierCurves.pop_at(selectedIndex)
		selectedIndex = len(bezierCurves) - 1
	update()

func _on_prevButton_pressed():
	print("voltou")
	if selectedIndex == 0:
		selectedIndex = len(bezierCurves) - 1
	else:
		selectedIndex -= 1
	update()

func _on_nextButton_pressed():
	print("avancou")
	if selectedIndex == len(bezierCurves) - 1:
		selectedIndex = 0
	else:
		selectedIndex += 1
	update()

func _on_evalButton_value_changed(value):
	num_evals = value
	if selectedIndex >= 0:
		bezierCurves[selectedIndex].updateCurvePoints(num_evals)
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
	for i in range(len(bezierCurves[selectedIndex].controlPoints)):
		if mousePosition.distance_to(bezierCurves[selectedIndex].controlPoints[i]) < 7:
			return i
	return -1

func isCurveEdition(event: InputEvent) -> bool:
	return (event is InputEventMouseButton
		and event.pressed
		and event.position[0] > 115
		and selectedIndex >= 0)

func isAddControlPoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_RIGHT

func isToggleDragPoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_LEFT

func isDeletePoint(event: InputEvent) -> bool:
	return isCurveEdition(event) and event.button_index == BUTTON_MIDDLE

# TODO: always do curve = bezierCurves[selectedIndex]
func _input(event):

	if isAddControlPoint(event):
		bezierCurves[selectedIndex].controlPoints.append(event.position)
		bezierCurves[selectedIndex].updateCurvePoints(num_evals)
		update()
	
	elif isToggleDragPoint(event):
		selectedPointIndex = getSelectedPointIndex(event.position)
		if selectedPointIndex != -1:
			isSelected = !isSelected
	
	elif isDeletePoint(event):
		for i in range(len(bezierCurves[selectedIndex].controlPoints)):
			if event.position.distance_to(bezierCurves[selectedIndex].controlPoints[i]) < 7:
				bezierCurves[selectedIndex].controlPoints.remove(i)
				if len(bezierCurves[selectedIndex].controlPoints) > 0:
					bezierCurves[selectedIndex].updateCurvePoints(num_evals)
				else:
					bezierCurves.remove(selectedIndex)
					selectedIndex -= 1
				update()
				break

	if isSelected:
		bezierCurves[selectedIndex].controlPoints[selectedPointIndex] = event.position
		bezierCurves[selectedIndex].updateCurvePoints(num_evals)
		update()

func _draw() -> void:
	for polygon in bezierCurves:
		if bezierCurves[selectedIndex] == polygon:
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
