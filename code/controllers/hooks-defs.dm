/**
 * Startup hook.
 * Called in world.dm when the server starts.
 */
/hook/startup

/**
 * Roundstart hook.
 * Called in gameticker.dm when a round starts.
 */
/hook/roundstart

/**
 * Roundend hook.
 * Called in gameticker.dm when a round ends.
 */
/hook/roundend

/**
 * Death hook.
 * Called in death.dm when someone dies.
 * Parameters:69ar/mob/living/carbon/human,69ar/gibbed
 */
/hook/death

/**
 * Cloning hook.
 * Called in cloning.dm when someone is brought back by the wonders of69odern science.
 * Parameters:69ar/mob/living/carbon/human
 */
/hook/clone

/**
 * Debrained hook.
 * Called in brain_item.dm when someone gets debrained.
 * Parameters:69ar/obj/item/organ/internal/brain
 */
/hook/debrain

/**
 * Borged hook.
 * Called in robot_parts.dm when someone gets turned into a cyborg.
 * Parameters:69ar/mob/living/silicon/robot
 */
/hook/borgify

/**
 * Payroll revoked hook.
 * Called in Accounts_DB.dm when someone's payroll is stolen at the Accounts terminal.
 * Parameters:69ar/datum/money_account
 */
/hook/revoke_payroll

/**
 * Account suspension hook.
 * Called in Accounts_DB.dm when someone's account is suspended or unsuspended at the Accounts terminal.
 * Parameters:69ar/datum/money_account
 */
/hook/change_account_status

/**
 * Employee reassignment hook.
 * Called in card.dm when someone's card is reassigned at the HoP's desk.
 * Parameters:69ar/obj/item/card/id
 */
/hook/reassign_employee

/**
 * Employee terminated hook.
 * Called in card.dm when someone's card is terminated at the HoP's desk.
 * Parameters:69ar/obj/item/card/id
 */
/hook/terminate_employee

/**
 * Crate sold hook.
 * Called in supplyshuttle.dm when a crate is sold on the shuttle.
 * Parameters:69ar/obj/structure/closet/crate/sold,69ar/area/shuttle
 */
/hook/sell_crate
