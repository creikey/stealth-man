extends KinematicBody2D

const chase_accel: float = 700.0
const friction: float = 500.0

onready var _checks_for_player_area: Area2D = $ChecksForPlayerArea
onready var home_base: Vector2 = global_position

var facing_vector := Vector2(0, 1)
var aggro: bool = false
var vel := Vector2()

func _physics_process(delta):
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
		vel = move_and_slide(vel)
		for c in get_slide_count():
			var collision: KinematicCollision2D = get_slide_collision(c)
			if collision.collider.is_in_group("aggros_guards"):
				collision.collider.push(chase_direction.normalized() * 1000.0)
	else:
		for b in get_aggro_bodies():
			if not (b.global_position - global_position).normalized().dot(facing_vector.normalized()) > 0.8:
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

