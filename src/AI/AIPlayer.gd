extends Node

export var id: int

var active := true
var player_data: PlayerData
var research_list = ["mine2",  "power2", "shield2", "science2", "laser2", "mine3", "shield3", "laser3", "power3", "science3"]

var build_tile = preload("res://src/AI/AIBuildTile.tscn")
var owned_tiles = []

"""
So I was told to tell everyone my strategy, so here it is:
-Spend all starting materials on mines and maybe a power plant or 2
-Build a shield
-Improve economy when low on resources from now on
-Build a laser
-Build another shield
-Keep building lasers (and the occasional shield) whenever possible
-Pray that the dwarf planet targets a well defended area
"""

class BuildOrderSorter:
	static func sort_build_order(tile1, tile2):
		if tile1.build_order < tile2.build_order:
			return true
		return false

func _ready() -> void:
	check_active()
	Signals.connect("day_passed", self, "_on_day_passed")
	Signals.connect("player_data_updated", self, "_on_player_data_updated")

	player_data = PlayersManager.players[id - 1]

func check_active():
	if PlayersManager.players[id - 1].ai_controlled:
		if not active:
			print("Player %s is now ai controlled: " % id)
			active = true
	else:
		if active:
			print("Player %s is no longer ai controlled: " % id)
			active = false

func _on_player_data_updated(player_data: PlayerData):
	if player_data.num == id:
		check_active()

func get_next_research():
	for tech in research_list:
		if not Utils.has_tech(tech, player_data):
			return tech

func research_next():
	var next_research = get_next_research()
	if next_research != null:
		if Utils.can_research(next_research, player_data):
			Utils.research_tech(next_research, player_data)


func _on_day_passed(day):
	# only the server does AI
	if get_tree().is_network_server() and active:
		research_next()

		var all_build_tiles = get_tree().get_nodes_in_group("ai_tiles")

		var our_build_tiles = []
		var num_built_tiles = 0
		# ensure that the tile is actually the same id as the AIPlayer
		# and also that we haven't built it
		for t in all_build_tiles:
			if t.id == id:
				if not t.built:
					our_build_tiles.append(t)
				else:
					num_built_tiles += 1

		our_build_tiles.sort_custom(BuildOrderSorter, "sort_build_order")
#
		if our_build_tiles.size() > 0:
			var made_tile = our_build_tiles[0].build_tile()
		# if we have built all defined build tiles, make a new build tile somewhere in our territory and make lasers
		elif num_built_tiles >= 10:
			var new_build_tile = build_tile.instance()

			var all_territories = get_parent().get_parent().get_parent().get_territories()
			for t in all_territories:
				if t.territory_owner == id and t.type == Enums.territory_types.normal:
					owned_tiles.append(t)

			randomize()
			var random_territory = owned_tiles[randi() % owned_tiles.size()]
			var laser_position = random_territory.center_global

			randomize()
			var add_position = randi() % 2 == 0
			randomize()
			var change_x = randi() % 2 == 0
			laser_position = change_position(laser_position, add_position, change_x)

			new_build_tile.id = id
			new_build_tile.building_to_build = Enums.game_buildings.Laser
			new_build_tile.global_position = laser_position
			# add build tile
			get_parent().get_parent().get_parent().add_child(new_build_tile)
			# check if we can afford it
			# if we can't then remove the build tile.
			if new_build_tile.can_afford_tile():
				new_build_tile.build_tile()
			else:
				new_build_tile.queue_free()

	# every day brings new players
	check_active()

func change_position(laser_position, add_position, change_x):
	if add_position:
		if change_x:
			laser_position.x += 15
		else:
			laser_position.y += 15
	else:
		if change_x:
			laser_position.x -= 15
		else:
			laser_position.y -= 15

	return laser_position
