/obj/item/gun/projectile/automatic/luty
    name = "handmade SMG .35 Auto \"Luty\""
    desc = "A dead simple open-bolt automatic firearm, easily made and easily concealed.\
            A gun that has gone by many names, from the Grease gun to the Carlo to the Swedish K. \
            Some designs are too good to change."
    icon = 'icons/obj/guns/projectile/luty.dmi'
    icon_state = "luty"
    item_state = "luty"

    w_class = ITEM_SIZE_NORMAL
    can_dual = TRUE
    caliber = CAL_PISTOL
    slot_flags = SLOT_BELT|SLOT_HOLSTER
    ammo_type = /obj/item/ammo_casing/pistol
    load_method = MAGAZINE
    mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL|MAG_WELL_SMG
    magazine_type = /obj/item/ammo_magazine/smg

    init_firemodes = list(
        FULL_AUTO_400,
        SEMI_AUTO_NODELAY,
        )

    can_dual = 1
    damage_multiplier = 0.7
    penetration_multiplier = 0.9
    recoil_buildup = 1
    one_hand_penalty = 5 //SMG level.
    spawn_blacklisted = TRUE

    origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
    matter = list(MATERIAL_STEEL = 15, MATERIAL_WOOD = 10)

/obj/item/gun/projectile/automatic/luty/on_update_icon()
    cut_overlays()
    icon_state = "[initial(icon_state)][safety ? "_safe" : ""]"
    if(ammo_magazine)
        add_overlays("mag[ammo_magazine.ammo_color]")

/obj/item/gun/projectile/automatic/luty/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/luty/toggle_safety()
    . = ..()
    update_icon()
