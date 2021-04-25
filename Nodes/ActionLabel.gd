extends Panel

export(Array, Texture) var selected_action_textures
export(Color) var highlight_enable
export(Color) var highlight_disable

func _ready():
	assert(selected_action_textures.size() == Actions.Titles.size())

func set_action(action):
	$TextureRect.texture = selected_action_textures[action]

func highlight(enable):
	if enable:
		self_modulate = highlight_enable
	else:
		self_modulate = highlight_disable
