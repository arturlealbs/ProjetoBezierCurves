extends Node2D

var eval := 2
var scene := []
var selectedIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true
var selectedPoint
var isSelected := false

class ControlPoints:
	var points := []
	var isSelected := true
	var bezierCurve := []

func linearInterpolate(A: Vector2, B: Vector2, t: float) -> Vector2:
	return (1-t)*A + t*B

func getBezierCurvePoints(controlPoints: ControlPoints, num_evals: int) -> PoolVector2Array:
	var t := 0.0
	var bezierCurve := PoolVector2Array()
	for _j in range(num_evals+1):
		var aux : Array = controlPoints.points
		while(len(aux) > 1):
			var temp := []
			for i in range(0, len(aux) - 1):
				temp.append(linearInterpolate(aux[i], aux[i+1], t))
			aux = temp
		t += float(1)/num_evals
		bezierCurve.append(aux[0])
	return(bezierCurve)

func _on_addButton_pressed():
	print("Adicionou")
	scene.append(ControlPoints.new())
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
		scene[selectedIndex].bezierCurve = getBezierCurvePoints(scene[selectedIndex],eval)
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
						scene[selectedIndex].points.append(event.position)
						scene[selectedIndex].bezierCurve = getBezierCurvePoints(scene[selectedIndex],eval)
						update()
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if selectedIndex > -1:
					for i in range(len(scene[selectedIndex].points)):
						if event.position.distance_to(scene[selectedIndex].points[i]) < 7:
							isSelected = !isSelected
							selectedPoint = i
							break
		if event.button_index == BUTTON_MIDDLE:
			if event.pressed:
				if selectedIndex > -1:
					for i in range(len(scene[selectedIndex].points)):
						if event.position.distance_to(scene[selectedIndex].points[i]) < 7:
							scene[selectedIndex].points.remove(i)
							if len(scene[selectedIndex].points) > 0:
								scene[selectedIndex].bezierCurve = getBezierCurvePoints(scene[selectedIndex],eval)
							else:
								scene.remove(selectedIndex)
								selectedIndex -= 1
							update()
							break
				
	if isSelected:
		scene[selectedIndex].points[selectedPoint] = event.position
		scene[selectedIndex].bezierCurve = getBezierCurvePoints(scene[selectedIndex],eval)
		update()

func _draw() -> void:
	for polygon in scene:
		if scene[selectedIndex] == polygon:
			if drawCurve:
				if len(polygon.points) > 2:	
					for point in range(len(polygon.bezierCurve) - 1):
						draw_line(polygon.bezierCurve[point], polygon.bezierCurve[point + 1], Color(0,1,0), 2)
			if drawPoints:
				for point in polygon.points:
					draw_circle(point, 5, Color(1,0,0))
			if drawLines:
				if len(polygon.points) > 1:
					for vertex in range (len(polygon.points) - 1):
						draw_line(polygon.points[vertex], polygon.points[vertex + 1], Color(1,0,0),1)
		else:
			if drawCurve:
				if len(polygon.points) > 2:
					for point in range(len(polygon.bezierCurve) - 1):
						draw_line(polygon.bezierCurve[point], polygon.bezierCurve[point + 1], Color(0.35,0.35,0.35,1), 2)
			if drawPoints:
				for point in polygon.points:
					draw_circle(point, 5, Color(0.35, 0.35, 0.35, 1))
			if drawLines:
				if len(polygon.points) > 1:
					for vertex in range (len(polygon.points) - 1):
						draw_line(polygon.points[vertex], polygon.points[vertex + 1], Color(0.35, 0.35, 0.35, 1), 1)
