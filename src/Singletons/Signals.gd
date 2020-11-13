extends Node

func _ready() -> void:
	var username := ""
	if OS.has_environment("USER"):
		username = OS.get_environment("USER")
	if not username.begins_with('craig'):
		OS.window_maximized = true

signal game_building_selected
signal game_building_cancelled
signal game_building_placed(player_num, building_type_name, position)
signal day_passed(day)
signal resource_generated(player_num, resource_info)
signal player_data_updated(player_data)

signal tech_progress_changed(player_data)

# Notify when the connected players change
signal players_updated(player_dicts)
signal player_owner_changed(player)
signal player_joined(id, player)

# These are lifecycle signals. The server sends a
# pre_start_game to each client
# each client responds with a ready_to_start
# the server sends each client a post_start_game
signal pre_start_game(players)
signal player_ready_to_start(id)
signal post_start_game

# client connection signals
signal connected_to_server
signal connection_to_server_failed
signal server_disconnected


signal asteroid_impact(impact_point, explosion_radius)
signal asteroid_destroyed(position, size)
signal final_wave_complete()
