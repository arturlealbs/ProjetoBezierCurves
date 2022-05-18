extends Node2D

var num_evals := 2
var scene := []
var selectedIndex := -1
var drawPoints := true
var drawLines := true
var drawCurve := true
var selectedPoint
var isSelected := false


func _on_addButton_pressed():
	print("Adicionou")
	scene.append(BezierCurve.new())
	selectedIndex += 1
	update()

func _on_delButton_pressed():
	print("Deletou")
	if(selectedIndex != -1):
		scene.pop_at(selectedIndex)
		selectedIndex = len(scene) - 1
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
	num_evals = value
	if selectedIndex >= 0:
		scene[selectedIndex].updateCurvePoints(num_evals)
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
						scene[selectedIndex].updateCurvePoints(num_evals)
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
								scene[selectedIndex].updateCurvePoints(num_evals)
							else:
								scene.remove(selectedIndex)
								selectedIndex -= 1
							update()
							break
				
	if isSelected:
		scene[selectedIndex].controlPoints[selectedPoint] = event.position
		scene[selectedIndex].updateCurvePoints(num_evals)
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
