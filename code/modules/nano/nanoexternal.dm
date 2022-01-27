 // This file contains all69ano procs/definitions for external classes/objects

 /**
  * A "panic button"69erb to close all UIs on current69ob.
  * Use it when the bug with UI69ot opening (because the server still considers it open despite it being closed on client) pops up.
  * Feel free to remove it once the bug is confirmed to be fixed.
  *
  * @return69othing
  */
/client/verb/resetnano()
	set69ame = "Reset69anoUI"
	set category = "OOC"

	var/ui_amt = length(mob.open_uis)
	for(var/datum/nanoui/ui in69ob.open_uis)
		ui.close()
	to_chat(src, "69ui_amt69 UI windows reset.")

 /**
  * Called when a69ano UI window is closed
  * This is how69ano handles closed windows
  * It69ust be a69erb so that it can be called using winset
  *
  * @return69othing
  */
/client/verb/nanoclose(var/uiref as text)
	set hidden = 1	// hide this69erb from the user's panel
	set69ame = "nanoclose"

	var/datum/nanoui/ui = locate(uiref)

	if (istype(ui))
		ui.close()

		if(ui.ref)
			var/href = "close=1"
			src.Topic(href, params2list(href), ui.ref)	// this will direct to the atom's Topic() proc69ia client.Topic()
		else if (ui.on_close_logic)
			//69o atomref specified (or69ot found)
			// so just reset the user69ob's69achine69ar
			if(src && src.mob)
				src.mob.unset_machine()

 /**
  * The ui_interact proc is used to open and update69ano UIs
  * If ui_interact is69ot used then the UI will69ot update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The69ob who is interacting with this UI
  * @param ui_key string A string key to use for this UI. Allows for69ultiple unique UIs on one obj/mob (defaut69alue "main")
  * @param ui /datum/nanoui This parameter is passed by the69anoui process() proc when updating an open UI
  * @param force_open enum See _defines/nanoui.dm
  *
  * @return69othing
  */
/datum/proc/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, datum/nanoui/master_ui =69ull, datum/topic_state/state = GLOB.default_state)
	return

 /**
  * Data to be sent to the UI.
  * This69ust be implemented for a UI to work.
  *
  * @param user /mob The69ob who interacting with the UI
  * @param ui_key string A string key to use for this UI. Allows for69ultiple unique UIs on one obj/mob (defaut69alue "main")
  *
  * @return data /list Data to be sent to the UI
 **/
/datum/proc/ui_data(mob/user, ui_key = "main")
	return list() //69ot implemented.

// Used by SSnano (/datum/controller/subsystem/processing/nano) to track UIs opened by this69ob
/mob/var/list/open_uis