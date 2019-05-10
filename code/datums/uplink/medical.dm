/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/onegativeblood
	name = "O- Blood Pack"
	item_cost = 10
	path = /obj/item/weapon/reagent_containers/blood/OMinus

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	item_cost = 20
	path = /obj/item/weapon/storage/box/sinpockets

/datum/uplink_item/item/medical/surgery
	name = "Surgery Kit"
	item_cost = 50
	path = /obj/item/weapon/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Drug Medical Kit"
	item_cost = 50
	path = /obj/item/weapon/storage/firstaid/combat
	desc = "Comes with pillbottles of Bicaridine, Dermaline, Dexaline Plus, Dylovene, Tramadol, Spaceacilline plus cheap, non-reffillable hypospray full of Tricordrazine."

/datum/uplink_item/item/medical/injectors
	name = "Combat Medical Kit"
	item_cost = 80
	path = /obj/item/weapon/storage/firstaid/injectors
	desc = "Contains all neccessary meds you need for tending your combat wounds and gunshots alike on go.\
			Contains two advanced trauma kits, one advanced burn kit, two of both Bicaridine and Dermaline injectors and one of each Dexalin Plus and Inaprovaline \
			as well as non-reffillable combat hypospray with potent mix of chems to keep you on your feet."

datum/uplink_item/item/medical/autoinjector_bica
	name = "Bicaridine Autoinjector"
	item_cost = 8
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/bicaridine

datum/uplink_item/item/medical/autoinjector_derma
	name = "Dermaline Autoinjector"
	item_cost = 8
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/dermaline

datum/uplink_item/item/medical/autoinjector_dexplus
	name = "Dexaline Plus Autoinjector"
	item_cost = 6
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/dexalinplus

datum/uplink_item/item/medical/autoinjector_dylo
	name = "Dylovene Autoinjector"
	item_cost = 4
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/dylovene

datum/uplink_item/item/medical/autoinjector_space
	name = "Spaceacilline Autoinjector"
	item_cost = 6
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/spaceacillin

datum/uplink_item/item/medical/autoinjector_tram
	name = "Tramadol Autoinjector"
	item_cost = 4
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/tramadol

datum/uplink_item/item/medical/autoinjector_oxy
	name = "Oxycodone Autoinjector"
	item_cost = 8
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/oxycodone