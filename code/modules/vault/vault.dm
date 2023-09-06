#define BALANCE "balance"

/datum/player_vault
    var/iriska_balance = 0
    // picked up when generating loadout
    // assoc list of item types to thier data (job, fate, etc)
    var/list/iriska_items = list()

/datum/player_vault/proc/load_from_list(var/list/data)
    if(isnull(data))
        return

    iriska_balance = data[BALANCE] ? data[BALANCE] : 0

/datum/player_vault/proc/save_to_list()
    var/list/data = list()
    data[BALANCE] = iriska_balance
    return data

#undef BALANCE