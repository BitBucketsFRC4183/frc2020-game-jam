extends Node

func _ready() -> void:
	var username := ""
	if OS.has_environment("USER"):
		username = OS.get_environment("USER")
	if not username.begins_with('craig'):
		OS.window_maximized = true

signal game_building_selected(scene_path, building)
signal game_building_cancelled
signal game_building_placed(player_num, building_type_name, position)
signal day_passed(day)
signal resource_generated(player_num, resource_info)
signal player_data_updated(player_data)
signal player_give_resources(source_player_num, dest_player_num, resource_type, amount)

signal tech_progress_changed(player_data)
signal player_score_changed

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

# server signals
# this is called by the server to let any server specific code know it's ready to go
signal server_started


signal asteroid_wave_timer_reset(time_left)
signal asteroid_impact(asteroid_id, impact_point, explosion_radius)
signal asteroid_destroyed(asteroid_id, position, size)
signal asteroid_incoming(position, asteroid_strength, attributes)
signal asteroid_position_updated(asteroid_id, position)
signal final_wave_complete()

signal grand_winner
signal winner
signal loser
