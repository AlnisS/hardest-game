extends Spatial

signal level_finished


func _on_EndArea_body_entered(body):
	emit_signal("level_finished")

