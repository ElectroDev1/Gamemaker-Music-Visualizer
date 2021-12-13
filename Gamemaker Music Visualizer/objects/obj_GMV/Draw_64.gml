/// @description Editor hud
draw_set_font(Font1);
draw_set_halign(fa_center);draw_set_colour(c_white);draw_set_valign(fa_top);

//Title
draw_text_transformed(room_width/2,15,"Gamemaker Music Visualizer",2,2,0);

draw_set_halign(fa_center);draw_set_valign(fa_top);

#region Start menu
if(!OnAudio){
	
	var _roof = 15+string_height("M")*2;
	
	draw_set_alpha(0.2);
	
	//Select
	if(device_mouse_y_to_gui(0)>_roof){ if(AnswerWait==-1){ window_set_cursor(cr_handpoint); }
	
	if(device_mouse_x_to_gui(0)<room_width/2){
	   draw_rectangle(0,_roof,room_width/2,room_height,0);	
	}
	else{
	   draw_rectangle(room_width/2,_roof,room_width,room_height,0);	
	}
	
	}else{  window_set_cursor(cr_default); }
	
	draw_set_alpha(1);
	
	//Text
	draw_text(room_width/4,room_height/2,"Click to open a\nnew .ogg file");
	
	draw_text(room_width-room_width/4,room_height/2,"Click to select a song\nfrom the data file");
	
    draw_line_width(room_width/2,_roof,room_width/2,room_height,3);
	
}
#endregion

#region Select song
else if(OnAudio==2){ //List of pre existing songs
	
	var _roof = 15+string_height("M")*4;
	
	draw_text_transformed(room_width/2,15+string_height("M")*2+8,"Select a song",1.5,1.5,0);
	
	for(var a=0; a<array_length(musiclist); a++){
				
		var _Y = _roof+20+(string_height("M")+18)*a;
		var _str = string_replace_all(musiclist[a],".ogg","");
		
		if(mouse_in_rectangle(room_width/2-string_width(_str)/2-4,
		_Y-6,room_width/2+string_width(_str)/2+4,
		_Y+string_height(_str)+4)){
		
		draw_rectangle(room_width/2-string_width(_str)/2-4,
		_Y-6,room_width/2+string_width(_str)/2+4,
		_Y+string_height(_str)+4,1);

          if(mouse_check_button_pressed(mb_left)){
			  scr_load_music(_str,0,1,1,1,1);
			  
			  alarm[0]=2;
			  
			  filename=_str;
			  OnAudio=1;
		  }
		
		}
	
	
	    draw_text(room_width/2,_Y,_str);	
		
	}
	
	if(!is_array(musiclist)){
	   draw_text(room_width/2,room_height/2,"No song found");	
	}
	
	var _back = draw_button_ext(4,room_height-40,mouse_check_button(mb_left),"click",
	"Back",1,2,1.5)
	
	if(_back){ OnAudio=0; }
	
}
#endregion

#region Playing menu
else if(OnAudio==1){
	
	draw_text_transformed(room_width/2,15+string_height("M")*2+8,"Visualizing '"+string(filename)+"'",1.5,1.5,0);
	
	if(editloop!=0){
	draw_text_transformed(room_width/2,15+string_height("M")*5+12,"Press Enter to stop editing loop points",1,1,0);
	}
	
	//Draw timeline
	var _playpos = audio_sound_get_track_position(global.currentstream);
	var _length  = audio_sound_length(global.stream);
	var _playing = audio_is_playing(global.currentstream);
	var _paused = audio_is_paused(global.currentstream);
	
	var _W = 600;
	var _H = 40;
	var _Y = room_height/2-_H/2
	var _X = room_width/2-_W/2;
	var _pad = 8;
	
	
	if(!useloops){
	   
	   if(mouse_in_rectangle(_X-10,_Y,_X+_W+10,_Y+_H)){
		  if(mouse_check_button(mb_left)){

			 audio_sound_set_track_position(global.currentstream, 
			  min( max( (mouse_x-_X)/13.7, 0 ),_length ) 
			 );
			  
		  }   
	   }
	   
	}
	
	var _rW = (_W/_length)*_playpos;
	
	if(useloops)&&(global.loopend>=0)&&(global.loopstart>=0){
	  _rW = min((_W/_length)*_playpos,(_W/_length)*global.loopend);	
	}
	
	draw_line_width(_X-_pad,_Y-_pad,_X-_pad,_Y+_H+_pad,2);
	draw_line_width(_X+_W+_pad,_Y-_pad,_X+_W+_pad,_Y+_H+_pad,2);
	
	draw_set_alpha(0.2);
    draw_rectangle(_X,_Y,_X+_W,_Y+_H,0);
	
	if(global.loopstart>=0)&&(global.loopend>=0)&&(useloops){
	   draw_set_colour(c_red);
	   draw_rectangle(
	   _X+ max((_W/_length)*global.loopstart,0),_Y,
	   _X+ max((_W/_length)*global.loopend,0),_Y+_H,0);
	   draw_set_colour(c_white);
	}
	
	draw_set_alpha(1);
    draw_rectangle(_X,_Y,_X+max(1,_rW),_Y+_H,0);
	
	
	
	//Draw loop start
	var _loopX = _X+ max((_W/_length)*global.loopstart,0);
	var _pad = 6;
	
	if(global.loopstart>=0){
	
	   var _sec = global.loopstart%60;
	   var _min = global.loopstart/60;
	   draw_set_color(c_white);
	   if(editloop==1){draw_set_color(c_red);
		   
		  if(mouse_in_rectangle(_X-10,_Y-80,_X+_W+10,_Y)){
			 if(mouse_check_button(mb_left)){
			    global.loopstart = min( max( (mouse_x-_X)/13.7, 0 ),_length );
			 }
	      }   
		   
	   }
	   draw_triangle(_loopX,_Y-_pad,_loopX-8,_Y-28,_loopX+8,_Y-28,0);	
	   
	   if(useloops){
		  draw_set_color(c_red);
		  draw_line_width(_loopX,_Y-_pad,_loopX,_Y+_H+_pad,2);
		  draw_set_color(c_white);
	   }
	   
	   draw_set_color(c_white);
	   draw_set_halign(fa_center);draw_set_valign(fa_bottom);
	   draw_text_transformed(_loopX+10,_Y-32,
	   "L.S."+"\n"+string_replace_all( string_format(_min,2,0)," ","0" )+":"+string_replace_all(string_format(_sec,2,2)," ","0")
	   ,1,1,0);
	   
	   
	   
	}
	
	
	//Draw loop end
	var _loopX = _X+ max((_W/_length)*global.loopend,0);
	var _pad = 6;
	
	if(global.loopend>=0){
	
	   var _sec = global.loopend%60;
	   var _min = global.loopend/60;
	   draw_set_color(c_white);
	   if(editloop==2){draw_set_color(c_red);
		
		  if(mouse_in_rectangle(_X-10,_Y,_X+_W+10,_Y+_H+80)){
			 if(mouse_check_button(mb_left)){
			    global.loopend = min( max( (mouse_x-_X)/13.7, 0 ),_length );
			 }
	      } 
		   
	   }
	   
	   draw_triangle(_loopX,_Y+_H+_pad,_loopX-8,_Y+_H+28,_loopX+8,_Y+_H+28,0);
	   
	   if(useloops){
		  draw_set_color(c_red);
		  draw_line_width(_loopX,_Y-_pad,_loopX,_Y+_H+_pad,2);
		  draw_set_color(c_white);
	   }
	   
	   draw_set_color(c_white);
	   draw_set_halign(fa_center);draw_set_valign(fa_top);
	   draw_text_transformed(_loopX+10,_Y+_H+34,
	   "L.E."+"\n"+string_replace_all( string_format(_min,2,0)," ","0" )+":"+string_replace_all(string_format(_sec,2,2)," ","0")
	   ,1,1,0);
	   
	   
	   
	}
	
	if(keyboard_check_pressed(vk_enter)){ editloop=0; }
	
	
	
	
	//Time values
	draw_set_halign(fa_right);draw_set_valign(fa_middle);
	
	var _sec = (_playpos%60)
	var _min = (_playpos/60);
	
	draw_text(_X-_pad*2,_Y+_H/2+4,string_replace_all( string_format(_min,2,0)," ","0" )+
	                                  ":"+string_replace_all(string_format(_sec,2,2)," ","0"));
	
	draw_set_halign(fa_left);
	
	var _sec = (_length%60);
	var _min = (_length-_sec)/60;
	
	draw_text(_X+_W+_pad*2,_Y+_H/2+4, string_replace_all( string_format(_min,2,0)," ","0" )+
	                                  ":"+string_replace_all(string_format(_sec,2,2)," ","0"));
	
	draw_set_halign(fa_center);draw_set_valign(fa_top);
	
	//Buttons
	var _back = draw_button_ext(4,room_height-40,mouse_check_button(mb_left),"click",
	"Back",1,2,1.5)
	
	if(_back){ init_global(); 
		
		ini_open("musicdata.ini")
			   
			   var _count = ini_read_real(blacklist,"count",0);
			   
			   for(var a=0; a<_count; a++){
				   musiclist[a] = ini_read_string(blacklist,"name_"+string(a),"No name found");
			   }
			   
			   ini_close();
			  
		
		
		OnAudio=2; }
	
	var _save = draw_button_ext(4+string_width("Back")*1.5+16,room_height-40,mouse_check_button(mb_left),"click",
	"Save",1,2,1.5)
	
	if(_save){ 
	   
	   ini_open("musicdata.ini");
	   
	   ini_write_real(filename,"loopend",global.loopend);
	   ini_write_real(filename,"loopstart",global.loopstart);
	   
	   ini_close();
	   
	   show_message("Loop points saved and copied to clipboard.")
	   
	   clipboard_set_text(string(global.loopstart)+","+string(global.loopend));
	   
	}
	
	
	if((!_playing)||(_paused))&&(paused){
	   var _Bstr = "Play";	
	}else{
	   var _Bstr = "Pause";	
	}
	
	var _play = draw_button_ext(room_width/2-string_width(_Bstr)*1.5-10,room_height-40,mouse_check_button(mb_left),"click",
	_Bstr,1,2,1.5)
	
	if(_play){
	   if(_paused){
		  audio_resume_sound(global.currentstream);   
		  paused=0;
	   }else if(!_playing){
		  global.currentstream = audio_play_sound(global.stream,0,1); 
		  paused=0;
	   }else{
		  audio_pause_sound(global.currentstream)   
		  paused=1;
	   }
	}
	
	
	var _stop = draw_button_ext(room_width/2+10,room_height-40,mouse_check_button(mb_left),"click",
	"Stop",1,2,1.5)
	
	if(_stop){ 
	   if(_playing)||(_paused){
		  audio_pause_sound(global.currentstream)
		  audio_sound_set_track_position(global.currentstream,0); 
		  paused=1;
	   }
	}
	
	
	var _loopstart = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,room_height-40-string_height("M")*1.5-10,mouse_check_button(mb_left),"click",
	"Set L.S.",1,2,1.5)
	
	if(_loopstart){
	   global.loopstart=max(global.loopstart,0);	
	   editloop=1;
	}
	
	var _startX = draw_button_ext(room_width-string_width("X")*1.5-12,room_height-40-string_height("M")*1.5-10,mouse_check_button(mb_left),"click",
	"X",1,2,1.5)
	
	if(_startX){ 
	   editloop=0;
	   global.loopstart=-4;
	}
	
	
	var _loopend = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,room_height-40,mouse_check_button(mb_left),"click",
	"Set L.E.",1,2,1.5)
	
	if(_loopend){ 
	   global.loopend=max(global.loopend,0);	
	   editloop=2;
	}
	
	var _endX = draw_button_ext(room_width-string_width("X")*1.5-12,room_height-40,mouse_check_button(mb_left),"click",
	"X",1,2,1.5)
	
	if(_endX){ 
	   editloop=0;	
	   global.loopend=-4;
	}
	
	var _useloops = draw_button_ext(room_width-string_width("X")*2-20-string_width("Set L.S.")*1.5,room_height-40-string_height("M")*3-20,mouse_check_button(mb_left),"click",
	"Use loops",1,2,1.5)
	
	if(_useloops){ 
	   useloops=!useloops;
	}
	
	
}
#endregion