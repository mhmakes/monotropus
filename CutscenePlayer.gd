extends AnimationPlayer

export(NodePath) onready var _dialogue_box = get_node(_dialogue_box) as Panel
export(NodePath) onready var _choice_box = get_node(_choice_box) as PanelContainer

func _ready() -> void:
	connect("animation_started", GameEvents, "_on_CutscenePlayer_animation_started")
	connect("animation_finished", GameEvents, "_on_CutscenePlayer_animation_finished")
	
	play("cutscene_Test")
	
	_dialogue_box.set_cutscene_player(self)

