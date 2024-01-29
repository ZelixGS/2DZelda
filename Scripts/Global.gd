extends Node

var tile_size: int = 16

#region Player Related

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func direction_to_player(pos: Vector2) -> Vector2:
	var player: Player = get_player()
	if is_instance_valid(player):
		return pos.direction_to(player.global_position)
	return Vector2.ZERO

func distance_to_player(pos: Vector2) -> float:
	var player: Player = get_player()
	if is_instance_valid(player):
		return pos.distance_squared_to(player.global_position)
	return 9999.0

func get_player_position() -> Vector2:
	var player: Player = get_player()
	if is_instance_valid(player):
		return player.global_position
	return Vector2.ZERO

#endregion


func get_stage() -> Node2D:
	return get_tree().get_first_node_in_group("stage")

func snap_to_grid(pos: Vector2) -> Vector2:
	@warning_ignore("integer_division")
	return (pos / tile_size).floor() * tile_size + Vector2(int(tile_size/2),int(tile_size/2))

func snap_angle(rotation: float, angles: int = 4) -> float:
	return snapped(rotation, PI/angles)


#region Facing Relating
func snap_angle_to_facing(facing: String) -> float:
	return snapped(facing_to_vector(facing).angle() ,PI/4)

func facing_to_angle(facing: String) -> float:
	return facing_to_vector(facing).angle()

func facing_to_vector(facing: String) -> Vector2:
	match facing:
		"up":
			return Vector2.UP
		"right":
			return Vector2.RIGHT
		"down":
			return Vector2.DOWN
		"left":
			return Vector2.LEFT
		_:
			return Vector2.DOWN

func vector_to_facing(vector: Vector2) -> String:
	var direction: String = "down"
	if abs(vector.y) > abs(vector.x):
		if vector.y < 0:
			direction = "up"
		if vector.y > 0:
			direction = "down"
	else :
		if vector.x < 0:
			direction = "left"
		if vector.x > 0:
			direction = "right"
	
	return direction

#endregion
