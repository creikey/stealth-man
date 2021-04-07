extends Area2D



func _on_DeckArea_body_entered(body):
	if body is Player:
		body.entered_deck()

func _on_DeckArea_body_exited(body):
	if body is Player:
		body.exited_deck()
