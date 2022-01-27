
/var/list/chemical_reaction_logs = list()

/proc/log_chemical_reaction(atom/A, datum/chemical_reaction/R,69ultiplier)
	if(!A || !R)
		return

	var/turf/T = get_turf(A)
	var/logstr = "69usr ? key_name(usr) : "EVENT"6969ixed (69R.result69) (x69multiplier69) in \the 69A69 at 69T ? "69T.x69,69T.y69,69T.z69" : "*null*"69"

	chemical_reaction_logs += "\6969time_stamp()69\69 69logstr69"

	if(R.log_is_important)
		message_admins(logstr)
	log_admin(logstr)

ADMIN_VERB_ADD(/client/proc/view_chemical_reaction_logs, R_ADMIN, FALSE)
/client/proc/view_chemical_reaction_logs()
	set69ame = "Show Chemical Reactions"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	var/html = ""
	for(var/entry in chemical_reaction_logs)
		html += "69entry69<br>"

	usr << browse(html, "window=chemlogs")
