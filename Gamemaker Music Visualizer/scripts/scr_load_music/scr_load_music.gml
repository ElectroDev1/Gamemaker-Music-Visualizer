// @description A script that loads music from the datafiles using a .ini file as reference
// since having music loaded in the actual project is stupid very stupid
function scr_load_music(name="",priority = 0,play=0,loops = 1,volume = 0.5,pause=0){
	
	//If the name has not be set we exit the script
	if(name==""){ return -4; }
	
	//If the music data file doesn't exist we exit the script
	if(!file_exists("musicdata.ini")){ 
	   show_debug_message("Cannot load song: data file not found"); return -4; 
	}
	
	
	//Open the data file and get data
	ini_open("musicdata.ini");
	
	  //Get the name of the file
	  var _filename = ini_read_string(name,"filename",-4);
	  
	  //Remove the .ogg in the name if present in case it has been accidentaly kept in
	  _filename = string_replace(_filename,".ogg","");
	
	  //If no file was found exit the script
	  if(_filename==-4){
		 show_debug_message("Cannot load song: key not found or no file name was written");
	     return -4;	
	  }
	  
	  if(!file_exists("Music/"+string(_filename)+".ogg") ){
		 show_debug_message("Cannot load song: music file not found");
	     return -4;	
	  }
	  
	  //Get loops
	  var _loopstart = ini_read_real(name,"loop_start",-4);
	  global.loopstart = _loopstart;
	  
	  
	  var _loopend   = ini_read_real(name,"loop_end",-4);
	  global.loopend   = _loopend;
	
	ini_close();
	
	//Stop currently playing sound and destroy it
	if(global.stream!=-4){
	
	   audio_stop_sound(global.stream);	
       audio_destroy_stream(global.stream);
	   global.currentstream = -4;

	}
	
	//Load song
    global.stream = audio_create_stream("Music/"+string(_filename)+".ogg");

    if(play){
       global.currentstream = audio_play_sound(global.stream,priority,loops);
	}   
	
	if(pause){
	   audio_pause_sound(global.currentstream)
	   audio_sound_set_track_position(global.currentstream,0);	
	}
	  
    audio_sound_gain(global.stream,volume,1);

    show_debug_message("Loaded song '"+_filename+".ogg'");
	show_debug_message("Loop start: "+string(_loopstart));
	show_debug_message("Loop end: "+string(_loopend));
 
    return global.stream;

}