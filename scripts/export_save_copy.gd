extends Node

func _ready() -> void:
	var source_path := "user://political_world_save.json"
	var destination_path := "res://political_world_save_recovery_copy.json"

	print("Godot user data folder: ", OS.get_user_data_dir())

	if not FileAccess.file_exists(source_path):
		push_error("Save file not found at: " + source_path)
		return

	if FileAccess.file_exists(destination_path):
		push_error("Recovery copy already exists. Rename it before trying again.")
		return

	var error := FileAccess.copy(source_path, destination_path)
	if error == OK:
		print("Recovery copy created: ", destination_path)
	else:
		push_error("Could not copy save. Error code: " + str(error))
