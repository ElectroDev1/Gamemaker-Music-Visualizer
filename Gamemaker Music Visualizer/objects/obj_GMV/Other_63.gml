/// @description Get answers from async event
var i_d = ds_map_find_value(async_load, "id");
if i_d == msg
    {
    if ds_map_find_value(async_load, "status")
        {
        if ds_map_find_value(async_load, "result") != ""
            {
				
			  //Got an anwser
			  switch(AnswerWait){
				  
				     case Questions.new_file: //We gave the name for a new file
					   
					     filename=ds_map_find_value(async_load, "result");
						
					     if(filename!=blacklist){
					 
					     //Create a copy of the music file
					     musicbuffer = buffer_load(globalfile);
						 buffer_save(musicbuffer,working_directory+"Music/"+string(filename)+".ogg");
						 show_debug_message("Saved new music file buffer as '"+string(filename));
						 
						 //Set data in the .ini file
						 ini_open("musicdata.ini");
						 
						    var _count = ini_read_real(blacklist,"count",0);
						 
						    ini_write_real(blacklist,"count",_count+1);
						    ini_write_string(blacklist,"name_"+string(_count+1),filename);
						 
						    ini_write_string(filename,"filename",filename);
						    ini_write_string(filename,"loopstart",-4);
						    ini_write_string(filename,"loopend",-4);
						 
						 ini_close();
						 
						 //Reset globals
						 init_global();
						 
						 //Load song
						 scr_load_music(filename,0,1,0,1);
						 alarm[0]=2;
						 
						 //Reset other things
						 window_set_cursor(cr_default);
						 globalfile="";checkfile=1;
						 
						 //Go to the editor
						 OnAudio=1;
						 
						 }else{ //A name that isn't allowed was set
							 
						   show_message("Name "+string(filename)+" is not allowed"); checkfile=1; globalfile=""; 
						   
						 }
						 
					 break;
					 
					 case Questions.set_time:
					 
					     var _time = ds_map_find_value(async_load, "result");
						 
						 var _length  = audio_sound_length(global.stream);
						 
						 audio_sound_set_track_position(global.currentstream,min(_length,_time));
					 
					 break;
					 
					 case Questions.set_ls:
					   
					    var _time = ds_map_find_value(async_load,"result");
						var _length = audio_sound_length(global.stream);
						
						global.loopstart = min(_length,_time);
					   
					 break;
					 
					 case Questions.set_le:
					   
					    var _time = ds_map_find_value(async_load,"result");
						var _length = audio_sound_length(global.stream);
						
						global.loopend = min(_length,_time);
					   
					 break;
					 
			  }
			  
            }
        }else{ checkfile=1; globalfile=""; if(buffer_exists(musicbuffer)){ buffer_delete(musicbuffer); musicbuffer=-4; } }
    }