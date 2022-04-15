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
#	$InfoLabel.text = str($Player/CoyoteTime.time_left)

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
	
