extends AttackPattern
class_name StraightPewPew

export (float) var ROF := 0.2
export (float) var ProjectileSpeed := 50.0
export (float) var Duration := 2.5

var cleanup := []

func do_turn(enemy : Node2D):
	if not enemy:
		yield(GameHelper.get_tree().create_timer(0.01), "timeout")
		return
	var time := 0.0
	while time < Duration:
		# this should shoot all of the shots?
		yield(_one_shot(enemy as Battler), "completed")
		time += ROF
	do_turn_cleanup()

func _one_shot(enemy : Battler) -> void:
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return
	_shoot(enemy)
	yield(enemy.get_tree().create_timer(ROF), "timeout")

func _shoot(enemy : Battler):
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return
	var proj := ProjectileScene.instance() as Projectile
	assert(proj, "Failed to load instance of Projectile class for _shoot method")
	proj.speed = ProjectileSpeed
	enemy.get_node(enemy.WorldSpaceRoot).add_child(proj)
	proj.global_position = enemy.global_position

	var player := GameHelper.get_player()
	if not player or player == null:
		print("Player was returned null somehow?")

	#print("A")
	var player_pos :Vector2 = player.global_position
	var proj_pos := proj.global_position
	proj.rotation = _get_angle(player_pos, proj_pos)
	cleanup.append(proj)

func do_turn_cleanup():
	for c in cleanup:
		if is_instance_valid(c):
			(c as Node).queue_free()
	cleanup.clear()

func _get_angle(from : Vector2, to : Vector2) -> float:
	var dir := from - to
	dir = dir.normalized()
	return atan2(dir.y, dir.x)
