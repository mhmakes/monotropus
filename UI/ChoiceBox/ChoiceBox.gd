extends PanelContainer

signal choice_started
signal choice_ended

export (Resource) var _choice_buttons_data
export (Resource) var _theme = _theme as Theme

export (NodePath) onready var _choice_label = get_node(_choice_label) as Label
export (NodePath) onready var _buttons = get_node(_buttons) as VBoxContainer

var _cutscene_player = null

var _active: bool = false

func _ready() -> void:
	#create_choice_buttons()
	pass


func start_choice(data: Resource):
	_choice_buttons_data = data
	create_choice_buttons()


func destroy_choice_buttons():
	var button_list: Array = _buttons.get_children()
	for button in button_list:
		button.queue_free()


func create_choice_buttons():
	if _cutscene_player:
		if _cutscene_player.is_playing():
			_cutscene_player.stop(false)
	
	_choice_label.text = _choice_buttons_data.label
	
	var _button_label_index: int = 0
	
	for choice in _choice_buttons_data.choices:
		var _size: Vector2 = Vector2(120, 16)
		var _button: Button = Button.new()
		
		_button.rect_size = _size
		_button.text = choice.button_label
		_button.set_theme(_theme)
		
		_button.connect("pressed", GameEvents, "_on_choice_button_pressed", [choice.story_flags])
		_button.connect("pressed", self, "_on_choice_button_pressed")
		
		_buttons.add_child(_button)
		
		if _button_label_index == 0:
			_button.grab_focus()
		
		_button_label_index += 1
	
	_active = true
	set_visible(true)
	set_anchors_and_margins_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_WIDTH)


func set_cutscene_player(cutscene_player: Node) -> void:
	_cutscene_player = cutscene_player


func _on_choice_button_pressed() -> void:
	destroy_choice_buttons()
	_active = false
	set_visible(false)
	
	if _cutscene_player:
		if _cutscene_player.get_current_animation_position() > 0.001:
			_cutscene_player.play()
