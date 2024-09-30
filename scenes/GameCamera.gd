extends Camera2D


export(Color, RGB) var background_color = Color( 0.87451, 0.964706, 0.960784, 1 )


func _ready():
	VisualServer.set_default_clear_color(background_color)
	
