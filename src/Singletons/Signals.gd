extends Node

signal day_passed(day)


# Notify when the connected players change
signal player_name_updated(id, name)

# These are lifecycle signals. The server sends a
# pre_start_game to each client
# each client responds with a ready_to_start
# the server sends each client a post_start_game
signal pre_start_game
signal player_ready_to_start(id)
signal post_start_game

# client connection signals
signal connecterd_to_server
signal connection_to_server_failed
signal server_disconnected
