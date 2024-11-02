extends Control
class_name Hotbar

@export var player: Player
@export var current_selected_bar: int = 0
@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer

var _input_actions: Array[String] = []
var hotbar_slots: Array[Node]
var hotbar_state: Array[ItemResource]

func _ready() -> void:
	#Setup Initial Hotbar
	_input_actions = _generate_input_actions()
	hotbar_slots = h_box_container.get_children()
	hotbar_state = GameConstants.test_hotbar_inventory
	
	hotbar_slots[current_selected_bar].select_as_current()
	player.set_equipped_item(hotbar_state[current_selected_bar])
	_load_saved_hotbar()

func _process(_delta: float) -> void:
	if not Input.is_anything_pressed():
		return
	
	for index in range(_input_actions.size()):
		if Input.is_action_just_pressed(_input_actions[index]):
			_change_selected(index)
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_change_selected(wrapi(current_selected_bar - 1, 0, 9))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_change_selected(wrapi(current_selected_bar + 1, 0, 9))

func _change_selected(index: int) -> void:
	if index < 0 or index >= h_box_container.get_child_count():
		push_warning("Invalid hotbar index: %d" % index)
		return
	
	hotbar_slots[current_selected_bar].remove_as_selected()
	hotbar_slots[index].select_as_current()
	
	current_selected_bar = index
	player.set_equipped_item(hotbar_state[current_selected_bar])

func _generate_input_actions() -> Array[String]:
	var actions: Array[String] = []
	for i in range(9):
		actions.append(GameConstants.INPUT_HOTBAR + str(i + 1))
	return actions

func _load_saved_hotbar() -> void:
	for i in range(9):
		hotbar_slots[i].item_sprite_icon.texture = hotbar_state[i].sprite_texture
