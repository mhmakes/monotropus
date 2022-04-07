extends Panel

signal dialogue_started
signal dialogue_ended

export(NodePath) onready var _dialogue_text = get_node(_dialogue_text) as RichTextLabel
export(NodePath) onready var _dialogue_speaker = get_node(_dialogue_speaker) as Label
export(NodePath) onready var _animation_player = get_node(_animation_player) as AnimationPlayer
export(NodePath) onready var _text_blip = get_node(_text_blip) as AudioStreamPlayer

var _cutscene_player = null

var _active: bool = false

var _current_dialogue_data: Dictionary = {}
var _current_slide_index: int = 0

# Used when generating an animation for writing text to screen.
var _text_speeds: Dictionary = {
	"": 0.023,
	",": 0.15,
	"-": 0.1,
}

var _sentence_enders: Array = [".", "!", "?"]


func _ready() -> void:
	connect("dialogue_started", GameEvents, "_on_dialogue_started")
	
	for ender in _sentence_enders:
		_text_speeds[ender] = 0.25
	
#	self._active = true
#	_set_dialogue_data("res://Story/Data/Text/text_FrontDoor_FrontDoorKey_FirstTry.csv")
#	advance_text_slide()
#	_animation_player.play("draw_text")


func _physics_process(delta: float) -> void:
	if _active:
		self.visible = true
		
		if Input.is_action_just_pressed("game_interact"):
			if _animation_player.is_playing():
				_animation_player.seek(_animation_player.get_animation("draw_text").get_length())
			else:
				advance_text_slide()
				_animation_player.stop()
				_animation_player.play("draw_text")
	else:
		_animation_player.stop()
		self.visible = false


func start_dialogue(csv_file_path: String) -> void:
	if _cutscene_player:
		if _cutscene_player.is_playing():
			_cutscene_player.stop(false)
	
	_current_slide_index = 0
	_set_dialogue_data(csv_file_path)
	_active = true
	_animation_player.play("draw_text")
	advance_text_slide()
	
	#emit_signal("dialogue_started")


func set_cutscene_player(cutscene_player: Node) -> void:
	_cutscene_player = cutscene_player


func _set_dialogue_data(csv_file_path: String) -> void:
	var dialogue_dict = Utils.csv_2_dictionary(csv_file_path)
	
	_current_dialogue_data = dialogue_dict


func advance_text_slide() -> void:
	var _num_of_slides: int = _current_dialogue_data.text_eng.size()
	
	if _current_slide_index < _num_of_slides:
		_dialogue_text.visible_characters = 0
		_dialogue_text.bbcode_text = _current_dialogue_data.text_eng[_current_slide_index]
		_dialogue_speaker.text = _current_dialogue_data.speaker[_current_slide_index]
		generate_draw_text_animation()
		
		_current_slide_index += 1 
	else:
		self._active = false
		
		if _cutscene_player:
			if _cutscene_player.get_current_animation_position() > 0.001:
				_cutscene_player.play()
		# TODO: Logging

##
## Generate the draw_text animation in the AnimationPlayer. This animation writes text out
## in a gradual fashion, based in part by what characters make up the dialogue string. 
## For instance, it will write a character every two frames, however it will take a pause
## of 400 milliseconds if the playhead reaches a "."
func generate_draw_text_animation() -> void:
	var anim: Animation = _animation_player.get_animation("draw_text")
	
	anim.clear()  # we don't want our animations to preserve any older keys!
	
	# create animation tracks. 
	# TODO: Refactor this into a function that dynamically creates animation 
	# tracks based on passed parameters.
	var char_track_idx: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_interpolation_type(char_track_idx, Animation.INTERPOLATION_NEAREST)
	anim.track_set_path(char_track_idx, "Text:visible_characters")
	
	var audio_track_idx: int = anim.add_track(Animation.TYPE_AUDIO)
	anim.track_set_interpolation_type(audio_track_idx, Animation.INTERPOLATION_NEAREST)
	anim.track_set_path(audio_track_idx, "TextBlip")
	
	var character_index: int = 0
	var time_elapsed_since_anim_start: float = 0.0 
	for character in _dialogue_text.text:
		# Speed is obtained from our dictionary of speeds _text_speeds, along with the speeds provided
		# in the dialogue data
		var current_character_speed: float = _text_speeds.get(character, _text_speeds[""]) * float(_current_dialogue_data.speed[_current_slide_index])
		
		# The character index + 1 bit is to match the visible character. The first visible character
		# is the 0th index!!!
		anim.track_insert_key(char_track_idx, time_elapsed_since_anim_start, character_index + 1)
		
		# only create audio every 4th or so character at default speed--it sounds nicer.
		if character_index % 4 == 0 or (current_character_speed > 0.08 and character != " "):
			anim.audio_track_insert_key(audio_track_idx, time_elapsed_since_anim_start, _text_blip.get_stream()) 
		
		time_elapsed_since_anim_start += current_character_speed
		character_index += 1
	
	anim.set_length(anim.track_get_key_time(char_track_idx, anim.track_get_key_count(0) - 1))
