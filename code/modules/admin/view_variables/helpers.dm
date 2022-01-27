
// Keep these two together, they *must* be defined on both
// If /client ever becomes /datum/client or similar, they can be69erged
/client/proc/get_view_variables_header()
	return "<b>69src69</b>"
/datum/proc/get_view_variables_header()
	return "<b>69src69</b>"

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;datumedit=\ref69src69;varnameedit=name'><b>69src69</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=\ref69src69;rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=\ref69src69;varnameedit=dir'>69dir2text(dir)69</a>
		<a href='?_src_=vars;rotatedatum=\ref69src69;rotatedir=right'>>></a>
		</font>
	"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;rename=\ref69src69'><b>69src69</b></a><font size='1'>
		<br><a href='?_src_=vars;rotatedatum=\ref69src69;rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=\ref69src69;varnameedit=dir'>69dir2text(dir)69</a> <a href='?_src_=vars;rotatedatum=\ref69src69;rotatedir=right'>>></a>
		<br><a href='?_src_=vars;datumedit=\ref69src69;varnameedit=ckey'>69ckey ? ckey : "No ckey"69</a> / <a href='?_src_=vars;datumedit=\ref69src69;varnameedit=real_name'>69real_name ? real_name : "No real name"69</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=brute'>69getBruteLoss()69</a>
		FIRE:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=fire'>69getFireLoss()69</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=toxin'>69getToxLoss()69</a>
		OXY:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=oxygen'>69getOxyLoss()69</a>
		CLONE:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=clone'>69getCloneLoss()69</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=\ref69src69;adjustDamage=brain'>69getBrainLoss()69</a>
		</font>
	"}

// Same for these as for get_view_variables_header() above
/client/proc/get_view_variables_options()
	return ""
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option69alue='?_src_=vars;mob_player_panel=\ref69src69'>Show player panel</option>
		<option>---</option>
		<option69alue='?_src_=vars;give_spell=\ref69src69'>Give Spell</option>
		<option69alue='?_src_=vars;give_disease2=\ref69src69'>Give Disease</option>
		<option69alue='?_src_=vars;give_disease=\ref69src69'>Give TG-style Disease</option>
		<option69alue='?_src_=vars;godmode=\ref69src69'>Toggle Godmode</option>
		<option69alue='?_src_=vars;build_mode=\ref69src69'>Toggle Build69ode</option>

		<option69alue='?_src_=vars;make_skeleton=\ref69src69'>Make 2spooky</option>

		<option69alue='?_src_=vars;direct_control=\ref69src69'>Assume Direct Control</option>
		<option69alue='?_src_=vars;drop_everything=\ref69src69'>Drop Everything</option>

		<option69alue='?_src_=vars;regenerateicons=\ref69src69'>Regenerate Icons</option>
		<option69alue='?_src_=vars;addlanguage=\ref69src69'>Add Language</option>
		<option69alue='?_src_=vars;remlanguage=\ref69src69'>Remove Language</option>
		<option69alue='?_src_=vars;addorgan=\ref69src69'>Add Organ</option>
		<option69alue='?_src_=vars;remorgan=\ref69src69'>Remove Organ</option>

		<option69alue='?_src_=vars;fix_nano=\ref69src69'>Fix NanoUI</option>

		<option69alue='?_src_=vars;addverb=\ref69src69'>Add69erb</option>
		<option69alue='?_src_=vars;remverb=\ref69src69'>Remove69erb</option>
		<option>---</option>
		<option69alue='?_src_=vars;gib=\ref69src69'>Gib</option>
	"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option69alue='?_src_=vars;setspecies=\ref69src69'>Set Species</option>
		<option69alue='?_src_=vars;makeai=\ref69src69'>Make AI</option>
		<option69alue='?_src_=vars;makerobot=\ref69src69'>Make cyborg</option>
		<option69alue='?_src_=vars;makemonkey=\ref69src69'>Make69onkey</option>
		<option69alue='?_src_=vars;makeslime=\ref69src69'>Make slime</option>
	"}

/turf/get_view_variables_options()
	return ..() + {"
		<option69alue='?_src_=vars;teleport_to=\ref69src69'>Teleport to</option>
		<option69alue='?_src_=vars;explode=\ref69src69'>Trigger explosion</option>
		<option69alue='?_src_=vars;emp=\ref69src69'>Trigger EM pulse</option>
	"}

/atom/get_view_variables_options()
	. = ..()
	if(reagents)
		. += "<option69alue='?_src_=vars;addreagent=\ref69src69'>Add reagent</option>"


/atom/movable/get_view_variables_options()
	return ..() + {"
		<option69alue='?_src_=vars;teleport_here=\ref69src69'>Teleport here</option>
		<option69alue='?_src_=vars;teleport_to=\ref69src69'>Teleport to</option>
		<option69alue='?_src_=vars;delall=\ref69src69'>Delete all of type</option>
		<option69alue='?_src_=vars;explode=\ref69src69'>Trigger explosion</option>
		<option69alue='?_src_=vars;emp=\ref69src69'>Trigger EM pulse</option>
	"}

// The following69ars cannot be69iewed by anyone
/datum/proc/VV_hidden()
	return list()