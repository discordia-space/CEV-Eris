#define RANGE_BIOMES 7

#define LOOT_LEVEL_VERY_LOW 4000

#define LOOT_LEVEL_LOW 8000

#define LOOT_LEVEL_ADVERAGE 12000

#define LOOT_LEVEL_HIG 16000

#define LOOT_LEVEL_VERY_HIG 20000

//	Items
#define SPAWN_OBJ "obj"
#define SPAWN_ITEM "item"
#define SPAWN_WEAPON "weapon"

#define SPAWN_TAG_ITEM "obj,item"
#define SPAWN_TAG_WEAPON "obj,item,weapon"

#define SPAWN_RARE_ITEM "rare_item"

#define SPAWN_TAG_RARE_ITEM "obj,item,rare_item"

#define SPAWN_SPACECASH "spacecash"

#define SPAWN_TAG_SPACECASH "obj,item,spacecash"

//Items - tools
#define SPAWN_TOOL "tool"
#define SPAWN_ADVANCED_TOOL "advanced_tool"
#define SPAWN_OS_TOOL "os_tool"

#define SPAWN_TAG_TOOL "obj,item,tool"
#define SPAWN_TAG_TOOL_ADVANCED "obj,item,tool,advanced_tool"
#define SPAWN_TAG_OS_TOOL "obj,item,tool,os_tool,onestar"
#define SPAWN_TAG_TOOL_TAG_JUNK "obj,item,tool,junk"

//	Items - tools - knife
#define SPAWN_KNIFE "knife"
#define SPAWN_SWORD "sword"

#define SPAWN_TAG_KNIFE "obj,item,weapon,tool,knife"
#define SPAWN_TAG_SWORD "obj,item,weapon,tool,knife,sword"
#define SPAWN_TAG_KNIFE_CONTRABAND "obj,item,weapon,tool,knife,contraband"

// ITEMS - tools - SURGERY
#define SPAWN_SURGERY_TOOL "surgery_tool"

#define SPAWN_TAG_SURGERY_TOOL "obj,item,tool,surgery_tool,medical"

//	Items - upgrades
#define SPAWN_TOOL_UPGRADE "tool_upgrade"
#define SPAWN_RARE_TOOL_UPGRADE "rare_tool_upgrade"
#define SPAWN_GUN_UPGRADE "gun_upgrade"

#define SPAWN_TAG_TOOL_UPGRADE "obj,item,tool_upgrade"
#define SPAWN_TAG_RARE_TOOL_UPGRADE "obj,item,tool_upgrade,rare_tool_upgrade"
#define SPAWN_TAG_RARE_TOOL_UPGRADE_OS "obj,item,tool_upgrade,rare_tool_upgrade,item_tech_os,onestar"
#define SPAWN_TAG_GUN_UPGRADE "obj,item,gun_upgrade"

//items - one star
#define SPAWN_ITEM_TECH_OS "item_tech_os"

#define SPAWN_TAG_ITEM_TECH_OS "obj,item,item_tech_os,onestar"

// ITEMS - organ- PROSTHESIS
#define SPAWN_OS_PROSTHETIC "prosthetic_os"

#define SPAWN_TAG_OS_PROSTHETIC "obj,item,organ,external,prosthetic,prosthetic_os,item_tech_os,onestar"

//	Items - Oddities
#define SPAWN_ODDITY "oddity"

#define SPAWN_TAG_ODDITY "obj,item,oddity"
#define SPAWN_TAG_ODDITY_WEAPON "obj,item,oddity,weapon"

//	Items - Tanks
#define SPAWN_TANK_GAS "tank_gas"

#define SPAWN_TAG_TANK_GAS "obj,item,tank_gas"

//items - jetpack
#define SPAWN_JETPACK "jetpack"

#define SPAWN_TAG_JETPACK "obj,item,jetpack"

//  Items - electronics
#define SPAWN_ELECTRONICS "electronics"

#define SPAWN_TAG_ELECTRONICS "obj,item,electronics"
#define SPAWN_TAG_ELECTRONICS_TAG_JUNK "obj,item,electronics,junk"

//  Items - assembly
#define SPAWN_ASSEMBLY "assembly"

#define SPAWN_TAG_ASSEMBLY "obj,item,assembly"

// items - ore
#define SPAWN_MATERIAL "material"
#define SPAWN_ORE "ore"
#define SPAWN_MATERIAL_RESOURCES "material_resources"
#define SPAWN_MATERIAL_RESOURCES_RARE "material_resources_rare"
#define SPAWN_MATERIAL_BUILDING "bulding_material"
#define SPAWN_MATERIAL_BUILDING_ROD "rod"
#define SPAWN_MATERIAL_JUNK "material_junk"

#define SPAWN_TAG_MATERIAL "obj,item,material"
#define SPAWN_TAG_ORE "obj,item,material,ore"
#define SPAWN_TAG_MATERIAL_RESOURCES "obj,item,material,material_resources"
#define SPAWN_TAG_MATERIAL_RESOURCES_RARE "obj,item,material,material_resources,material_resources_rare"
#define SPAWN_TAG_MATERIAL_RESOURCES_BULDING "obj,item,material,bulding_material,material_resources"
#define SPAWN_TAG_MATERIAL_BUILDING "obj,item,material,bulding_material"
#define SPAWN_TAG_MATERIAL_BUILDING_ROD "obj,item,bulding_material,rod,material_junk,junk"
#define SPAWN_TAG_ORE_TAG_JUNK "obj,item,material,ore,material_junk,junk"
#define SPAWN_TAG_MATERIAL_JUNK "obj,item,bulding_material,material_junk,junk"

// FOSSIL
#define SPAWN_XENOARCH "xenoarcheology"
#define SPAWN_FOSSIL "fossil"

#define SPAWN_TAG_XENOARCH_ITEM "obj,item,xenoarch"
#define SPAWN_TAG_XENOARCH_ITEM_FOSSIL "obj,item,fossil,xenoarch"
#define SPAWN_TAG_GUN_ENERGY_XENOARCH "obj,item,gun,gun_energy,xenoarch"

//  MINES
#define SPAWN_MINE "mine"
#define SPAWN_ITEM_MINE "item_mine"
#define SPAWN_STUCTURE_MINE "structure_mine"

#define SPAWN_TAG_ITEM_MINE "obj,item,mine,item_mine"
#define SPAWN_TAG_STUCTURE_MINE "obj,structure,mine,structure_mine"

//traps
#define SPAWN_TRAP_ARMED "trap_armed"
#define SPAWN_WIRE_TRAP "wire_trap"

#define SPAWN_TAG_TRAP_ARMED "obj,item,trap_armed"
#define SPAWN_TAG_STRUCTURE_TRAP_ARMED_WIRE "obj,structure,trap_armed,wire_trap"

//	Items - powercells
#define SPAWN_POWERCELL "powercell"
#define SPAWN_SMALL_POWERCELL "small_powercell"
#define SPAWN_MEDIUM_POWERCELL "medium_powercell"
#define SPAWN_LARGE_POWERCELL "large_powercell"

#define SPAWN_TAG_POWERCELL "obj,item,powercell"
#define SPAWN_TAG_SMALL_POWERCELL "obj,item,powercell,small_powercell"
#define SPAWN_TAG_MEDIUM_POWERCELL "obj,item,powercell,medium_powercell"
#define SPAWN_TAG_MEDIUM_POWERCELL_IH_AMMO "obj,item,powercell,medium_powercell,ammo_ih,ammo_common"
#define SPAWN_TAG_LARGE_POWERCELL "obj,item,powercell,large_powercell"

//	Items - GUNS
#define SPAWN_GUN "gun"
#define SPAWN_GUN_ENERGY "gun_energy"
#define SPAWN_GUN_PROJECTILE "gun_projectile"
#define SPAWN_GUN_SHOTGUN "shotgun"

#define SPAWN_TAG_GUN "obj,item,gun"
#define SPAWN_TAG_GUN_ENERGY "obj,item,gun,gun_energy"
#define SPAWN_TAG_GUN_ENERGY_CHAMALEON "obj,item,gun,gun_energy,contraband,chamaleon"
#define SPAWN_TAG_GUN_PROJECTILE "obj,item,gun,gun_projectile"
#define SPAWN_TAG_GUN_SHOTGUN "obj,item,gun,gun_projectile,shotgun"
#define SPAWN_TAG_GUN_SHOTGUN_ENERGY "obj,item,gun,gun_energy,shotgun"

//	Items - GUNS - ammo
#define SPAWN_AMMO "ammmo_storage"
#define SPAWN_AMMO_IH "ammo_ih"
#define SPAWN_AMMO_SHOTGUN "ammmo_storage_shotgun"
#define SPAWN_AMMO_COMMON "ammo_common"

#define SPAWN_TAG_AMMO "obj,item,gun,ammo,ammmo_storage"
#define SPAWN_TAG_AMMO_COMMON "obj,item,gun,ammo,ammmo_storage,ammmo_storage_common"
#define SPAWN_TAG_AMMO_SHOTGUN "obj,item,gun,ammo,ammmo_storage,ammmo_storage_shotgun"
#define SPAWN_TAG_AMMO_SHOTGUN_COMMON "obj,item,gun,ammo,ammmo_storage,ammmo_storage_shotgun,ammo_common"
#define SPAWN_TAG_AMMO_IH "obj,item,gun,ammo,ammmo_storage,ammo_ih"

//	Items - contraband
#define SPAWN_CONTRABAND "contraband"

#define SPAWN_TAG_CONTRABAND "obj,item,contraband"
#define SPAWN_TAG_DRUG_CONTRABAND "obj,item,drug,contraband"
#define SPAWN_TAG_DRUG_PILL_CONTRABAND "obj,item,pill,drug,contraband"

//	Items - TOYS
#define SPAWN_TOY "toy"
#define SPAWN_PLUSHIE "toy_plushie"
#define SPAWN_FIGURE "toy_figure"
#define SPAWN_TOY_WEAPON "weapon_toy"

#define SPAWN_TAG_TOY "obj,item,toy"
#define SPAWN_TAG_TOY_WEAPON "obj,item,toy,weapon_toy"
#define SPAWN_TAG_PLUSHIE "obj,item,toy,toy_plushie"
#define SPAWN_TAG_STRUCTURE_PLUSHIE "obj,structure,toy_plushie"
#define SPAWN_TAG_FIGURE "obj,item,toy,toy_figure"

//items - utility
#define SPAWN_ITEM_UTILITY "utility"

#define SPAWN_TAG_ITEM_UTILITY "obj,item,toy,utility"

//	Items - CLOTHING
#define SPAWN_CLOTHING "clothing"
#define SPAWN_MASK "mask"
#define SPAWN_VOID_SUIT "void_suit"
#define SPAWN_HAZMATSUIT "hazmatsuit"
#define SPAWN_HOLSTER "holster"
#define SPAWN_SHOES "shoes"
#define SPAWN_GLOVES "gloves"
#define SPAWN_GLOVES_INSULATED "insulated_gloves"
#define SPAWN_CLOTHING_UNDER "under"
#define SPAWN_CLOTHING_HEAD "head"
#define SPAWN_CLOTHING_HEAD_HELMET "helmet"
#define SPAWN_CLOTHING_ARMOR "armor"
#define SPAWN_GLASSES "glasses"
#define SPAWN_CLOTHING_SUIT_STORAGE "suit_storage"
#define SPAWN_CLOTHING_SUIT_PONCHO "suit_poncho"

#define SPAWN_TAG_CLOTHING "obj,item,clothing"
#define SPAWN_TAG_VOID_SUIT "obj,item,clothing,suit,space_suit,void_suit"
#define SPAWN_TAG_MASK "obj,item,clothing,mask"
#define SPAWN_TAG_MASK_CONTRABAND "obj,item,clothing,mask,contraband,chamaleon"
#define SPAWN_TAG_HAZMATSUIT "obj,item,clothing,hazmatsuit"
#define SPAWN_TAG_HOLSTER "obj,item,clothing,holster"
#define SPAWN_TAG_SHOES "obj,item,clothing,shoes"
#define SPAWN_TAG_SHOES_CHAMALEON "obj,item,clothing,shoes,contraband,chamaleon"
#define SPAWN_TAG_GLOVES "obj,item,clothing,gloves"
#define SPAWN_TAG_GLOVES_INSULATED "obj,item,clothing,gloves,insulated_gloves,utility_item"
#define SPAWN_TAG_GLOVES_CHAMALEON "obj,item,clothing,gloves,chamaleon,contraband"
#define SPAWN_TAG_CLOTHING_UNDER "obj,item,clothing,under"
#define SPAWN_TAG_CLOTHING_UNDER_CHAMALEON "obj,item,clothing,under,contraband,chamaleon"
#define SPAWN_TAG_CLOTHING_HEAD "obj,item,clothing,head"
#define SPAWN_TAG_CLOTHING_HEAD_CHAMALEON "obj,item,clothing,head,chamaleon,contraband"
#define SPAWN_TAG_CLOTHING_HEAD_HELMET "obj,item,clothing,head,helmet"
#define SPAWN_TAG_CLOTHING_ARMOR "obj,item,clothing,armor"
#define SPAWN_TAG_GLASSES "obj,item,clothing,glasses"
#define SPAWN_TAG_GLASSES_CHAMALEON "obj,item,clothing,glasses,contraband,chamaleon"
#define SPAWN_TAG_CLOTHING_SUIT_STORAGE "obj,item,clothing,suit,suit_storage"
#define SPAWN_TAG_CLOTHING_SUIT_PONCHO "obj,item,clothing,suit,suit_poncho"

//	Items - storage
#define SPAWN_storage "storage"
#define SPAWN_TOOLBOX "toolbox"
#define SPAWN_POUCH "pouch"
#define SPAWN_BELT "belt"
#define SPAWN_BOX "box"
#define SPAWN_FIRSTAID "firstaid"
#define SPAWN_BACKPACK "backpack"

#define SPAWN_TAG_TOOLBOX "obj,item,storage,toolbox"
#define SPAWN_TAG_POUCH "obj,item,storage,pouch,clothing"
#define SPAWN_TAG_BELT "obj,item,storage,belt,clothing"
#define SPAWN_TAG_BELT_UTILITY "obj,item,storage,belt,clothing,item_utility"
#define SPAWN_TAG_BOX "obj,item,storage,box"
#define SPAWN_TAG_FIRSTAID "obj,item,storage,firstaid"
#define SPAWN_TAG_BACKPACK "obj,item,storage,backpack,clothing"
#define SPAWN_TAG_BACKPACK_CHAMALEON "obj,item,storage,backpack,clothing,contraband,chamaleon"
#define SPAWN_TAG_BOX_TAG_JUNK "obj,item,storage,box,junk"

// ITEM - STOCK PARTS   and os_tech
#define SPAWN_STOCK_PARTS "stock_parts"

#define SPAWN_TAG_STOCK_PARTS "obj,item,stock_parts"
#define SPAWN_TAG_STOCK_PARTS_TIER_2 "obj,item,stock_parts,science"
#define SPAWN_TAG_STOCK_PARTS_OS "obj,item,stock_parts,stock_parts_os,item_tech_os,onestar"

// ITEM - divice
#define SPAWN_DIVICE "divice"

#define SPAWN_TAG_DIVICE "obj,item,divice"
#define SPAWN_TAG_DIVICE_SCIENCE "obj,item,divice,science"

//factions
#define SPAWN_SCIENCE "science"

//Factions - medical
#define SPAWN_MEDICAL "medical"

#define SPAWN_TAG_MEDICAL "obj,item,medical"

// ITEMS - MEDICINE
#define SPAWN_MEDICINE_COMMON "medicine_common"
#define SPAWN_MEDICINE "medicine"

#define SPAWN_TAG_MEDICINE "obj,item,medicine,medical"
#define SPAWN_TAG_MEDICINE_COMMON "obj,item,medicine,medicine_common,medical"
#define SPAWN_TAG_MEDICINE_CONTRABAND "obj,item,medicine,medical,contraband"

//ITEMS - BEAKER
#define SPAWN_TAG_VIAL "obj,item,beaker,vial,science,medical"


// ITEMS - COMPUTER
#define SPAWN_DESING "desing"
#define SPAWN_DESING_COMMON "desing_common"
#define SPAWN_DESING_ADVANCED "desing_advanced"
#define SPAWN_COMPUTER_HARDWERE "computer_hardware"

#define SPAWN_TAG_DESING "obj,item,desing"
#define SPAWN_TAG_DESING_COMMON "obj,item,desing,desing_common"
#define SPAWN_TAG_DESING_OS "obj,item,desing,desing_os,item_tech_os,onestar"
#define SPAWN_TAG_DESING_ADVANCED "obj,item,desing,desing_advanced"
#define SPAWN_TAG_DESING_ADVANCED_COMMON "obj,item,desing,desing_advanced,desing_common"
#define SPAWN_TAG_RESEARCH_POINTS "obj,item,science"
#define SPAWN_TAG_COMPUTER_HARDWERE "obj,item,computer_hardware"

// ITEMS - RING
#define SPAWN_RING "ring_suit"
#define SPAWN_RING_MODULE "ring_module"
#define SPAWN_RING_MODULE_COMMON "ring_module_common"

#define SPAWN_TAG_RING "obj,item,space_suit,ring_suit"
#define SPAWN_TAG_RING_HAZMAT "obj,item,space_suit,ring_suit,science"
#define SPAWN_TAG_RING_MODULE "obj,item,ring_module"
#define SPAWN_TAG_RING_MODULE_COMMON "ring_module_common"

// ITEM - DRIKS
#define SPAWN_BOOZE "bottle_alcohol"
#define SPAWN_DRINK_SODA "cans"

#define SPAWN_TAG_BOOZE "obj,item,drink,bottle_drink,bottle_alcohol"
#define SPAWN_TAG_DRINK_SODA "obj,item,drink,bottle_drink,cans"

// item -snacks
#define SPAWN_JUNKFOOD "junkfood"
#define SPAWN_PIZZA "pizza"
#define SPAWN_RATIONS "rations"
#define SPAWN_COOKED_FOOD "cooked_food"

#define SPAWN_TAG_RATIONS "obj,item,snacks,rations"
#define SPAWN_TAG_JUNKFOOD "obj,item,snacks,junkfood"
#define SPAWN_TAG_JUNKFOOD_RATIONS "obj,item,snacks,junkfood,rations"
#define SPAWN_TAG_PIZZA "obj,item,snacks,pizza"
#define SPAWN_TAG_COOKED_FOOD "obj,item,snacks,cooked_food"

// ITEM - GRENADES
#define SPAWN_TAG_GRENADE "obj,item,grenade"

#define SPAWN_TAG_GRENADE_CLEANER "obj,item,grenade,grenade_cleaner,utility_item"

//	MECH
#define SPAWN_MECH_PREMADE "mech_premade"
#define SPAWN_MECH_QUIPMENT "mech_equipment"

#define SPAWN_TAG_MECH "mech,mech_premade"
#define SPAWN_TAG_MECH_QUIPMENT "mech,item,mech_equipment"


//	MACHINERY
#define SPAWN_MACHINERY "machinery"

#define SPAWN_TAG_MACHINERY "obj,machinery"

//	Structures
#define SPAWN_STRUCTURE "structure"
#define SPAWN_STRUCTURE_COMMON "common_structure"

#define SPAWN_TAG_STRUCTURE "obj,structure"
#define SPAWN_TAG_STRUCTURE_COMMON "obj,structure,common_structure"

// Structures - ClOSET
#define SPAWN_CLOSET "closet"
#define SPAWN_WARDROBE "wardrobe"
#define SPAWN_TECHNICAL_CLOSET "technical_closet"
#define SPAWN_RANDOM_CLOSET "random_closet"
#define SPAWN_LASERTAG_CLOSET "lasertag_closet"
#define SPAWN_BOMB_CLOSET "bomb_closet"
#define SPAWN_COFFIN_CLOSET "coffin_closet"
#define SPAWN_CLOSET_SECURE "secure_closet"//secure

#define SPAWN_TAG_CLOSET "obj,structure,closet"
#define SPAWN_TAG_CLOSET_OS "obj,structure,closet,onestar"
#define SPAWN_TAG_CLOSET_SECURE "obj,structure,closet,secure_closet"//secure
#define SPAWN_TAG_TECHNICAL_CLOSET "obj,structure,closet,technical_closet"
#define SPAWN_TAG_WARDROBE "obj,structure,closet,wardrobe"
#define SPAWN_TAG_RANDOM_CLOSET "obj,structure,closet,random_closet"
#define SPAWN_TAG_RANDOM_SECURE_CLOSET "obj,structure,closet,random_closet,secure_closet"
#define SPAWN_TAG_LASERTAG_CLOSET "obj,structure,closet,lasertag_closet"
#define SPAWN_TAG_BOMB_CLOSET "obj,structure,closet,bomb_closet"
#define SPAWN_TAG_COFFIN_CLOSET "obj,structure,closet,coffin_closet"

// Structures - SALVAGEABLE
#define SPAWN_SALVAGEABLE "structure_salvageable"
#define SPAWN_SALVAGEABLE_OS "structure_salvageable_os"
#define SPAWN_SALVAGEABLE_AUTOLATHEABLE "structure_salvageable_autolathe"

#define SPAWN_TAG_SALVAGEABLE "obj,structure,structure_salvageable"
#define SPAWN_TAG_SALVAGEABLE_OS "obj,structure,structure_salvageable,structure_salvageable_os,onestar"
#define SPAWN_TAG_SALVAGEABLE_AUTOLATHE "obj,structure,structure_salvageable,structure_salvageable_autolathe"

// Structures - MACHINE_FRAME
#define SPAWN_MACHINE_FRAME "structure_machine_frame"

#define SPAWN_TAG_COMPUTERFRAME "obj,structure,structure_machine_frame,structure_computer_frame"
#define SPAWN_TAG_CONSTRUCTABLE_FRAME "obj,structure,structure_machine_frame,struture_constructable_frame"

// Structures - reagent dispensers
#define SPAWN_REAGENT_DISPENSER "structure_reagent_dispensers"

#define SPAWN_TAG_REAGENT_DISPENSER "obj,structure,structure_reagent_dispensers"

// Structures - scrap
#define SPAWN_SCRAP "structure_scrap"
#define SPAWN_LARGE_SCRAP "structure_large_scrap"
#define SPAWN_BEACON_SCRAP "structure_beacon_scrap"

#define SPAWN_TAG_SCRAP "obj,structure,structure_scrap"
#define SPAWN_TAG_LARGE_SCRAP "obj,structure,structure_scrap,structure_large_scrap"
#define SPAWN_TAG_BEACON_SCRAP "obj,structure,structure_scrap,structure_beacon_scrap"


//-encounters
#define SPAWN_ENCOUNER "encounter"
#define SPAWN_ENCOUNTER_CRYOPOD "encounter_cryopod"
#define SPAWN_SATELITE  "structure_satelite"
#define SPAWN_OMINOUS "structure_ominous"
#define SPAWN_STRANGEBEACON "strangebeacon"
#define SPAWN_BOT_OS "bot_os"

#define SPAWN_TAG_ENCOUNTER_CRYOPOD "obj,structure,encounter,encounter_cryopod"
#define SPAWN_TAG_SATELITE "obj,structure,encounter,structure_satelite"
#define SPAWN_TAG_OMINOUS "obj,structure,encounter,structure_ominous"
#define SPAWN_TAG_STRANGEBEACON "obj,structure,encounter,strangebeacon"
#define SPAWN_TAG_BOT_OS "mob,bot,bot_os,onestar,encounter"

//	Mobs
#define SPAWN_MOB "mob"
#define SPAWN_HOSTILE_MOB "hostile_mob"
#define SPAWN_FRIENDLY_MOB "friendly_mob"
#define SPAWN_SLIME "slime"
#define SPAWN_MOB_OS_CUSTODIAN "os_custodian"
#define SPAWN_MOB_ROOMBA "roomba"
#define SPAWN_MOB_HIVEMIND "hivemind"

#define SPAWN_TAG_HOSTILE_MOB "mob,hostile_mob"
#define SPAWN_TAG_FRIENDLY_MOB "mob,friendly_mob"
#define SPAWN_TAG_SLIME "mob,slime"
#define SPAWN_TAG_MOB_OS_CUSTODIAN "mob,hostile_mob,os_custodian,onestar"
#define SPAWN_TAG_MOB_HIVEMIND "mob,hostile_mob,hivemind"
#define SPAWN_TAG_MOB_ROOMBA "mob,hostile_mob,roomba,onestar"

// MOBS - ROACH
#define SPAWN_ROACH "mob_roach"
#define SPAWN_NANITE_ROACH "nanite_roach"

#define SPAWN_TAG_ROACH "mob,hostile_mob,mob_roach"
#define SPAWN_TAG_NANITE_ROACH "mob,hostile_mob,mob_roach,nanite_roach"

//MOBS - SLIMES
#define SPAWN_SPIDER "mob_spider"

#define SPAWN_TAG_SPIDER "mob,hostile_mob,mob_spider"

//EFFECTS
#define SPAWN_FLORA "flora"

#define SPAWN_TAG_FLORA "effect,flora"


//JUNK
#define SPAWN_JUNK "junk"
#define SPAWN_CLEANABLE "cleanable"
#define SPAWN_REMAINS "remains"

#define SPAWN_TAG_REMAINS "obj,item,remains"
#define SPAWN_TAG_JUNK "obj,item,junk"
#define SPAWN_TAG_CLEANABLE "effect,cleanable"

//  SPAWNERS
#define SPAWN_SPAWNER "spawner"
#define SPAWN_SPAWNER_ENCOUNER "spawner_encounter"
#define SPAWN_SPAWNER_MOB "spawner_mob"
#define SPAWN_SPAWNER_SCRAP "spawner_scrap"
#define SPAWN_SPAWNER_LARGE_SCRAP "spawner_large_scrap"

#define SPAWN_TAG_SPAWNER_ENCOUNER "spawner,spawner_encounter"
#define SPAWN_TAG_SPAWNER_MOB "spawner,spawner_mob"
#define SPAWN_TAG_SPAWNER_SCRAP "spawner,spawner_scrap"
#define SPAWN_TAG_SPAWNER_LARGE_SCRAP "spawner,spawner_scrap,spawner_large_scrap"

// FACTION KEYWORDS
#define SPAWN_ASTERS "asters"
#define SPAWN_FROZEN_STAR "frozen_star"
#define SPAWN_IRONHAMMER "ironhammer"
#define SPAWN_NANOTRASEN "nanotrasen"
#define SPAWN_NEOTHEOLOGY "neotheology"
#define SPAWN_MOEBIUS "moebius"
#define SPAWN_SERBIAN "serbian"
