extends KinematicBody

export(Array, NodePath) var waypoints
export var speed = 4.0

var waypoint_locations = []
var waypoint_index = 0


func _ready():
	for waypoint in waypoints:
		waypoint_locations.append(get_node(waypoint).get_global_transform().origin)
	if waypoint_locations.size() == 0:
		waypoint_locations.append(get_global_transform().origin)


func _physics_process(delta):
	var target = waypoint_locations[waypoint_index]
	
	var displacement = get_global_transform().origin - target
	
	var motion = to_local(-displacement.normalized() * delta * speed)
	var base = to_local(Vector3.ZERO)
	
	translate(motion - base)
	
	if displacement.length() < delta * speed * 2:
		waypoint_index += 1
	
	if waypoint_index >= waypoint_locations.size():
		waypoint_index = 0
