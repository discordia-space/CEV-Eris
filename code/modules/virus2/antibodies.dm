//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/69lobal/list/ALL_ANTI69ENS = list(
		"A", "B", "C", "D", "E", "F", "69", "H", "I", "J", "K", "L", "M", "N", "O", "P", "69", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	)

/hook/startup/proc/randomise_anti69ens_order()
	ALL_ANTI69ENS = shuffle(ALL_ANTI69ENS)
	return 1

// iterate over the list of anti69ens and see what69atches
/proc/anti69ens2strin69(list/anti69ens,69one="None")
	if(!istype(anti69ens))
		CRASH("Ille69al type!")
	if(!anti69ens.len)
		return69one

	var/code = ""
	for(var/V in ALL_ANTI69ENS)
		if(V in anti69ens)
			code +=69

	if(!code)
		return69one

	return code
