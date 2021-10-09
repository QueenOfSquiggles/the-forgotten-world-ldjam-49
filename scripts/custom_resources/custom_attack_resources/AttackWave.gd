extends AttackPattern
class_name AttackWave

export (float) var ROF := 0.2
export (float) var ProjectileSpeed := 50.0
export (float) var Duration := 2.5
export (Vector2) var base_direction := Vector2.DOWN
export (float) var wave_angle := 45.0
export (float) var wave_speed := 1.0
export (bool) var use_angle_towards_player_as_base := true

var cleanup := []
var time := 0.0

func do_turn(enemy : Node2D):
	time = 0.0
	while time < Duration:
		# this should shoot all of the shots?
		yield(_one_shot(enemy as Battler), "completed")
		time += ROF
	do_turn_cleanup()

func _one_shot(enemy : Battler) -> void:
	_shoot(enemy)
	yield(GameHelper.create_timer(ROF), "timeout")

func _shoot(enemy : Battler):
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return
	var proj := ProjectileScene.instance() as Projectile
	assert(proj, "Failed to load instance of Projectile class for _shoot method")
	proj.speed = ProjectileSpeed
	enemy.get_node(enemy.WorldSpaceRoot).add_child(proj)
	proj.global_position = enemy.global_position
	proj.rotation = _get_angle(enemy)
	cleanup.append(proj)

func do_turn_cleanup():
	for c in cleanup:
		if is_instance_valid(c):
			(c as Node).queue_free()
	cleanup.clear()

func _get_angle(enemy : Battler) -> float:
	if use_angle_towards_player_as_base:
		base_direction = (GameHelper.get_player().global_position - enemy.global_position).normalized()
	var cur_vec := base_direction.rotated(sin(time * wave_speed) * deg2rad(wave_angle/2))
	return cur_vec.angle()
