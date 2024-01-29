extends Node

#var preloaded: Dictionary = {
	#"DeathFX": preload("res://GameObjects/Effects/DeathFX/DeathFX.tscn")
#}
#
#func _check_preloaded(resource_name: String) -> Resource:
	#if preloaded.has(resource_name):
		#return preloaded[resource_name]
	#else:
		#

func _add_to_node(target: Node, obj: Node) -> void:
	target.call_deferred("add_child", obj)

func _add_to_world(obj: Node2D) -> void:
	Global.get_stage().call_deferred("add_child", obj)

func node(res: Resource, spawn: Transform2D) -> void:
	var _node: Node2D = res.instantiate()
	_node.global_position = spawn.get_origin()
	_add_to_world(_node)

#func projectile(res: Resource, spawn: Transform2D, properties: AbilityProperties) -> void:
	#var p: Projectile = res.instantiate()
	#p.properties = properties
	#p.position = spawn.get_origin()
	#p.rotation = spawn.get_rotation()
	#add_to_world(p)

func particle_to_world(res: Resource, target: Transform2D) -> void:
	if not Global.get_stage():
		printerr("No stage for %s" % res)
		return
	var p: GPUParticles2D = res.instantiate()
	p.position = target.get_origin()
	p.rotation = target.get_rotation()
	_add_to_world(p)

func particle_to_node(res: Resource, target: Node2D) -> void:
	var p: PackedScene = res.instantiate()
	target._add_child(p)
