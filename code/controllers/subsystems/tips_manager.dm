GLOBAL_LIST_EMPTY(gameplayTips)
GLOBAL_LIST_EMPTY(mobsTips)
GLOBAL_LIST_EMPTY(rolesTips)
GLOBAL_LIST_EMPTY(jobsTips)
SUBSYSTEM_DEF(tips)
	name = "Tips and Tricks"
	priority = SS_PRIORITY_TIPS
	//Initializes at default time
	flags = SS_NO_FIRE

/client/verb/showRandomTip()
	set name = "Show Random Tip"
	set category = "OOC"
	if(SSticker.current_state > GAME_STATE_STARTUP)
		if(mob)
			var/tipsAndTricks/T = SStips.getRandomTip()
			if(T)
				mob << SStips.formatTip(T, "Random Tip: ")

/client/verb/showSmartTip()
	set name = "Show Smart Tip"
	set category = "OOC"
	if(SSticker.current_state > GAME_STATE_STARTUP)
		if(mob)
			var/tipsAndTricks/T = SStips.getSmartTip(mob)
			if(T)
				mob << SStips.formatTip(T, "Tip for your character: ")

/datum/controller/subsystem/tips/Initialize(start_timeofday)
	for(var/path in typesof(/tipsAndTricks/mobs) - /tipsAndTricks/mobs)
		var/tipsAndTricks/mobs/T = new path()
		for(var/mob in T.mobs_list)
			if(!GLOB.mobsTips[mob])
				GLOB.mobsTips[mob] = list()
			GLOB.mobsTips[mob] += T
	for(var/path in typesof(/tipsAndTricks/roles) - /tipsAndTricks/roles)
		var/tipsAndTricks/roles/T = new path()
		for(var/role in T.roles_list)
			if(!GLOB.rolesTips[role])
				GLOB.rolesTips[role] = list()
			GLOB.rolesTips[role] += T
	for(var/path in typesof(/tipsAndTricks/jobs) - /tipsAndTricks/jobs)
		var/tipsAndTricks/jobs/T = new path()
		for(var/job in T.jobs_list)
			if(!GLOB.jobsTips[job])
				GLOB.jobsTips[job] = list()
			GLOB.jobsTips[job] += T
	for(var/path in typesof(/tipsAndTricks/gameplay) - /tipsAndTricks/gameplay)
		var/tipsAndTricks/gameplay/T = new path()
		GLOB.gameplayTips += T
	return ..()

/datum/controller/subsystem/tips/proc/getRandomTip()
	var/list/allTips = list()
	allTips += GLOB.gameplayTips
	for(var/mob in GLOB.mobsTips)
		allTips += GLOB.mobsTips[mob]
	for(var/role in GLOB.rolesTips)
		allTips += GLOB.rolesTips[role]
	for(var/job in GLOB.jobsTips)
		allTips += GLOB.jobsTips[job]
	var/tipsAndTricks/T = pick(allTips)
	return T

/datum/controller/subsystem/tips/proc/getSmartTip(var/mob/target)
	if(!target)
		return
	// We need types
	var/roleType
	var/jobType
	if(target.mind)
		roleType = target.mind.antagonist.len ? pick(target.mind.antagonist).type : null	//pick random role cuz its a list
		jobType = target.mind.assigned_job ? target.mind.assigned_job.type : null
	var/mobType = target.type ? target.type : null

	var/list/options = list()
	// Returning tip based on weight, we want more specific tips for player based on its character
	if(roleType)
		var/tipsAndTricks/T = getRoleTip(mobType)
		if(T)
			options[T] = 40
	if(jobType)
		var/tipsAndTricks/T = getJobTip(mobType)
		if(T)
			options[T] = 30
	if(mobType)
		var/tipsAndTricks/T = getMobTip(mobType)
		if(T)
			options[T] = 20
	var/tipsAndTricks/T = getGameplayTip()
	if(T)
		options[T] = 10
	var/tipsAndTricks/result = pickweight(options)
	return result

/datum/controller/subsystem/tips/proc/formatTip(var/tipsAndTricks/T, var/startText, var/plainText = FALSE)
	if(plainText)
		return "[startText ? "<b>[startText]</b>" : ""][T.getText()]"
	else
		return "<font color='[T.textColor]'>[startText ? "<b>[startText]</b>" : ""][T.getText()]</font>"

/datum/controller/subsystem/tips/proc/getGameplayTip(var/startText)
	if(GLOB.gameplayTips)
		var/tipsAndTricks/T = pick(GLOB.gameplayTips)
		return T

/datum/controller/subsystem/tips/proc/getRoleTip(var/path)
	if(!ispath(path))
		error("Not path variable was passed to tips subsystem. No tips for you.")
	if(GLOB.rolesTips[path])
		var/tipsAndTricks/T = pick(GLOB.rolesTips[path])
		return T

/datum/controller/subsystem/tips/proc/getJobTip(var/path)
	if(!ispath(path))
		error("Not path variable was passed to tips subsystem. No tips for you.")
	if(GLOB.jobsTips[path])
		var/tipsAndTricks/T = pick(GLOB.jobsTips[path])
		return T

/datum/controller/subsystem/tips/proc/getMobTip(var/path)
	if(!ispath(path))
		error("Not path variable was passed to tips subsystem. No tips for you.")
	if(GLOB.mobsTips[path])
		var/tipsAndTricks/T = pick(GLOB.mobsTips[path])
		return T
