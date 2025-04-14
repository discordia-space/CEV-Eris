// IMPORTANT! CLIENT IS A SUBTYPE OF DATUM

/datum/proc/get_view_variables_header()
	return "<b>[src]</b>"

/atom/get_view_variables_header()
	return {"
		<a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='byond://?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=left'><<</a>
		<a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='byond://?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
	"}

/mob/living/get_view_variables_header()
	return {"
		<a href='byond://?_src_=vars;rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='byond://?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=left'><<</a> <a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a> <a href='byond://?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=right'>>></a>
		<br><a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='byond://?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
	"}

/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='byond://?_src_=vars;[HrefToken()];mob_player_panel=\ref[src];'>Show player panel</option>
		<option>---</option>
		<option value='byond://?_src_=vars;[HrefToken()];give_spell=\ref[src];'>Give Spell</option>
		<option value='byond://?_src_=vars;[HrefToken()];give_disease2=\ref[src];'>Give Disease</option>
		<option value='byond://?_src_=vars;[HrefToken()];give_disease=\ref[src];'>Give TG-style Disease</option>
		<option value='byond://?_src_=vars;[HrefToken()];godmode=\ref[src];'>Toggle Godmode</option>
		<option value='byond://?_src_=vars;[HrefToken()];build_mode=\ref[src];'>Toggle Build Mode</option>

		<option value='byond://?_src_=vars;[HrefToken()];make_skeleton=\ref[src];'>Make 2spooky</option>

		<option value='byond://?_src_=vars;[HrefToken()];direct_control=\ref[src];'>Assume Direct Control</option>
		<option value='byond://?_src_=vars;[HrefToken()];drop_everything=\ref[src];'>Drop Everything</option>

		<option value='byond://?_src_=vars;[HrefToken()];regenerateicons=\ref[src];'>Regenerate Icons</option>
		<option value='byond://?_src_=vars;[HrefToken()];addlanguage=\ref[src];'>Add Language</option>
		<option value='byond://?_src_=vars;[HrefToken()];remlanguage=\ref[src];'>Remove Language</option>
		<option value='byond://?_src_=vars;[HrefToken()];addorgan=\ref[src];'>Add Organ</option>
		<option value='byond://?_src_=vars;[HrefToken()];remorgan=\ref[src];'>Remove Organ</option>

		<option value='byond://?_src_=vars;[HrefToken()];fix_nano=\ref[src];'>Fix NanoUI</option>

		<option value='byond://?_src_=vars;[HrefToken()];addverb=\ref[src];'>Add Verb</option>
		<option value='byond://?_src_=vars;[HrefToken()];remverb=\ref[src];'>Remove Verb</option>
		<option>---</option>
		<option value='byond://?_src_=vars;[HrefToken()];gib=\ref[src];'>Gib</option>
	"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='byond://?_src_=vars;[HrefToken()];setspecies=\ref[src];'>Set Species</option>
		<option value='byond://?_src_=vars;[HrefToken()];makeai=\ref[src];'>Make AI</option>
		<option value='byond://?_src_=vars;[HrefToken()];makerobot=\ref[src];'>Make cyborg</option>
		<option value='byond://?_src_=vars;[HrefToken()];makeslime=\ref[src];'>Make slime</option>
	"}

/turf/get_view_variables_options()
	return ..() + {"
		<option value='byond://?_src_=vars;[HrefToken()];teleport_to=\ref[src];'>Teleport to</option>
		<option value='byond://?_src_=vars;[HrefToken()];explode=\ref[src];'>Trigger explosion</option>
		<option value='byond://?_src_=vars;[HrefToken()];emp=\ref[src];'>Trigger EM pulse</option>
	"}

/atom/get_view_variables_options()
	. = ..()
	if(reagents)
		. += "<option value='byond://?_src_=vars;[HrefToken()];addreagent=\ref[src];'>Add reagent</option>"


/atom/movable/get_view_variables_options()
	return ..() + {"
		<option value='byond://?_src_=vars;[HrefToken()];teleport_here=\ref[src];'>Teleport here</option>
		<option value='byond://?_src_=vars;[HrefToken()];teleport_to=\ref[src];'>Teleport to</option>
		<option value='byond://?_src_=vars;[HrefToken()];delall=\ref[src];'>Delete all of type</option>
		<option value='byond://?_src_=vars;[HrefToken()];explode=\ref[src];'>Trigger explosion</option>
		<option value='byond://?_src_=vars;[HrefToken()];emp=\ref[src];'>Trigger EM pulse</option>
	"}

// The following vars cannot be viewed by anyone
/datum/proc/VV_hidden()
	return list()
