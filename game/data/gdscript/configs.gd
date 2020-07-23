# Tool generated file DO NOT MODIFY
tool
extends Node

const policy_infoScript = preload("policy_info.gd")
const policy_infoData = policy_infoScript.policy_infoData

var unique_id_depot = {}
var configs = {
	policy_infoData: [],
}

func get_config_by_uid(id: int):
	return unique_id_depot[id] if id in unique_id_depot else null

func get_table_configs(table: GDScript):
	return configs[table] if table in configs else null

func _init():
	configs[policy_infoData] = policy_infoScript.load_configs()
	for d in configs[policy_infoData]: unique_id_depot[d.get_instance_id()] = d
