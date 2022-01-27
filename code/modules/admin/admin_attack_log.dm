/mob/var/lastattacker = null
/mob/var/lastattacked = null
/mob/var/attack_log = list()

proc/log_and_message_admins(var/message as text,69ar/mob/user = usr,69ar/turf/location)
	var/turf/T = location ? location : (user ? get_turf(user) : null)
	if(T)
		message =69essage + " (<a HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69T.x69;Y=69T.y69;Z=69T.z69'>JMP</a>)"

	log_admin(user ? "69key_name(user)69 69message69" : "EVENT 69message69")
	message_admins(user ? "69key_name_admin(user)69 69message69" : "EVENT 69message69")

proc/log_and_message_admins_many(var/list/mob/users,69ar/message)
	if(!users || !users.len)
		return

	var/list/user_keys = list()
	for(var/mob/user in users)
		user_keys += key_name(user)

	log_admin("69english_list(user_keys)69 69message69")
	message_admins("69english_list(user_keys)69 69message69")

proc/admin_attack_log(var/mob/attacker,69ar/mob/victim,69ar/attacker_message,69ar/victim_message,69ar/admin_message)
	if(victim)
		victim.attack_log += text("\6969time_stamp()69\69 <font color='orange'>69key_name(attacker)69 - 69victim_message69</font>")
	if(attacker)
		attacker.attack_log += text("\6969time_stamp()69\69 <font color='red'>69key_name(victim)69 - 69attacker_message69</font>")

	msg_admin_attack("69key_name(attacker)69 69admin_message69 69key_name(victim)69 (INTENT: 69attacker? uppertext(attacker.a_intent) : "N/A"69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69attacker.x69;Y=69attacker.y69;Z=69attacker.z69'>JMP</a>)")

proc/admin_attacker_log_many_victims(var/mob/attacker,69ar/list/mob/victims,69ar/attacker_message,69ar/victim_message,69ar/admin_message)
	if(!victims || !victims.len)
		return

	for(var/mob/victim in69ictims)
		admin_attack_log(attacker,69ictim, attacker_message,69ictim_message, admin_message)

proc/admin_inject_log(mob/attacker,69ob/victim, obj/item/weapon, reagents, amount_transferred,69iolent=0)
	if(violent)
		violent = "violently "
	else
		violent = ""
	admin_attack_log(attacker,
	                69ictim,
	                 "used \the 69weapon69 to 69violent69inject - 69reagents69 - 69amount_transferred69u transferred",
	                 "was 69violent69injected with \the 69weapon69 - 69reagents69 - 69amount_transferred69u transferred",
	                 "used \the 69weapon69 to 69violent69inject 69reagents69 (69amount_transferred69u transferred) into")
