/proc/ext_python(var/script,69ar/args,69ar/scriptsprefix = 1)
	if(scriptsprefix) script = "scripts/" + script

	if(world.system_type ==69S_WINDOWS)
		script = replacetext(script, "/", "\\")

	var/command = config.python_path + " " + script + " " + args

	return shell(command)
