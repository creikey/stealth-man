extends Node2D

export var _color := Color(1, 1, 1)
export var _width: float = 10.0

const _frames_between_points: int = 2
const _max_points: int = 15

var leaving_trail: bool = false
var _water_points: Array = []
var _frame_count: int = 0


class WaterPoint:
	var life: float = 1.0
	var global_position := Vector2()
	var end_of_trail: bool = false

func _process(_delta):
	update() # update every frame so line stays in global coords
	_frame_count += 1
	if leaving_trail:
		if _frame_count >= _frames_between_points:
			_frame_count = 0
			
			var new_point := WaterPoint.new()
			new_point.global_position = global_position
			_water_points.append(new_point)

			if _water_points.size() > _max_points:
				_water_points.remove(0)
		elif _water_points.size() >= 1:
			_water_points[_water_points.size() - 1].global_position = global_position
	elif _water_points.size() >= 1:
		_water_points[_water_points.size() - 1].end_of_trail = true

func _draw():
	draw_set_transform_matrix(global_transform.inverse())
	if _water_points.size() >= 2:
		
		var set_of_points: Array = [[]]
		for w in _water_points:
			set_of_points[set_of_points.size() - 1].append(w.global_position)
			if w.end_of_trail:
				set_of_points.append([])
		
		var set_of_colors: Array = []
		for p_array in set_of_points:
			set_of_colors.append(p_array.duplicate())
			for i in p_array.size():
				var new_color = _color
				new_color.a = (float(i) / float(p_array.size()))
				set_of_colors[set_of_colors.size() - 1][i] = new_color
		
		for i in set_of_points.size():
			if set_of_points[i].size() < 2:
				continue
			draw_polyline_colors(set_of_points[i], set_of_colors[i], _width, true)
