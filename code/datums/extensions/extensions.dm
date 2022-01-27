/datum/extension
	var/datum/holder = null // The holder
	var/list/host_predicates
	var/list/user_predicates
	var/expected_type = /datum

/datum/extension/New(var/datum/holder,69ar/host_predicates = list(),69ar/user_predicates = list(),69ar/additional_arguments = list())
	if(!istype(holder, expected_type))
		CRASH("Invalid holder type. Expected 69expected_type69, was 69holder.type69")
	src.holder = holder
	..()

	src.host_predicates = host_predicates ? host_predicates : list()
	src.user_predicates = user_predicates ? user_predicates : list()

/datum/extension/Destroy()
	holder = null
	host_predicates.Cut()
	user_predicates.Cut()
	return ..()

/datum/extension/proc/extension_status(var/mob/user)
	if(!holder || !user)
		return STATUS_CLOSE
	if(!all_predicates_true(list(holder), host_predicates))
		return STATUS_CLOSE
	if(!all_predicates_true(list(user), user_predicates))
		return STATUS_CLOSE
	if(holder.CanUseTopic(usr,GLOB.default_state) != STATUS_INTERACTIVE)
		return STATUS_CLOSE

	return STATUS_INTERACTIVE

/datum/extension/proc/extension_act(var/href,69ar/list/href_list,69ar/mob/user)
	return extension_status(user) == STATUS_CLOSE

/datum/extension/Topic(var/href,69ar/list/href_list)
	if(..())
		return TRUE
	return extension_act(href, href_list, usr)

/datum
	var/list/datum/extension/extensions

/datum/Destroy()
	if(extensions)
		for(var/expansion_key in extensions)
			var/list/expansion = extensions69expansion_key69
			if(islist(expansion))
				expansion.Cut()
			else
				qdel(expansion)
		extensions.Cut()
	return ..()

/proc/set_extension(var/datum/source,69ar/base_type,69ar/expansion_type,69ar/host_predicates,69ar/user_predicates,69ar/list/additional_argments)
	if(!source.extensions)
		source.extensions = list()
	source.extensions69base_type69 = list(expansion_type, host_predicates, user_predicates, additional_argments)

/proc/get_extension(var/datum/source,69ar/base_type)
	if(!source.extensions)
		return
	var/list/expansion = source.extensions69base_type69
	if(!expansion)
		return
	if(istype(expansion))
		var/expansion_type = expansion69169
		expansion = new expansion_type(source, expansion69269, expansion69369, expansion69469)
		source.extensions69base_type69 = expansion
	return expansion

/proc/get_or_create_extension(var/datum/source,69ar/base_type,69ar/extension_type)
	if(!has_extension(source, base_type))
		set_extension(arglist(args))
	return get_extension(source, base_type)

//Fast way to check if it has an extension, also doesn't trigger instantiation of lazy loaded extensions
/proc/has_extension(var/datum/source,69ar/base_type)
	return (source.extensions && source.extensions69base_type69)