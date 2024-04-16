extends Node
# GlobalSignals

signal room_clicked(room)
signal summoning_completed(success, ghost_to_summon) # did we succeed, if so ghost to summon
signal summoning_started()
signal player_takes_stairs(room, player)
signal player_disable_summoning()
signal player_enable_summoning()
signal combo_completed(combo)

# Pushing information to the UI
signal display_keys(keys)
signal display_prompt(text)
signal score_incremented(amount)
signal score_updated(value)
