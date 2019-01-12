// This file contains all gameplay tips that didnt fit into other categories
/tipsAndTricks/jobs
    var/list/jobs_list       //list of jobs to which tip can be shown
    textColor = "#22458d"
    
/tipsAndTricks/jobs/captain
    jobs_list = list(/datum/job/captain)
    tipText = "As a captain you own this ship. You set the rules."