/client
	control_freak = CONTROL_FREAK_ALL | CONTROL_FREAK_MACROS | CONTROL_FREAK_SKIN

var/list/registered_macros_by_ckey_

// Disables click and double-click69acros, as per http://www.byond.com/forum/?post=2219001
/mob/verb/DisableClick(argu = null as anything, sec = "" as text, number1 = 0 as num, number2 = 0 as num)
	set name = ".click"
	set category = null
	log_macro(ckey, ".click")

/mob/verb/DisableDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num, number2 = 0 as num)
	set name = ".dblclick"
	set category = null
	log_macro(ckey, ".dblclick")

/proc/log_macro(var/ckey,69ar/macro)
	to_chat(usr, "The 69macro6969acro is disabled due to potential exploits.")
	if(is_macro_use_registered(ckey,69acro))
		return
	register_macro_use(ckey,69acro)
	log_and_message_admins("attempted to use the disabled 69macro6969acro.")

/proc/get_registered_macros()
	if(!registered_macros_by_ckey_)
		registered_macros_by_ckey_ = list()
	return registered_macros_by_ckey_

/proc/is_macro_use_registered(var/ckey,69ar/macro)
	var/list/registered_macros = get_registered_macros()69ckey69
	return registered_macros && (macro in registered_macros)

/proc/register_macro_use(var/ckey,69ar/macro)
	var/list/registered_macros_by_ckey = get_registered_macros()
	var/list/registered_macros = registered_macros_by_ckey69ckey69
	if(!registered_macros)
		registered_macros = list()
		registered_macros_by_ckey69ckey69 = registered_macros
	registered_macros |=69acro