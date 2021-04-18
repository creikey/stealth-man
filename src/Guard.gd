extends KinematicBody2D

enum Direction {
	right,
	down,
	left,
	up,
}

export (Direction) var direction = Direction.down

const chase_accel: float = 700.0
const friction: float = 500.0


onready var _checks_for_player_area: Area2D = $ChecksForPlayerArea
onready var home_base: Vector2 = global_position

var aggro: bool = false
var vel := Vector2()

func _ready():
	$FourDirectionSprite.movement = Vector2(1, 0).rotated((float(direction)/4.0) * 2.0 * PI)

func _physics_process(delta):
	if not $DeckListener.on_deck:
		modulate.a -= delta/5.0
		if modulate.a <= 0.2:
			queue_free()
	if aggro:
		var aggro_bodies: Array = get_aggro_bodies()
		var chase_direction := (home_base - global_position).normalized()
		if aggro_bodies.size() > 0 and $DeckListener.on_deck:
			var to_go_towards = get_aggro_bodies()[0]
			chase_direction = (to_go_towards.global_position - global_position).normalized()
		vel += chase_direction * (chase_accel + friction) * delta
		vel += friction * -vel.normalized() * delta
		
		if chase_direction.length() < 0.1 and vel.length() < friction * delta:
			vel = Vector2()
		else:
			$FourDirectionSprite.movement = chase_direction
		
#		$FourDirectionSprite.movement = chase_direction
		vel = move_and_slide(Util.fourize(vel))
		for c in get_slide_count():
			var collision: KinematicCollision2D = get_slide_collision(c)
			if collision.collider.is_in_group("aggros_guards"):
				collision.collider.push(chase_direction.normalized() * 1000.0)
	else:
		for b in get_aggro_bodies():
			if not (b.global_position - global_position).normalized().dot(Vector2(1, 0).rotated($LightPivot.rotation)) > 0.8:
				continue
			var space_state = get_world_2d().direct_space_state
			var result: Dictionary = space_state.intersect_ray(global_position, b.global_position, [self])
			if not result.empty():
				aggro = true

func get_aggro_bodies() -> Array:
	var to_return: Array = []
	for b in _checks_for_player_area.get_overlapping_bodies():
		if not b.is_in_group("aggros_guards"):
			continue
		to_return.append(b)
	return to_return


func _on_FourDirectionSprite_quantized_angle_changed(new_quantized_angle):
	$LightPivot.rotation = new_quantized_angle
