extends Node


func _ready() -> void:
	pass


func get_input_direction() -> Vector2:
	var x: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x, y)


## Convert a CSV into a dictionary of arrays, mostly used to process dialogue files.
func csv_2_dictionary(csv_file_path: String) -> Dictionary:
	var csv_output_dictionary: Dictionary = {}
	var key_arr: Array = []
	var csv_line: PoolStringArray
	var value_index: int = 0
	
	var file = File.new()
	file.open(csv_file_path, File.READ)
	
	while file.get_position() < file.get_len():
		value_index = 0
		
		if file.get_position() == 0:
			key_arr = file.get_csv_line()
			
			for key in key_arr:
				csv_output_dictionary[key] = []
		else:
			csv_line = file.get_csv_line()
			
			for value in csv_line:
				csv_output_dictionary[key_arr[value_index]].append(value)
				value_index += 1
	
	file.close()
	
	return csv_output_dictionary
