
/datum/event/mundane_news
	endWhen = 10

/datum/event/mundane_news/announce()
	var/datum/trade_destination/affected_dest = pickweight(weighted_mundaneevent_locations)
	var/event_type = 0
	if(affected_dest.viable_mundane_events.len)
		event_type = pick(affected_dest.viable_mundane_events)

	if(!event_type)
		return

	var/author = "Nyx Daily"
	var/channel = author

	//see if our location has custom event info for this event
	var/body = affected_dest.get_custom_eventstring()
	if(!body)
		body = ""
		switch(event_type)
			if(RESEARCH_BREAKTHROUGH)
				body = "A69ajor breakthough in the field of 69pick("plasma research","super-compressed69aterials","nano-augmentation","bluespace research","volatile power69anipulation")69 \
				was announced 69pick("yesterday","a few days ago","last week","earlier this69onth")69 by a private firm on 69affected_dest.name69. \
				69company_name69 declined to comment as to whether this could impinge on profits."

			if(ELECTION)
				body = "The pre-selection of an additional candidates was announced for the upcoming 69pick("supervisors council","advisory board","governership","board of inquisitors")69 \
				election on 69affected_dest.name69 was announced earlier today, \
				69pick("media69ogul","web celebrity", "industry titan", "superstar", "famed chef", "popular gardener", "ex-army officer", "multi-billionaire")69 \
				69random_name(pick(MALE,FEMALE))69. In a statement to the69edia they said '69pick("My only goal is to help the 69pick("sick","poor","children")69",\
				"I will69aintain69y company's record profits","I believe in our future","We69ust return to our69oral core","Just like... chill out dudes")69'."

			if(RESIGNATION)
				body = "69company_name69 regretfully announces the resignation of 69pick("Sector Admiral","Division Admiral","Ship Admiral","Vice Admiral")69 69random_name(pick(MALE,FEMALE))69."
				if(prob(25))
					var/locstring = pick("Segunda","Salusa","Cepheus","Andromeda","Gruis","Corona","Aquila","Asellus") + " " + pick("I","II","III","IV","V","VI","VII","VIII")
					body += " In a ceremony on 69affected_dest.name69 this afternoon, they will be awarded the \
					69pick("Red Star of Sacrifice","Purple Heart of Heroism","Blue Eagle of Loyalty","Green Lion of Ingenuity")69 for "
					if(prob(33))
						body += "their actions at the Battle of 69pick(locstring,"REDACTED")69."
					else if(prob(50))
						body += "their contribution to the colony of 69locstring69."
					else
						body += "their loyal service over the years."
				else if(prob(33))
					body += " They are expected to settle down in 69affected_dest.name69, where they have been granted a handsome pension."
				else if(prob(50))
					body += " The news was broken on 69affected_dest.name69 earlier today, where they cited reasons of '69pick("health","family","REDACTED")69'"
				else
					body += " Administration Aerospace wishes them the best of luck in their retirement ceremony on 69affected_dest.name69."

			if(CELEBRITY_DEATH)
				body = "It is with regret today that we announce the sudden passing of the "
				if(prob(33))
					body += "69pick("distinguished","decorated","veteran","highly respected")69 \
					69pick("Ship's Captain","Vice Admiral","Colonel","Lieutenant Colonel")69 "
				else if(prob(50))
					body += "69pick("award-winning","popular","highly respected","trend-setting")69 \
					69pick("comedian","singer/songwright","artist","playwright","TV personality","model")69 "
				else
					body += "69pick("successful","highly respected","ingenious","esteemed")69 \
					69pick("academic","Professor","Doctor","Scientist")69 "

				body += "69random_name(pick(MALE,FEMALE))69 on 69affected_dest.name69 69pick("last week","yesterday","this69orning","two days ago","three days ago")69\
				69pick(". Assassination is suspected, but the perpetrators have not yet been brought to justice",\
				" due to69ercenary infiltrators (since captured)",\
				" during an industrial accident",\
				" due to 69pick("heart failure","kidney failure","liver failure","brain hemorrhage")69")69"

			if(BARGAINS)
				body += "BARGAINS! BARGAINS! BARGAINS! Commerce Control on 69affected_dest.name69 wants you to know that everything69ust go! Across all retail centres, \
				all goods are being slashed, and all retailors are onboard - so come on over for the \69shopping\69 time of your life."

			if(SONG_DEBUT)
				body += "69pick("Singer","Singer/songwriter","Saxophonist","Pianist","Guitarist","TV personality","Star")69 69random_name(pick(MALE,FEMALE))69 \
				announced the debut of their new 69pick("single","album","EP","label")69 '69pick("Everyone's","Look at the","Baby don't eye those","All of those","Dirty nasty")69 \
				69pick("roses","three stars","starships","nanobots","cyborgs")69 \
				69pick("on69enus","on Reade","on69oghes","in69y hand","slip through69y fingers","die for you","sing your heart out","fly away")69' \
				with 69pick("pre-puchases available","a release tour","cover signings","a launch concert")69 on 69affected_dest.name69."

			if(MOVIE_RELEASE)
				body += "From the 69pick("desk","home town","homeworld","mind")69 of 69pick("acclaimed","award-winning","popular","stellar")69 \
				69pick("playwright","author","director","actor","TV star")69 69random_name(pick(MALE,FEMALE))69 comes the latest sensation: '\
				69pick("Deadly","The last","Lost","Dead")69 69pick("Starships","Warriors","outcasts")69 \
				69pick("of","from","raid","go hunting on","visit","ravage","pillage","destroy")69 \
				69pick("Moghes","Earth","Biesel","Ahdomai","S'randarr","the69oid","the Edge of Space")69'.\
				. Own it on webcast today, or69isit the galactic premier on 69affected_dest.name69!"

			if(BIG_GAME_HUNTERS)
				body += "Game hunters on 69affected_dest.name69 "
				if(prob(33))
					body += "were surprised when an unusual species experts have since identified as \
					69pick("a subclass of69ammal","a divergent abhuman species","an intelligent species of lemur","organic/cyborg hybrids")69 turned up. Believed to have been brought in by \
					69pick("alien smugglers","early colonists","mercenary raiders","unwitting tourists")69, this is the first such specimen discovered in the wild."
				else if(prob(50))
					body += "were attacked by a69icious 69pick("nas'r","diyaab","samak","predator which has not yet been identified")69\
					. Officials urge caution, and locals are advised to stock up on armaments."
				else
					body += "brought in an unusually 69pick("valuable","rare","large","vicious","intelligent")69 69pick("mammal","predator","farwa","samak")69 for inspection \
					69pick("today","yesterday","last week")69. Speculators suggest they69ay be tipped to break several records."

			if(GOSSIP)
				body += "69pick("TV host","Webcast personality","Superstar","Model","Actor","Singer")69 69random_name(pick(MALE,FEMALE))69 "
				if(prob(33))
					body += "and their partner announced the birth of their 69pick("first","second","third")69 child on 69affected_dest.name69 early this69orning. \
					Doctors say the child is well, and the parents are considering "
					if(prob(50))
						body += capitalize(pick(GLOB.first_names_female))
					else
						body += capitalize(pick(GLOB.first_names_male))
					body += " for the name."
				else if(prob(50))
					body += "announced their 69pick("split","break up","marriage","engagement")69 with 69pick("TV host","webcast personality","superstar","model","actor","singer")69 \
					69random_name(pick(MALE,FEMALE))69 at 69pick("a society ball","a new opening","a launch","a club")69 on 69affected_dest.name69 yesterday, pundits are shocked."
				else
					body += "is recovering from plastic surgery in a clinic on 69affected_dest.name69 for the 69pick("second","third","fourth")69 time, reportedly having69ade the decision in response to "
					body += "69pick("unkind comments by an ex","rumours started by jealous friends",\
					"the decision to be dropped by a69ajor sponsor","a disasterous interview on Nyx Tonight")69."
			if(TOURISM)
				body += "Tourists are flocking to 69affected_dest.name69 after the surprise announcement of 69pick("major shopping bargains by a wily retailer",\
				"a huge new ARG by a popular entertainment company","a secret tour by popular artiste 69random_name(pick(MALE,FEMALE))69")69. \
				Nyx Daily is offering discount tickets for two to see 69random_name(pick(MALE,FEMALE))69 live in return for eyewitness reports and up to the69inute coverage."

	news_network.SubmitArticle(body, author, channel, null, 1)

/datum/event/trivial_news
	endWhen = 10

/datum/event/trivial_news/announce()
	var/author = "Editor69ike Hammers"
	var/channel = "The Gibson Gazette"

	var/datum/trade_destination/affected_dest = pick(weighted_mundaneevent_locations)
	var/body = pick(
	"Armadillos want aardvarks removed from dictionary claims 'here first'.",\
	"Angel found dancing on pinhead ordered to stop; cited for public nuisance.",\
	"Letters claim they are better than number; 'Always have been'.",\
	"Pens proclaim pencils obsolete, 'lead is dead'.",\
	"Rock and paper sues scissors for discrimination.",\
	"Steak tell-all book reveals he never liked sitting by potato.",\
	"Woodchuck stops counting how69any times he�s chucked 'Never again'.",\
	"69affected_dest.name69 clerk first person able to pronounce '@*69CREDS69%!'.",\
	"69affected_dest.name69 delis serving boiled paperback dictionaries, 'Adjectives chewy' customers declare.",\
	"69affected_dest.name69 weather deemed 'boring';69eteors and rad storms to be imported.",\
	"Most 69affected_dest.name69 security officers prefer cream over sugar.",\
	"Palindrome speakers conference in 69affected_dest.name69; 'Wow!' says Otto.",\
	"Question69ark worshipped as deity by ancient 69affected_dest.name69 dwellers.",\
	"Spilled69ilk causes whole 69affected_dest.name69 populace to cry.",\
	"World largest carp patty at display on 69affected_dest.name69.",\
	"Man travels 7000 light years to retrieve lost hankie, 'It was69y favourite'.",\
	"New bowling lane that shoots69ini-meteors at bowlers69ery popular.",\
	"69pick("Unathi","Spacer")69 gets tattoo of Nyx on chest '69pick("69boss_short69","star","starship","asteroid")69 tickles69ost'.",\
	"Chef reports successfully using harmonica as cheese grater.",\
	"69company_name69 invents handkerchief that says 'Bless you' after sneeze.",\
	"Clone accused of posing for other clones�s school photo.",\
	"Clone accused of stealing other clones�s employee of the69onth award.",\
	"Woman robs station with hair dryer; crewmen love new style.",\
	"This space for rent.",\
	"69affected_dest.name69 Baker Wins Pickled Crumpet Toss Three Years Running",\
	"Survey: 'Cheese Louise'69oted Best Pizza Restaurant In Nyx",\
	"I Was Framed, jokes 69affected_dest.name69 artist",\
	"Mysterious Loud Rumbling Noises In 69affected_dest.name69 Found To Be69ysterious Loud Rumblings",\
	"Alien ambassador becomes lost on 69affected_dest.name69, refuses to ask for directions",\
	"Swamp Gas69erified To Be Exhalations Of Stars--Movie Stars--Long Passed",\
	"Tainted Broccoli Weapon Of Choice For Efficient Assassins",\
	"Chefs Find Broccoli Effective Tool For Cutting Cheese",\
	"Broccoli Found To Cause Grumpiness In69onkeys",\
	"Survey: 80% Of People on 69affected_dest.name69 Love Clog-Dancing",\
	"Giant Hairball Has Perfect Grammar But Rolls rr's Too69uch, Linguists Say",\
	"69affected_dest.name69 Phonebooks Print All Wrong Numbers; Results In 15 New69arriages",\
	"Gibson Gazette Updates Frequently Absurd, Poll Indicates",\
	"Esoteric69erbosity Culminates In Communicative Ennui, 69affected_dest.name69 Academics Note",\
	"Taj Demand Longer Breaks, Cleaner Litter, Slower69ice",\
	"Shipment Of Apples Overturns, 69affected_dest.name69 Diner Offers Applesauce Special",\
	"Spotted Owl Spotted on 69affected_dest.name69",\
	"From The Desk Of Wise Guy Sammy: One Word In This Gazette Is Sdrawkcab",\
	"From The Desk Of Wise Guy Sammy: It's Hard To Have Too69uch Shelf Space",\
	"From The Desk Of Wise Guy Sammy: Wine And Friendships Get Better With Age",\
	"From The Desk Of Wise Guy Sammy: The Insides Of Golf Balls Are69ostly Rubber Bands",\
	"From The Desk Of Wise Guy Sammy: You Don't Have To Fool All The People, Just The Right Ones",\
	"From The Desk Of Wise Guy Sammy: If You69ade The69ess, You Clean It Up",\
	"From The Desk Of Wise Guy Sammy: It Is Easier To Get Forgiveness Than Permission",\
	"From The Desk Of Wise Guy Sammy: Check Your Facts Before69aking A Fool Of Yourself",\
	"From The Desk Of Wise Guy Sammy: You Can't Outwait A Bureaucracy",\
	"From The Desk Of Wise Guy Sammy: It's Better To Yield Right Of Way Than To Demand It",\
	"From The Desk Of Wise Guy Sammy: A Person Who Likes Cats Can't Be All Bad",\
	"From The Desk Of Wise Guy Sammy: Help Is The Sunny Side Of Control",\
	"From The Desk Of Wise Guy Sammy: Two Points Determine A Straight Line",\
	"From The Desk Of Wise Guy Sammy: Reading Improves The69ind And Lifts The Spirit",\
	"From The Desk Of Wise Guy Sammy: Better To Aim High And69iss Then To Aim Low And Hit",\
	"From The Desk Of Wise Guy Sammy:69eteors Often Strike The Same Place69ore Than Once",\
	"Tommy B. Saif Sez: Look Both Ways Before Boarding The Shuttle",\
	"Tommy B. Saif Sez: Hold On; Sudden Stops Sometimes Necessary",\
	"Tommy B. Saif Sez: Keep Fingers Away From69oving Panels",\
	"Tommy B. Saif Sez: No Left Turn, Except Shuttles",\
	"Tommy B. Saif Sez: Return Seats And Trays To Their Proper Upright Position",\
	"Tommy B. Saif Sez: Eating And Drinking In Docking Bays Is Prohibited",\
	"Tommy B. Saif Sez: Accept No Substitutes, And Don't Be Fooled By Imitations",\
	"Tommy B. Saif Sez: Do Not Remove This Tag Under Penalty Of Law",\
	"Tommy B. Saif Sez: Always69ix Thoroughly When So Instructed",\
	"Tommy B. Saif Sez: Try To Keep Six69onth's Expenses In Reserve",\
	"Tommy B. Saif Sez: Change Not Given Without Purchase",\
	"Tommy B. Saif Sez: If You Break It, You Buy It",\
	"Tommy B. Saif Sez: Reservations69ust Be Cancelled 48 Hours Prior To Event To Obtain Refund",\
	"Doughnuts: Is There Anything They Can't Do",\
	"If Tin Whistles Are69ade Of Tin, What Do They69ake Foghorns Out Of?",\
	"Broccoli discovered to be colonies of tiny aliens with69urder on their69inds"\
	)

	news_network.SubmitArticle(body, author, channel, null, 1)
