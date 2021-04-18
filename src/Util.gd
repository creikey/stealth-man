extends Node

class_name Util

static func fourize(v: Vector2) -> Vector2:
	if abs(v.x) > abs(v.y):
		return Vector2(v.x, 0.0)
	elif abs(v.y) > abs(v.x):
		return Vector2(0.0, v.y)
	else:
		return Vector2(0.0, 0.0)
