#define RESTART_WEBHOOK "restart"

/proc/call_restart_webhook()
    call_webhook(RESTART_WEBHOOK)

/proc/call_webhook(method)
    if (!config.webhook_url || !config.webhook_key)
        log_adminwarn("Looks like webhook is not configured. Please add WEBHOOK_URL and WEBHOOK_KEY to the config")
        return

    var/webhook = "[config.webhook_url]/[method]?key=[config.webhook_key]";
    log_debug("Calling webhook with address [webhook]")
    var http[] = world.Export(webhook)
    if(!http)
        log_adminwarn("Failed to call [method] webhook!");