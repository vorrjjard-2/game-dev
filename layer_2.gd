extends TileMapLayer

@onready var fx1 = $TileMapLayer/AnimatedSprite2D
@onready var fx2 = $TileMapLayer/AnimatedSprite2D2
@onready var fx3 = $TileMapLayer/AnimatedSprite2D3
@onready var fx4 = $TileMapLayer/AnimatedSprite2D4
@onready var fx5 = $TileMapLayer/AnimatedSprite2D5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fx1.play("default")
	fx2.play("default")
	fx3.play("default")
	fx4.play("default")
	fx5.play("default")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
