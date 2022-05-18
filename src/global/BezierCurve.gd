class_name BezierCurve

var controlPoints := []
var curvePoints := PoolVector2Array()

func linearInterpolate(A: Vector2, B: Vector2, t: float) -> Vector2:
	return (1-t)*A + t*B

func getPoint(t: float) -> Vector2:
	var aux := PoolVector2Array(controlPoints)
	for i in range(len(aux) - 1):
		for j in range(len(aux) - 1 - i):
			aux[j] = linearInterpolate(aux[j], aux[j+1], t)
	return aux[0]

func updateCurvePoints(num_evals: int) -> void:
	var t := 0.0
	var delta := 1.0/(num_evals-1)
	var newCurvePoints := PoolVector2Array()

	for _i in range(num_evals):
		newCurvePoints.append(getPoint(t))
		t += delta
	self.curvePoints = newCurvePoints
