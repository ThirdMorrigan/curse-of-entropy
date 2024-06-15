extends GPUParticles3D

@export var spell : Attack

# Called when the node enters the scene tree for the first time.
func _ready():
	if spell :
		print(str(spell.has_signal("fired"), " <------"))
		spell.fired.connect(_on_fire)

func _on_fire(mana_cost):
	emitting = true
	$OmniLight3D.light_energy = 2.0
	print("fired?")

func _process(delta):
	if $OmniLight3D.light_energy > 0.0 :
		$OmniLight3D.light_energy = move_toward($OmniLight3D.light_energy, 0.0, delta * 4.0)
