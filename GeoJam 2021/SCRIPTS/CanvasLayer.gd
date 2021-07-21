extends CanvasLayer


func _ready():
	$CirclePopup/Button.connect("pressed", self, "unpause_circle")
	$TrianglePopup/Button.connect("pressed", self, "unpause_triangle")
	$CubePopup/Button.connect("pressed", self, "unpause_cube")
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func unpause_circle():
	get_tree().paused = false
	$CirclePopup.visible = false

func unpause_triangle():
	get_tree().paused = false
	$TrianglePopup.visible = false

func unpause_cube():
	get_tree().paused = false
	$CubePopup.visible = false
