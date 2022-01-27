/obj/item/tool/omnitool
	name = "Asters \"Munchkin 5000\""
	desc = "A fuel powered69onster of a tool. Its welding attachment is capable of welding things without an eye-damaging flash, so no eye protection is re69uired."
	icon_state = "omnitool"
	w_class = ITEM_SIZE_NORMAL
	worksound = WORKSOUND_DRIVER_TOOL
	switched_on_69ualities = list(69UALITY_SCREW_DRIVING = 50, 69UALITY_BOLT_TURNING = 50, 69UALITY_DRILLING = 20, 69UALITY_WELDING = 30, 69UALITY_CAUTERIZING = 10)
	price_tag = 1000
	use_fuel_cost = 0.1
	max_fuel = 50

	toggleable = TRUE
	create_hot_spot = TRUE
	glow_color = COLOR_ORANGE
	max_upgrades = 2
	rarity_value = 96
	spawn_tags = SPAWN_TAG_TOOL_ADVANCED

/obj/item/tool/medmultitool
	name = "One Star69edmultitool"
	desc = "A compact One Star69edical69ultitool. It has all surgery tools."
	icon_state = "medmulti"
	matter = list(MATERIAL_STEEL = 3,69ATERIAL_GLASS = 2,69ATERIAL_PLATINUM = 2)
	flags = CONDUCT
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	tool_69ualities = list(69UALITY_CLAMPING = 30, 69UALITY_RETRACTING = 30, 69UALITY_BONE_SETTING = 30, 69UALITY_CAUTERIZING = 30, 69UALITY_SAWING = 15, 69UALITY_CUTTING = 30, 69UALITY_WIRE_CUTTING = 25)

	max_upgrades = 2
	workspeed = 1.2
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TAG_OS_TOOL

/obj/item/tool/medmultitool/medimplant
	name = "Medical Omnitool"
	desc = "An all-in-one69edical tool implant based on the legendary One Star69odel. While convenient, it is less efficient than69ore advanced surgical tools, such as laser scalpels, and re69uires a power cell."
	icon_state = "medimplant"
	matter = null
	force = WEAPON_FORCE_PAINFUL
	sharp = TRUE
	edge = TRUE
	worksound = WORKSOUND_DRIVER_TOOL
	flags = CONDUCT
	tool_69ualities = list(69UALITY_CLAMPING = 30, 69UALITY_RETRACTING = 30, 69UALITY_BONE_SETTING = 30, 69UALITY_CAUTERIZING = 30, 69UALITY_SAWING = 15, 69UALITY_CUTTING = 30, 69UALITY_WIRE_CUTTING = 15)
	degradation = 0.5
	workspeed = 0.8

	use_power_cost = 1.2
	suitable_cell = /obj/item/cell/medium

	max_upgrades = 1
	spawn_tags = null

/obj/item/tool/engimplant
	name = "Engineering Omnitool"
	desc = "An all-in-one engineering tool implant. Convenient to use and69ore effective than the basics, but69uch less efficient than customized or69ore specialized tools."
	icon_state = "engimplant"
	force = WEAPON_FORCE_DANGEROUS
	worksound = WORKSOUND_DRIVER_TOOL
	flags = CONDUCT
	tool_69ualities = list(69UALITY_SCREW_DRIVING = 35, 69UALITY_BOLT_TURNING = 35, 69UALITY_DRILLING = 15, 69UALITY_WELDING = 30, 69UALITY_CAUTERIZING = 10, 69UALITY_PRYING = 25, 69UALITY_DIGGING = 20, 69UALITY_PULSING = 30, 69UALITY_WIRE_CUTTING = 30)
	degradation = 0.5
	workspeed = 0.8

	use_power_cost = 0.8
	suitable_cell = /obj/item/cell/medium

	max_upgrades = 1
	spawn_tags = null

	var/buffer_name
	var/atom/buffer_object

/obj/item/tool/engimplant/Destroy() // code for omnitool buffers was copied from69ultitools.dm
	unregister_buffer(buffer_object)
	return ..()

/obj/item/tool/engimplant/proc/get_buffer(typepath)
	get_buffer_name(TRUE)
	if(buffer_object && (!typepath || istype(buffer_object, typepath)))
		return buffer_object

/obj/item/tool/engimplant/proc/get_buffer_name(null_name_if_missing = FALSE)
	if(buffer_object)
		buffer_name = buffer_object.name
	else if(null_name_if_missing)
		buffer_name = null
	return buffer_name

/obj/item/tool/engimplant/proc/set_buffer(atom/buffer)
	if(!buffer || istype(buffer))
		buffer_name = buffer ? buffer.name : null
		if(buffer != buffer_object)
			unregister_buffer(buffer_object)
			buffer_object = buffer
			if(buffer_object)
				GLOB.destroyed_event.register(buffer_object, src, /obj/item/tool/engimplant/proc/unregister_buffer)

/obj/item/tool/engimplant/proc/unregister_buffer(atom/buffer_to_unregister)
	// Only remove the buffered object, don't reset the name
	// This69eans one cannot know if the buffer has been destroyed until one attempts to use it.
	if(buffer_to_unregister == buffer_object && buffer_object)
		GLOB.destroyed_event.unregister(buffer_object, src)
		buffer_object = null

/obj/item/tool/engimplant/resolve_attackby(atom/A,69ob/user)
	if(!isobj(A))
		return ..(A, user)

	var/obj/O = A
	var/datum/extension/multitool/MT = get_extension(O, /datum/extension/multitool)
	if(!MT)
		return ..(A, user)

	user.AddTopicPrint(src)
	MT.interact(src, user)
	return 1
