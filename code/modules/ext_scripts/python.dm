/proc/ext_python(script, args, scriptsprefix = 1)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = CONFIG_GET(string/python_path) + " " + script + " " + args

	return shell(command)
