extends KinematicBody2D

class_name Player

const walking_accel: float = 5000.0
const ocean_friction: float = 2000.0
const deck_friction: float = 500.0
const ocean_max_speed: float = 300.0
const deck_ocean_max_speed: float = 400.0
const water_time: float = 15.0

var cur_friction = ocean_friction
var cur_max_speed = ocean_max_speed
var _vel := Vector2()
var warmth: float = 1.0
var heating_up: bool = false

# warmed
func started_warming():
	heating_up = true

func stopped_warming():
	heating_up = false

func warm_up(amount: float):
	warmth += amount
	warmth = clamp(warmth, 0.0, 1.0)

func _physics_process(delta):
	if not $DeckListener.on_deck:
		warmth -= delta / water_time
	if warmth < 0.0:
		get_tree().reload_current_scene()
	
	var horizontal: float = Input.get_action_strength("g_right") - Input.get_action_strength("g_left")
	var vertical: float = Input.get_action_strength("g_down") - Input.get_action_strength("g_up")
	
	var movement := Vector2(horizontal, vertical)

	$FourDirectionSprite.movement = movement

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
	
	_vel = move_and_slide(Util.fourize(_vel))


func _on_DeckListener_entered_deck():
	$WaterTrail.leaving_trail = true
	cur_friction = deck_friction
	cur_max_speed = deck_ocean_max_speed

func _on_DeckListener_exited_deck():
	$WaterTrail.leaving_trail = false
	cur_friction = ocean_friction
	cur_max_speed = ocean_max_speed

# fullfills aggros guards
func push(push: Vector2):
	_vel += push
func harm(amount: float):
	self.warmth -= amount
