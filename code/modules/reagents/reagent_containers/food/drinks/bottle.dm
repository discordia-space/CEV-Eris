///////////////////////////////////////////////Alcohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles69ow weaken and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until uni69ue ones are69ade.
	force = 5
	rarity_value = 14
	bad_type = /obj/item/reagent_containers/food/drinks/bottle
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is69ade of glass or69ot so that69ilk cartons dont shatter when someone gets hit by it

	var/obj/item/reagent_containers/glass/rag/rag
	var/rag_underlay = "rag"
	var/icon_state_full
	var/icon_state_empty

/obj/item/reagent_containers/food/drinks/bottle/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/Initialize()
	icon_state_full = "69icon_state69"
	icon_state_empty = "69icon_state69_empty"
	. = ..()
	if(isGlass)
		unacidable = TRUE


/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
	rag =69ull
	return ..()

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, speed)
	..()

	var/mob/M = thrower
	if(isGlass && istype(M) &&69.a_intent == I_HURT)
		var/throw_dist = get_dist(throw_source, loc)
		if(speed >= throw_speed && smash_check(throw_dist)) //not as reliable as smashing directly
			if(reagents)
				hit_atom.visible_message(SPAN_NOTICE("The contents of \the 69src69 splash all over 69hit_atom69!"))
				reagents.splash(hit_atom, reagents.total_volume)
			src.smash(loc, hit_atom)

/obj/item/reagent_containers/food/drinks/bottle/proc/smash_check(distance)
	if(!isGlass || !smash_duration)
		return 0

	var/list/chance_table = list(90, 90, 85, 85, 60, 35, 15) //starting from distance 0
	var/idx =69ax(distance + 1, 1) //since list indices start at 1
	if(idx > chance_table.len)
		return 0
	return prob(chance_table69idx69)

/obj/item/reagent_containers/food/drinks/bottle/proc/smash(newloc, atom/against)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)

	//Creates a shattering69oise and replaces the bottle with a broken_bottle
	var/obj/item/tool/broken_bottle/B =69ew /obj/item/tool/broken_bottle(newloc)
	if(prob(33))
		new/obj/item/material/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state

	var/icon/I =69ew('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src,'sound/effects/GLASS_Rattle_Many_Fragments_01_stereo.ogg',100,1)
	src.transfer_fingerprints_to(B)

	69del(src)
	return B

/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/W,69ob/user)
	if(!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if(rag && istype(W, /obj/item/flame))
		rag.attackby(W, user)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user)
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/reagent_containers/food/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R,69ob/user)
	if(!isGlass || rag) return
	if(user.unE69uip(R))
		to_chat(user, SPAN_NOTICE("You stuff 69R69 into 69src69."))
		rag = R
		rag.forceMove(src)
		reagent_flags &= ~OPENCONTAINER
		verbs -= /obj/item/reagent_containers/food/drinks/proc/gulp_whole
		update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag) return
	user.put_in_hands(rag)
	rag =69ull
	var/was_open_container = initial(reagent_flags) & OPENCONTAINER
	if(was_open_container)
		reagent_flags |= OPENCONTAINER
		verbs += /obj/item/reagent_containers/food/drinks/proc/gulp_whole
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag) return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "69rag_underlay69_lit" : rag_underlay)
		underlays += underlay_image
		set_light(2)
	else
		set_light(0)
		if(reagents && reagents.total_volume)
			icon_state = icon_state_full
		else
			icon_state = icon_state_empty

/obj/item/reagent_containers/food/drinks/bottle/apply_hit_effect(mob/living/target,69ob/living/user,69ar/hit_zone)
	..()

	if(user.a_intent != I_HURT)
		return
	if(!smash_check(1))
		return //won't always break on the first hit

	// You are going to knock someone out for longer if they are69ot wearing a helmet.
	var/weaken_duration = smash_duration +69in(0, force - target.getarmor(hit_zone, ARMOR_MELEE) + 10)

	var/mob/living/carbon/human/H = target
	if(istype(H) && H.headcheck(hit_zone))
		var/obj/item/organ/affecting = H.get_organ(hit_zone) //headcheck should ensure that affecting is69ot69ull
		user.visible_message(SPAN_DANGER("69user69 smashes 69src69 into 69H69's 69affecting.name69!"))
		if(weaken_duration)
			target.apply_effect(min(weaken_duration, 5), WEAKEN, armor_value = target.getarmor(hit_zone, ARMOR_MELEE)) //69ever weaken69ore than a flash!
	else
		user.visible_message(SPAN_DANGER("\The 69user69 smashes 69src69 into 69target69!"))

	//The reagents in the bottle splash all over the target, thanks for the idea69odrak
	if(reagents)
		user.visible_message(SPAN_NOTICE("The contents of \the 69src69 splash all over 69target69!"))
		reagents.splash(target, reagents.total_volume)

	//Finally, smash the bottle. This kills (69del) the bottle.
	var/obj/item/tool/broken_bottle/B = smash(target.loc, target)
	user.put_in_active_hand(B)

//// Precreated bottles ////

/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high 69uality gin, produced in the69ew London Space Station."
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("gin" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently69atured inside the tunnels of a69uclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=3)
	preloaded_reagents = list("whiskey" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah,69odka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("vodka" = 100)
	spawn_tags = SPAWN_TAG_BOOZE
	rarity_value = 7

/obj/item/reagent_containers/food/drinks/bottle/te69uilla
	name = "Caccavo Guaranteed 69uality Te69uilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine 69uality ingredients!"
	icon_state = "te69uillabottle"
	center_of_mass = list("x"=16, "y"=3)
	preloaded_reagents = list("te69uilla" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "Bottle of69othing"
	desc = "A bottle filled with69othing"
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=17, "y"=5)
	preloaded_reagents = list("nothing" = 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced te69uilla, served in space69ight clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("patron" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh69o. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=8)
	preloaded_reagents = list("rum" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye69ermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("vermouth" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Li69ueur"
	desc = "A widely known,69exican coffee-flavoured li69ueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	center_of_mass = list("x"=17, "y"=3)
	preloaded_reagents = list("kahlua" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=15, "y"=3)
	preloaded_reagents = list("goldschlager" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alcoholic drink,69ade after69umerous distillations and years of69aturing. You69ight as well69ot scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("cognac" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("wine" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/ntcahors
	name = "NeoTheology Cahors Wine"
	desc = "Ritual drink that cleanses the soul and body."
	icon_state = "ntcahors"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("ntcahors" = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker69erte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("absinthe" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/melonli69uor
	name = "Emeraldine69elon Li69uor"
	desc = "A bottle of 46 proof Emeraldine69elon Li69uor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("melonli69uor" = 100)
	icon_state_empty = "alco-clear"
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does69ot allow the imbiber to use the fifth69agic."
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("bluecuracao" = 100)
	icon_state_empty = "alco-clear"
	spawn_tags = SPAWN_TAG_BOOZE

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("grenadine" = 100)
	icon_state_empty = "grenadinebottle"

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "\improper Space Cola"
	desc = "Cola. in space"
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("cola" = 100)

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your69outh."
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("space_up" = 100)

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Space69ountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)
	preloaded_reagents = list("spacemountainwind" = 100)

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Warlock's69elvet"
	desc = "What a delightful packaging for a surely high 69uality wine! The69intage69ust be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	preloaded_reagents = list("pwine" = 100)
	spawn_tags = SPAWN_TAG_BOOZE

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of69itamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=7)
	isGlass = 0
	preloaded_reagents = list("orangejuice" = 100)

/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream.69ade from69ilk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("cream" = 100)

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("tomatojuice" = 100)

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=8)
	isGlass = 0
	preloaded_reagents = list("limejuice" = 100)

//Small bottles
/obj/item/reagent_containers/food/drinks/bottle/small
	volume = 50
	smash_duration = 1
	flags = 0 //starts closed
	rag_underlay = "rag_small"
	bad_type = /obj/item/reagent_containers/food/drinks/bottle/small

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water,69alt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=12)
	preloaded_reagents = list("beer" = 30)
	spawn_tags = SPAWN_TAG_BOOZE
	rarity_value = 2

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper69agm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=10)
	preloaded_reagents = list("ale" = 30)
	spawn_tags = SPAWN_TAG_BOOZE
