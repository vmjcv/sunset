# Tool generated file DO NOT MODIFY
tool
extends Node

const item_infoScript = preload("item_info.gd")
const music_infoScript = preload("music_info.gd")
const plot_infoScript = preload("plot_info.gd")
const result_infoScript = preload("result_info.gd")
const sound_infoScript = preload("sound_info.gd")
const item_infoData = item_infoScript.item_infoData
const music_infoData = music_infoScript.music_infoData
const plot_infoData = plot_infoScript.plot_infoData
const result_infoData = result_infoScript.result_infoData
const sound_infoData = sound_infoScript.sound_infoData

var unique_id_depot = {}
var configs = {
	item_infoData: [],
	music_infoData: [],
	plot_infoData: [],
	result_infoData: [],
	sound_infoData: [],
}

func get_config_by_uid(id: int):
	return unique_id_depot[id] if id in unique_id_depot else null

func get_table_configs(table: GDScript):
	return configs[table] if table in configs else null

func _init():
	configs[item_infoData] = item_infoScript.load_configs()
	configs[music_infoData] = music_infoScript.load_configs()
	configs[plot_infoData] = plot_infoScript.load_configs()
	configs[result_infoData] = result_infoScript.load_configs()
	configs[sound_infoData] = sound_infoScript.load_configs()
	for d in configs[item_infoData]: unique_id_depot[d.get_instance_id()] = d
	for d in configs[music_infoData]: unique_id_depot[d.get_instance_id()] = d
	for d in configs[plot_infoData]: unique_id_depot[d.get_instance_id()] = d
	for d in configs[result_infoData]: unique_id_depot[d.get_instance_id()] = d
	for d in configs[sound_infoData]: unique_id_depot[d.get_instance_id()] = d
