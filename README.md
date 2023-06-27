# godot-voice-gen

This is a voice generator based on animalese from the Animal Crossing series.

## Installing:

Either clone this repo into your `[project_folder]/addons/godot-voice-gen` or add it is a submodule with <br>
> `git submodule add https://github.com/Kibibibit/godot-voice-gen ./addons/godot-voice-gen` <br>
> 
or, if you use SSH with git:<br>
> `git submodule add https://github.com/Kibibibit/godot-voice-gen ./addons/godot-voice-gen`

Then, once you open your project in Godot, go into `Project Settings > Plugins` and enable `godot-voice-gen`

## Usage:

This plugin adds a new node called `VoiceGen`, which actually does the voice generating. The node has 2 parameters you need to set, either in code or in the inspector.

### `player`
This should be either an `AudioStreamPlayer`, `AudioStreamPlayer2D`, or an `AudioStreamPlayer3D`, depending on whether or not you want the voice to be positional or not. (Note that as `VoiceGen` extends `Node`, you will need to position `player` in code or it will not follow `VoiceGen`'s parent)

This player will actually play the sound files for the voices.

> Note that in the future, `VoiceGen` may be split into `VoiceGen2D`, `VoiceGen3D` and `VoiceGen` to account for different scene types.

### `voice_path`
This should be the directory where all of your voice sound files are stored.


### Parameters
The other parameters for the generator determine a few things like the speed, pitch and variance of the voiced.

| parameter | type | description |
| - | - | - |
| `pitch` | `float` |  |
| `pitch_range` | `float` | |
| `speed` | `float` | |
| `question_pitch` | `float` | |
| `question_length` | `int` | |