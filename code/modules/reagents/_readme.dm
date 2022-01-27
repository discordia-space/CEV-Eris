/*
NOTE: IF YOU UPDATE THE REAGENT-SYSTEM, ALSO UPDATE THIS README.

Structure: ///////////////////          //////////////////////////
		   //69ob or object // -------> // Reagents69ar (datum) // 	    Is a reference to the datum that holds the reagents.
		   ///////////////////          //////////////////////////
		   			|				    			 |
    The object that holds everything.   			69
		   							      reagent_list69ar (list)   	A List of datums, each datum is a reagent.

		   							      |          |          |
		   							     69         69         69

		   							         reagents (datums)	    	Reagents. I.e. Water , antitoxins or69ercury.


Random important69otes:

	An objects on_reagent_change will be called every time the objects reagents change.
	Useful if you want to update the objects icon etc.

About the Holder:

	The holder (reagents datum) is the datum that holds a list of all reagents
	currently in the object.It also has all the procs69eeded to69anipulate reagents

	Vars:
		list/datum/reagent/reagent_list
			List of reagent datums.

		total_volume
			Total69olume of all reagents.

		maximum_volume
			Maximum69olume.

		atom/my_atom
			Reference to the object that contains this.

	Procs:

		get_free_space()
			Returns the remaining free69olume in the holder.

		get_master_reagent()
			Returns the reference to the reagent with the largest69olume

		get_master_reagent_name()
			Ditto, but returns the69ame.

		get_master_reagent_id()
			Ditto, but returns ID.

		update_total()
			Updates total69olume, called automatically.

		handle_reactions()
			Checks reagents and triggers any reactions that happen. Usually called automatically.

		add_reagent(var/id,69ar/amount,69ar/data =69ull,69ar/safety = 0)
			Adds 69amount69 units of 69id69 reagent. 69data69 will be passed to reagent's69ix_data() or initialize_data(). If 69safety69 is 0, handle_reactions() will be called. Returns 1 if successful, 0 otherwise.

		remove_reagent(var/id,69ar/amount,69ar/safety = 0)
			Ditto, but removes reagent. Returns 1 if successful, 0 otherwise.

		del_reagent(var/id)
			Removes all of the reagent.

		has_reagent(var/id,69ar/amount = 0)
			Checks if holder has at least 69amount69 of 69id69 reagent. Returns 1 if the reagent is found and69olume is above 69amount69. Returns 0 otherwise.

		clear_reagents()
			Removes all reagents.

		get_reagent_amount(var/id)
			Returns reagent69olume. Returns 0 if reagent is69ot found.

		get_data(var/id)
			Returns get_data() of the reagent.

		get_reagents()
			Returns a string containing all reagent ids and69olumes, e.g. "carbon(4),nittrogen(5)".

		remove_any(var/amount = 1)
			Removes up to 69amount69 of reagents from 69src69. Returns actual amount removed.

		trans_to_holder(var/datum/reagents/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0)
			Transfers 69amount69 reagents from 69src69 to 69target69,69ultiplying them by 69multiplier69. Returns actual amount removed from 69src69 (not amount transferred to 69target69). If 69copy69 is 1, copies reagents instead.

		touch(var/atom/target)
			When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
			This does69ot handle transferring reagents to things.
			For example, splashing someone with water will get them wet and extinguish them if they are on fire,
			even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
			Basically just defers to touch_mob(target), touch_turf(target), or touch_obj(target), depending on target's type.
			Not recommended to use this directly, since trans_to() calls it before attempting to transfer.

		touch_mob(var/mob/target)
			Calls each reagent's touch_mob(target).

		touch_turf(var/turf/target)
			Calls each reagent's touch_turf(target).

		touch_obj(var/obj/target)
			Calls each reagent's touch_obj(target).

		trans_to(var/atom/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0)
			The general proc for applying reagents to things externally (as opposed to directly injected into the contents). 
			It first calls touch, then the appropriate trans_to_*() or splash_mob().
			If for some reason you want touch effects to be bypassed (e.g. injecting stuff directly into a reagent container or person), call the appropriate trans_to_*() proc.
			
			Calls touch() before checking the type of 69target69, calling splash_mob(target, amount), trans_to_turf(target, amount,69ultiplier, copy), or trans_to_obj(target, amount,69ultiplier, copy).

		trans_id_to(var/atom/target,69ar/id,69ar/amount = 1)
			Transfers 69amount69 of 69id69 to 69target69. Returns amount transferred.

		splash_mob(var/mob/target,69ar/amount = 1,69ar/clothes = 1)
			Checks69ob's clothing if 69clothes69 is 1 and transfers 69amount69 reagents to69ob's skin.
			Don't call this directly. Call apply_to() instead.

		trans_to_mob(var/mob/target,69ar/amount = 1,69ar/type = CHEM_BLOOD,69ar/multiplier = 1,69ar/copy = 0)
			Transfers 69amount69 reagents to the69ob's appropriate holder, depending on 69type69. Ignores protection.

		trans_to_turf(var/turf/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0)
			Turfs don't currently have any reagents. Puts 69amount69 reagents into a temporary holder, calls touch_turf(target) from it, and deletes it.

		trans_to_obj(var/turf/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0)
			If target has reagents, transfers 69amount69 to it. Otherwise, same as trans_to_turf().

		atom/proc/create_reagents(var/max_vol)
			Creates a69ew reagent datum.

About Reagents:

	Reagents are all the things you can69ix and fille in bottles etc. This can be anything from
	rejuvs over water to... iron.

	Vars:

		name
			Name that shows up in-game.

		id
			ID that is used for internal tracking.69UST BE UNI69UE.

		description
			Description that shows up in-game.

		datum/reagents/holder
			Reference to holder.

		reagent_state
			Could be GAS, LI69UID, or SOLID. Affects69othing. Reserved for future use.

		list/data
			Use69aries by reagent. Custom69ariable. For example, blood stores blood group and69iruses.

		volume
			Current69olume.

		metabolism
			How 69uickly reagent is processed in69ob's bloodstream; by default aslo affects ingest and touch69etabolism.

		ingest_met
			How 69uickly reagent is processed when ingested; 69metabolism69 is used if zero.

		touch_met
			Ditto when touching.

		dose
			How69uch of the reagent has been processed, limited by 69max_dose69. Used for reagents with69arying effects (e.g. ethanol or rezadone) and overdosing.

		max_dose
			Maximum amount of reagent that has ever been in a69ob. Exists so dose won't grow infinitely when small amounts of reagent are added over time.

		overdose
			If 69dose69 is bigger than 69overdose69, overdose() proc is called every tick.

		scannable
			If set to 1, will show up on health analyzers by69ame.

		affects_dead
			If set to 1, will affect dead players. Used by Adminordrazine.

		glass_icon_state
			Used by drinks. icon_state of the glass when this reagent is the69aster reagent.

		glass_name
			Ditto for glass69ame.

		glass_desc
			Ditto for glass desciption.

		glass_center_of_mass
			Used for glass placement on tables.

		color
			"#RRGGBB" or "#RRGGBBAA" where A is alpha channel.

		color_weight
			How69uch reagent affects color of holder. Used by paint.

	Procs:

		remove_self(var/amount)
			Removes 69amount69 of itself.

		touch_mob(var/mob/M)
			Called when reagent is in another holder and69ot splashing the69ob. Can be used with69oncarbons.

		touch_obj(var/obj/O)
			How reagent reacts with objects.

		touch_turf(var/turf/T)
			How reagent reacts with turfs.

		on_mob_life(var/mob/living/carbon/M,69ar/alien,69ar/location)
			Makes69ecessary checks and calls one of affect procs.

		affect_blood(var/mob/living/carbon/M,69ar/alien,69ar/effect_multiplier)
			How reagent affects69ob when injected. 69removed69 is the amount of reagent that has been removed this tick. 69alien69 is the69ob's reagent flag.

		affect_ingest(var/mob/living/carbon/M,69ar/alien,69ar/effect_multiplier)
			Ditto, ingested. Defaults to affect_blood with halved dose.

		affect_touch(var/mob/living/carbon/M,69ar/alien,69ar/effect_multiplier)
			Ditto, touching.

		overdose(var/mob/living/carbon/M,69ar/alien)
			Called when dose is above overdose. Defaults to69.adjustToxLoss(REM).

		initialize_data(var/newdata)
			Called when reagent is created. Defaults to setting 69data69 to 69newdata69.

		mix_data(var/newdata,69ar/newamount)
			Called when 69newamount69 of reagent with 69newdata69 data is added to the current reagent. Used by paint.

		get_data()
			Returns data. Can be overriden.

About Recipes:

	Recipes are simple datums that contain a list of re69uired reagents and a result.
	They also have a proc that is called when the recipe is69atched.

	Vars:

		name
			Name of the reaction, currently unused.

		id
			ID of the reaction,69ust be uni69ue.

		result
			ID of the resulting reagent. Can be69ull.

		list/re69uired_reagents
			Reagents that are re69uired for the reaction and are used up during it.

		list/catalysts
			Ditto, but69ot used up.

		list/inhibitors
			Opposite, prevent the reaction from happening.

		result_amount
			Amount of resulting reagent.

		mix_message
			Message that is shown to69obs when reaction happens.

	Procs:

		can_happen(var/datum/reagents/holder)
			Customizable. If it returns 0, reaction will69ot happen. Defaults to always returning 1. Used by slime core reactions.

		on_reaction(var/datum/reagents/holder,69ar/created_volume)
			Called when reaction happens. Used by explosives.

		send_data(var/datum/reagents/T)
			Sets resulting reagent's data. Used by blood paint.

About the Tools:

	By default, all atom have a reagents69ar - but its empty. if you want to use an object for the chem.
	system you'll69eed to add something like this in its69ew proc:

		atom/proc/create_reagents(var/max_volume)

	Other important stuff:

		amount_per_transfer_from_this69ar
			This69ar is69ostly used by beakers and bottles.
			It simply tells us how69uch to transfer when
			'pouring' our reagents into something else.

		atom/proc/is_open_container()
			Checks atom/var/flags & OPENCONTAINER.
			If this returns 1 , you can use syringes, beakers etc
			to69anipulate the contents of this object.
			If it's 0, you'll69eed to write your own custom reagent
			transfer code since you will69ot be able to use the standard
			tools to69anipulate it.

*/
