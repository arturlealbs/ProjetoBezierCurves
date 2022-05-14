extends Node2D

var curve = []
var len_curve := 0
var t = 0
var evaluation := 100
var temp = []
var controlPoints = []
var i = 0
var center
var line = []

func interpolate(p0, p1, te):
	return([(1-te)*p0[0] + te*p1[0],
			(1-te)*p0[1] + te*p1[1]])

func bezierEquation():
	t = 0
	line = []
	while t < 1:
		controlPoints = curve
		while(len(controlPoints) > 1):
			temp = []
			i = 0
			while i < len(controlPoints) - 1:
				temp.append(interpolate(controlPoints[i], controlPoints[i+1], t))
				i += 1
			controlPoints = temp
		t += float(1)/evaluation
		line.append(Vector2(controlPoints[0][0],controlPoints[0][1]))
		
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			curve.append(event.position)
			len_curve += 1
			bezierEquation()
			update()

func _draw() -> void:
	for point in curve:
		draw_circle(point, 10, Color(1,0,0))
	if len_curve > 1:
		for vertex in range (len_curve - 1):
			draw_line(curve[vertex], curve[vertex + 1], Color(1,0,0))
		for point in range(len(line) - 1):
			draw_line(line[point], line[point + 1], Color(0,1,0))

