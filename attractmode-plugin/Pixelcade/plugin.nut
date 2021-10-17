// Layout User Options

// Layout User Options
class UserConfig  {

}
// PixelCade
class PixelCade {
	user_config = null;
	script_path = "";
	emu_to_pixelcade_map = {
	 Arcade = "mame"
   mame4all = "mame"

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
			  print("Starting Game " + game_title + "\n");
				print("Emulator is " + emulator_str + "\n");
				local cmd_args = "\"" + game_title + "\"";
				      cmd_args += " " + emulator_str;
				      cmd_args += " " + rom_name;
				print("Script path is " + this.script_path + "\n");
				print("Cmd args are : " + cmd_args + "\n");
				fe.plugin_command_bg(this.script_path + "/update_pixelcade.sh", cmd_args );
				break;
		}
		return false;
	}
}
fe.plugin["PixelCade"] <- PixelCade();
