// This file contains all gameplay tips that didnt fit into other categories
/tipsAndTricks/jobs
    var/list/jobs_list       //list of jobs to which tip can be shown
    textColor = "#22458d"
    
/tipsAndTricks/jobs/captain_boss
    jobs_list = list(/datum/job/captain)
    tipText = "As a captain you own this ship. You set the rules."

/tipsAndTricks/jobs/ironhammer_theft
    jobs_list = list(/datum/job/ihc, /datum/job/gunserg, /datum/job/inspector, /datum/job/medspec, /datum/job/ihoper)
    tipText = "As an ironhammer operative, you have broad access to chase criminals. This does not mean you can take anything you have access to. Taking things from other departments is theft!"

/tipsAndTricks/jobs/guild_resale_profit
    jobs_list = list(/datum/job/merchant, /datum/job/cargo_tech)
    tipText = "As a guild merchant, you should be buying up valueable things from scavengers and reselling them for a profit. Buy anything of value that's brought to you"

/tipsAndTricks/jobs/captain_leader
    jobs_list = list(/datum/job/captain)
    tipText = "A good leader's orders are always obeyed because a good leader never gives an order that won't be obeyed."

/tipsAndTricks/jobs/captain_free_access
    jobs_list = list(/datum/job/captain)
    tipText = "You didn't pick this role for the ID, did you?"

/tipsAndTricks/jobs/captain_value_your_ship
    jobs_list = list(/datum/job/captain)
    tipText = "This ship is the culmination of your life's work. Don't abandon it because you scratched the paint."

/tipsAndTricks/jobs/captain_is_overseer
    jobs_list = list(/datum/job/captain)
    tipText = "You have a vital out-of-character role; you are the quest-giver. If play lacks direction and the crew is getting restless, give them something productive to do."

/tipsAndTricks/jobs/is_captain_right
    jobs_list = list(/datum/job/captain)
    tipText = "The Captain is always right, even when he is wrong. Because they better hope you're right when you read that fuel gauge twelve light-days from port."

/tipsAndTricks/jobs/captain_mutiny
    jobs_list = list(/datum/job/captain)
    tipText = "When do you break out the lash and airlock the ringleaders? Black. Bloody. Mutiny."

/tipsAndTricks/jobs/engies_tribe
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "In the ancient times, a group of engineers was called a tribe. That is why some technomancers call you Chief."

/tipsAndTricks/jobs/engies_suppermatter_one
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "The Supreme Matter is a fickle mistress, and each Exultant has their own unique ritual. No ritual is strictly wrong; such a poor lover would be dead by now, surely..."

/tipsAndTricks/jobs/engies_suppermatter_two
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "Venting the Supreme Matter's overheated coolant may drop temperatures immediately, but without fresh coolant gas the Supreme Matter will almost surely delaminate."

/tipsAndTricks/jobs/engies_suppermatter_three
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "Woe betide the Exultant who jettisons a Supreme Matter, one of the ancient relics of the grand, lost fleets; for their numbers dwindle, and the artifice of their creation is lost. It is better to hurl oneself after it than live so ashamed."

/tipsAndTricks/jobs/engies_lifekeeper
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "You are responsible for keeping these hundred souls alive inside an electrified air canister hurtling through an unholy blackness at speeds that make an Ironhammer bullet-pusher stare slack-jawed. You will fail. The question is how many bodies need fill the breach, smother the flames, and bind the wires."

/tipsAndTricks/jobs/engies_die_live
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "A technomancer shall die that the ship shall live. It is the one rite all clans share."

/tipsAndTricks/jobs/engies_tenants
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "The relationship between ship captains and technomancers is like that between tenants and landlords. One struts around between carpeting and ceiling like they own the place, while the other crawls in the foundation and attic actually giving a damn."

/tipsAndTricks/jobs/engies_glass_fire
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "In case of fire, break glass."

/tipsAndTricks/jobs/engies_firespacesuit
    jobs_list = list(/datum/job/chief_engineer, /datum/job/technomancer)
    tipText = "No technomancer lives long without learning that firesuits are not space suits, and vice versa."

/tipsAndTricks/jobs/tric
    jobs_list = list(/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/paramedic)
    tipText = "Inaprovaline and dylovene can be mixed together in a container to produce tricordazine - a mild regenerative compound that can treat brute/burns/toxin damage and even suffocation, best of all, it has no overdose risk."

/tipsAndTricks/jobs/carbonPills
    jobs_list = list(/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/paramedic)
    tipText = "Pills containing pure carbon can be ingested to treat cases of poisoning and accidental overdoes, 1u of carbon will remove 1u of anything in the stomach. This will not, however, purge chemicals in the bloodstream, nor will injecting carbon have the same effect."

/tipsAndTricks/jobs/inabicaInternal
    jobs_list = list(/datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/paramedic)
    tipText = "Inaprovaline and bicardine can be used to stem the effects of internal bleeding."

/tipsAndTricks/jobs/crewMonitorHelp
    jobs_list = list(/datum/job/cmo, /datum/job/doctor, /datum/job/paramedic)
    tipText = "You can use crew monitoring programm on computers to locate injured crew member. It can be downloaded on tablet or laptop for portable solution. Medical storage always has one tablet for this purpose on roundstart."

/tipsAndTricks/jobs/thermite
    jobs_list = list(/datum/job/chemist)
    tipText = "Thermite is a great way to take down walls."

/tipsAndTricks/jobs/grenades
    jobs_list = list(/datum/job/chemist)
    tipText = "You can make grenades for various of purposes. From harmful like explosion or emp to helful like cleaning and weed killing."

/tipsAndTricks/jobs/acidForNerds
    jobs_list = list(/datum/job/chemist)
    tipText = "Your collegues from science wing will often need more sulphuric acid for their circuits."

/tipsAndTricks/jobs/cyborgsDontBreathe
    jobs_list = list(/datum/job/cyborg)
    tipText = "As a cyborg you dont need oxygen/pressure to survive. You also quite resistant to heat. Use it to your advantage."

/tipsAndTricks/jobs/siliconRemoteControl
    jobs_list = list(/datum/job/cyborg, /datum/job/ai)
    tipText = "Silicons have ability to remotely control machinery. You can open airlocks for you without bumping into them."

/tipsAndTricks/jobs/siliconShortcuts
    jobs_list = list(/datum/job/cyborg, /datum/job/ai)
    tipText = "Many machinery has keyboard shortcuts. Try alt/shift/ctrl clicking on some. For example airlocks, air/fire alarms, apc etc."

/tipsAndTricks/jobs/siliconRemoteControlTwo
    jobs_list = list(/datum/job/cyborg, /datum/job/ai)
    tipText = "You can access some computer programs without interacting with actual computers using your \"Subsystems\" located in silicon tab."

/tipsAndTricks/jobs/changeAILaws
    jobs_list = list(/datum/job/captain, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/ihc, /datum/job/hop, /datum/job/rd)
    tipText = "As one of command you have access to change AI laws. Dont be afraid to add custom laws to guide AI in certain direction."

/tipsAndTricks/jobs/aiCanBeMoved
    jobs_list = list(/datum/job/ai)
    tipText = "AI core can be unwrenched and moved to safer location, but its trackable by power consumption."

/tipsAndTricks/jobs/expeditionsAreFUN
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Expeditions are FUN, try to participating in one."

/tipsAndTricks/jobs/prostheticsForTheMeek
    jobs_list = list(/datum/job/roboticist)
    tipText = "You can enhance human body by installing prosthetics and modifications."

/tipsAndTricks/jobs/moreAcidForAnCircuitPrinting
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "You can get more sulphuric acid for circuits from chemist."

/tipsAndTricks/jobs/bots
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Bots are tireless servants that you can create. No janitor? CleanBot to the rescue! Not enough medical staff? MedBot will solve that."

/tipsAndTricks/jobs/ripley
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Ripley mech is an universal tool for various of tasks, be that mining, building or deconstructing. It also has rather strong melee attack."

/tipsAndTricks/jobs/odysseus
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Odysseus is a reliable medical mech that can be used as paramedic vehicle or mobile medical treatment machine."

/tipsAndTricks/jobs/gygax
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Gygax is a combat mech. It is lighly armored but rather mobile threat to any antagonist."

/tipsAndTricks/jobs/durand
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Durand is a combat mech. It is heavely armored and extra scary in confined spaces due to its punches and defense mode."

/tipsAndTricks/jobs/phazon
    jobs_list = list(/datum/job/rd, /datum/job/scientist, /datum/job/roboticist)
    tipText = "Phazon is a combat mech. It has the highest base movespeed, good armor and can phase through anything thanks to bluespace technology."
