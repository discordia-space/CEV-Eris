/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/reagent_containers/food/drinks/bottle/gin = 5,/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/reagent_containers/food/drinks/bottle/tequilla = 5,/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/reagent_containers/food/drinks/bottle/wine = 5,/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,/obj/item/reagent_containers/food/drinks/bottle/small/beer = 6,
					/obj/item/reagent_containers/food/drinks/bottle/small/ale = 6,/obj/item/reagent_containers/food/drinks/bottle/orangejuice = 4,
					/obj/item/reagent_containers/food/drinks/bottle/tomatojuice = 4,/obj/item/reagent_containers/food/drinks/bottle/limejuice = 4,
					/obj/item/reagent_containers/food/drinks/bottle/cream = 4,/obj/item/reagent_containers/food/drinks/cans/tonic = 8,
					/obj/item/reagent_containers/food/drinks/bottle/cola = 5, /obj/item/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 5, /obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/reagent_containers/food/drinks/flask/barflask = 2, /obj/item/reagent_containers/food/drinks/flask/vacuumflask = 2,
					/obj/item/reagent_containers/food/drinks/drinkingglass = 30,/obj/item/reagent_containers/food/drinks/ice = 9,
					/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 2,/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 2,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe = 2,/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5)
	contraband = list(/obj/item/reagent_containers/food/drinks/tea/green = 10, /obj/item/reagent_containers/food/drinks/tea/black = 10)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this ship?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	auto_price = FALSE

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(/obj/item/reagent_containers/food/drinks/coffee = 25,/obj/item/reagent_containers/food/drinks/tea/black = 25,
					/obj/item/reagent_containers/food/drinks/tea/green = 25,/obj/item/reagent_containers/food/drinks/h_chocolate = 25)
	contraband = list(/obj/item/reagent_containers/food/drinks/ice = 10)
	prices = list(/obj/item/reagent_containers/food/drinks/coffee = 3, /obj/item/reagent_containers/food/drinks/tea/black = 3,
					/obj/item/reagent_containers/food/drinks/tea/green = 3, /obj/item/reagent_containers/food/drinks/h_chocolate = 3)
	vendor_department = DEPARTMENT_CIVILIAN

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(/obj/item/reagent_containers/food/snacks/candy = 6,/obj/item/reagent_containers/food/drinks/dry_ramen = 6,/obj/item/reagent_containers/food/snacks/chips =6,
					/obj/item/reagent_containers/food/snacks/sosjerky = 6,/obj/item/reagent_containers/food/snacks/no_raisin = 6,/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6, /obj/item/reagent_containers/food/snacks/tastybread = 6)
	contraband = list(/obj/item/reagent_containers/food/snacks/syndicake = 6)
	prices = list(/obj/item/reagent_containers/food/snacks/candy = 40,/obj/item/reagent_containers/food/drinks/dry_ramen = 45,/obj/item/reagent_containers/food/snacks/chips = 40,
					/obj/item/reagent_containers/food/snacks/sosjerky = 45,/obj/item/reagent_containers/food/snacks/no_raisin = 40,/obj/item/reagent_containers/food/snacks/spacetwinkie = 40,
					/obj/item/reagent_containers/food/snacks/cheesiehonkers = 40, /obj/item/reagent_containers/food/snacks/tastybread = 50,
					/obj/item/reagent_containers/food/snacks/syndicake = 60)
	vendor_department = DEPARTMENT_CIVILIAN

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not have some cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/reagent_containers/food/drinks/cans/cola = 10,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/reagent_containers/food/drinks/cans/grape_juice = 10)
	contraband = list(/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5, /obj/item/reagent_containers/food/snacks/liquidfood = 6)
	prices = list(/obj/item/reagent_containers/food/drinks/cans/cola = 30,/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 30,
					/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1000,/obj/item/reagent_containers/food/drinks/cans/starkist = 30,
					/obj/item/reagent_containers/food/drinks/cans/waterbottle = 32,/obj/item/reagent_containers/food/drinks/cans/space_up = 30,
					/obj/item/reagent_containers/food/drinks/cans/iced_tea = 30,/obj/item/reagent_containers/food/drinks/cans/grape_juice = 30,
					/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 50, /obj/item/reagent_containers/food/snacks/liquidfood = 60)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vendor_department = DEPARTMENT_CIVILIAN

/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs."
	vend_delay = 34
	icon_state = "cigs"
	products = list(/obj/item/storage/fancy/cigarettes = 10,
					/obj/item/storage/fancy/cigcartons = 5,
					/obj/item/clothing/mask/smokable/cigarette/cigar = 4,
					/obj/item/flame/lighter/zippo = 4,
					/obj/item/storage/box/matches = 10,
					/obj/item/flame/lighter/random = 4,
					/obj/item/storage/fancy/cigar = 5,
					/obj/item/storage/fancy/cigarettes/killthroat = 5,
					/obj/item/storage/fancy/cigcartons/killthroat = 3,
					/obj/item/storage/fancy/cigarettes/dromedaryco = 5,
					/obj/item/storage/fancy/cigcartons/dromedaryco = 3,
					/obj/item/clothing/mask/vape = 5,
					/obj/item/reagent_containers/glass/beaker/vial/vape/berry = 10,
					/obj/item/reagent_containers/glass/beaker/vial/vape/banana = 10,
					/obj/item/reagent_containers/glass/beaker/vial/vape/lemon = 10,
					/obj/item/reagent_containers/glass/beaker/vial/vape/nicotine = 5
				   )
	contraband = list(/obj/item/storage/fancy/cigarettes/homeless = 3,
					  /obj/item/storage/fancy/cigcartons/homeless = 1,
					)
	prices = list(/obj/item/clothing/mask/smokable/cigarette/cigar = 200,
				  /obj/item/storage/fancy/cigarettes = 100,
				  /obj/item/storage/fancy/cigcartons = 800,
				  /obj/item/storage/box/matches = 10,
				  /obj/item/flame/lighter/random = 5,
				  /obj/item/storage/fancy/cigar = 450,
				  /obj/item/storage/fancy/cigarettes/killthroat = 100,
				  /obj/item/storage/fancy/cigcartons/killthroat = 800,
				  /obj/item/storage/fancy/cigarettes/dromedaryco = 100,
				  /obj/item/storage/fancy/cigcartons/dromedaryco = 800,
				  /obj/item/flame/lighter/zippo = 250,
				  /obj/item/clothing/mask/vape = 300,
				  /obj/item/reagent_containers/glass/beaker/vial/vape/berry = 100,
				  /obj/item/reagent_containers/glass/beaker/vial/vape/banana = 100,
				  /obj/item/reagent_containers/glass/beaker/vial/vape/lemon = 100,
				  /obj/item/reagent_containers/glass/beaker/vial/vape/nicotine = 100,
				  /obj/item/storage/fancy/cigarettes/homeless = 300,
				  /obj/item/storage/fancy/cigcartons/homeless = 2400
				  )

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(/obj/item/tray = 8,/obj/item/material/kitchen/utensil/fork = 6, /obj/item/tool/knife = 6, /obj/item/material/kitchen/utensil/spoon = 6, /obj/item/tool/knife = 3,/obj/item/reagent_containers/food/drinks/drinkingglass = 8,/obj/item/clothing/suit/chef/classic = 2,/obj/item/storage/lunchbox = 3,/obj/item/storage/lunchbox/rainbow = 3,/obj/item/storage/lunchbox/cat = 3,
					/obj/item/reagent_containers/food/drinks/pitcher = 3,/obj/item/reagent_containers/food/drinks/teapot = 3,/obj/item/reagent_containers/food/drinks/mug = 3,/obj/item/reagent_containers/food/drinks/mug/black = 3,/obj/item/reagent_containers/food/drinks/mug/green = 3,/obj/item/reagent_containers/food/drinks/mug/blue = 3,
					/obj/item/reagent_containers/food/drinks/mug/red = 3,/obj/item/reagent_containers/food/drinks/mug/heart = 3,/obj/item/reagent_containers/food/drinks/mug/one = 3,/obj/item/reagent_containers/food/drinks/mug/metal = 3,
					/obj/item/reagent_containers/food/drinks/mug/rainbow = 3,/obj/item/reagent_containers/food/drinks/mug/brit = 3,/obj/item/reagent_containers/food/drinks/mug/moebius = 3,/obj/item/reagent_containers/food/drinks/mug/teacup = 10,)
	contraband = list(/obj/item/material/kitchen/rollingpin = 2, /obj/item/tool/knife/butch = 2)
	auto_price = FALSE

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine,how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_containers/food/drinks/drinkingglass/soda = 30)
	contraband = list(/obj/item/reagent_containers/food/drinks/drinkingglass/cola = 20)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	auto_price = FALSE
