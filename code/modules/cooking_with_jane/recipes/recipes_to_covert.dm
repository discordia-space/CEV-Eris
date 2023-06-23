

/datum/recipe/dumplings
	fruit = list("cabbage" = 1) // A recipe that ACTUALLY uses cabbage.
	reagents = list("soysauce" = 5, "sodiumchloride" = 1, "blackpepper" = 1, "cornoil" = 1) // No sesame oil, corn will have to do.
	items = list(
		/obj/item/reagent_containers/food/snacks/rawbacon,
		/obj/item/reagent_containers/food/snacks/rawbacon, // Substitute for minced pork.
		/obj/item/reagent_containers/food/snacks/doughslice,
	)
	result = /obj/item/reagent_containers/food/snacks/dumplings

/datum/recipe/humanburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger

/datum/recipe/plainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/patty, // Should no longer conflict with every other quirky burger recipe. - Seb
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/recipe/syntiburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/recipe/brainburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger

/datum/recipe/roburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger

/datum/recipe/xenoburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger

/datum/recipe/fishburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/carp
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger

/datum/recipe/tofuburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/recipe/clownburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/costume/job/clown
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger

/datum/recipe/mimeburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger

/datum/recipe/muffinegg
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/friedegg,
		/obj/item/reagent_containers/food/snacks/bacon,
	)
	result = /obj/item/reagent_containers/food/snacks/muffinegg

/datum/recipe/baconburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/patty,
		/obj/item/reagent_containers/food/snacks/bacon,
	)
	result = /obj/item/reagent_containers/food/snacks/baconburger

/datum/recipe/chickenburger
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/friedchikin,
	)
	result = /obj/item/reagent_containers/food/snacks/chickenburger

/datum/recipe/kampferburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/kampferburger

/datum/recipe/panzerburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/panzerburger

/datum/recipe/jagerburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jagerburger

/datum/recipe/seucheburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/seucheburger

/datum/recipe/bigroachburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager,
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/bigroachburger

/datum/recipe/fuhrerburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer,
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/fuhrerburger

/datum/recipe/kaiserburger
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser,
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/kaiserburger

/datum/recipe/hotdog
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/datum/recipe/donkpocket
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meatball
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL
	proc/warm_up(var/obj/item/reagent_containers/food/snacks/donkpocket/being_cooked)
		being_cooked.heat()
	make_food(var/obj/container as obj)
		var/obj/item/reagent_containers/food/snacks/donkpocket/being_cooked = ..(container)
		warm_up(being_cooked)
		return being_cooked

/datum/recipe/donkpocket/warm
	reagents = list() //This is necessary since this is a child object of the above recipe and we don't want donk pockets to need flour
	items = list(
		/obj/item/reagent_containers/food/snacks/donkpocket
	)
	result = /obj/item/reagent_containers/food/snacks/donkpocket //SPECIAL
	make_food(var/obj/container as obj)
		var/obj/item/reagent_containers/food/snacks/donkpocket/being_cooked = locate() in container
		if(being_cooked && !being_cooked.warm)
			warm_up(being_cooked)
		return being_cooked

/datum/recipe/meatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/syntibread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/xenomeatbread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/xenomeat,
		/obj/item/reagent_containers/food/snacks/meat/xenomeat,
		/obj/item/reagent_containers/food/snacks/meat/xenomeat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread

/datum/recipe/bananabread
	fruit = list("banana" = 1)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

/datum/recipe/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/reagent_containers/food/snacks/muffin

/datum/recipe/eggplantparm
	fruit = list("eggplant" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/reagent_containers/food/snacks/eggplantparm

/datum/recipe/soylenviridians
	fruit = list("soybeans" = 1)
	reagents = list("flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/soylenviridians

/datum/recipe/soylentgreen
	reagents = list("flour" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human
	)
	result = /obj/item/reagent_containers/food/snacks/soylentgreen

/datum/recipe/meatpie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/reagent_containers/food/snacks/meatpie

/datum/recipe/tofupie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/reagent_containers/food/snacks/tofupie

/datum/recipe/xemeatpie
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat/xenomeat,
	)
	result = /obj/item/reagent_containers/food/snacks/xemeatpie

/datum/recipe/pie
	fruit = list("banana" = 1)
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/butterslice,
		)
	result = /obj/item/reagent_containers/food/snacks/pie

/datum/recipe/cherrypie
	fruit = list("cherries" = 1)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/cherrypie

/datum/recipe/berryclafoutis
	fruit = list("berries" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/berryclafoutis

/datum/recipe/wingfangchu
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/xenomeat,
	)
	result = /obj/item/reagent_containers/food/snacks/wingfangchu

/datum/recipe/chaosdonut
	reagents = list("frostoil" = 5, "capsaicin" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough
	)
	result = /obj/item/reagent_containers/food/snacks/donut/chaos

/datum/recipe/humankabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human,
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob

/datum/recipe/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/monkey,
		/obj/item/reagent_containers/food/snacks/meat/monkey,
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/recipe/syntikabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/recipe/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob

/datum/recipe/tofubread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/tofubread

/datum/recipe/loadedbakedpotato
	fruit = list("potato" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/cheesyfries
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/cheesyfries

/datum/recipe/cubancarp
	fruit = list("chili" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat/carp
	)
	result = /obj/item/reagent_containers/food/snacks/cubancarp

/datum/recipe/popcorn
	reagents = list("cornoil" = 2)
	fruit = list("corn" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/butterslice)
	result = /obj/item/reagent_containers/food/snacks/popcorn

/datum/recipe/cookie
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/chocolatebar,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/cookie

/datum/recipe/fortunecookie
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/doughslice,
		/obj/item/paper,
	)
	result = /obj/item/reagent_containers/food/snacks/fortunecookie
	make_food(var/obj/container as obj)
		var/obj/item/paper/paper = locate() in container
		paper.loc = null //prevent deletion
		var/obj/item/reagent_containers/food/snacks/fortunecookie/being_cooked = ..(container)
		paper.loc = being_cooked
		being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
		return being_cooked
	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			var/obj/item/paper/paper = locate() in container
			if (!paper || !paper.info)
				return 0
		return .


/datum/recipe/friedchicken
	reagents = list("cornoil" = 5, "sodiumchloride" = 1, "blackpepper" = 1, "flour" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/chickenbreast)
	result = /obj/item/reagent_containers/food/snacks/friedchikin

/datum/recipe/patty
	items = list(/obj/item/reagent_containers/food/snacks/patty_raw)
	result = /obj/item/reagent_containers/food/snacks/patty

/datum/recipe/syntisteak
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/tonkatsu
	reagents = list("sodiumchloride" = 1, "flour" = 5, "egg" = 3, "cornoil" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/pork,
	)
	result = /obj/item/reagent_containers/food/snacks/tonkatsu

/datum/recipe/pizzamargherita
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/meatpizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/syntipizza
	fruit = list("tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/vegetablepizza
	fruit = list("eggplant" = 1, "carrot" = 1, "corn" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/hawaiianpizza
	fruit = list("pineapples" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pizza/hawaiianpizza

/datum/recipe/spacylibertyduff
	reagents = list("water" = 5, "vodka" = 5, "psilocybin" = 5)
	result = /obj/item/reagent_containers/food/snacks/spacylibertyduff

/datum/recipe/amanitajelly
	reagents = list("water" = 5, "vodka" = 5, "amatoxin" = 5)
	result = /obj/item/reagent_containers/food/snacks/amanitajelly
	make_food(var/obj/container as obj)
		var/obj/item/reagent_containers/food/snacks/amanitajelly/being_cooked = ..(container)
		being_cooked.reagents.del_reagent("amatoxin")
		return being_cooked

/datum/recipe/candy_corn
	reagents = list("sugar" = 5, "cornoil" = 5)
	result= /obj/item/reagent_containers/food/snacks/candy_corn

/datum/recipe/amanita_pie
	reagents = list("amatoxin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/amanita_pie

/datum/recipe/plump_pie
	fruit = list("plumphelmet" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/reagent_containers/food/snacks/plump_pie

/datum/recipe/bigbiteburger
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/reagent_containers/food/snacks/patty,
		/obj/item/reagent_containers/food/snacks/patty,
		/obj/item/reagent_containers/food/snacks/friedegg,
	)
	result = /obj/item/reagent_containers/food/snacks/bigbiteburger

/datum/recipe/enchiladas
	fruit = list("chili" = 2, "corn" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/cutlet)
	result = /obj/item/reagent_containers/food/snacks/enchiladas

/datum/recipe/creamcheesebread
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread

/datum/recipe/monkeysdelight
	fruit = list("banana" = 1)
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1, "flour" = 10)
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeycube
	)
	result = /obj/item/reagent_containers/food/snacks/monkeysdelight

/datum/recipe/fishandchips
	items = list(
		/obj/item/reagent_containers/food/snacks/fries,
		/obj/item/reagent_containers/food/snacks/fishfingers,
	)
	result = /obj/item/reagent_containers/food/snacks/fishandchips

/datum/recipe/sashimi // Ironically, this doesn't get cooked since it's raw fish
	reagents = list("soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/carp,
		/obj/item/reagent_containers/food/snacks/meat/carp,
	)
	result = /obj/item/reagent_containers/food/snacks/sashimi


/datum/recipe/sandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/meatsteak,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/sandwich

/datum/recipe/toastedsandwich
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/grilledcheese
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/datum/recipe/blt
	fruit = list("cabbage" = 1, "tomato" = 1) // As close as lettuce as it gets...
	items = list(
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/breadslice,
		/obj/item/reagent_containers/food/snacks/bacon,
	)
	result = /obj/item/reagent_containers/food/snacks/blt

/datum/recipe/stewedsoymeat
	fruit = list("carrot" = 1, "tomato" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/soydope,
		/obj/item/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/reagent_containers/food/snacks/stewedsoymeat

/datum/recipe/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/boiledrice

/datum/recipe/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/reagent_containers/food/snacks/ricepudding

/datum/recipe/beefcurry
	fruit = list("chili" = 1, "carrot" = 1, "tomato" = 1)
	reagents = list("flour" = 5, "soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/boiledrice,
	)
	result = /obj/item/reagent_containers/food/snacks/beefcurry

/datum/recipe/chickencurry
	fruit = list("chili" = 1, "carrot" = 1, "tomato" = 1)
	reagents = list("flour" = 5, "soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenbreast,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/boiledrice,
	)
	result = /obj/item/reagent_containers/food/snacks/chickencurry

/datum/recipe/mashpotato
	reagents = list("milk" = 5)
	fruit = list("potato" = 2)
	items = list(/obj/item/reagent_containers/food/snacks/butterslice)
	result = /obj/item/reagent_containers/food/snacks/mashpotatoes

/datum/recipe/katsudon
	reagents = list("egg" = 3, "soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/boiledrice,
		/obj/item/reagent_containers/food/snacks/tonkatsu,
		)
	result = /obj/item/reagent_containers/food/snacks/katsudon

/datum/recipe/poppypretzel
	fruit = list("poppy" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/dough)
	result = /obj/item/reagent_containers/food/snacks/poppypretzel

/datum/recipe/superbiteburger
	fruit = list("tomato" = 1)
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/patty,
		/obj/item/reagent_containers/food/snacks/patty,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/bacon,
	)
	result = /obj/item/reagent_containers/food/snacks/superbiteburger

/datum/recipe/applepie
	fruit = list("apple" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/applepie

/datum/recipe/slimeburger
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/slime

/datum/recipe/jellyburger
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/cherry

/datum/recipe/sausage
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawmeatball,
		/obj/item/reagent_containers/food/snacks/rawbacon,
	)
	result = /obj/item/reagent_containers/food/snacks/sausage

/datum/recipe/fishfingers
	reagents = list("flour" = 5, "egg" = 3, "cornoil" = 2)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/carp,
	)
	result = /obj/item/reagent_containers/food/snacks/fishfingers

/datum/recipe/pumpkinpie
	fruit = list("pumpkin" = 1)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie

/datum/recipe/plumphelmetbiscuit
	fruit = list("plumphelmet" = 1)
	reagents = list("water" = 5, "flour" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/butterslice)
	result = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit

/datum/recipe/chawanmushi
	fruit = list("mushroom" = 1)
	reagents = list("water" = 5, "soysauce" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/egg
	)
	result = /obj/item/reagent_containers/food/snacks/chawanmushi

/datum/recipe/appletart
	fruit = list("goldapple" = 1)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10, "egg" = 3)
	items = list(/obj/item/reagent_containers/food/snacks/butterslice)
	result = /obj/item/reagent_containers/food/snacks/appletart


/datum/recipe/tofurkey
	items = list(
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/stuffing,
	)
	result = /obj/item/reagent_containers/food/snacks/tofurkey

/datum/recipe/honey_bun
	reagents = list("sugar" = 3, "honey" = 5, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/butterslice,
	)
	result = /obj/item/reagent_containers/food/snacks/honeybuns

/datum/recipe/honey_pudding
	reagents = list("sugar" = 3, "honey" = 15, "cream" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/reagent_containers/food/snacks/honeypudding

// Fuck Science!
/datum/recipe/ruinedvirusdish
	items = list(
		/obj/item/virusdish
	)
	result = /obj/item/ruinedvirusdish

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/taco
	reagents = list("flour" = 5)
	fruit = list("corn" = 1, "cabbage" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cutlet,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/reagent_containers/food/snacks/taco

/datum/recipe/fries
	reagents = list("cornoil" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/reagent_containers/food/snacks/fries

/datum/recipe/mint
	reagents = list("sugar" = 5, "frostoil" = 5)
	result = /obj/item/reagent_containers/food/snacks/mint



//Roach cubes

/datum/recipe/cube/
	fruit = list("potato" = 1)
	reagents = list("protein" = 15, "egg" = 3)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat)
	result = /obj/item/reagent_containers/food/snacks/cube/roach

/datum/recipe/cube/fuhrer
	fruit = list("potato" = 2)
	reagents = list("protein" = 25, "fuhrerole" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer,
	)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/fuhrer

/datum/recipe/cube/jager
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, "blattedin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat/jager)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/jager

/datum/recipe/cube/kraftwerk
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, "gewaltine" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat/kraftwerk)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/kraftwerk

/datum/recipe/cube/elektromagnetisch
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, "iron" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat/elektromagnetisch)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/elektromagnetisch

/datum/recipe/cube/glowing
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, MATERIAL_URANIUM = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat/glowing)
	result = /obj/item/reagent_containers/food/snacks/meat/roachmeat/glowing

/datum/recipe/cube/roachling
	fruit = list("potato" = 1)
	reagents = list("protein" = 5, "seligitillin" = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/roachling

/datum/recipe/cube/seuche
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, "diplopterum" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/seuche

/datum/recipe/cube/panzer
	fruit = list("potato" = 1)
	reagents = list("protein" = 20, "starkellin" = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer,
		/obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer,
	)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/panzer

/datum/recipe/cube/gestrahlte
	fruit = list("potato" = 1)
	reagents = list("protein" = 10, "toxin" = 5)
	items = list(/obj/item/reagent_containers/food/snacks/meat/roachmeat)
	result = /obj/item/reagent_containers/food/snacks/cube/roach/grestrahlte
