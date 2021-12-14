/// @description Pause track at the start
// This is because track position cannot be manipulated when it is stopped
// with the standard audio_stop_sound function so it's instead paused and set to the start
audio_sound_set_track_position(global.currentstream,0);	
audio_pause_sound(global.currentstream);