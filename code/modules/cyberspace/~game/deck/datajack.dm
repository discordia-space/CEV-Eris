/obj/item/organ/internal/data_jack
	name = "data jack implant"
	desc = "A strange augmentation with two rows of needles."
	icon = 'icons/obj/cyberspace/implant.dmi'
	icon_state = "common"

	parent_organ_base = BP_HEAD
	unique_tag = BP_AUGMENT_HEAD
	max_damage = 400

	specific_organ_size = 0

	var/UIStyle = "cyberspace_eye"

	var/obj/item/mind_cable/cable

	owner_verbs = list(
		/obj/item/organ/internal/data_jack/proc/verb_EjectMindCable,
		/obj/item/organ/internal/data_jack/proc/verb_RetractMindCable,
		/obj/item/organ/internal/data_jack/proc/verb_BeginConnection,
	)

	Initialize()
		. = ..()
		cable = new()
		cable.SetOwner(src)

	proc
		verb_RetractMindCable()
			set category = CYBERNETIC_VERBS_CATEGORY
			set name = "Retract Mind Cable"

			RetractMindCable(usr)

		verb_EjectMindCable()
			set category = CYBERNETIC_VERBS_CATEGORY
			set name = "Eject Mind Cable"

			EjectMindCable(usr)
		
		verb_BeginConnection()
			set category = CYBERNETIC_VERBS_CATEGORY
			set name = "Establish Cyberspace Connection"

			if(istype(cable))
				if(istype(cable.loc, /obj/item/computer_hardware/deck))
					if(istype(usr, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = usr
						to_chat(usr, "You are trying to relax your physical body.")
						var/cognitionScale = max(10 - H.stats.getStat(STAT_COG)/10, 0)
						if(do_after(usr, rand(1, 4) * cognitionScale, get_turf(cable.loc)))
							to_chat(usr, "You trying to clean your mind.")
							if(do_after(usr, rand(1, 4) * cognitionScale, get_turf(cable.loc)))
								to_chat(usr, "You trying to feel the void.")
								if(do_after(usr, rand(1, 2) * cognitionScale, get_turf(cable.loc)))
									BeginConnection()
				else
					to_chat(usr, SPAN_WARNING("ERROR: Cable not connected to deck."))
			else
				to_chat(usr, SPAN_WARNING("ERROR: Cable not found."))

		get_deck()
			if(istype(cable) && istype(cable.connection))
				return cable.connection

		BeginConnection()
			var/obj/item/computer_hardware/deck/deck = get_deck()
			return deck?.BeginCyberspaceConnection()

		RetractMindCable(mob/user)
			if(istype(cable) && cable.loc != src)
				if(cable.owner == src)
					cable.forceRetract(user)
				else
					cable = null
					visible_message(SPAN_DANGER("Your mind cable is broken, you need to replace it."))

		EjectMindCable(mob/user)
			if(istype(cable))
				if(cable.owner == src)
					cable.Ejected(user)
				else
					cable = null
					visible_message(SPAN_DANGER("[user] reaches [src] and trying to do something strange, but only sparks showed."))

/obj/item/mind_cable
	name = "mind cable"

	icon = 'icons/obj/cyberspace/implant.dmi'
	icon_state = "audiojack"

	var/length = 1
	var/obj/item/organ/internal/data_jack/owner

	var/obj/item/computer_hardware/deck/connection
	
	Initialize()
		. = ..()
		GLOB.moved_event.register(src, src, .proc/RetractIfNeed)

	proc //this maden to split procs to categories, for example this is setters', getters' region 
		SetOwner(obj/item/organ/internal/data_jack/_owner)
			if(owner != _owner)
				if(isloc(owner)) 
					UnRegisterMovementEventsFor(owner)
				RegisterMovementEventsFor(_owner)
				owner = _owner
				return TRUE
	proc
		RegisterMovementEventsFor(atom/movable/mover = owner)
			GLOB.moved_event.register(mover, src, .proc/RetractIfNeed)

		UnRegisterMovementEventsFor(atom/movable/mover = owner)
			GLOB.moved_event.unregister(mover, src, .proc/RetractIfNeed)

	proc
		ShouldRetracted(atom/movable/target = owner)
			var/distance = get_dist(src, target)
			if(loc != owner && distance > length && distance <= 127)
				return TRUE
	
		RetractIfNeed()
			if(QDELETED(owner))
				owner = null
			else
				RegisterMovementEventsFor()
			if(ShouldRetracted())
				return forceRetract()

		forceRetract(visible = TRUE)
			if(ishuman(loc))
				var/mob/living/carbon/equipedTo = loc
				equipedTo.unEquip(src)
			UnRegisterMovementEventsFor()
			if(connection)
				DisconnectFromDeck()
			relocateTo(owner)
			visible && visible_message(SPAN_WARNING("[src] has retracted to [owner.loc]."))
			return TRUE
	proc
		Ejected(mob/user, visible = TRUE)
			. = user.put_in_active_hand(src)
			if(. && visible)
				visible_message(SPAN_DANGER("[user] pulls [src] from \his neck."))
	proc
		ConnectToDeck(obj/item/computer_hardware/deck/_deck)
			connection = _deck
			return relocateTo(connection)

		DisconnectFromDeck()
			UnRegisterMovementEventsFor(connection)
			connection.DisconnectCable()
			dropInto(connection)
			connection = null
			
