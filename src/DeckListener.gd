extends Node

class_name DeckListener

signal entered_deck
signal exited_deck

var on_deck: bool = false setget set_on_deck

func set_on_deck(new_on_deck):
	if new_on_deck and not on_deck:
		emit_signal("entered_deck")
	elif not new_on_deck and on_deck:
		emit_signal("exited_deck")
	on_deck = new_on_deck
	
