/proc/ext_python(script, arguments, scriptsprefix = 1)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type == MS_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = CONFIG_GET(string/python_path) + " " + script + " " + arguments

	return shell(command)
