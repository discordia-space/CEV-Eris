//Spans. Robot speech, italics, etc. Applied in compose_message().
#define SPAN_ROBOT "robot"
#define SPAN_YELL "yell"
#define SPAN_ITALICS "italics"
#define SPAN_SANS "sans"
#define SPAN_PAPYRUS "papyrus"
#define SPAN_REALLYBIG "reallybig"
#define SPAN_COMMAND "command_headset"
#define SPAN_CLOWN "clown"
#define SPAN_SINGING "singing"
#define SPAN_TAPE_RECORDER "tape_recorder"
#define SPAN_HELIUM "small"
#define SPAN_SOAPBOX "soapbox"
#define SPAN_BOLD "bold"


#define MODE_SING "sing"

#define MODE_CUSTOM_SAY_EMOTE "custom_say"



#define WHISPER_MODE "the type of whisper"
#define MODE_WHISPER "whisper"
#define MODE_WHISPER_CRIT "whispercrit"



// Audio/Visual Flags. Used to determine what sense are required to notice a message.
#define MSG_VISUAL (1<<0)
#define MSG_AUDIBLE (1<<1)


//Used in visible_message_flags, audible_message_flags and runechat_flags
#define EMOTE_MESSAGE (1<<0)
#define LOOC_MESSAGE (1<<1)


#define SPEECHPROBLEM_R_MESSAGE 1
#define SPEECHPROBLEM_R_VERB 2
#define SPEECHPROBLEM_R_FLAG 3
