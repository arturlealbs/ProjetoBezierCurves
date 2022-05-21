extends Node2D

export(bool) var antialiased := true
export(bool) var hollowPoints := false

export(Color) var pointColorOfSelectedCurve := Color(1,1,1)
export(Color) var lineColorOfSelectedCurve  := Color(1,1,1)
export(Color) var curveColorOfSelectedCurve := Color(0.98,0.26,0.54)
export(Color) var colorOfUnselectedCurve := Color(0.09, 0.081, 0.148, 1)
export(Color) var backgroundColor := Color(0.04,0.031,0.098)

export(int) var pointRadius := 5
export(int) var lineWidth := 2
export(int) var curveWidth := 4

var num_evals := 20
var bezierCurves := [] # array of BezierCurve
var selectedCurveIndex := -1
var selectedPointIndex
var drawPoints := true
var drawLines := true
var drawCurve := true
var isDraggingPoint := false


func getSelectedPointIndex(mousePosition: Vector2) -> int:
	# TODO: use squared distance
	# TODO: use for controlPoint in selectedCurve.controlPoints
	var allowedDistance := pointRadius + 2
	var allowedDistanceSquared := allowedDistance*allowedDistance

	var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
	var i := 0
	for controlPoint in selectedCurve.controlPoints:
		if mousePosition.distance_squared_to(controlPoint) <= allowedDistanceSquared:
			return i
		i += 1
	return -1

func isCurveCondition(event: InputEvent) -> bool:
	return (event is InputEventMouseButton
		and event.pressed
		and event.position[0] > 138
		and selectedCurveIndex >= 0)

func isAddControlPoint(event: InputEvent) -> bool:
	return isCurveCondition(event) and event.button_index == BUTTON_RIGHT

func isToggleDragPoint(event: InputEvent) -> bool:
	return isCurveCondition(event) and event.button_index == BUTTON_LEFT

func isDeletePoint(event: InputEvent) -> bool:
	return isCurveCondition(event) and event.button_index == BUTTON_MIDDLE

func _input(event):

	if isAddControlPoint(event):
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		selectedCurve.controlPoints.append(event.position)
		selectedCurve.updateCurvePoints(num_evals)
		update()
	
	elif isToggleDragPoint(event):
		selectedPointIndex = getSelectedPointIndex(event.position)
		if selectedPointIndex != -1:
			isDraggingPoint = !isDraggingPoint
		update()
	
	elif isDeletePoint(event):
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		var i = getSelectedPointIndex(event.position)
		if i != -1:
			selectedCurve.controlPoints.remove(i)
			if len(selectedCurve.controlPoints) > 0:
				selectedCurve.updateCurvePoints(num_evals)
			else:
				bezierCurves.remove(selectedCurveIndex)
				selectedCurveIndex = len(bezierCurves) - 1
			update()

	if isDraggingPoint:
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]
		selectedCurve.controlPoints[selectedPointIndex] = event.position
		selectedCurve.updateCurvePoints(num_evals)
		update()

func drawLinesOf(curve: BezierCurve, color: Color, width: float, antialiased: bool) -> void:
	if len(curve.controlPoints) > 1:
		for i in range (len(curve.controlPoints) - 1):
			draw_line(curve.controlPoints[i], curve.controlPoints[i + 1], color, width, antialiased)

func drawCurveOf(curve: BezierCurve, color: Color, width: float, antialiased: bool) -> void:
	if len(curve.controlPoints) > 2:
		for i in range(len(curve.curvePoints) - 1):
			draw_line(curve.curvePoints[i], curve.curvePoints[i + 1], color, width, antialiased)

func drawControlPointsOf(curve: BezierCurve, radius: float, color: Color, selected: bool) -> void:
	for point in curve.controlPoints:
		if isDraggingPoint:
			if selected and point == curve.controlPoints[selectedPointIndex]:
				draw_circle(point, radius + 2, color)
			else:
				draw_circle(point, radius, color)
		else:
			draw_circle(point, radius, color)
			
func drawHollowControlPointsOf(curve: BezierCurve, radius: float, color: Color, selected: bool) -> void:
	for point in curve.controlPoints:
		if isDraggingPoint:
			if point == curve.controlPoints[selectedPointIndex] and selected:
				draw_arc(point, radius + 4, 0, TAU, 20, color,3)
				draw_circle(point, radius + 2, backgroundColor)
			else:
				draw_arc(point, radius + 2, 0, TAU, 20, color,3)
				draw_circle(point, radius, backgroundColor)
		else:
			draw_arc(point, radius + 2, 0, TAU, 20, color,3)
			draw_circle(point, radius, backgroundColor)
			
func drawCurveAsSelected(curve: BezierCurve) -> void:
	if drawLines:
		drawLinesOf(curve, lineColorOfSelectedCurve, lineWidth, self.antialiased)

	if drawCurve:
		drawCurveOf(curve, curveColorOfSelectedCurve, curveWidth, self.antialiased)

	if drawPoints:
		if hollowPoints:
			drawHollowControlPointsOf(curve, pointRadius, pointColorOfSelectedCurve, true)
		else:
			drawControlPointsOf(curve, pointRadius, pointColorOfSelectedCurve, true)

func drawCurveAsNotSelected(curve: BezierCurve) -> void:
	if drawLines:
		drawLinesOf(curve, colorOfUnselectedCurve, lineWidth, antialiased)

	if drawCurve:
		drawCurveOf(curve, colorOfUnselectedCurve, curveWidth, antialiased)

	if drawPoints:
		if hollowPoints:
			drawHollowControlPointsOf(curve, pointRadius, colorOfUnselectedCurve, false)
		else:
			drawControlPointsOf(curve, pointRadius, colorOfUnselectedCurve, false)

func _draw() -> void:
	for bezierCurve in bezierCurves:
		var selectedCurve: BezierCurve = bezierCurves[selectedCurveIndex]

		if bezierCurve == selectedCurve:
			drawCurveAsSelected(bezierCurve)

		else:
			drawCurveAsNotSelected(bezierCurve)
