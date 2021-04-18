extends Area2D

func _process(delta):
	for b in get_overlapping_bodies():
		if b.is_in_group("warmed"):
			b.warm_up(delta/3.0)


func _on_HeatBarrel_body_entered(body):
	if body.is_in_group("warmed"):
		body.started_warming()

func _on_HeatBarrel_body_exited(body):
	if body.is_in_group("warmed"):
		body.stopped_warming()
