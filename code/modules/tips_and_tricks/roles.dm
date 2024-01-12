// This file contains all tips and tricks and shown when you are assigned that role
/tipsAndTricks/roles
    var/list/roles_list       //list of roles to which tip can be shown
    textColor = "purple"

/tipsAndTricks/roles/contractor_uplink
    roles_list = list(/datum/antagonist/contractor)
    tipText = "As a contractor you can order all sorts of useful stuff from your PDA/Headset/Implant uplink, like weapons, devices, equipment, services and even money!"

/tipsAndTricks/roles/antag_good_rp
    roles_list = list(/datum/antagonist)
    tipText = "Roleplaying makes for loyal friends and respectful adversaries. Everyone loves a good storyteller who brings others into the plot."

/tipsAndTricks/roles/antag_good_rp_two
    roles_list = list(/datum/antagonist)
    tipText = "Play to have fun and to bring others into the fun. If your round feels less like a kill compilation and more like a sci-fi thriller, you're doing it right."

/tipsAndTricks/roles/antag_good_rp_three
    roles_list = list(/datum/antagonist)
    tipText = "Merely killing your enemies with a shot in the back is so very droll. You can do better. Make them die tired."

/tipsAndTricks/roles/antag_good_rp_four
    roles_list = list(/datum/antagonist)
    tipText = "Being an antagonist is no excuse for not roleplaying."

/tipsAndTricks/roles/bombs
    roles_list = list(/datum/antagonist)
    tipText = "You can create very potent bombs in Moebius chemistry or toxins. You also have various activation methods to chose from."

/tipsAndTricks/roles/computerPrograms
    roles_list = list(/datum/antagonist/contractor)
    tipText = "When you emag a computer it unlocks access to some unique programs. Access Decipherer is one of them. Note that most of the programs depend on computer processing power."

/tipsAndTricks/roles/borgEmag
    roles_list = list(/datum/antagonist/contractor)
    tipText = "By emagging a cyborg, you obtain a powerful ally with full access. Don't forget to open its panel first."

/tipsAndTricks/roles/siliconLaws
    roles_list = list(/datum/antagonist)
    tipText = "The AI of the ship can do your bidding if you update its laws accordingly. It can also affect cyborgs if they are in sync with the AI."

/tipsAndTricks/roles/carrionsurgery
    roles_list = list(/datum/antagonist/carrion)
    tipText = "As a carrion, you have greatly increased control over your body - if you want to perform self-surgery, you can do it standing up."

/tipsAndTricks/roles/borerLang
    roles_list = list(/datum/antagonist/borer)
    tipText = "As a borer, reading a host's mind will teach you the languages they know. For every language you learn you get more experience."

