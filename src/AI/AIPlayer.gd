extends Node

export var id: int
var active := true

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

# if PlayersManager.players_by_network_id is 0, single player. ALL AI'S ARE ACTIVE
# if it's not, get the size of it. get the id's which are there. the rest are AIs
# PlayerData.ai_controlled should be set to whatever

func _ready() -> void:
	check_active()
	if active:
		Signals.connect("day_passed", self, "_on_day_passed")

func check_active():
	if PlayersManager.players_by_network_id.size() == 0:
		active = true
	else:
		if id in PlayersManager.players_by_network_id.keys():
			active = false

func _on_day_passed(day):
	var all_build_tiles = get_tree().get_nodes_in_group("ai_tiles")

	var our_build_tiles = []
	# ensure that the tile is actually the same id as the AIPlayer
	# and also that we haven't built it
	for t in all_build_tiles:
		if t.id == id and not t.built:
			our_build_tiles.append(t)

	our_build_tiles.sort_custom(BuildOrderSorter, "sort_build_order")

	if our_build_tiles.size() > 0:
		our_build_tiles[0].build_tile()
