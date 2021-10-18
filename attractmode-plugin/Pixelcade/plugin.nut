// Layout User Options

// Layout User Options
class UserConfig  {

}
// Pixelcade Plug in for Attract Mode Source
class PixelCade {
	user_config = null;
	script_path = "";
	emu_to_pixelcade_map = {
	   Arcade = "mame"
     mame4all = "mame"
     mame172 = "mame"
     advmame = "mame"
     mame230 = "mame"
     mame203 = "mame"
     mame094 = "mame"
     mame078 = "mame"
     mame037 = "mame"
     mame139 = "mame"
     gameboy = "gb"
     fba = "fba"
     gameboyadvance = "gba"
     gameboycolor = "gbc"
     commodore64 = "c64"
     nintendo = "nes"
     pcenginecd = "nec_pc_engine-cd"
     playstation = "psx"
     openbor = "openbor"
     turbografx = "turbografx"
     supernintendo = "snes"
     super_nintendo = "snes"
     atari2600 = "atari2600"
     atari7800 = "atari7800"
     colecovision = "coleco"
     genesis = "genesis"
     daphne = "daphne"
     mastersystem = "mastersystem"
     megadrive = "megadrive"
     pcengine = "pcengine"
     sega32x = "sega32x"
     segacd = "segacd"
     supergrafx = "nec_supergrafx"
     vextrex = "vextrex"
}

	constructor() {
		user_config = fe.get_config();
		script_path =  fe.script_dir + "/scripts";
		fe.add_transition_callback(this, "transitions");
	}

	function transitions(ttype, var, ttime) {
        switch(ttype) {
			  case Transition.ToGame:
			  case Transition.ToNewSelection:
			  case Transition.FromGame:
				local game_title = fe.game_info(Info.Title,var);
				local emulator_str = fe.game_info(Info.Emulator, var);
				local rom_name = fe.game_info(Info.Name, var);
			  //print("Game Title " + game_title + "\n");
				//print("Emulator is " + emulator_str + "\n");
        //print("ROM name is " + rom_name + "\n");

        local emulator_mapped = "mame";
        try {
            emulator_mapped=this.emu_to_pixelcade_map[emulator_str];
          } catch(exception) {
            emulator_mapped=emulator_str;
        }
        //print("mapped emulator is " + emulator_mapped + "\n");

				local cmd_args = "\"" + game_title + "\"";
              cmd_args += " " + "\"" + emulator_mapped + "\"";
              cmd_args += " " + "\"" + rom_name + "\"";

        //print("Script path is " + this.script_path + "\n");
				print("[COMMAND] : " + cmd_args + "\n");
				fe.plugin_command_bg(this.script_path + "/update_pixelcade.sh", cmd_args );
				break;
		}
		return false;
	}
}
fe.plugin["PixelCade"] <- PixelCade();
