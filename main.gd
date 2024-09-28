extends Spatial

export(Array, PackedScene) var levels
export var level_index = 0

var deaths = 0

func _ready():
	switch_to_level(level_index)

var x_runahead = 2.0

func _process(delta):
	var target = $"%CameraTarget".global_transform
	var current = $Camera.global_transform
	var decay = 0.1
	var interpolated = current.interpolate_with(target, decay)
	$Camera.global_transform = interpolated

func _physics_process(delta):
	$Player/CameraBase.rotation_degrees.y = -$Player.velocity.x * 2
	$Player/CameraBase.rotation_degrees.x = -$Player.velocity.z * 2
	
#	x_runahead += $Player.velocity.x * delta * 0.5
#	x_runahead = clamp(x_runahead, -2.0, 2.0)
	$Player/CameraBase.translation.x = x_runahead
	
	if Input.is_action_just_pressed("skip"):
		pass
#		_on_level_finished()
	
	if Input.is_action_just_pressed("restart_game"):
		get_tree().change_scene("res://main.tscn")
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	$InfoLabel.text = str($Player/CoyoteTime.time_left)

func reset_player():
	$Player.translation = Vector3(0, 0.5, 0)
	$Player.velocity = Vector3.ZERO

func switch_to_level(index):
	var new_level = levels[index].instance()
	for child in $Level.get_children():
		child.queue_free()
	$Level.add_child(new_level)
	$LevelNumber.text = str(level_index + 1)
	reset_player()
	
	# wait two frames to let the new level load and the old one unload so that we
	# don't have any duplicates, hitches, delays, etc.
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	var level_bounds = AABB()
	for object in new_level.get_children():
		if object is Spatial:
			if object.has_method("get_aabb"):
				level_bounds = level_bounds.merge(object.get_aabb())
			else:
				level_bounds = level_bounds.expand(object.get_global_transform().origin)
	level_bounds = level_bounds.grow(8.0)
	$ShadowCatcher.mesh.size = Vector3(level_bounds.size.x, 2.0, level_bounds.size.z)
	$ShadowCatcher.translation = (level_bounds.end + level_bounds.position) / 2.0
	$ShadowCatcher.translation.y = -4.0 - 1.0
	
	get_tree().set_group("music_sync_animation", "playback_speed", 1.166667)
	
	for end_area in get_tree().get_nodes_in_group("end_areas"):
		end_area.connect("body_entered", self, "_on_end_area_body_entered")

	for animation_player in get_tree().get_nodes_in_group("music_sync_animation"):
		animation_player.seek(fmod(get_music_playhead(), animation_player.current_animation_length))
	print('synced')

# music playhead position as a fraction of a beat
func get_music_playhead():
	var music_time = $Music.get_playback_position()
	music_time += AudioServer.get_time_since_last_mix()
	music_time -= AudioServer.get_output_latency()
	# theoretically there should be a delay of 0.03 seconds because the music
	# doesn't immediately start in the mp3... but it sounds better without it?
#	music_time -= 0.03
	return music_time * 1.16666667


func _on_Player_player_died():
	deaths += 1
	$Slap.play()
	$FailsCount.text = str(deaths)
	reset_player()

func _on_end_area_body_entered(body):
	_on_level_finished()

func _on_level_finished():
	level_index += 1
	if level_index >= levels.size():
		level_index = levels.size() - 1
		$WinLabel.show()
	else:
		switch_to_level(level_index)
	


func _on_TopBarBackground_gui_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_LEFT):
		call_deferred("_move_window", event.relative)

func _move_window(delta: Vector2):
	OS.window_position += delta


func _on_ButtonL1_pressed():
	switch_to_level(1)


func _on_ButtonL2_pressed():
	pass # Replace with function body.
