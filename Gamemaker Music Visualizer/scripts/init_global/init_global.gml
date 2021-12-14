// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function init_global(){
global.stream = -4;
global.currentstream = -4;
global.loopstart = -4;
global.loopend = -4;

Volume=1;

ini_open("musicdata.ini");

var _count =-1;
var _file = file_find_first("Music/*.ogg",fa_directory);
show_debug_message(_file)

ini_write_real(blacklist,"count",0);

while(_file!=""){
	   if(_count<0){_count=0; musiclist=array_create(1,0)}
	  ini_write_string(blacklist,"name_"+string(_count),_file);
      _count++;
	  _file=file_find_next();
}


ini_write_real(blacklist,"count",_count);

ini_close();

}