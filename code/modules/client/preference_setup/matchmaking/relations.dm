/datum/preferences
	var/list/relations = list()
	var/list/relations_info = list()

/datum/preferences/proc/GetMatchmakingPage(mob/user)
	.=list()
	. += "<div style='height:420px;overflow-y:auto'>"
	. += "Characters with enabled relations are paired up randomly after spawn. You can terminate relations when you first open relations info window, but after that it's final."
	. += "<hr>"
	. += "<br><b>What do they know about you?</b> This is the general info that all kinds of your connections would know. <a href='?src=\ref[src];relation_info=["general"]'>Edit</a>"
	. += "<br><i>[relations_info["general"] ? relations_info["general"] : "Nothing specific."]</i>"
	. += "<hr>"
	for(var/T in subtypesof(/datum/relation))
		var/datum/relation/R = T
		. += "<b>[initial(R.name)]</b>\t"
		if(initial(R.name) in relations)
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>Off</a>"
		else
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>On</a>"
		. += "<br><i>[initial(R.desc)]</i>"
		. += "<br><b>What do they know about you?</b><a href='?src=\ref[src];relation_info=[initial(R.name)]'>Edit</a>"
		. += "<br><i>[relations_info[initial(R.name)] ? relations_info[initial(R.name)] : "Nothing specific."]</i>"
		. += "<hr>"
	. += "</div>"
	. = jointext(.,null)

/datum/preferences/proc/HandleMatchmakingTopic(var/mob/user,var/list/href_list)
	if(href_list["relation"])
		var/R = href_list["relation"]
		relations ^= R
		return
	if(href_list["relation_info"])
		var/R = href_list["relation_info"]
		var/info = input_utf8(user, "Character info", "What would you like the other party for this connection to know about your character?", relations_info[R], "message")
		if(info)
			relations_info[R] = info
		return
	return ..()
