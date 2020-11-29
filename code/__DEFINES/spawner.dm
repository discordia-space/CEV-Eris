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

#define SPAWN_TAG_ITEM "obj;item"
#define SPAWN_TAG_WEAPON "obj;item;weapon"


#define SPAWN_TAG_DICE "obj;item;dice"
#define SPAWN_TAG_ITEM_BOTANICAL "obj;item;botanical"
#define SPAWN_TAG_ITEM_CLOWN "obj;item;clown"


#define SPAWN_RARE_ITEM "rare_item"

#define SPAWN_TAG_RARE_ITEM "obj;item;rare_item"

//Items - tools
#define SPAWN_TOOL "tool"
#define SPAWN_JUNK_TOOL "junk_tool"
#define SPAWN_TOOL_ADVANCED "tool_advanced"
#define SPAWN_OS_TOOL "os_tool"

#define SPAWN_TAG_TOOL "obj;item;tool"
#define SPAWN_TAG_TOOL_ADVANCED "obj;item;tool;tool_advanced"
#define SPAWN_TAG_OS_TOOL "obj;item;tool;os_tool;onestar"
#define SPAWN_TAG_TOOL_TAG_JUNK "obj;item;tool;junk_tool;junk"

//	Items - tools - knife
#define SPAWN_KNIFE "knife"
#define SPAWN_SWORD "sword"

#define SPAWN_TAG_KNIFE "obj;item;weapon;tool;knife"
#define SPAWN_TAG_SWORD "obj;item;weapon;tool;knife;sword"
#define SPAWN_TAG_KNIFE_CONTRABAND "obj;item;weapon;tool;knife;contraband"

// ITEMS - tools - SURGERY
#define SPAWN_SURGERY_TOOL "surgery_tool"

#define SPAWN_TAG_SURGERY_TOOL "obj;item;tool;surgery_tool;medical"

//	Items - upgrades
#define SPAWN_TOOL_UPGRADE "tool_upgrade"
#define SPAWN_TOOL_UPGRADE_RARE "tool_upgrade_rare"
#define SPAWN_GUN_UPGRADE "gun_upgrade"

#define SPAWN_TAG_TOOL_UPGRADE "obj;item;tool_upgrade"
#define SPAWN_TAG_TOOL_UPGRADE_RARE "obj;item;tool_upgrade;tool_upgrade_rare"
#define SPAWN_TAG_TOOL_UPGRADE_RARE_OS "obj;item;tool_upgrade;tool_upgrade_rare;item_tech_os;onestar"
#define SPAWN_TAG_GUN_UPGRADE "obj;item;gun_upgrade;guns"

//items - one star
#define SPAWN_ITEM_TECH_OS "item_tech_os"

#define SPAWN_TAG_ITEM_TECH_OS "obj;item;item_tech_os;onestar"

// organ- PROSTHESIS
#define SPAWN_ORGAN "organ"
#define SPAWN_ORGAN_ORGANIC "organ_organic"
#define SPAWN_PROSTHETIC "organ_prosthetic"
#define SPAWN_PROSTHETIC_OS "organ_prosthetic_os"

#define SPAWN_TAG_ORGAN "obj;item;organ;organ_organic"
#define SPAWN_TAG_ORGAN_INTERNAL "obj;item;organ;organ_internal;organ_organic"
#define SPAWN_TAG_ORGAN_EXTERNAL "obj;item;organ;organ_external;organ_organic"
#define SPAWN_TAG_PROSTHETIC "obj;item;organ;organ_external;organ_prosthetic"
#define SPAWN_TAG_PROSTHETIC_OS "obj;item;organ;organ_external;organ_prosthetic;organ_prosthetic_os;item_tech_os;onestar"

//	Items - Oddities
#define SPAWN_ODDITY "oddity"

#define SPAWN_TAG_ODDITY "obj;item;oddity"

//	Items - Tanks
#define SPAWN_TANK_GAS "tank_gas"

#define SPAWN_TAG_TANK_GAS "obj;item;tank_gas"

//items - jetpack
#define SPAWN_JETPACK "jetpack"

#define SPAWN_TAG_JETPACK "obj;item;jetpack"

//  Items - electronics
#define SPAWN_ELECTRONICS "electronics"

#define SPAWN_TAG_ELECTRONICS "obj;item;electronics"
#define SPAWN_TAG_ELECTRONICS_TAG_JUNK "obj;item;electronics;junk"

//  Items - assembly
#define SPAWN_ASSEMBLY "assembly"

#define SPAWN_TAG_ASSEMBLY "obj;item;assembly"

// items - ore
#define SPAWN_MATERIAL "material"
#define SPAWN_ORE "ore"
#define SPAWN_MATERIAL_RESOURCES "material_resources"
#define SPAWN_MATERIAL_RESOURCES_RARE "material_resources_rare"
#define SPAWN_MATERIAL_BUILDING "bulding_material"
#define SPAWN_MATERIAL_BUILDING_ROD "rod"
#define SPAWN_MATERIAL_JUNK "material_junk"

#define SPAWN_TAG_MATERIAL "obj;item;material"
#define SPAWN_TAG_ORE "obj;item;material;ore"
#define SPAWN_TAG_MATERIAL_RESOURCES "obj;item;material;material_resources"
#define SPAWN_TAG_MATERIAL_RESOURCES_RARE "obj;item;material;material_resources;material_resources_rare"
#define SPAWN_TAG_MATERIAL_RESOURCES_BULDING "obj;item;material;bulding_material;material_resources"
#define SPAWN_TAG_MATERIAL_BUILDING "obj;item;material;bulding_material"
#define SPAWN_TAG_MATERIAL_BUILDING_ROD "obj;item;bulding_material;rod;material_junk;junk"
#define SPAWN_TAG_ORE_TAG_JUNK "obj;item;material;ore;material_junk;junk"
#define SPAWN_TAG_MATERIAL_JUNK "obj;item;bulding_material;material_junk;junk"

// FOSSIL
#define SPAWN_XENOARCH "xenoarcheology"
#define SPAWN_FOSSIL "fossil"

#define SPAWN_TAG_XENOARCH_ITEM "obj;item;xenoarch"
#define SPAWN_TAG_XENOARCH_ITEM_FOSSIL "obj;item;fossil;xenoarch"
#define SPAWN_TAG_GUN_ENERGY_XENOARCH "obj;item;gun;guns;gun_energy;xenoarch"

//  MINES
#define SPAWN_MINE "mine"
#define SPAWN_MINE_ITEM "mine_item"
#define SPAWN_STUCTURE_MINE "mine_structure"

#define SPAWN_TAG_MINE_ITEM "obj;item;mine;mine_item"
#define SPAWN_TAG_MINE_STUCTURE "obj;structure;mine;mine_structure"

//traps
#define SPAWN_TRAP_ARMED "trap_armed"
#define SPAWN_TRAP_WIRE "trap_wire"

#define SPAWN_TAG_TRAP_ARMED "obj;item;trap_armed"
#define SPAWN_TAG_TRAP_ARMED_WIRE "obj;structure;trap_armed;trap_wire"

//	Items - powercells
#define SPAWN_POWERCELL "powercell"
#define SPAWN_POWERCELL_SMALL "powercell_small"
#define SPAWN_POWERCELL_MEDIUM "powercell_medium"
#define SPAWN_POWERCELL_LARGE "powercell_large"

#define SPAWN_TAG_POWERCELL "obj;item;powercell"
#define SPAWN_TAG_POWERCELL_SMALL "obj;item;powercell;powercell_small"
#define SPAWN_TAG_POWERCELL_MEDIUM "obj;item;powercell;powercell_medium"
#define SPAWN_TAG_POWERCELL_MEDIUM_IH_AMMO "obj;item;powercell;powercell_medium;ammo_ih;ammo_common"
#define SPAWN_TAG_POWERCELL_LARGE "obj;item;powercell;powercell_large"

//	Items - GUNS
#define SPAWN_GUN "gun"
#define SPAWN_GUN_ENERGY "gun_energy"
#define SPAWN_GUN_PROJECTILE "gun_projectile"
#define SPAWN_GUN_SHOTGUN "shotgun"

#define SPAWN_TAG_GUN "obj;item;gun;guns"
#define SPAWN_TAG_GUN_ENERGY "obj;item;gun;gun_energy;guns"
#define SPAWN_TAG_GUN_ENERGY_CHAMALEON "obj;item;gun;gun_energy;contraband;chamaleon;guns"
#define SPAWN_TAG_GUN_PROJECTILE "obj;item;gun;gun_projectile;guns"
#define SPAWN_TAG_GUN_SHOTGUN "obj;item;gun;gun_projectile;shotgun;guns"
#define SPAWN_TAG_GUN_SHOTGUN_ENERGY "obj;item;gun;gun_energy;shotgun;guns"
#define SPAWN_TAG_GUN_ENERGY_BOTANICAL "obj;item;gun;gun_energy;guns;botanical"

//	Items - GUNS - ammo
#define SPAWN_AMMO "ammmo_storage"
#define SPAWN_AMMO_IH "ammo_ih"
#define SPAWN_AMMO_SHOTGUN "ammmo_storage_shotgun"
#define SPAWN_AMMO_COMMON "ammo_common"

#define SPAWN_TAG_AMMO "obj;item;guns;ammo;ammmo_storage"
#define SPAWN_TAG_AMMO_COMMON "obj;item;guns;ammo;ammmo_storage;ammmo_storage_common"
#define SPAWN_TAG_AMMO_SHOTGUN "obj;item;guns;ammo;ammmo_storage;ammmo_storage_shotgun"
#define SPAWN_TAG_AMMO_SHOTGUN_COMMON "obj;item;guns;ammo;ammmo_storage;ammmo_storage_shotgun;ammo_common"
#define SPAWN_TAG_AMMO_IH "obj;item;guns;ammo;ammmo_storage;ammo_ih"

//	Items - contraband
#define SPAWN_CONTRABAND "contraband"

#define SPAWN_TAG_CONTRABAND "obj;item;contraband"
#define SPAWN_TAG_DRUG_CONTRABAND "obj;item;drug;contraband"
#define SPAWN_TAG_DRUG_PILL_CONTRABAND "obj;item;pill;drug;contraband"

//	Items - TOYS
#define SPAWN_TOY "toy"
#define SPAWN_PLUSHIE "toy_plushie"
#define SPAWN_FIGURE "toy_figure"
#define SPAWN_TOY_WEAPON "toy_weapon"

#define SPAWN_TAG_TOY "obj;item;toy"
#define SPAWN_TAG_TOY_WEAPON "obj;item;toy;toy_weapon"
#define SPAWN_TAG_PLUSHIE "obj;item;toy;toy_plushie"
#define SPAWN_TAG_STRUCTURE_PLUSHIE "obj;structure;toy_plushie"
#define SPAWN_TAG_FIGURE "obj;item;toy;toy_figure"

//items - utility
#define SPAWN_ITEM_UTILITY "utility"

#define SPAWN_TAG_ITEM_UTILITY "obj;item;utility"

//	Items - CLOTHING
#define SPAWN_CLOTHING "clothing"
#define SPAWN_MASK "mask"
#define SPAWN_VOID_SUIT "void_suit"
#define SPAWN_HAZMATSUIT "hazmatsuit"
#define SPAWN_HOLSTER "holster"
#define SPAWN_SHOES "shoes"
#define SPAWN_GLOVES "gloves"
#define SPAWN_CLOTHING_UNDER "under"
#define SPAWN_CLOTHING_HEAD "head"
#define SPAWN_CLOTHING_HEAD_HELMET "helmet"
#define SPAWN_CLOTHING_ARMOR "armor"
#define SPAWN_GLASSES "glasses"
#define SPAWN_CLOTHING_SUIT_STORAGE "suit_storage"
#define SPAWN_CLOTHING_SUIT_PONCHO "suit_poncho"

#define SPAWN_TAG_CLOTHING "obj;item;clothing"
#define SPAWN_TAG_VOID_SUIT "obj;item;clothing;suit;space_suit;void_suit"
#define SPAWN_TAG_MASK "obj;item;clothing;mask"
#define SPAWN_TAG_MASK_CONTRABAND "obj;item;clothing;mask;contraband;chamaleon"
#define SPAWN_TAG_HAZMATSUIT "obj;item;clothing;hazmatsuit"
#define SPAWN_TAG_HOLSTER "obj;item;clothing;holster"
#define SPAWN_TAG_SHOES "obj;item;clothing;shoes"
#define SPAWN_TAG_SHOES_CHAMALEON "obj;item;clothing;shoes;contraband;chamaleon"
#define SPAWN_TAG_GLOVES "obj;item;clothing;gloves"
#define SPAWN_TAG_GLOVES_INSULATED "obj;item;clothing;gloves;item_utility"
#define SPAWN_TAG_GLOVES_CHAMALEON "obj;item;clothing;gloves;chamaleon;contraband"
#define SPAWN_TAG_CLOTHING_UNDER "obj;item;clothing;under"
#define SPAWN_TAG_CLOTHING_UNDER_CHAMALEON "obj;item;clothing;under;contraband;chamaleon"
#define SPAWN_TAG_CLOTHING_HEAD "obj;item;clothing;head"
#define SPAWN_TAG_CLOTHING_HEAD_CHAMALEON "obj;item;clothing;head;chamaleon;contraband"
#define SPAWN_TAG_CLOTHING_HEAD_HELMET "obj;item;clothing;head;helmet"
#define SPAWN_TAG_CLOTHING_ARMOR "obj;item;clothing;armor"
#define SPAWN_TAG_GLASSES "obj;item;clothing;glasses"
#define SPAWN_TAG_GLASSES_CHAMALEON "obj;item;clothing;glasses;contraband;chamaleon"
#define SPAWN_TAG_CLOTHING_SUIT_STORAGE "obj;item;clothing;suit;suit_storage"
#define SPAWN_TAG_CLOTHING_SUIT_PONCHO "obj;item;clothing;suit;suit_poncho"

//	Items - storage
#define SPAWN_STORAGE "storage"
#define SPAWN_TOOLBOX "toolbox"
#define SPAWN_POUCH "pouch"
#define SPAWN_BELT "belt"
#define SPAWN_BOX "box"
#define SPAWN_FIRSTAID "firstaid"
#define SPAWN_BACKPACK "backpack"

#define SPAWN_TAG_STORAGE "obj;item;storage"
#define SPAWN_TAG_TOOLBOX "obj;item;storage;toolbox"
#define SPAWN_TAG_POUCH "obj;item;storage;pouch;clothing"
#define SPAWN_TAG_BELT "obj;item;storage;belt;clothing"
#define SPAWN_TAG_BELT_UTILITY "obj;item;storage;belt;clothing;item_utility"
#define SPAWN_TAG_BOX "obj;item;storage;box"
#define SPAWN_TAG_FIRSTAID "obj;item;storage;firstaid"
#define SPAWN_TAG_BACKPACK "obj;item;storage;backpack;clothing"
#define SPAWN_TAG_BACKPACK_CHAMALEON "obj;item;storage;backpack;clothing;contraband;chamaleon"
#define SPAWN_TAG_BOX_TAG_JUNK "obj;item;storage;box;junk"

// ITEM - STOCK PARTS   and os_tech
#define SPAWN_STOCK_PARTS "stock_parts"

#define SPAWN_TAG_STOCK_PARTS "obj;item;stock_parts"
#define SPAWN_TAG_STOCK_PARTS_TIER_2 "obj;item;stock_parts;science"
#define SPAWN_TAG_STOCK_PARTS_OS "obj;item;stock_parts;stock_parts_os;item_tech_os;onestar"

// ITEM - divice
#define SPAWN_DIVICE "divice"

#define SPAWN_TAG_DIVICE "obj;item;divice"
#define SPAWN_TAG_DIVICE_SCIENCE "obj;item;divice;science"

//factions
#define SPAWN_SCIENCE "science"

//Factions - medical
#define SPAWN_MEDICAL "medical"

#define SPAWN_TAG_MEDICAL "obj;item;medical"

// ITEMS - MEDICINE
#define SPAWN_MEDICINE "medicine"
#define SPAWN_MEDICINE_COMMON "medicine_common"
#define SPAWN_MEDICINE_ADVANCED "medicine_advanced"

#define SPAWN_TAG_MEDICINE "obj;item;medicine;medical"
#define SPAWN_TAG_MEDICINE_COMMON "obj;item;medicine;medicine_common;medical"
#define SPAWN_TAG_MEDICINE_CONTRABAND "obj;item;medicine;medical;contraband"
#define SPAWN_TAG_MEDICINE_ADVANCED "obj;item;medicine;medicine_advanced;medical"

//ITEMS - BEAKER
#define SPAWN_TAG_VIAL "obj;item;beaker;vial;science;medical"


// ITEMS - COMPUTER
#define SPAWN_DESING "desing"
#define SPAWN_DESING_COMMON "desing_common"
#define SPAWN_DESING_ADVANCED "desing_advanced"
#define SPAWN_COMPUTER_HARDWERE "computer_hardware"

#define SPAWN_TAG_DESING "obj;item;desing"
#define SPAWN_TAG_DESING_COMMON "obj;item;desing;desing_common"
#define SPAWN_TAG_DESING_OS "obj;item;desing;desing_os;item_tech_os;onestar"
#define SPAWN_TAG_DESING_ADVANCED "obj;item;desing;desing_advanced"
#define SPAWN_TAG_DESING_ADVANCED_COMMON "obj;item;desing;desing_advanced;desing_common"
#define SPAWN_TAG_RESEARCH_POINTS "obj;item;science"
#define SPAWN_TAG_COMPUTER_HARDWERE "obj;item;computer_hardware"

// ITEMS - RIG
#define SPAWN_RIG "rig_suit"
#define SPAWN_RIG_MODULE "rig_module"
#define SPAWN_RIG_MODULE_COMMON "rig_module_common"

#define SPAWN_TAG_RIG "obj;item;space_suit;rig_suit"
#define SPAWN_TAG_RIG_HAZMAT "obj;item;space_suit;rig_suit;science"
#define SPAWN_TAG_RIG_MODULE "obj;item;rig_module"
#define SPAWN_TAG_RIG_MODULE_COMMON "rig_module_common"

// ITEM - DRIKS
#define SPAWN_BOOZE "bottle_alcohol"
#define SPAWN_DRINK_SODA "cans"

#define SPAWN_TAG_BOOZE "obj;item;drink;bottle_drink;bottle_alcohol"
#define SPAWN_TAG_DRINK_SODA "obj;item;drink;bottle_drink;cans"

// item -snacks
#define SPAWN_JUNKFOOD "junkfood"
#define SPAWN_PIZZA "pizza"
#define SPAWN_RATIONS "rations"
#define SPAWN_COOKED_FOOD "cooked_food"

#define SPAWN_TAG_RATIONS "obj;item;snacks;rations"
#define SPAWN_TAG_JUNKFOOD "obj;item;snacks;junkfood"
#define SPAWN_TAG_JUNKFOOD_RATIONS "obj;item;snacks;junkfood;rations"
#define SPAWN_TAG_PIZZA "obj;item;snacks;pizza"
#define SPAWN_TAG_COOKED_FOOD "obj;item;snacks;cooked_food"

// ITEM - GRENADES
#define SPAWN_TAG_GRENADE "obj;item;grenade"

#define SPAWN_TAG_GRENADE_CLEANER "obj;item;grenade;grenade_cleaner;item_utility"

//	MECH
#define SPAWN_MECH "mech"

#define SPAWN_MECH_PREMADE "mech_premade"
#define SPAWN_MECH_QUIPMENT "mech_equipment"

#define SPAWN_TAG_MECH "mech;mech_premade"
#define SPAWN_TAG_MECH_QUIPMENT "mech;item;mech_equipment"


//	MACHINERY
#define SPAWN_MACHINERY "machinery"

#define SPAWN_TAG_MACHINERY "obj;machinery"

//	Structures
#define SPAWN_STRUCTURE "structure"
#define SPAWN_STRUCTURE_COMMON "structure_common"

#define SPAWN_TAG_STRUCTURE "obj;structure"
#define SPAWN_TAG_STRUCTURE_COMMON "obj;structure;structure_common"

// Structures - ClOSET
#define SPAWN_CLOSET "closet"
#define SPAWN_WARDROBE "wardrobe"
#define SPAWN_CLOSET_TECHNICAL "closet_technical"
#define SPAWN_CLOSET_RANDOM "closet_random"
#define SPAWN_CLOSET_LASERTAG "closet_lasertag"
#define SPAWN_CLOSET_BOMB "closet_bomb"
#define SPAWN_CLOSET_COFFIN "closet_coffin"
#define SPAWN_CLOSET_SECURE "closet_secure"//secure

#define SPAWN_TAG_CLOSET "obj;structure;closet"
#define SPAWN_TAG_CLOSET_OS "obj;structure;closet;onestar"
#define SPAWN_TAG_CLOSET_SECURE "obj;structure;closet;closet_secure"//secure
#define SPAWN_TAG_TECHNICAL_CLOSET "obj;structure;closet;closet_technical"
#define SPAWN_TAG_WARDROBE "obj;structure;closet;wardrobe"
#define SPAWN_TAG_RANDOM_CLOSET "obj;structure;closet;closet_random"
#define SPAWN_TAG_RANDOM_SECURE_CLOSET "obj;structure;closet;closet_random;closet_secure"
#define SPAWN_TAG_CLOSET_LASERTAG "obj;structure;closet;closet_lasertag"
#define SPAWN_TAG_CLOSET_BOMB "obj;structure;closet;closet_bomb"
#define SPAWN_TAG_CLOSET_COFFIN "obj;structure;closet;closet_coffin"

// Structures - SALVAGEABLE
#define SPAWN_SALVAGEABLE "structure_salvageable"
#define SPAWN_SALVAGEABLE_OS "structure_salvageable_os"
#define SPAWN_SALVAGEABLE_AUTOLATHEABLE "structure_salvageable_autolathe"

#define SPAWN_TAG_SALVAGEABLE "obj;structure;structure_salvageable"
#define SPAWN_TAG_SALVAGEABLE_OS "obj;structure;structure_salvageable;structure_salvageable_os;onestar"
#define SPAWN_TAG_SALVAGEABLE_AUTOLATHE "obj;structure;structure_salvageable;structure_salvageable_autolathe"

// Structures - MACHINE_FRAME
#define SPAWN_MACHINE_FRAME "structure_machine_frame"

#define SPAWN_TAG_COMPUTERFRAME "obj;structure;structure_machine_frame;structure_computer_frame"
#define SPAWN_TAG_CONSTRUCTABLE_FRAME "obj;structure;structure_machine_frame;struture_constructable_frame"

// Structures - reagent dispensers
#define SPAWN_REAGENT_DISPENSER "structure_reagent_dispensers"

#define SPAWN_TAG_REAGENT_DISPENSER "obj;structure;structure_reagent_dispensers"

// Structures - scrap
#define SPAWN_SCRAP "structure_scrap"
#define SPAWN_SCRAP_LARGE "structure_scrap_large"
#define SPAWN_SCRAP_BEACON "structure_scrap_beacon"

#define SPAWN_TAG_SCRAP "obj;structure;structure_scrap"
#define SPAWN_TAG_LARGE_SCRAP "obj;structure;structure_scrap;structure_scrap_large"
#define SPAWN_TAG_BEACON_SCRAP "obj;structure;structure_scrap;structure_scrap_beacon"


//-encounters
#define SPAWN_ENCOUNER "encounter"
#define SPAWN_ENCOUNTER_CRYOPOD "encounter_cryopod"
#define SPAWN_SATELITE  "structure_satelite"
#define SPAWN_OMINOUS "structure_ominous"
#define SPAWN_STRANGEBEACON "strangebeacon"
#define SPAWN_BOT_OS "bot_os"

#define SPAWN_TAG_ENCOUNTER_CRYOPOD "obj;structure;encounter;encounter_cryopod"
#define SPAWN_TAG_SATELITE "obj;structure;encounter;structure_satelite"
#define SPAWN_TAG_OMINOUS "obj;structure;encounter;structure_ominous"
#define SPAWN_TAG_STRANGEBEACON "obj;structure;encounter;strangebeacon"
#define SPAWN_TAG_BOT_OS "mob;bot;bot_os;onestar;encounter"

//	Mobs
#define SPAWN_MOB "mob"
#define SPAWN_MOB_HOSTILE "mob_hostile"
#define SPAWN_MOB_FRIENDLY "mob_friendly"
#define SPAWN_SLIME "slime"
#define SPAWN_MOB_OS_CUSTODIAN "os_custodian"
#define SPAWN_MOB_ROOMBA "roomba"
#define SPAWN_MOB_HIVEMIND "hivemind"

#define SPAWN_TAG_MOB_HOSTILE "mob;mob_hostile"
#define SPAWN_TAG_MOB_FRIENDLY "mob;mob_friendly"
#define SPAWN_TAG_SLIME "mob;slime"
#define SPAWN_TAG_MOB_OS_CUSTODIAN "mob;mob_hostile;os_custodian;onestar"
#define SPAWN_TAG_MOB_HIVEMIND "mob;mob_hostile;hivemind"
#define SPAWN_TAG_MOB_ROOMBA "mob;mob_hostile;roomba;onestar"

// MOBS - ROACH
#define SPAWN_ROACH "roach"
#define SPAWN_ROACH_NANITE "roach_nanite"

#define SPAWN_TAG_ROACH "mob;mob_hostile;roach"
#define SPAWN_TAG_ROACH_NANITE "mob;mob_hostile;roach;roach_nanite"

//MOBS - SLIMES
#define SPAWN_SPIDER "spider"

#define SPAWN_TAG_SPIDER "mob;mob_hostile;spider"

//EFFECTS
#define SPAWN_FLORA "flora"

#define SPAWN_TAG_FLORA "effect;flora"


//JUNK
#define SPAWN_JUNK "junk"
#define SPAWN_CLEANABLE "cleanable"
#define SPAWN_REMAINS "remains"

#define SPAWN_TAG_REMAINS "obj;item;remains"
#define SPAWN_TAG_JUNK "obj;item;junk"
#define SPAWN_TAG_JUNK_CLOWN "obj;item;junk;clown"
#define SPAWN_TAG_CLEANABLE "effect;cleanable"

//  SPAWNERS
#define SPAWN_SPAWNER "spawner"
#define SPAWN_SPAWNER_ENCOUNER "spawner_encounter"
#define SPAWN_SPAWNER_MOB "spawner_mob"
#define SPAWN_SPAWNER_SCRAP "spawner_scrap"
#define SPAWN_SPAWNER_SCRAP_LARGE "spawner_scrap_large"

#define SPAWN_TAG_SPAWNER_ENCOUNER "spawner;spawner_encounter"
#define SPAWN_TAG_SPAWNER_MOB "spawner;spawner_mob"
#define SPAWN_TAG_SPAWNER_SCRAP "spawner;spawner_scrap"
#define SPAWN_TAG_SPAWNER_SCRAP_LARGE "spawner;spawner_scrap;spawner_scrap_large"

// FACTION KEYWORDS
#define SPAWN_ASTERS "asters"
#define SPAWN_FROZEN_STAR "frozen_star"
#define SPAWN_IRONHAMMER "ironhammer"
#define SPAWN_NANOTRASEN "nanotrasen"
#define SPAWN_NEOTHEOLOGY "neotheology"
#define SPAWN_MOEBIUS "moebius"
#define SPAWN_SERBIAN "serbian"

#define CHEAP_ITEM_PRICE 800
