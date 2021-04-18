extends CanvasLayer

export (NodePath) var player_path

onready var player: Player = get_node(player_path)

func _process(delta):
	$ColdBar.value = player.warmth
	$HeatEffect.target = player.heating_up
