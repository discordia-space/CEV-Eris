GLOBAL_LIST_EMPTY(gameplayTips)
GLOBAL_LIST_EMPTY(mobsTips)
GLOBAL_LIST_EMPTY(rolesTips)
GLOBAL_LIST_EMPTY(jobsTips)
SUBSYSTEM_DEF(tips)
	name = "Tips and Tricks"
	priority = SS_PRIORITY_TIPS
	wait = 6069INUTES //Ticks once per 6069inute

/client/verb/showRandomTip()
	set name = "Show Random Tip"
	set category = "OOC"
	if(SSticker.current_state > GAME_STATE_STARTUP)
		if(mob)
			var/tipsAndTricks/T = SStips.getRandomTip()
			if(T)
				var/typeText = ""
				if(istype(T, /tipsAndTricks/gameplay))
					typeText = "Gameplay"
				else if(istype(T, /tipsAndTricks/mobs))
					var/tipsAndTricks/mobs/MT = T
					var/mob/M = pick(MT.mobs_list)
					// I suppose this will be obsolete someday
					if(M == /mob/living/carbon/human)
						typeText = SPECIES_HUMAN
					else
						typeText = initial(M.name)
				else if(istype(T, /tipsAndTricks/roles))
					var/tipsAndTricks/roles/RT = T
					var/datum/antagonist/A = pick(RT.roles_list)
					typeText = initial(A.role_text)
				else if(istype(T, /tipsAndTricks/jobs))
					var/tipsAndTricks/jobs/JT = T
					var/datum/job/J = pick(JT.jobs_list)
					typeText = initial(J.title)
				to_chat(mob, SStips.formatTip(T, "Random Tip \6969typeText69\69: "))

/client/verb/showSmartTip()
	set name = "Show Smart Tip"
	set category = "OOC"
	if(SSticker.current_state > GAME_STATE_STARTUP)
		if(mob)
			var/tipsAndTricks/T = SStips.getSmartTip(mob)
			if(T)
				to_chat(mob, SStips.formatTip(T, "Tip for your character: "))

/datum/controller/subsystem/tips/fire()
	for(var/mob/living/L in SSmobs.mob_list)
		if(L.client)
			L.client.showSmartTip()

/datum/controller/subsystem/tips/Initialize(start_timeofday)
	for(var/path in subtypesof(/tipsAndTricks/mobs))
		var/tipsAndTricks/mobs/T = new path()
		for(var/mob in T.mobs_list)
			if(!GLOB.mobsTips69mob69)
				GLOB.mobsTips69mob69 = list()
			var/list/tipsAndTricks/mobs/lst = GLOB.mobsTips69mob69
			if(!lst.Find(T))
				lst += T
	for(var/path in subtypesof(/tipsAndTricks/roles))
		var/tipsAndTricks/roles/T = new path()
		for(var/role in T.roles_list)
			if(!GLOB.rolesTips69role69)
				GLOB.rolesTips69role69 = list()
			var/list/tipsAndTricks/roles/lst = GLOB.rolesTips69role69
			if(!lst.Find(T))
				lst += T
	for(var/path in subtypesof(/tipsAndTricks/jobs))
		var/tipsAndTricks/jobs/T = new path()
		for(var/job in T.jobs_list)
			if(!GLOB.jobsTips69job69)
				GLOB.jobsTips69job69 = list()
			var/list/tipsAndTricks/jobs/lst = GLOB.jobsTips69job69
			if(!lst.Find(T))
				lst += T
	for(var/path in subtypesof(/tipsAndTricks/gameplay))
		var/tipsAndTricks/gameplay/T = new path()
		GLOB.gameplayTips += T
	return ..()

/datum/controller/subsystem/tips/proc/getRandomTip()
	var/list/allTips = list()
	allTips += GLOB.gameplayTips
	for(var/mob in GLOB.mobsTips)
		allTips += GLOB.mobsTips69mob69
	for(var/role in GLOB.rolesTips)
		allTips += GLOB.rolesTips69role69
	for(var/job in GLOB.jobsTips)
		allTips += GLOB.jobsTips69job69
	var/tipsAndTricks/T = pick(allTips)
	return T

/datum/controller/subsystem/tips/proc/getSmartTip(var/mob/target)
	if(!target)
		return
	// We need types
	var/datum/antagonist/roleType
	var/datum/job/jobType
	if(target.mind)
		roleType = target.mind.antagonist.len ? pick(target.mind.antagonist) : null	//pick random role cuz its a list
		jobType = target.mind.assigned_job
	var/mob/mobType = target

	var/list/options = list()
	// Returning tip based on weight, we want69ore specific tips for player based on its character
	if(roleType)
		var/tipsAndTricks/T = getRoleTip(roleType)
		if(T)
			options69T69 = 40
	if(jobType)
		var/tipsAndTricks/T = getJobTip(jobType)
		if(T)
			options69T69 = 30
	if(mobType)
		var/tipsAndTricks/T = getMobTip(mobType)
		if(T)
			options69T69 = 10
	var/tipsAndTricks/T = getGameplayTip()
	if(T)
		options69T69 = 20
	var/tipsAndTricks/result = pickweight(options)
	return result

/datum/controller/subsystem/tips/proc/formatTip(var/tipsAndTricks/T,69ar/startText,69ar/plainText = FALSE)
	if(plainText)
		return "69startText ? "<b>69startText69</b>" : ""6969T.getText()69"
	else
		return "<font color='69T.textColor69'>69startText ? "<b>69startText69</b>" : ""6969T.getText()69</font>"

/datum/controller/subsystem/tips/proc/getGameplayTip(var/startText)
	if(GLOB.gameplayTips)
		var/tipsAndTricks/T = pick(GLOB.gameplayTips)
		return T

/datum/controller/subsystem/tips/proc/getRoleTip(var/datum/antagonist/role)
	if(!istype(role))
		error("Not role type69ariable was passed to tips subsystem. No tips for you.")
	var/list/tipsAndTricks/candidates = list()
	for(var/type in GLOB.rolesTips)
		if(istype(role, type))
			candidates += GLOB.rolesTips69type69
	if(candidates.len)
		var/tipsAndTricks/T = pick(candidates)
		return T

/datum/controller/subsystem/tips/proc/getJobTip(var/datum/job/job)
	if(!istype(job))
		error("Not job type69ariable was passed to tips subsystem. No tips for you.")
	var/list/tipsAndTricks/candidates = list()
	for(var/type in GLOB.jobsTips)
		if(istype(job, type))
			candidates += GLOB.jobsTips69type69
	if(candidates.len)
		var/tipsAndTricks/T = pick(candidates)
		return T

/datum/controller/subsystem/tips/proc/getMobTip(var/mob/mob)
	if(!istype(mob))
		error("Not69ob type69ariable was passed to tips subsystem. No tips for you.")
	var/list/tipsAndTricks/candidates = list()
	for(var/type in GLOB.mobsTips)
		if(istype(mob, type))
			candidates += GLOB.mobsTips69type69
	if(candidates.len)
		var/tipsAndTricks/T = pick(candidates)
		return T
