extends Spatial

export(Array, PackedScene) var levels
export var level_index = 0

var deaths = 0

func _ready():
#	pass
	switch_to_level(level_index)

func _physics_process(delta):
	$Player/CameraBase.rotation_degrees.y = -$Player.velocity.x * 2
	$Player/CameraBase.rotation_degrees.x = -$Player.velocity.z * 2
	
	if Input.is_action_just_pressed("skip"):
		_on_level_finished()
	
	$InfoLabel.text = str($Player/CoyoteTime.time_left)

func reset_player():
	$Player.translation = Vector3(0, 0.5, 0)
	$Player.velocity = Vector3.ZERO

func switch_to_level(index):
	var new_level = levels[index].instance()
	for child in $Level.get_children():
		child.queue_free()
	$Level.add_child(new_level)
	new_level.connect("level_finished", self, "_on_level_finished")
	$LevelNumber.text = str(level_index + 1)
	reset_player()
	get_tree().set_group("music_sync_animation", "playback_speed", 1.166667)
	
	# animations seem to not immediately start on scene switch
	# waiting 2 frames seems to be enough to sync on all platforms
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	var music_playhead = fmod(get_music_playhead(), 1.0)
	for animation_player in get_tree().get_nodes_in_group("music_sync_animation"):
		var animation_playhead = fmod(animation_player.current_animation_position, 1.0)
		animation_player.advance(music_playhead - animation_playhead)


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

func _on_level_finished():
	level_index += 1
	if level_index >= levels.size():
		level_index = levels.size() - 1
		$WinLabel.show()
	else:
		switch_to_level(level_index)
	
