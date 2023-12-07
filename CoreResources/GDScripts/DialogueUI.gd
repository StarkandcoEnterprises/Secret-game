extends BasePanel

class_name DialogueManager

## Manages display for any in game text interactions with objects or characters.

## Ref to [Label] that is the container for any dialogue tetx 
@onready var dialogueText : Label = %DialogueText
## Ref to the [GridContainer] that holds any options necessary for the dialogue
@onready var optionsContainer : GridContainer = %OptionHolder
## Empty [Dictionary] to store the provided data for an interaction
var dialogueTree : Dictionary

var calling_object

func _ready(): 
	super()
	hide() 

func show_dialogue(object_that_called, dialogue_data : Dictionary):
	calling_object = object_that_called
	# Show the panel 
	show() 
	# Store the dialogue tree 
	dialogueTree = dialogue_data 
	# Set initial dialogue text 
	set_dialogue_text(dialogueTree["text"]) 
	# Generate option labels 
	generate_option_labels(dialogueTree["options"])

func set_dialogue_text(text : String): 
	# Set the text of the dialogue label 
	dialogueText.text = text 

func generate_option_labels(options : Array): 
	# Clear existing option labels 
	for child in optionsContainer.get_children():
		optionsContainer.remove_child(child)
		child.queue_free()
	# Generate option labels dynamically 
	for option in options: 
		var option_button = Button.new() 
		option_button.text = option["text"] 
		option_button.flat = true
		option_button.add_theme_color_override("font_shadow_color", Color.BLACK)
		option_button.add_theme_color_override("font_outline_color", Color.BLACK)
		option_button.add_theme_constant_override("shadow_outline_size", 2) 
		option_button.add_theme_constant_override("shadow_offset_x", 1) 
		option_button.add_theme_constant_override("shadow_offset_y", 1) 
		option_button.add_theme_constant_override("outline_size", 2) 
		option_button.set_size(Vector2(125, 30))
		option_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		# Connect the label's pressed signal to an _on_option_selected function
		option_button.pressed.connect(_on_option_selected.bind(option["callback"])) 
		option_button.mouse_entered.connect(_on_option_button_mouse_entered.bind(option_button))
		optionsContainer.add_child(option_button) 
		
	var option_size = Vector2(125, 30)
	var margin = Vector2(10, 10)  # Margin size
	var container_min_size = option_size * Vector2(1, options.size()) + 2 * margin
	%OptionPanel.custom_minimum_size = container_min_size


func _on_option_selected(callback_name : String): 
	# Hide the dialogue panel 
	hide()
	# Assuming the parent is the interactable object 
	calling_object.call_dialogue_callback(callback_name) 
	calling_object = null

func _on_option_button_mouse_entered(button: Button):
	# Calculate the new position of the cursor
	%Cursor.global_position = button.global_position + Vector2(-%Cursor.texture.get_size().x, 0)
	
	var offset = Vector2(10, 20)  # Adjust this value as needed
	%Cursor.global_position += offset
