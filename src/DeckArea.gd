extends Area2D

func _on_DeckArea_body_entered(body):
	if body.has_node("DeckListener"):
		body.get_node("DeckListener").on_deck = true

func _on_DeckArea_body_exited(body):
	if body.has_node("DeckListener"):
		body.get_node("DeckListener").on_deck = false
