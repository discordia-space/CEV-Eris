// This file contains all tips and tricks and shown when you are assigned that role
/tipsAndTricks/roles
    var/list/roles_list       //list of roles to which tip can be shown
    textColor = "purple"
    
/tipsAndTricks/roles/traitor_uplink
    roles_list = list(/datum/antagonist/traitor)
    tipText = "As a traitor you can order all sorts of useful stuff from your PDA/Headset/Implant uplink, like weapons, devices, equipment, services and even money!"