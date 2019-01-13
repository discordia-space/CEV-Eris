// This file contains all tips and tricks and shown when you are assigned that role
/tipsAndTricks/roles
    var/list/roles_list       //list of roles to which tip can be shown
    textColor = "purple"
    
/tipsAndTricks/roles/traitor_uplink
    roles_list = list(/datum/antagonist/traitor)
    tipText = "As a traitor you can order all sorts of useful stuff from your PDA/Headset/Implant uplink, like weapons, devices, equipment, services and even money!"

/tipsAndTricks/roles/antag_good_rp
    roles_list = list(/datum/antagonist)
    tipText = "Roleplaying makes for loyal friends and respectful adversaries. Everyone loves a good storyteller who brings others into the plot."

/tipsAndTricks/roles/antag_good_rp_two
    roles_list = list(/datum/antagonist)
    tipText = "Play to have fun and to bring others into the fun. If your round feels less like a kill compilation and more like a scifi thriller, you're doing it right."

/tipsAndTricks/roles/antag_good_rp_three
    roles_list = list(/datum/antagonist)
    tipText = "Merely killing your enemies with a shot in the back is so very droll. You can do better. Make them die tired."

/tipsAndTricks/roles/antag_good_rp_four
    roles_list = list(/datum/antagonist)
    tipText = "Being an antagonist is no excuse for not roleplaying."



