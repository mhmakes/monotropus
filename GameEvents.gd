extends Node


func _ready() -> void:
	pass


func _on_choice_button_pressed(choice: Dictionary) -> void:
	Game.update_story_flags(choice)


func _on_dialogue_started() -> void:
	pass


func _on_CutscenePlayer_animation_started(_animation_name: String) -> void:
	Game.set_cutscene_playing(true)


func _on_CutscenePlayer_animation_finished(_animation_name: String) -> void:
	Game.set_cutscene_playing(false)
