extends Node
class_name VoiceGen

var voices = []

const _letters = "abcdefghijklmnopqrstuvwxyz"
const _numbers = {
	"0":"zero",
	"1":"one",
	"2":"two",
	"3":"three",
	"4":"four",
	"5":"five",
	"6":"six",
	"7":"seven",
	"8":"eight",
	"9":"nine"
}

var _sounds = {
	
}

var _queue: Array = []
var _pitch_curve: Array = []
var _timer: Timer

## This is the directory where all the voice assets are stored.
@export_dir var voice_path: String

## This should be any of the AudioStreamPlayer objects, and will be used to play the audio
@export var player: Node

@export_group("Voice Settings")

## This is the base pitch that the voice will be played at, as a multiplier of the base
## audio's pitch. This will also increase the speed of the player.
@export var pitch: float

## The pitch multiplier [pitch] will be modified up and down by up to this amount randomly
## on each letter.
@export var pitch_range: float

## This is the time in seconds each letter is played for.
@export var speed: float

## This is the amount the pitch multiplier will increase by for each letter at the end of a question.
@export var question_pitch: float
## This is how many letters before a question mark the pitch will rise for
@export var question_length: int
## This choses which voice from [voices] will play
@export var voice: int = 0
## If true, all the voice files will be loaded when this Node calls _ready()
@export var load_on_ready:bool = false

func _ready():
	_timer = Timer.new()
	_timer.autostart = false
	_timer.one_shot = true
	_timer.name = "Timer"
	add_child(_timer)
	assert(
		player.get_class() == "AudioStreamPlayer2D" || 
		player.get_class() == "AudioStreamPlayer3D" || 
		player.get_class() == "AudioStreamPlayer",
		"Player must be an AudioStreamPlayer, either standard, 2D or 3D"
	)
	_timer.timeout.connect(_play_sound)
	if (load_on_ready):
		load_voices()

func load_voices():
	var directory: DirAccess = DirAccess.open(voice_path)
	
	if (directory == null):
		return DirAccess.get_open_error()
	
	voices = directory.get_directories()
	
	if (voices.is_empty()):
		push_warning("No voices in %s!",voice_path)
		return
	for v in voices:
		load_voice(v)

func load_voice(voice_name: String):
	_sounds[voice_name] = {}
	var directory: DirAccess = DirAccess.open("%s/%s" % [voice_path, voice_name])
	if (directory == null):
		return DirAccess.get_open_error()
	var sounds = directory.get_files()
	
	for letter in _letters:
		var found_letter = false
		for sound in sounds:
			if (sound.begins_with("%s." % letter) && !sound.ends_with(".import")):
				_sounds[voice_name][letter] = load("%s/%s/%s" % [voice_path, voice_name, sound])
				found_letter = true
				break
		if (!found_letter):
			push_warning("Could not find letter '%s' in voice '%s'!" % [letter, voice_name])
		
	
func play(text: String):
	if (voices.is_empty()):
		push_error("No voices are loaded! Try using .load_voices or .load_voice first!")
		return
	stop()
	
	for number in _numbers.keys():
		while (text.contains(number)):
			text = text.replace(number, _numbers[number])
	_queue = text.to_lower().split()
	_pitch_curve = []
	## Handling pithc changes
	for i in range(0,_queue.size()):
		_pitch_curve.append(max(0.01, pitch + randf_range(-pitch_range,pitch_range)))
		## if its a question mark, go back a few steps and raise the pitch
		if (_queue[i] == "?"):
			for q in question_length:
				if (i-q > 0):
					var mult = question_length-q
					_pitch_curve[i-q-1] = pitch + question_pitch*(mult)
					
	_play_sound()

func stop():
	_timer.stop()
	player.stop()
	_queue = []
	
func _play_sound():
	player.stop()
	if (_queue.is_empty()):
		return
	var c = _queue.pop_front()
	var p = _pitch_curve.pop_front()
	if (_sounds[voices[voice]].has(c)):
		player.pitch_scale = p
		player.stream = _sounds[voices[voice]][c]
		player.play()
	
	_timer.start(speed)


