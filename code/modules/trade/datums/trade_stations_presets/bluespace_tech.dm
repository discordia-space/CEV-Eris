/datum/trade_station/bluespace_technical
	max_missing_assortiment = 2

	name_pool = list("B-42-Alpha" = "Unknown signature, bluespace traces interfere with sensors. Unable to triangulate object.")
	assortiment = list(
		"#$285@$532#$@" = list(
			/obj/item/weapon/circuitboard/teleporter,
			/obj/item/weapon/bluespace_harpoon,
			/obj/item/weapon/tool/knife/dagger/bluespace,
			/obj/item/weapon/reagent_containers/glass/beaker/bluespace,
			/obj/item/weapon/circuitboard/bssilk_hub,
			/obj/item/mech_equipment/catapult
		)
	)

	offer_types = list(
		/obj/item/bluespace_crystal,
		/obj/item/device/mmi/digital/posibrain,
		/obj/item/weapon/reagent_containers/food/snacks/csandwich
	)
/datum/trade_station/bluespace_technical/New()
	for(var/i = 1; i <= length(name_pool); i++)
		var/save_desc = name_pool[name_pool[i]]
		name_pool -= name_pool[i]
		name_pool["[uppertext(pick(EN_ALPHABET))]-[rand(10, 99)]-[pick(GLOB.greek_letters)]"] = save_desc
	. = ..()
