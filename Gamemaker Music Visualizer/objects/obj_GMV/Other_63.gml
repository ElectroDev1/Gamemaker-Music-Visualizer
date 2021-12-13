/// @description Get answers
var i_d = ds_map_find_value(async_load, "id");
if i_d == msg
    {
    if ds_map_find_value(async_load, "status")
        {
        if ds_map_find_value(async_load, "result") != ""
            {
			  filename=ds_map_find_value(async_load, "result")
              
			  //Get anwser
			  switch(AnswerWait){
				     case Questions.new_file:
					   
					     if(filename!=blacklist){
					 
					     //Create a new music file
					     musicbuffer = buffer_load(globalfile);
						 buffer_save(musicbuffer,working_directory+"Music/"+string(filename)+".ogg");
						 show_debug_message("Saved new music file as '"+string(filename));
						 
						 /*var _file = file_text_open_write("musicdata.ini");
						 
						 file_text_write_string(_file,"# Music data file");  
						 file_text_writeln(_file);
                         file_text_write_string(_file,"# The section is used for reference in the game");
                         file_text_writeln(_file);
                         file_text_write_string(_file,"# .ogg at the end of the file name is not needed");
                         file_text_writeln(_file);
                         file_text_write_string(_file,"# loop start and end are in seconds")
						 
						 file_text_close(_file);*/
						 
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
						 scr_load_music(filename,0,1,1,1);
						 alarm[0]=2;
						 
						 window_set_cursor(cr_default)
						 globalfile="";checkfile=1;
						 
						 OnAudio=1;
						 
						 }else{ show_message("Name "+string(filename)+" is not allowed"); checkfile=1; globalfile=""; }
						 
					 break;
			  }
			  
            }
        }else{ checkfile=1; globalfile=""; if(buffer_exists(musicbuffer)){ buffer_delete(musicbuffer); musicbuffer=-4; } }
    }