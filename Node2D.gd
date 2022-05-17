extends Node2D

class ControlPoints:
	var points = []
	var isSelected := true
	var bezierCurve := []
	
func interpolate(p0, p1, te):
	return(Vector2((1-te)*p0[0] + te*p1[0],
		(1-te)*p0[1] + te*p1[1]))

func bezierEquation(controlPoints, evaluation):
	var t = 0
	var bezierCurve = []
	for _j in range(evaluation+1):
		var aux = controlPoints.points
		while(len(aux) > 1):
			var temp = []
			for i in range(0, len(aux) - 1):
				temp.append(interpolate(aux[i], aux[i+1], t))
			aux = temp
		t += float(1)/evaluation
		bezierCurve.append(aux[0])
	return(bezierCurve)

var eval := 100
var scene := []
var selectedIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true

func _on_addButton_pressed():
	print("Adicionou")
	scene.append(ControlPoints.new())
	selectedIndex += 1
	update()

func _on_delButton_pressed():
	print("Deletou")
	scene.pop_at(selectedIndex)
	selectedIndex -= 1
	update()

func _on_prevButton_pressed():
	print("voltou")
	if selectedIndex == len(scene) - 1:
		selectedIndex = 0
	else:
		selectedIndex += 1
	update()

func _on_nextButton_pressed():
	print("avancou")
	if selectedIndex == 0:
		selectedIndex = len(scene) - 1
	else:
		selectedIndex -= 1
	update()

func _on_evalButton_value_changed(value):
	eval = value
	if selectedIndex >= 0:
		scene[selectedIndex].bezierCurve = bezierEquation(scene[selectedIndex],eval)
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
		if event.pressed:
			if len(scene) == 0:
				pass
			else:
				if event.position[0] > 115:
					scene[selectedIndex].points.append(event.position)
					scene[selectedIndex].bezierCurve = bezierEquation(scene[selectedIndex],eval)
					update()

func _draw() -> void:
	for polygon in scene:
		if scene[selectedIndex] == polygon:
			if drawPoints:
				for point in polygon.points:
					draw_circle(point, 5, Color(1,0,0))
			if drawLines:
				if len(polygon.points) > 1:
					for vertex in range (len(polygon.points) - 1):
						draw_line(polygon.points[vertex], polygon.points[vertex + 1], Color(1,0,0),1)
			if drawCurve:
				if len(polygon.points) > 2:	
					for point in range(len(polygon.bezierCurve) - 1):
						draw_line(polygon.bezierCurve[point], polygon.bezierCurve[point + 1], Color(0,1,0), 4)
		else:
			if drawPoints:
				for point in polygon.points:
					draw_circle(point, 5, Color(0.35, 0.35, 0.35, 1))
			if drawLines:
				if len(polygon.points) > 1:
					for vertex in range (len(polygon.points) - 1):
						draw_line(polygon.points[vertex], polygon.points[vertex + 1], Color(0.35, 0.35, 0.35, 1), 1)
			if drawCurve:
				if len(polygon.points) > 2:
					for point in range(len(polygon.bezierCurve) - 1):
						draw_line(polygon.bezierCurve[point], polygon.bezierCurve[point + 1], Color(0.35,0.35,0.35,1), 4)
