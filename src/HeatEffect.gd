extends TextureRect

var target: float = 0.0

func _process(delta):
	modulate.a = lerp(modulate.a, target, delta*3.0)
