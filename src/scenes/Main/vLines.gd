extends Button

onready var CH = get_parent().get_parent().get_parent().get_node("CurvesHandler")

func _on_vLines_pressed():
	CH.drawLines = !CH.drawLines
	CH.update()
