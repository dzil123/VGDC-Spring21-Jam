extends Panel

export(Array, Texture) var selected_action_textures

func _ready():
	assert(selected_action_textures.size() == Actions.Titles.size())

func set_action(action):
	$TextureRect.texture = selected_action_textures[action]
