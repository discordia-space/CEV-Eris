/obj/item/paper/manifest
	spawn_blacklisted = TRUE
	var/order_cost = 0
	var/order_id = 0
	var/errors = 0

/obj/item/paper/manifest/New(atom/A, id, cost)
	..()
	order_id = id
	order_cost = cost

	if(prob(MANIFEST_ERROR_CHANCE))
		errors |=69ANIFEST_ERROR_NAME
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |=69ANIFEST_ERROR_CONTENTS
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |=69ANIFEST_ERROR_ITEM

/obj/item/paper/manifest/proc/is_approved()
	return stamped && stamped.len && !is_denied()

/obj/item/paper/manifest/proc/is_denied()
	return stamped && (/obj/item/stamp/denied in stamped)

/datum/supply_order
	var/id
	var/orderer
	var/orderer_rank
	var/orderer_ckey
	var/reason
	var/datum/supply_pack/object

/datum/supply_order/New(datum/supply_pack/object, orderer, orderer_rank, orderer_ckey, reason)
	id = SSsupply.ordernum++
	src.object = object
	src.orderer = orderer
	src.orderer_rank = orderer_rank
	src.orderer_ckey = orderer_ckey
	src.reason = reason

/datum/supply_order/proc/generateRe69uisition(turf/T)
	var/obj/item/paper/re69form = new(T)

	re69form.name = "re69uisition form - #69id69 (69object.name69)"
	re69form.info += "<h3>69station_name()69 Supply Re69uisition Form</h3><hr>"
	re69form.info += "Order #69id69<br>"
	re69form.info += "Item: 69object.name69<br>"
	re69form.info += "Access Restrictions: 69get_access_desc(object.access)69<br>"
	re69form.info += "Re69uested by: 69orderer69<br>"
	re69form.info += "Rank: 69orderer_rank69<br>"
	re69form.info += "Contents:<br>"
	re69form.info += object.true_manifest
	if(reason)
		re69form.info += "Reason: 69reason69<br>"
	re69form.info += "<hr>"
	re69form.info += "STAMP BELOW TO APPROVE THIS RE69UISITION:<br>"

	re69form.update_icon()
	return re69form

/datum/supply_order/proc/generateManifest(obj/structure/closet/crate/C)
	var/obj/item/paper/manifest/P = new(C, id, object.cost)

	P.name = "shipping69anifest - #69id69 (69object.name69)"
	P.info += "<h2>Shipping69anifest</h2>"
	P.info += "<hr/>"
	P.info += "Order #69id69<br/>"
	P.info += "Destination: 69station_name()69<br/>"
	P.info += "Item: 69object.name69<br/>"
	P.info += "Contents: <br/>"
	P.info += "<ul>"
	for(var/atom/movable/AM in C.contents - P)
		if((P.errors &69ANIFEST_ERROR_CONTENTS))
			if(prob(50))
				P.info += "<li>69AM.name69</li>"
			else
				continue
		P.info += "<li>69AM.name69</li>"
	P.info += "</ul>"
	P.info += "<h4>Stamp below to confirm receipt of goods:</h4>"

	P.update_icon()
	P.loc = C
	//C.manifest = P
	//C.update_icon()

	return P

/datum/supply_order/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = object.generate(T)
	var/obj/item/paper/manifest/M = generateManifest(C)

	if(M.errors &69ANIFEST_ERROR_ITEM)
		if(istype(C, /obj/structure/closet/crate/secure) || istype(C, /obj/structure/closet/crate/large))
			M.errors &= ~MANIFEST_ERROR_ITEM
		else
			var/lost =69ax(round(C.contents.len / 10), 1)
			while(--lost >= 0)
				69del(pick(C.contents))
	return C
