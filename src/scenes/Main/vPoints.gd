extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_vPoints_pressed():
	CH.drawPoints = !CH.drawPoints
	CH.update()
