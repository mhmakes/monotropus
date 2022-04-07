extends Node

var debug_mode: bool = true

# These flags will be checked to determine which cutscenes, dialogue boxes and choice boxes appear.
var story_flags: Dictionary = {
	"front_door_has_key": false,
	"front_door_first_try": true,
	"existing_flag": false,
}

var cutscene_playing: bool = false


func _ready() -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_fullscreen"):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())


func update_story_flags(flags: Dictionary) -> void:
	var keys: Array = flags.keys()
	
	for key in keys:
		assert(story_flags.has(key), "Story flag '" + str(key) + "' does not exist.")
		story_flags[key] = flags[key]
	
	if debug_mode:
		print(flags)


func is_cutscene_playing() -> bool:
	return cutscene_playing


func set_cutscene_playing(value: bool) -> void:
	cutscene_playing = value
