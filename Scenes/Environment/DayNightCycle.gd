extends Node2D

@export var DAY_DURATION: float = 480.0  # Duration of a full day in seconds
@export var NIGHT_COLOR: Color = Color(0.15, 0.15, 0.25, 1.0)
@export var DAY_COLOR: Color = Color(0.75, 0.85, 0.75, 1.0)
@export var SUN_COLOR: Color = Color(0.8, 0.65, 0.35, 1.0)

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ambient_light: DirectionalLight2D = $AmbientLight
@onready var background: ColorRect = $DynamicBackground/Background

var time_elapsed: float = 240.0

# Time configuration (all values in cycle percentage 0.0-1.0)
const DAWN_START: float = 0.2
const DAWN_END: float = 0.3
const DUSK_START: float = 0.7
const DUSK_END: float = 0.8

# Background Color Configuration
@export var NIGHT_BG: Color = Color(0.05, 0.05, 0.1, 1.0)
@export var DAWN_BG: Color = Color(0.45, 0.35, 0.3, 1.0)
@export var DAY_BG: Color = Color(0.5, 0.7, 0.9, 1.0)
@export var DUSK_BG: Color = Color(0.4, 0.25, 0.3, 1.0)

func _ready() -> void:
	background.visible = true
	# Start at dawn
	canvas_modulate.color = DAY_COLOR
	setup_ambient_light()

func setup_ambient_light() -> void:
	ambient_light.color = SUN_COLOR
	ambient_light.energy = 0.4
	ambient_light.shadow_enabled = true
	ambient_light.blend_mode = Light2D.BLEND_MODE_ADD
	
	ambient_light.height = 0.4

func _process(delta: float) -> void:
	# Update time
	time_elapsed += delta
	if time_elapsed >= DAY_DURATION:
		time_elapsed = 0.0
	
	# Calculate day cycle (0.0 to 1.0)
	var cycle: float = time_elapsed / DAY_DURATION
	
	# Update lighting
	update_lighting(cycle)

func update_lighting(cycle: float) -> void:
	# Calculate sun position (rotate around the world)
	var sun_angle: float = cycle * TAU - PI
	
	# Update sun direction and energy
	ambient_light.rotation = sun_angle
	
	# Sun energy based on height (only when above horizon)
	var sun_energy: float = calculate_sun_energy(cycle)
	ambient_light.energy = sun_energy * 1.0  # Increased multiplier for stronger daylight
	
	ambient_light.color = calculate_sun_color(cycle)
	canvas_modulate.color = calculate_sky_color(cycle)
	background.color = calculate_background_color(cycle)

func calculate_sun_energy(cycle: float) -> float:
	if cycle < DAWN_START or cycle > DUSK_END:
		return 0.0
	elif cycle < DAWN_END:
		var t: float = inverse_lerp(DAWN_START, DAWN_END, cycle)
		return lerp(0.0, 0.8, ease(t, -2.0))  # Soft ease in
	elif cycle < DUSK_START:
		return 0.8
	else:
		var t: float = inverse_lerp(DUSK_START, DUSK_END, cycle)
		return lerp(0.8, 0.0, ease(t, 2.0))  # Soft ease out

func calculate_sun_color(cycle: float) -> Color:
	if cycle < DAWN_START or cycle > DUSK_END:
		return Color(0.7, 0.7, 1.0, 1.0)  # Cool night light
	elif cycle < DAWN_END:
		var t: float = inverse_lerp(DAWN_START, DAWN_END, cycle)
		return Color(1.0, 0.8, 0.6, 1.0).lerp(SUN_COLOR, ease(t, -2.0))
	elif cycle < DUSK_START:
		return SUN_COLOR
	else:
		var t: float = inverse_lerp(DUSK_START, DUSK_END, cycle)
		return SUN_COLOR.lerp(Color(1.0, 0.6, 0.4, 1.0), ease(t, 2.0))

func calculate_sky_color(cycle: float) -> Color:
	if cycle < DAWN_START:
		return NIGHT_COLOR
	elif cycle < DAWN_END:
		var t: float = inverse_lerp(DAWN_START, DAWN_END, cycle)
		return NIGHT_COLOR.lerp(DAY_COLOR, ease(t, -2.0))
	elif cycle < DUSK_START:
		return DAY_COLOR
	elif cycle < DUSK_END:
		var t: float = inverse_lerp(DUSK_START, DUSK_END, cycle)
		return DAY_COLOR.lerp(NIGHT_COLOR, ease(t, 2.0))
	else:
		return NIGHT_COLOR

func calculate_background_color(cycle: float) -> Color:
	if cycle < DAWN_START:
		return NIGHT_BG
	elif cycle < DAWN_END:
		var t: float = inverse_lerp(DAWN_START, DAWN_END, cycle)
		return NIGHT_BG.lerp(DAWN_BG, ease(t, -2.0)).lerp(DAY_BG, ease(t, -2.0))
	elif cycle < DUSK_START:
		return DAY_BG
	elif cycle < DUSK_END:
		var t: float = inverse_lerp(DUSK_START, DUSK_END, cycle)
		return DAY_BG.lerp(DUSK_BG, ease(t, -2.0)).lerp(NIGHT_BG, ease(t, -2.0))
	else:
		return NIGHT_BG
