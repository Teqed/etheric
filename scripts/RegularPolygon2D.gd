@tool # Allows editor to draw clouds
extends Node2D

@export var _center = Vector2(0, 0):
	set(new_center):
		_center = new_center

@export var _radius = 80:
	set(new_radius):
		_radius = new_radius

@export var _angle_from = 0:
	set(new_angle_from):
		_angle_from = new_angle_from

@export var _angle_to = 360:
	set(new_angle_to):
		_angle_to = new_angle_to

@export var _color = Color(1.0, 0.0, 0.0):
	set(new_color):
		_color = new_color

func _draw():
		draw_circle_arc_poly(_center, _radius, _angle_from, _angle_to, _color)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])
	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
