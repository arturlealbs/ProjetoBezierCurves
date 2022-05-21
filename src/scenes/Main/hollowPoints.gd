extends CheckBox

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_hollowPoints_pressed():
	CH.hollowPoints = !CH.hollowPoints
	CH.update()
