/*********************MANUALS (BOOKS)***********************/

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = TRUE   // FALSE - Normal book, TRUE - Should not be treated as normal book, unable to be copied, unable to be modified


/obj/item/book/manual/chef_recipes
	name = "Bradhaanata Cooking Guide"
	icon_state = "cooked_book"
	author = "Jordan Damnsey"
	title = "Bradhaanata cooking guide"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food ingredients and how to not set the stove on fire. For actual recipes, please see the Bradhaanata Cooking Assistant App.

				<h2>Basics</h2>
				<li>The appliances focus entirely around the cooking containers, such as the Pan, Cutting Board, Pot, Oven Tray, ect. You'll be starting with adding your ingredients to the container, and ending by scooping everything out.</li>
				<li>The Prep Bowl cooking container is different than the Mixing Bowl.</li>
				<li>Any steps except the first and last can be done in any order, with the exception of Exclusive Optional Steps.</li>
				<li>Scooping ingredients out before the recipe is done, leaving excess reagents in the container, having the wrong heat set, or leaving the food on an active appliance too long will lead to lower quality meals.</li>
				<li>Some meals are inherently better than another, for various reasons. Some have more steps one could take to improve it, others are simply packed with nutrition. Both contribute to the mental wellbeing of your customer.</li>
				<li>For ease, you can leave cooking containers on the appliance, and place your ingredients or scoop them out without ever taking it off the appliance.</li>
				<li>Setting the appliance timer to 0 will force it to Stay On when activated. An attentive chef can make use of keeping a burner on, and quickly mix new recipes without ever turning the burner off.</li>

				<h3>Ingredients:</h3>
				<li>Knead an egg and some flour to make dough.</li>
				<li>Cut some meat for cutlets.</li>
				<li>Flatten cutlets for meatballs.</li>
				<li>Mix a little bit of animal protein with some flour for an alternative source of meatballs.</li>
				<li>Flatten a meatball for a meat patty.</li>
				<li>Drop a little bit of Universal Enzyme into a beaker, then add milk for cheese.</li>

				<h2>Appliances</h2>

				<h3>Stovetop:</h3>
				<li>Four burners, each with their own temperature and timer control.</li>
				<li>Requires nothing additional to power to operate.</li>
				<li>A skilled chef can designate two burners to simply ingredient preparation, keeping them on to continually cook low heat items such as cutlets.</li>

				<h3>Grill:</h3>
				<li>Two burners, each with their own temperature and timer control.</li>
				<li>In addition to power, it needs wood to turn into charcoal, and everyone knows carcinogens adds flavor.</li>

				<h3>Oven:</h3>
				<li>One burner, with it's own temperature and timer control.</li>
				<li>To open or close it, there's a latch towards the top of the unit.</li>

				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Drinks for Dummies</h1>
				Here's a guide for some basic drinks.

				<h3>Black Russian:</h3>
				Mix vodka and Kahlua into a glass.

				<h3>Cafe Latte:</h3>
				Mix milk and coffee into a glass.

				<h3>Classic Martini:</h3>
				Mix vermouth and gin into a glass.

				<h3>Gin Tonic:</h3>
				Mix gin and tonic into a glass.

				<h3>Grog:</h3>
				Mix rum and water into a glass.

				<h3>Irish Cream:</h3>
				Mix cream and whiskey into a glass.

				<h3>The Manly Dorf:</h3>
				Mix ale and beer into a glass.

				<h3>Mead:</h3>
				Mix enzyme, water, and sugar into a glass.

				<h3>Screwdriver:</h3>
				Mix vodka and orange juice into a glass.

				</body>
			</html>
			"}


/obj/item/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	desc = "An information manual for Syndicate operatives on the usage of nuclear devices to destroy Nanotrasen facilities, a throwback to the past."
	icon_state = "book_nuclear"
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Nuclear Explosives 101</h1>
				Hello and thank you for choosing the Syndicate for your nuclear information needs. Today's crash course will deal with the operation of a Nuclear Fission Device.<br><br>

				First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE. Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done, to unbolt it, one must completely log in, which at this time may not be possible.<br>

				<h2>To make the nuclear device functional</h2>
				<ul>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device from its interface.</li>
					<li>Insert the nuclear authorisation disk into the slot.</li>
					<li>Type the numeric authorisation code into the keypad. This should have been provided.<br>
					<b>Note</b>: If you make a mistake, press R to reset the device.
					<li>Press the E button to log on to the device.</li>
				</ul><br>

				You now have activated the device. To deactivate the buttons at anytime, for example when you've already prepped the bomb for detonation, remove the authentication disk OR press R on the keypad.<br><br>
				Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				<b>Note</b>: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br><br>

				So use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>
				<b>Note</b>: THE BOMB IS STILL SET AND WILL DETONATE<br><br>

				Now before you remove the disk, if you need to move the bomb, you can toggle off the anchor, move it, and re-anchor.<br><br>

				Remember the order:<br>
				<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br><br>
				Intelligence Analysts believe that normal corporate procedure is for the Captain to secure the nuclear authentication disk.<br><br>

				Good luck!
				</body>
			</html>
			"}


/obj/item/book/manual/wiki
	var/page_link = ""
	window_size = "970x710"
	bad_type = /obj/item/book/manual/wiki

/obj/item/book/manual/wiki/attack_self()
	if(!dat)
		initialize_wikibook()
	return ..()

/obj/item/book/manual/wiki/proc/initialize_wikibook()
	if(config.wikiurl)
		dat = {"
			<html><head>
			<style>
				iframe {
					display: none;
				}
			</style>
			</head>
			<body>
			<script type="text/javascript">
				function pageloaded(myframe) {
					document.getElementById("loading").style.display = "none";
					myframe.style.display = "inline";
    			}
			</script>
			<p id='loading'>You start skimming through the manual...</p>
			<iframe width='100%' height='97%' onload="pageloaded(this)" src="[config.wikiurl]/[page_link]_Eris[config.language]?printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
			</body>
			</html>
			"}

//engineering
/obj/item/book/manual/wiki/engineering_guide
	name = "Engineering Textbook"
	icon_state = "book_engineering"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"
	page_link = "Guide_to_Engineering"

/obj/item/book/manual/wiki/engineering_construction
	name = "Station Repairs and Construction"
	icon_state = "book_construction"
	author = "Engineering Encyclopedia"
	title = "Station Repairs and Construction"
	page_link = "Guide_to_Construction"

/obj/item/book/manual/wiki/engineering_atmos
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "book_atmos"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	page_link = "Guide_to_Atmospherics"

/obj/item/book/manual/wiki/engineering_hacking
	name = "Hacking"
	icon_state = "book_hacking"
	author = "Engineering Encyclopedia"
	title = "Hacking"
	page_link = "Guide_to_Hacking"

/obj/item/book/manual/wiki/engineering_singularity
	name = "Singularity Safety in Special Circumstances"
	icon_state = "book_singularity"
	author = "Engineering Encyclopedia"
	title = "Singularity Safety in Special Circumstances"
	page_link = "Guide_to_Singularity"

/obj/item/book/manual/wiki/engineering_supermatter
	name = "Supermatter Engine Operating Manual"
	icon_state = "book_supermatter"
	author = "Central Engineering Division"
	title = "Supermatter Engine Operating Manual"
	page_link = "Guide_to_Supermatter"

//science
/obj/item/book/manual/wiki/science_research
	name = "Research and Development 101"
	icon_state = "book_rnd"
	author = "Dr. L. Ight"
	title = "Research and Development 101"
	page_link = "Guide_to_Research_and_Development"

/obj/item/book/manual/wiki/science_robotics
	name = "Cyborgs for Dummies"
	icon_state = "book_borg"
	author = "XISC"
	title = "Cyborgs for Dummies"
	page_link = "Guide_to_Robotics"

//security
/obj/item/book/manual/wiki/security_ironparagraphs
	name = "Ironhammer Paragraphs"
	desc = "A set of corporate guidelines for keeping order on privately-owned space assets."
	icon_state = "book_ironparagraphs"
	author = "Ironhammer Security"
	title = "Ironhammer Paragraphs"
	page_link = "Agreement"

/obj/item/book/manual/wiki/security_detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state = "book_forensics"
	author = "The Company"
	title = "The Film Noir: Proper Procedures for Investigations"
	page_link = "Guide_to_Forensics"

//medical
/obj/item/book/manual/wiki/medical_guide
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "book_medical"
	author = "Medical Journal, volume 1"
	title = "Medical Diagnostics Manual"
	page_link = "Guide_to_Medical"

/obj/item/book/manual/wiki/medical_chemistry
	name = "Chemistry Textbook"
	icon_state = "book"//TODO: Add icon
	author = "Medical Journal, volume 2"
	title = "Chemistry"
	page_link = "Guide_to_Chemistry"

//neotheology
/obj/item/book/manual/wiki/neotheology_cloning //TODO: Completely change this to be NT-oriented.
	name = "Cloning Rituals"
	icon_state = "book"//TODO: Add icon
	author = "The Church"
	title = "Cloning Rituals"
	page_link = "Guide_to_Cloning"

//service
/obj/item/book/manual/wiki/barman_recipes
	name = "Barman Recipes"
	icon_state = "book"
	author = "Sir John Rose"
	title = "Barman Recipes"
	page_link = "Guide_to_Food_and_Drinks"

/obj/item/book/manual/wiki/chef_recipes
	name = "Bradhaanata Cooking Guide"
	icon_state = "cooked_book"
	author = "Jordan Damnsey"
	title = "Bradhaanata cooking guide"
	page_link = "Guide_to_Food_and_Drinks"
