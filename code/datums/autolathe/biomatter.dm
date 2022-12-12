/datum/design/bioprinter
	build_type = BIOPRINTER
	materials = list(MATERIAL_BIOMATTER = 6)
	factions = list(FACTION_NEOTHEOLOGY)

/datum/design/bioprinter/meat
	name = "Meat"
	build_path = /obj/item/reagent_containers/food/snacks/meat
	materials = list(MATERIAL_BIOMATTER = 5)

/datum/design/bioprinter/milk
	name = "Milk"
	build_path = /obj/item/reagent_containers/food/drinks/milk

/datum/design/bioprinter/soap
	name = "Soap"
	build_path = /obj/item/soap/nanotrasen

//[NUTRIMENTS]
/datum/design/bioprinter/ez
	name = "EZ-Nutrient"
	build_path = /obj/item/reagent_containers/glass/fertilizer/ez
	materials = list(MATERIAL_BIOMATTER = 3)

/datum/design/bioprinter/l4z
	name = "Left4Zed"
	build_path = /obj/item/reagent_containers/glass/fertilizer/l4z

/datum/design/bioprinter/rh
	name = "Robust Harvestt"
	build_path = /obj/item/reagent_containers/glass/fertilizer/rh
	materials = list(MATERIAL_BIOMATTER = 7.5)
//[/NUTRIMENTS]

//[CLOTHES, ARMOR AND ACCESORIES]
/datum/design/bioprinter/nt_clothes/acolyte_armor
	name = "NT Acolyte Armor"
	build_path = /obj/item/clothing/suit/armor/acolyte

/datum/design/bioprinter/nt_clothes/agrolyte_armor
	name = "NT Agrolyte Armor"
	build_path = /obj/item/clothing/suit/armor/agrolyte

/datum/design/bioprinter/nt_clothes/custodian_armor
	name = "NT Custodian Armor"
	build_path = /obj/item/clothing/suit/armor/custodian

/datum/design/bioprinter/nt_clothes/acolyte_armor_head
	name = "NT Acolyte Hood"
	build_path = /obj/item/clothing/head/armor/acolyte

/datum/design/bioprinter/nt_clothes/agrolyte_armor_head
	name = "NT Agrolyte Helmet"
	build_path = /obj/item/clothing/head/armor/agrolyte

/datum/design/bioprinter/nt_clothes/custodian_armor_head
	name = "NT Custodian Helmet"
	build_path = /obj/item/clothing/head/armor/custodian

/datum/design/bioprinter/nt_clothes/preacher_coat
	name = "NT Preacher Longcoat"
	build_path = /obj/item/clothing/suit/storage/neotheology_coat

/datum/design/bioprinter/nt_clothes/acolyte_jacket
	name = "NT Acolyte Jacket"
	build_path = /obj/item/clothing/suit/storage/neotheology_jacket

/datum/design/bioprinter/nt_clothes/sports_jacket
	name = "NT Sports Jacket"
	build_path = /obj/item/clothing/suit/storage/neotheosports

/datum/design/bioprinter/nt_clothes/acolyte_uniform
	name = "NT Acolyte Garment"
	build_path = /obj/item/clothing/under/rank/acolyte

/datum/design/bioprinter/nt_clothes/sports_uniform
	name = "NT Sport Clothes"
	build_path = /obj/item/clothing/under/rank/church/sport

/datum/design/bioprinter/nt_clothes/church_uniform
	name = "NT Church Garment"
	build_path = /obj/item/clothing/under/rank/church

/datum/design/bioprinter/jackboots
	name = "Custodian's jackboots"
	build_path = /obj/item/clothing/shoes/jackboots/neotheology
	materials = list(MATERIAL_BIOMATTER = 20)

/datum/design/bioprinter/belt/utility
	name = "Neotheology utility belt"
	build_path = /obj/item/storage/belt/utility/neotheology

/datum/design/bioprinter/belt/security
	name = "Neotheology tactical belt"
	build_path = /obj/item/storage/belt/tactical/neotheology

/datum/design/bioprinter/backpack
	name = "Cruciformed backpack"
	build_path = /obj/item/storage/backpack/neotheology
	materials = list(MATERIAL_BIOMATTER = 20)

/datum/design/bioprinter/satchel
	name = "Cruciformed satchel"
	build_path = /obj/item/storage/backpack/satchel/neotheology

// This separates regular clothes designs from NT clothes designs //

/datum/design/bioprinter/shoes
	name = "Reinforced shoes"
	build_path = /obj/item/clothing/shoes/reinforced
	materials = list(MATERIAL_BIOMATTER = 10)

/datum/design/bioprinter/leather/holster
	name = "compact holster"
	build_path = /obj/item/storage/pouch/holster

/datum/design/bioprinter/leather/holster/baton
	name = "baton holster"
	build_path = /obj/item/storage/pouch/holster/baton

/datum/design/bioprinter/leather/holster/belt
	name = "belt holster"
	build_path = /obj/item/storage/pouch/holster/belt

/datum/design/bioprinter/leather/holster/sheath
	name = "sheath"
	build_path = /obj/item/storage/pouch/holster/belt/sheath

/datum/design/bioprinter/leather/holster/knife
	name = "throwing knife pouch"
	build_path = /obj/item/storage/pouch/holster/belt/knife

/datum/design/bioprinter/leather/holster/accessory
	name = "concealed carry holster"
	build_path = /obj/item/clothing/accessory/holster

/datum/design/bioprinter/leather/holster/accessory/scabbard
	name = "scabbard"
	build_path = /obj/item/clothing/accessory/holster/scabbard

/datum/design/bioprinter/leather/holster/accessory/knife
	name = "throwing knife rig"
	build_path = /obj/item/clothing/accessory/holster/knife

/datum/design/bioprinter/belt
	materials = list(MATERIAL_BIOMATTER = 30)

/datum/design/bioprinter/belt/medical
	name = "Medical belt"
	build_path = /obj/item/storage/belt/medical

/datum/design/bioprinter/belt/medical/emt
	name = "EMT belt"
	build_path = /obj/item/storage/belt/medical/emt

/datum/design/bioprinter/backpack/duffelbag
	name = "grey duffelbag"
	build_path = /obj/item/storage/backpack/duffelbag
	materials = list(MATERIAL_BIOMATTER = 65)

/datum/design/bioprinter/wallet
	name = "Wallet"
	build_path = /obj/item/storage/wallet

/datum/design/bioprinter/botanic_leather
	name = "Botanical gloves"
	build_path = /obj/item/clothing/gloves/botanic_leather
	materials = list(MATERIAL_BIOMATTER = 25)

/datum/design/bioprinter/leather
	materials = list(MATERIAL_BIOMATTER = 40)

/datum/design/bioprinter/small_generic
	name= "Small generic pouch"
	build_path = /obj/item/storage/pouch/small_generic

/datum/design/bioprinter/medium_generic
	name= "Medium generic pouch"
	build_path = /obj/item/storage/pouch/medium_generic

/datum/design/bioprinter/large_generic
	name= "Large generic pouch"
	build_path = /obj/item/storage/pouch/large_generic

/datum/design/bioprinter/medical_supply
	name= "Medical supply pouch"
	build_path = /obj/item/storage/pouch/medical_supply

/datum/design/bioprinter/engineering_tools
	name= "Engineering tools pouch"
	build_path = /obj/item/storage/pouch/engineering_tools

/datum/design/bioprinter/engineering_supply
	name= "Engineering supply pouch"
	build_path = /obj/item/storage/pouch/engineering_supply

/datum/design/bioprinter/engineering_material
	name = "Engineering material pouch"
	build_path = /obj/item/storage/pouch/engineering_material

/datum/design/bioprinter/ammo
	name= "Ammo pouch"
	build_path = /obj/item/storage/pouch/ammo

/datum/design/bioprinter/tubular
	name= "Tubular pouch"
	build_path = /obj/item/storage/pouch/tubular

/datum/design/bioprinter/tubular/vial
	name= "Vial pouch"
	build_path = /obj/item/storage/pouch/tubular/vial

/datum/design/bioprinter/part
	name = "Part pouch"
	build_path = /obj/item/storage/pouch/gun_part

//[/CLOTHES, ARMOR AND ACCESORIES]

//[MISC]
/datum/design/bioprinter/holyvacuum
	name = "\"Tersus\" Vacuum Cleaner"
	build_path = /obj/item/holyvacuum

//[CELLS]
/datum/design/bioprinter/nt_cells/large
	name = "NT \"Spark 13000L\""
	build_path = /obj/item/cell/large/neotheology
	materials = list(MATERIAL_BIOMATTER = 15)

/datum/design/bioprinter/nt_cells/large/plasma
	name = "NT \"Radiance 20000L\""
	build_path = /obj/item/cell/large/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 3)

/datum/design/bioprinter/nt_cells/medium
	name = "NT \"Spark 1000M\""
	build_path = /obj/item/cell/medium/neotheology/
	materials = list(MATERIAL_BIOMATTER = 10)

/datum/design/bioprinter/nt_cells/medium/plasma
	name = "NT \"Radiance 1500M\""
	build_path = /obj/item/cell/medium/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 2)

/datum/design/bioprinter/nt_cells/small
	name = "NT \"Spark 300S\""
	build_path = /obj/item/cell/small/neotheology/
	materials = list(MATERIAL_BIOMATTER = 5)

/datum/design/bioprinter/nt_cells/small/plasma
	name = "NT \"Radiance 500S\""
	build_path = /obj/item/cell/small/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 1)

//[CELLS]
/datum/design/bioprinter/nt_cells/large
	name = "NT \"Spark 13000L\""
	build_path = /obj/item/cell/large/neotheology
	materials = list(MATERIAL_BIOMATTER = 15)

/datum/design/bioprinter/nt_cells/large/plasma
	name = "NT \"Radiance 20000L\""
	build_path = /obj/item/cell/large/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 3)

/datum/design/bioprinter/nt_cells/medium
	name = "NT \"Spark 1000M\""
	build_path = /obj/item/cell/medium/neotheology/
	materials = list(MATERIAL_BIOMATTER = 10)

/datum/design/bioprinter/nt_cells/medium/plasma
	name = "NT \"Radiance 1500M\""
	build_path = /obj/item/cell/medium/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 2)

/datum/design/bioprinter/nt_cells/small
	name = "NT \"Spark 300S\""
	build_path = /obj/item/cell/small/neotheology/
	materials = list(MATERIAL_BIOMATTER = 5)

/datum/design/bioprinter/nt_cells/small/plasma
	name = "NT \"Radiance 500S\""
	build_path = /obj/item/cell/small/neotheology/plasma
	materials = list(MATERIAL_PLASMA = 1)

//[/THINGS]
/datum/design/autolathe/nt
	factions = list(FACTION_NEOTHEOLOGY)

/datum/design/autolathe/firstaid/nt
	name = "NeoTheology Medkit"
	build_path = /obj/item/storage/firstaid/nt
	factions = list(FACTION_NEOTHEOLOGY)

/datum/design/autolathe/excruciator
	name = "NeoTheology \"EXCRUCIATOR\" giga lens"
	build_path = /obj/item/gun_upgrade/barrel/excruciator
	factions = list(FACTION_NEOTHEOLOGY)

/datum/design/autolathe/cruciform_upgrade
	build_path = /obj/item/cruciform_upgrade
	factions = list(FACTION_NEOTHEOLOGY)

/datum/design/autolathe/cruciform_upgrade/natures_blessing
	name = "Natures blessing"
	build_path = /obj/item/cruciform_upgrade/natures_blessing

/datum/design/autolathe/cruciform_upgrade/faiths_shield
	name = "Faiths shield"
	build_path = /obj/item/cruciform_upgrade/faiths_shield

/datum/design/autolathe/cruciform_upgrade/cleansing_presence
	name = "Cleansing presence"
	build_path = /obj/item/cruciform_upgrade/cleansing_presence

/datum/design/autolathe/cruciform_upgrade/martyr_gift
	name = "Martyr gift"
	build_path = /obj/item/cruciform_upgrade/martyr_gift

/datum/design/autolathe/cruciform_upgrade/wrath_of_god
	name = "Wrath of god"
	build_path = /obj/item/cruciform_upgrade/wrath_of_god

/datum/design/autolathe/cruciform_upgrade/speed_of_the_chosen
	name = "Speed of the chosen"
	build_path = /obj/item/cruciform_upgrade/speed_of_the_chosen

//[MELEE]
/datum/design/autolathe/nt/sword/nt_sword
	name = "NT Shortsword"
	build_path = /obj/item/tool/sword/nt/shortsword

/datum/design/autolathe/nt/sword/nt_longsword
	name = "NT Longsword"
	build_path = /obj/item/tool/sword/nt/longsword

/datum/design/autolathe/nt/sword/nt_dagger
	name = "NT Dagger"
	build_path = /obj/item/tool/knife/dagger/nt

/datum/design/autolathe/nt/sword/nt_halberd
	name = "NT Halberd"
	build_path = /obj/item/tool/sword/nt/halberd

/datum/design/autolathe/nt/sword/nt_scourge
	name = "NT Scourge"
	build_path = /obj/item/tool/sword/nt/scourge

/datum/design/autolathe/nt/shield/nt_shield
	name = "NT Shield"
	build_path = /obj/item/shield/riot/nt

/datum/design/autolathe/nt/shield/nt_buckler
	name = "NT Buckler"
	build_path = /obj/item/shield/buckler/nt

/datum/design/autolathe/nt/sword/nt_spear
	name = "NT Spear"
	build_path = /obj/item/tool/sword/nt/spear

/datum/design/autolathe/nt/sword/nt_verutum
	name = "NT Javelins (3)"
	build_path = /obj/item/stack/thrown/nt/verutum/full

/datum/design/autolathe/nt/tool_upgrade/sanctifier
	name = "sanctifier"
	build_path = /obj/item/tool_upgrade/augment/sanctifier

//[GRENADES]
/datum/design/autolathe/nt/grenade/nt_smokebomb
	name = "NT SG \"Holy Fog\""
	build_path = /obj/item/grenade/smokebomb/nt

/datum/design/autolathe/nt/grenade/nt_heatwave
	name = "NT HG \"Inferno\""
	build_path = /obj/item/grenade/heatwave/nt

/datum/design/autolathe/nt/grenade/nt_flashbang
	name = "NT FBG \"Holy Light\""
	build_path = /obj/item/grenade/flashbang/nt

/datum/design/autolathe/nt/grenade/nt_explosive
	name = "NT OBG \"Holy Grail\""
	build_path = /obj/item/grenade/explosive/nt

//[CRUSADE]
/datum/design/autolathe/nt/armor/crusader
	name = "crusader armor"
	build_path = /obj/item/clothing/suit/armor/crusader

/datum/design/autolathe/nt/helmet/crusader
	name = "crusader helmet"
	build_path = /obj/item/clothing/head/armor/helmet/crusader

/datum/design/autolathe/clothing/NTvoid
	name = "neotheology voidsuit"
	build_path = /obj/item/clothing/suit/space/void/NTvoid
	factions = list(FACTION_NEOTHEOLOGY)

//[MED]
/datum/design/bioprinter/medical
	materials = list(MATERIAL_BIOMATTER = 10)

/datum/design/bioprinter/medical/bruise
	name = "Roll of gauze"
	build_path = /obj/item/stack/medical/bruise_pack

/datum/design/bioprinter/medical/splints
	name = "Medical splints"
	build_path = /obj/item/stack/medical/splint

/datum/design/bioprinter/medical/ointment
	name = "Ointment"
	build_path = /obj/item/stack/medical/ointment


/datum/design/bioprinter/medical/advanced
	materials = list(MATERIAL_BIOMATTER = 20)

/datum/design/bioprinter/medical/advanced/bruise
	name = "Advanced trauma kit"
	build_path = /obj/item/stack/medical/advanced/bruise_pack

/datum/design/bioprinter/medical/advanced/ointment
	name = "Advanced burn kit"
	build_path = /obj/item/stack/medical/advanced/ointment

//[/MED]
