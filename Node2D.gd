extends Node2D

var eval := 2
var scene := []
var selectedIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true
var selectedPoint
var isSelected := false

class BezierCurve:
	var controlPoints := []
	var isSelected := true
	var curvePoints := []

func linearInterpolate(A: Vector2, B: Vector2, t: float) -> Vector2:
	return (1-t)*A + t*B

func getBezierCurvePoint(bezierCurve: BezierCurve, t: float) -> Vector2:
	var aux: Array = bezierCurve.controlPoints.duplicate(true)
	for i in range(len(aux) - 1):
		for j in range(len(aux) - 1 - i):
			aux[j] = linearInterpolate(aux[j], aux[j+1], t)
	return aux[0]

func getBezierCurvePoints(bezierCurve: BezierCurve, num_evals: int) -> PoolVector2Array:
	var t := 0.0
	var curve := PoolVector2Array()
	for _i in range(num_evals):
		curve.append(getBezierCurvePoint(bezierCurve, t))
		t += float(1)/(num_evals-1)
	return curve

func _on_addButton_pressed():
	print("Adicionou")
	scene.append(BezierCurve.new())
	selectedIndex = len(scene) - 1
	update()

func _on_delButton_pressed():
	print("Deletou")
	scene.pop_at(selectedIndex)
	selectedIndex -= 1
	update()

func _on_prevButton_pressed():
	print("voltou")
	if selectedIndex == 0:
		selectedIndex = len(scene) - 1
	else:
		selectedIndex -= 1
	update()

func _on_nextButton_pressed():
	print("avancou")
	if selectedIndex == len(scene) - 1:
		selectedIndex = 0
	else:
		selectedIndex += 1
	update()

func _on_evalButton_value_changed(value):
	eval = value
	if selectedIndex >= 0:
		scene[selectedIndex].curvePoints = getBezierCurvePoints(scene[selectedIndex],eval)
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

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				if selectedIndex > - 1:
					if event.position[0] > 115:
						scene[selectedIndex].controlPoints.append(event.position)
						scene[selectedIndex].curvePoints = getBezierCurvePoints(scene[selectedIndex],eval)
						update()
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if selectedIndex > -1:
					for i in range(len(scene[selectedIndex].controlPoints)):
						if event.position.distance_to(scene[selectedIndex].controlPoints[i]) < 7:
							isSelected = !isSelected
							selectedPoint = i
							break
		if event.button_index == BUTTON_MIDDLE:
			if event.pressed:
				if selectedIndex > -1:
					for i in range(len(scene[selectedIndex].controlPoints)):
						if event.position.distance_to(scene[selectedIndex].controlPoints[i]) < 7:
							scene[selectedIndex].controlPoints.remove(i)
							if len(scene[selectedIndex].controlPoints) > 0:
								scene[selectedIndex].curvePoints = getBezierCurvePoints(scene[selectedIndex],eval)
							else:
								scene.remove(selectedIndex)
								selectedIndex -= 1
							update()
							break
				
	if isSelected:
		scene[selectedIndex].controlPoints[selectedPoint] = event.position
		scene[selectedIndex].curvePoitns = getBezierCurvePoints(scene[selectedIndex],eval)
		update()

func _draw() -> void:
	for polygon in scene:
		if scene[selectedIndex] == polygon:
			if drawCurve:
				if len(polygon.controlPoints) > 2:	
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
				if len(polygon.controlPoints) > 2:
					for point in range(len(polygon.curvePoints) - 1):
						draw_line(polygon.curvePoints[point], polygon.curvePoints[point + 1], Color(0.35,0.35,0.35,1), 2)
			if drawPoints:
				for point in polygon.controlPoints:
					draw_circle(point, 5, Color(0.35, 0.35, 0.35, 1))
			if drawLines:
				if len(polygon.controlPoints) > 1:
					for vertex in range (len(polygon.controlPoints) - 1):
						draw_line(polygon.controlPoints[vertex], polygon.controlPoints[vertex + 1], Color(0.35, 0.35, 0.35, 1), 1)
