datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/randomize_appearance_for(var/mob/living/carbon/human/H)
		gender = pick(MALE, FEMALE)
		var/datum/species/current_species = all_species[species]

		if(current_species)
			if(current_species.appearance_flags & HAS_SKIN_TONE)
				s_tone = random_skin_tone()
			if(current_species.appearance_flags & HAS_EYE_COLOR)
				randomize_eyes_color()
			if(current_species.appearance_flags & HAS_SKIN_COLOR)
				randomize_skin_color()

		h_style = random_hair_style(gender, species)
		f_style = random_facial_hair_style(gender, species)
		randomize_hair_color("hair")
		randomize_hair_color("facial")

		backbag = 2
		age = rand(current_species.min_age, current_species.max_age)
		if(H)
			copy_to(H,1)


	proc/randomize_hair_color(var/target = "hair")
		if(prob (75) && target == "facial") // Chance to inherit hair color
			r_facial = r_hair
			g_facial = g_hair
			b_facial = b_hair
			return

		var/red
		var/green
		var/blue

		var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
		switch(col)
			if("blonde")
				red = 255
				green = 255
				blue = 0
			if("black")
				red = 0
				green = 0
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 51
			if("copper")
				red = 255
				green = 153
				blue = 0
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("wheat")
				red = 255
				green = 255
				blue = 153
			if("old")
				red = rand (100, 255)
				green = red
				blue = red
			if("punk")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		switch(target)
			if("hair")
				r_hair = red
				g_hair = green
				b_hair = blue
			if("facial")
				r_facial = red
				g_facial = green
				b_facial = blue

	proc/randomize_eyes_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_eyes = red
		g_eyes = green
		b_eyes = blue

	proc/randomize_skin_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_skin = red
		g_skin = green
		b_skin = blue


	proc/update_preview_icon()		//seriously. This is horrendous.
		qdel(preview_icon_front)
		qdel(preview_icon_side)
		qdel(preview_icon)

		var/g = "_m"
		if(gender == FEMALE)	g = "_f"

		var/datum/body_build/body = get_body_build(gender, body_build)



		var/icon/icobase
		var/datum/species/current_species = all_species[species]

		if(current_species)
			icobase = current_species.icobase
		else
			icobase = 'icons/mob/human_races/r_human.dmi'

		preview_icon = new /icon(icobase, "torso[g][body.index]")
		preview_icon.Blend(new /icon(icobase, "groin[g][body.index]"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "head[g][body.index]"), ICON_OVERLAY)

		for(var/name in list("r_arm","r_hand","r_leg","r_foot","l_leg","l_foot","l_arm","l_hand"))
			if(organ_data[name] == "amputated") continue
			if(organ_data[name] == "cyborg")
				var/datum/robolimb/R
				if(rlimb_data[name]) R = all_robolimbs[rlimb_data[name]]
				if(!R) R = basic_robolimb
				preview_icon.Blend(icon(R.icon, "[name][g][body.index]"), ICON_OVERLAY) // This doesn't check gendered_icon. Not an issue while only limbs can be robotic.
				continue
			preview_icon.Blend(new /icon(icobase, "[name][g][body.index]"), ICON_OVERLAY)

		//Tail
		if(current_species && (current_species.tail))
			var/icon/temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[current_species.tail]_s")
			preview_icon.Blend(temp, ICON_OVERLAY)

		// Skin color
		if(current_species && (current_species.appearance_flags & HAS_SKIN_COLOR))
			preview_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)

		// Skin tone
		if(current_species && (current_species.appearance_flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				preview_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				preview_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)

		var/icon/eyes = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
		if ((current_species && (current_species.appearance_flags & HAS_EYE_COLOR)))
			eyes.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			hair.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			eyes.Blend(hair, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			eyes.Blend(facial, ICON_OVERLAY)

		var/icon/clothes = null
		if(job_civilian_low & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes = new /icon('icons/mob/uniform.dmi', "grey_s")
			clothes.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else
			var/datum/job/J = job_master.GetJob(high_job_title)
			if(J)

				var/obj/item/clothing/under/UF = J.uniform
				var/UF_state = initial(UF.icon_state)
				if(!UF_state) UF_state = initial(UF.item_state)
				clothes = new /icon(body.uniform_icon, UF_state)

				var/obj/item/clothing/shoes/SH = J.shoes
				clothes.Blend(new /icon(body.shoes_icon, initial(SH.icon_state)), ICON_UNDERLAY)

				var/obj/item/clothing/gloves/GL = J.gloves
				if(GL)
					var/GL_state = initial(GL.item_state)
					if(!GL_state) GL_state = initial(GL.icon_state)
					clothes.Blend(new /icon(body.gloves_icon, ), ICON_UNDERLAY)
				var/obj/item/weapon/storage/belt/BT = J.belt
				if(BT)
					var/BT_state = initial(BT.item_state)
					if(!BT_state) BT_state = initial(BT.icon_state)
					clothes.Blend(new /icon(body.belt_icon, BT_state), ICON_OVERLAY)


				var/obj/item/clothing/suit/ST = J.suit
				if(ST) clothes.Blend(new /icon(body.suit_icon, initial(ST.icon_state)), ICON_OVERLAY)

				var/obj/item/clothing/head/HT = J.hat
				if(HT) clothes.Blend(new /icon(body.hat_icon, initial(HT.icon_state)), ICON_OVERLAY)

				if( backbag > 1 )
					var/obj/item/weapon/storage/backpack/BP = J.backpacks[backbag-1]
					clothes.Blend(new /icon(body.backpack_icon, initial(BP.icon_state)), ICON_OVERLAY)


		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon('icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes, ICON_OVERLAY)
		if(current_species.appearance_flags & HAS_UNDERWEAR)
			for(var/underwear_category_name in all_underwear)
				var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
				if(underwear_category)
					var/underwear_item_name = all_underwear[underwear_category_name]
					var/datum/category_item/underwear/underwear_item = underwear_category.items_by_name[underwear_item_name]
					if(underwear_item.icon_state)
						preview_icon.Blend(icon(body.underwear_icon, underwear_item.icon_state), ICON_OVERLAY)
				else
					all_underwear -= underwear_category_name

		if(clothes)
			preview_icon.Blend(clothes, ICON_OVERLAY)

		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)

		qdel(eyes)
		qdel(clothes)
