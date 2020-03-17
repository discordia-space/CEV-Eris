obj/item/weapon/gun/projectile/china
    name = "China Lake"
    desc = "China Lake Launcher desc"
    icon = 'icons/obj/guns/projectile/chinalake.dmi'
    icon_state = "china_lake"
    item_state = "china_lake"
    w_class = ITEM_SIZE_BULKY
    slot_flags = SLOT_BACK
    force = WEAPON_FORCE_PAINFUL
    matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_WOOD = 5 )  //Work on those numbers later 
    price_tag = 4000
    caliber = CAL_GRENADE
    load_method = SINGLE_CASING
    origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
    handle_casings = HOLD_CASINGS
    fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
    bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg' //Placeholder, could use a new sound
    max_shells = 6
    recoil_buildup = 20
    twohanded = TRUE

