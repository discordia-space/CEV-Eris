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
