extends KinematicBody2D

class_name Player

const walking_accel: float = 5000.0
const ocean_friction: float = 2000.0
const deck_friction: float = 500.0
const ocean_max_speed: float = 300.0
const deck_ocean_max_speed: float = 400.0

var cur_friction = ocean_friction
var cur_max_speed = ocean_max_speed
var _vel := Vector2()

func entered_deck():
	$WaterTrail.leaving_trail = true
	cur_friction = deck_friction
	cur_max_speed = deck_ocean_max_speed

func exited_deck():
	$WaterTrail.leaving_trail = false
	cur_friction = ocean_friction
	cur_max_speed = ocean_max_speed

func _physics_process(delta):
	var horizontal: float = Input.get_action_strength("g_right") - Input.get_action_strength("g_left")
	var vertical: float = Input.get_action_strength("g_down") - Input.get_action_strength("g_up")
	
	var movement := Vector2(horizontal, vertical)

	if abs(movement.x) > 0.1:
		$Sprite.flip_h = movement.x < 0.0

	var accel := Vector2()
	accel += movement * (walking_accel + ocean_friction)
	accel += cur_friction * -_vel.normalized()
	
	_vel += accel * delta
	
	# ocean_friction fully stops vel
	if _vel.length() < ocean_friction*delta:
		_vel = Vector2()
	
	# max vel
	if _vel.length() > cur_max_speed:
		_vel = _vel.normalized() * cur_max_speed
	
	_vel = move_and_slide(_vel)
