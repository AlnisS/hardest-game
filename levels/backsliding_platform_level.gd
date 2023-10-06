extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var p1 = $MovingPlatform.duplicate()
	add_child(p1)
	var p2 = $MovingPlatform.duplicate()
	add_child(p2)
	var p3 = $MovingPlatform.duplicate()
	add_child(p3)
	
	var p4 = $MovingPlatform.duplicate()
	add_child(p4)
	var p5 = $MovingPlatform.duplicate()
	add_child(p5)
	var p6 = $MovingPlatform.duplicate()
	add_child(p6)
	var p7 = $MovingPlatform.duplicate()
	add_child(p7)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	p1.get_node("AnimationPlayer").advance(1.0 / 1.16667 * 2.0)
	p2.get_node("AnimationPlayer").advance(2.0 / 1.16667 * 2.0)
	p3.get_node("AnimationPlayer").advance(3.0 / 1.16667 * 2.0)
	p4.get_node("AnimationPlayer").advance(4.0 / 1.16667 * 2.0)
	p5.get_node("AnimationPlayer").advance(5.0 / 1.16667 * 2.0)
	p6.get_node("AnimationPlayer").advance(6.0 / 1.16667 * 2.0)
	p7.get_node("AnimationPlayer").advance(7.0 / 1.16667 * 2.0)
	
	
	print(p1.get_node("AnimationPlayer").current_animation_position)
	print(p2.get_node("AnimationPlayer").current_animation_position)
	print(p3.get_node("AnimationPlayer").current_animation_position)
	print(p4.get_node("AnimationPlayer").current_animation_position)
	print(p5.get_node("AnimationPlayer").current_animation_position)
	print(p6.get_node("AnimationPlayer").current_animation_position)
	print(p7.get_node("AnimationPlayer").current_animation_position)
	
	print('advanced')
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
