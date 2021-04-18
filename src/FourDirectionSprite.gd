extends Node2D

signal quantized_angle_changed(new_quantized_angle)

var movement := Vector2() setget set_movement

# snapped to 0, 90, 180, or -90 degrees in radians
func get_quantized_angle() -> float:
	# I tried getting the currently playing animation from AnimationPlayer, but
	# that seems to not work well with AnimationTree. There also does not seem
	# to be an easy way to get this information from AnimationTree either.
	#return round((movement.angle()/(2.0*PI))) * (2.0*PI)
	return round(movement.angle()/(PI/2.0)) * (PI/2.0)

func set_movement(new_movement):
	var angle_before: float = get_quantized_angle()
	movement = new_movement
	if abs(angle_before - get_quantized_angle()) > 0.01:
		emit_signal("quantized_angle_changed", get_quantized_angle())
	if has_node("AnimationTree") and movement.length() > 0.1:
		$AnimationTree.set("parameters/blend_position", movement)
