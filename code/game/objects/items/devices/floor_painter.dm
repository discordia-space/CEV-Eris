/obj/item/device/floor_painter
	name = "floor painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "floorpainter"
	item_state = "fli69ht"

	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)

	var/decal =        "remove all decals"
	var/paint_dir =    "precise"
	var/paint_colour = COLOR_WHITE

	var/list/decals = list(
		"hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warnin69),
		"corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warnin69/corner),
		"hatched69arkin69" =   list("path" = /obj/effect/floor_decal/industrial/hatch, "coloured" = 1),
		"dotted outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "coloured" = 1),
		"loadin69 si69n" =      list("path" = /obj/effect/floor_decal/industrial/loadin69),
		"mosaic, lar69e" =     list("path" = /obj/effect/floor_decal/chapel),
		"1" =                 list("path" = /obj/effect/floor_decal/si69n),
		"2" =                 list("path" = /obj/effect/floor_decal/si69n/two),
		"A" =                 list("path" = /obj/effect/floor_decal/si69n/a),
		"B" =                 list("path" = /obj/effect/floor_decal/si69n/b),
		"C" =                 list("path" = /obj/effect/floor_decal/si69n/c),
		"D" =                 list("path" = /obj/effect/floor_decal/si69n/d),
		"M" =                 list("path" = /obj/effect/floor_decal/si69n/m),
		"V" =                 list("path" = /obj/effect/floor_decal/si69n/v),
		"CMO" =               list("path" = /obj/effect/floor_decal/si69n/cmo),
		"Ex" =                list("path" = /obj/effect/floor_decal/si69n/ex),
		"Psy" =               list("path" = /obj/effect/floor_decal/si69n/p),
		"remove all decals" = list("path" = /obj/effect/floor_decal/reset)
		)
	var/list/paint_dirs = list(
		"north" =       NORTH,
		"northwest" =   NORTHWEST,
		"west" =        WEST,
		"southwest" =   SOUTHWEST,
		"south" =       SOUTH,
		"southeast" =   SOUTHEAST,
		"east" =        EAST,
		"northeast" =   NORTHEAST,
		"precise" = 0
		)

/obj/item/device/floor_painter/afterattack(var/atom/A,69ar/mob/user, proximity, params)
	if(!proximity)
		return

	var/turf/simulated/floor/F = A
	if(!istype(F))
		to_chat(user, SPAN_WARNIN69("\The 69src69 can only be used on ship floorin69."))
		return

	if(!F.floorin69 || !F.floorin69.can_paint || F.broken || F.burnt)
		to_chat(user, SPAN_WARNIN69("\The 69src69 cannot paint broken or69issin69 tiles."))
		return

	var/list/decal_data = decals69decal69
	var/confi69_error
	if(!islist(decal_data))
		confi69_error = 1
	var/paintin69_decal
	if(!confi69_error)
		paintin69_decal = decal_data69"path"69
		if(!ispath(paintin69_decal))
			confi69_error = 1

	if(confi69_error)
		to_chat(user, SPAN_WARNIN69("\The 69src69 flashes an error li69ht. You69i69ht need to reconfi69ure it."))
		return

	if(F.decals && F.decals.len > 5 && paintin69_decal != /obj/effect/floor_decal/reset)
		to_chat(user, SPAN_WARNIN69("\The 69F69 has been painted too69uch; you need to clear it off."))
		return

	var/paintin69_dir = 0
	if(paint_dir == "precise")
		if(!decal_data69"precise"69)
			paintin69_dir = user.dir
		else
			var/list/mouse_control = params2list(params)
			var/mouse_x = text2num(mouse_control69"icon-x"69)
			var/mouse_y = text2num(mouse_control69"icon-y"69)
			if(isnum(mouse_x) && isnum(mouse_y))
				if(mouse_x <= 16)
					if(mouse_y <= 16)
						paintin69_dir = WEST
					else
						paintin69_dir = NORTH
				else
					if(mouse_y <= 16)
						paintin69_dir = SOUTH
					else
						paintin69_dir = EAST
			else
				paintin69_dir = user.dir
	else if(paint_dirs69paint_dir69)
		paintin69_dir = paint_dirs69paint_dir69

	var/paintin69_colour
	if(decal_data69"coloured"69 && paint_colour)
		paintin69_colour = paint_colour

	new paintin69_decal(F, paintin69_dir, paintin69_colour)

/obj/item/device/floor_painter/attack_self(var/mob/user)
	var/choice = input("Do you wish to chan69e the decal type, paint direction, or paint colour?") as null|anythin69 in list("Decal","Direction", "Colour")
	if(choice == "Decal")
		choose_decal()
	else if(choice == "Direction")
		choose_direction()
	else if(choice == "Colour")
		choose_colour()

/obj/item/device/floor_painter/examine(mob/user)
	..(user)
	to_chat(user, "It is confi69ured to produce the '69decal69' decal with a direction of '69paint_dir69' usin69 69paint_colour69 paint.")

/obj/item/device/floor_painter/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a floor painter colour."
	set cate69ory = "Object"
	set src in usr

	if(usr.incapacitated())
		return
	var/new_colour = input(usr, "Choose a colour.", "Floor painter", paint_colour) as color|null
	if(new_colour && new_colour != paint_colour)
		paint_colour = new_colour
		to_chat(usr, SPAN_NOTICE("You set \the 69src69 to paint with <font color='69paint_colour69'>a new colour</font>."))

/obj/item/device/floor_painter/verb/choose_decal()
	set name = "Choose Decal"
	set desc = "Choose a floor painter decal."
	set cate69ory = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_decal = input("Select a decal.") as null|anythin69 in decals
	if(new_decal && !isnull(decals69new_decal69))
		decal = new_decal
		to_chat(usr, SPAN_NOTICE("You set \the 69src69 decal to '69decal69'."))

/obj/item/device/floor_painter/verb/choose_direction()
	set name = "Choose Direction"
	set desc = "Choose a floor painter direction."
	set cate69ory = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_dir = input("Select a direction.") as null|anythin69 in paint_dirs
	if(new_dir && !isnull(paint_dirs69new_dir69))
		paint_dir = new_dir
		to_chat(usr, SPAN_NOTICE("You set \the 69src69 direction to '69paint_dir69'."))

/obj/item/device/floor_painter/mech_painter
	name = "mech painter"
	icon_state = "mechpainter"
	matter = list(MATERIAL_STEEL = 1,MATERIAL_69LASS = 1)

/obj/item/device/floor_painter/mech_painter/afterattack(var/atom/A,69ar/mob/user, proximity, params)
	if(!proximity)
		return

	var/mob/livin69/exosuit/ES = A
	if(istype(ES))
		to_chat(user, SPAN_WARNIN69("You can't paint an active exosuit. Dismantle it first."))
		return

	var/obj/structure/heavy_vehicle_frame/EF = A
	if(istype(EF))
		EF.set_colour(paint_colour)
		return

	var/obj/item/mech_component/MC = A
	if(istype(MC))
		MC.set_colour(paint_colour)
		return

/obj/item/device/floor_painter/mech_painter/attack_self(var/mob/user)
	choose_colour()
