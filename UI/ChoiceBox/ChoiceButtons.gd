extends Resource

class_name ChoiceButtons

# Stores the buttons and the data those buttons modify for choice boxes.
# More specifically, this includes a couple of things: the text prompt that 
# explains the nature of the choice (I.E. "will you pick up the door handle?") 
# the player is being presented with. 
#
# Then, we have an array of dictionaries. Each dictionary is a record of 
# A). what the text label on the button contains, and
# B). the data in Game.story_flags that will be modified.

export(String) var label = "Button Label"
export(Array, Dictionary) var choices = [{
	"button_label": "",
	"story_flags": {},
},
{
	"button_label": "",
	"story_flags": {},
},
{
	"button_label": "",
	"story_flags": {},
}]

