#pragma context server

// Converted from monsters/base_chat_array.script by msc_transpiler.
// More dynamic, array based chat system JUL2010_11 by Thothie
// callevent chat_now <text> [time] [anim|"none"|"no_convo"] [event|"none"] ["clear_que"] ["add_to_que"] [sound:<file>]
// - adds line to chat que and speaks line, if not busy, same formatting as chat_add_text above
// - if the "clear_que" flag is used, the current chat que will be emptied and this entry will replace it.
// - The "clear_que" parameter can be used in any position after <text>
// - "add_to_que" will add the chat entry to the current que, even if CHAT_NEVER_INTERRUPT or CHAT_IGNORE_WHILE_BUSY is set
// - The "add_to_que" parameter can be used in any position after <text>
// - good for one-liners (or things that may interrupt conversation if you add ["clear_que"]), though it's the simplest general use of the base
// - [time] [anim|"none"] [event|"none"] must come in order, any other conditions ( ["clear_que"] ["add_to_que"] [sound:<file>] ) can come in any order after that
// callevent chat_add_text <convo_sequence_name> <sentence_string> [time] [anim|"none"] [event] [sound:<file>]
// - Stores a line in a chat sequence for later use in chat_start_sequence, below.
// - <convo_sequence_name> conversation sequence to add text to
// - <sentence_string> text of sentence to say
// - [time] delay before speaking next line in conversation (defaults to CHAT_DELAY if ommited)
// - [anim|"none"|"no_convo"] play anim at beginning of this sentence (overrides random convo anims [see: chat_convo_anim]). "no_convo" forces the chat step not to play convo anims.
// - [event] fire this event on this step, with a delay equal to the time required for the sentence
// - [sound:wavefile] plays the wave file after sound: (as per usual, ommit the sound/ root folder)
// - if [event] begins with ! it will fire the event that follows on the instant it reaches the chat step, instead of when the chat step should end
// - PARAMS must be in order. You cannot, for instance, use [event] without defining [time] and [anim].)
// callevent chat_start_sequence <convo_sequence_name> ["clear_que"] ["prioritize"] ["add_to_que"]
// - loads designated chat sequence into que
// - if CHAT_RESET_ON_NEW is set 1, erases que
// - calls npc_chat_was_busy event (see "return events" below) when attempting/succeeding in calling a new conversation with one already in progress
// - "clear_que" flag causes the current que to be cleared and be replaced by the requested <sequence_name> even if CHAT_RESET_ON_NEW is set to 0
// - "prioritize" flag causes NPC to ignore all other chat_start_sequence and chat_now events until chat is no longer busy, unless ["clear_que"] flag is used
// - "add_to_que" will add the chat entry to the current quei, even if CHAT_NEVER_INTERRUPT or CHAT_IGNORE_WHILE_BUSY is set
// - The ["clear_que"] ["prioritize"] ["add_to_que"] optional parameters can be in any order, or ommited.
// callevent chat_face_speaker [target]
// - faces speaker
// - if param omitted, faces last ent_lastspoke or last player to use interaction menu (as determined by chat_find_speaker_id event below)
// callevent chat_move_mouth <time>
// - moves mouth for <time> seconds, as if speaking
// - default behavior is to do this every chat step, unless const CHAT_MOVE_MOUTH is set 0
// - does not reserve chat time in the process (see chat_reseve), has no effect on que
// - (related events: chat_open_mouth, chat_close_mouth)
// callevent chat_convo_anim
// - plays a random animation from the CHAT_CONV_ANIMS token list
// - default behavior is to do this every chat step, unless const CHAT_USE_CONV_ANIMS is set 0
// - note the default CHAT_CONV_ANIMS are only good for NPCs with full scientist animations
// - has no effect on que
// callevent chat_clear_que
// - Clears current chat que.
// callevent chat_reseve <time>
// - Retain the CHAT_BUSY flag for <x> seconds (useful for chat lines done outside of the base_chat_array system.)
// - This is normally done automatically by chat_start_sequence and chat_now
// - que will suspend until time expires, unless a chat_start_sequence or chat_now event is called using the 'clearque' flag
// callevent chat_find_speaker_id
// - finds the speaker's id (really guesses)
// - Guess work favors order: last_used_menu(if within 512 units)->last_spoke(if within 512)->any player within 512->first player indexed (regardless of distance)->well f*ck there's no players ;)
// callevent chat_pause
// - pauses cycling of chat
// callevent chat_resume
// - resumes chat, if paused
// out events:
// { npc_chat_was_busy //<action_taken:ignored|started_new>
// - Called whenever a speech is called while another is in progress, in case the NPC needs to take some special action
// - The returning PARAM1 indicates the action base_chat_array took in response to the attempted interruption:
// - PARAM1 = "ignored" - request was ingored, no new conversation began (because prioritize flag was used or CHAT_IGNORE_WHILE_BUSY was otherwise set)
// - PARAM1 = "started_new" - current speach was aborted in favor of this new conversation due to clear_que flag being used
// - PARAM1 = "added" - new conversation was added to que, but current conversation continues
// (This event is not called if conversation is stopped by monster death)
// out flags:
// CHAT_BUSY - busy chatting when set to 1 (ala ye old BUSY_CHATTING)
// CHAT_END_TIME - when current chat sentence will end +0.1 seconds
// CHAT_CURRENT_SPEAKER - ID of player last identified as the speaker
// in flags and their defaults described in init area below:

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseChatArray
{
	// Constants
	string CHAT_CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;";
	bool CHAT_NEVER_INTERRUPT = false;
	bool CHAT_USE_BUSY_MESSAGE = true;
	bool CHAT_USE_CONV_ANIMS = true;
	bool CHAT_MOVE_MOUTH = true;
	bool CHAT_NO_CLOSE_MOUTH = false;
	bool CHAT_AUTO_FACE = true;
	bool CHAT_FACE_ON_USE = true;
	bool CHAT_MENU_ENABLE = true;
	bool CHAT_RESET_ON_NEW = false;
	string CHAT_PLAYANIM_STYLE = "critical";
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_AUTO_JOB = false;
	bool CHAT_AUTO_RUMOR = false;
	int CHAT_MAX_LINE_LEN = 192;
	float CHAT_DELAY = 4.0f;

	// Variables (an unset .script variable reads as its own name)
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = true;
	bool CHAT_IGNORE_WHILE_BUSY = false;
	bool CHAT_MENU_ON = false;
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	CBasePlayer@ CHAT_LAST_USED_MENU = null;
	bool CHAT_ABORT = false;
	string CHAT_SEQUENCE = "CHAT_SEQUENCE";
	string CHAT_LINES_ANAME = "CHAT_LINES_ANAME";
	string CHAT_DELAYS_ANAME = "CHAT_DELAYS_ANAME";
	string CHAT_ANIMS_ANAME = "CHAT_ANIMS_ANAME";
	string CHAT_EVENTS_ANAME = "CHAT_EVENTS_ANAME";
	string CHAT_SOUNDS_ANAME = "CHAT_SOUNDS_ANAME";
	bool CHAT_QUE_ACTIVE = false;
	float CHAT_END_MOVE_MOUTH = 0.0f;
	string DUMP_CONVO = "DUMP_CONVO";
	float CHAT_SPOOL_OUT_ALL_COUNT = 0.0f;
	float CHAT_SPOOL_OUT_COUNT = 0.0f;
	bool CHAT_BUSY = false;
	float CHAT_END_TIME = 0.0f;

	// unnamed block (first think)
	void BaseChatArray_FirstThink()
	{
		HAS_BASE_CHAT_ARRAY_INCLUDE = true;
		CHAT_IGNORE_WHILE_BUSY = false; // sets to 1 if current speech has priority (is not be interrupted by another request), but resets when chat completes

		CHAT_MENU_ON = true; // set to 0 to temporarily disable chat adding menu items below (if any set)

		CHAT_CURRENT_SPEAKER = "none"; // speaker entID will be stored here
	}

	// game_spawn
	void BaseChatArray_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetMenuAutoOpen(CHAT_MENU_ENABLE);

		if (CHAT_AUTO_HAIL)
			CatchSpeech("say_hi", "hail", "hi", "j0", "yo", "waddup", "wassup", "gweets", "greet");
		if (CHAT_AUTO_JOB)
			CatchSpeech("say_job", "job", "work");
		if (CHAT_AUTO_RUMOR)
			CatchSpeech("say_rumor", "rumour", "rumor");

		ArrayCreate("CONVO_QUE_LINES");
		ArrayCreate("CONVO_QUE_DELAYS");
		ArrayCreate("CONVO_QUE_ANIMS");
		ArrayCreate("CONVO_QUE_EVENTS");
		ArrayCreate("CONVO_QUE_SOUNDS");
	}

	// game_menu_getoptions
	void BaseChatArray_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		// these vars are used to help chat_face_speaker determine target
		CHAT_CURRENT_SPEAKER = EntityId(player);
		@CHAT_LAST_USED_MENU = player;

		if (CHAT_FACE_ON_USE)
			SetMoveDest(@player, 9999);

		if (!CHAT_MENU_ON)
			return;

		// these are provided to help encourage standardization among multiple NPCs
		if (CHAT_AUTO_HAIL)
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);
		}

		if (CHAT_AUTO_JOB)
		{
			menuItem.title = "Ask about Jobs";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}

		if (CHAT_AUTO_RUMOR)
		{
			menuItem.title = "Ask about Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_rumor";
			RegisterMenuItem(menuItem);
		}
	}

	// chat_add_text
	// <sequence_name> <text_line> [time] [anim] [event]
	void BaseChatArray_OnChatAddText(string sequenceName = "", string lineText = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "")
	{
		// dbg chat_add_text PARAM1 [ $left(PARAM2,10) ] PARAM3 PARAM4 PARAM5

		string convoDelays = sequenceName + "_DELAYS";

		string convoAnims = sequenceName + "_ANIMS";

		string convoEvents = sequenceName + "_EVENTS";

		string convoSounds = sequenceName + "_SOUNDS";

		string convArrayExists = GetArray(sequenceName, "0");

		if (Contains(convArrayExists, "[ERROR_NO_ARRAY]"))
		{
			DebugPrint("chat_add_text creating new array for " + sequenceName);
			ArrayCreate(sequenceName);
			ArrayCreate(convoDelays);
			ArrayCreate(convoAnims);
			ArrayCreate(convoEvents);
			ArrayCreate(convoSounds);
		}

		string chatDelay = displayTime;
		if (chatDelay.isEmpty())
			chatDelay = Text(CHAT_DELAY);

		string chatAnim = animation;
		if (chatAnim.isEmpty())
			chatAnim = "none";

		string chatEvent = eventName;
		if (chatEvent.isEmpty())
			chatEvent = "none";

		string chatSound = "none";
		if (StartsWith(displayTime, "sound:"))
			chatSound = displayTime;
		if (StartsWith(animation, "sound:"))
			chatSound = animation;
		if (StartsWith(eventName, "sound:"))
			chatSound = eventName;
		if (StartsWith(sound, "sound:"))
			chatSound = sound;
		if (StartsWith(sound2, "sound:"))
			chatSound = sound2;
		if (StartsWith(sound3, "sound:"))
			chatSound = sound3;
		if (chatSound != "none")
		{
			float soundLength = int(chatSound.length()) - 6.0f;
			chatSound = Right(chatSound, int(soundLength));
			DebugPrint("chat_add_text SOUND: " + chatSound);
		}

		ArrayAdd(sequenceName, lineText);
		ArrayAdd(convoDelays, chatDelay);
		ArrayAdd(convoAnims, chatAnim);
		ArrayAdd(convoEvents, chatEvent);
		ArrayAdd(convoSounds, chatSound);

		// debugarry
		float arrayIdx = GetArrayCount(sequenceName) - 1.0f;
		string dbgTxt = GetArray(sequenceName, Text(arrayIdx));
		DebugPrint("chat_add_text final " + sequenceName + " step " + Text(arrayIdx) + " txt[ " + Left(dbgTxt, 11) + " ] del " + GetArray(convoDelays, Text(arrayIdx)) + " anim " + GetArray(convoAnims, Text(arrayIdx)) + " event " + GetArray(convoEvents, Text(arrayIdx)));
	}

	// chat_start_sequence
	// <sequence_name> ["clear_que"] ["prioritize"] ["add_to_que"]
	void BaseChatArray_OnChatStartSequence(string sequenceName = "", string option = "", string option2 = "", string option3 = "")
	{
		bool clearQue = false;
		bool addToQue = false;
		bool exitSub = false;

		DebugPrint("chat_start_sequence " + sequenceName + " " + option);

		if (option == "clear_que")
			clearQue = true;
		if (option2 == "clear_que")
			clearQue = true;
		if (option3 == "clear_que")
			clearQue = true;

		if (option == "add_to_que")
			addToQue = true;
		if (option2 == "add_to_que")
			addToQue = true;
		if (option3 == "add_to_que")
			addToQue = true;

		// if ( CLEAR_QUE ) dbg clear_que set
		if (CHAT_RESET_ON_NEW)
			clearQue = true;

		if (CHAT_AUTO_FACE && !Truthy(GetVar("CHAT_TEMP_NO_AUTO_FACE")))
			OnChatFaceSpeaker();

		CHAT_ABORT = false; // just in case
		string convArrayExists = GetArray(sequenceName, "0");
		if (Contains(convArrayExists, "[ERROR_NO_ARRAY]"))
		{
			SayText("[ERROR] conversation " + sequenceName + " does not exist!");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!addToQue && CHAT_BUSY)
		{
			if (clearQue)
				OnNpcChatWasBusy("started_new");
			if (!clearQue)
			{
				if (CHAT_IGNORE_WHILE_BUSY)
				{
					DebugPrint("chat_start_sequence: Attempted to start new chat ( " + sequenceName + " ) while already in conversation and ignore flag set");
					OnNpcChatWasBusy("ignored");
					exitSub = true;
				}
				else
				{
					OnNpcChatWasBusy("added");
				}
			}
		}
		if (exitSub)
			return;

		if (clearQue)
			OnChatClearQue("chat_start_sequence");

		if (option == "prioritize")
			CHAT_IGNORE_WHILE_BUSY = true;
		if (option2 == "prioritize")
			CHAT_IGNORE_WHILE_BUSY = true;
		if (option3 == "prioritize")
			CHAT_IGNORE_WHILE_BUSY = true;
		if (CHAT_NEVER_INTERRUPT)
			CHAT_IGNORE_WHILE_BUSY = true;

		CHAT_SEQUENCE = sequenceName;
		CHAT_LINES_ANAME = sequenceName;
		CHAT_DELAYS_ANAME = sequenceName + "_DELAYS";
		CHAT_ANIMS_ANAME = sequenceName + "_ANIMS";
		CHAT_EVENTS_ANAME = sequenceName + "_EVENTS";
		CHAT_SOUNDS_ANAME = sequenceName + "_SOUNDS";

		DebugPrint("requesting_que " + GetArrayCount(CHAT_LINES_ANAME) + " lines");
		int count = GetArrayCount(CHAT_LINES_ANAME);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnChatAddToQue();
		}

		if (!CHAT_QUE_ACTIVE)
		{
			CHAT_QUE_ACTIVE = true;
			OnChatCycleQue();
		}
	}

	// chat_convo_anim
	// { chat_load_sequence
	// local CUR_IDX game.script.iteration
	// array.add ARRAY_CHAT_LINES $get_array(CHAT_LINES_ANAME,CUR_IDX)
	// array.add ARRAY_CHAT_DELAYS $get_array(CHAT_DELAYS_ANAME,CUR_IDX)
	// array.add ARRAY_CHAT_ANIMS $get_array(CHAT_ANIMS_ANAME,CUR_IDX)
	// array.add ARRAY_CHAT_EVENTS $get_array(CHAT_EVENTS_ANAME,CUR_IDX)
	// //debugarry
	// local L_TXT $get_array(CHAT_LINES_ANAME,CUR_IDX)
	// dbg Reading In: ARRAY_CHAT_LINES # CUR_IDX - txt[ $left(L_TXT,11) ] del $get_array(CHAT_DELAYS_ANAME,CUR_IDX) anim $get_array(CHAT_ANIMS_ANAME,CUR_IDX) evt $get_array(CHAT_EVENTS_ANAME,CUR_IDX)
	// }
	void BaseChatArray_OnChatConvoAnim()
	{
		float nAnims = GetTokenCount(CHAT_CONV_ANIMS) - 1.0f;
		int rndAnim = RandomInt(0, int(nAnims));
		PlayAnim(CHAT_PLAYANIM_STYLE, GetToken(CHAT_CONV_ANIMS, rndAnim));
	}

	// chat_move_mouth
	// <time>
	void BaseChatArray_OnChatMoveMouth(string duration = "")
	{
		if (duration.isEmpty())
		{
			bool doNadda = true;
		}
		else
		{
			CHAT_END_MOVE_MOUTH = GameTime() + Float(duration) - 1.0f; // give sec for sentence to end
			DebugPrint("bchat_auto_mouth_move ( " + duration + " )");
		}

		if (GameTime() < CHAT_END_MOVE_MOUTH)
		{
			string rndSay = "[";
			float mTime = Random(0.1f, 0.3f);
			rndSay += Text(mTime) + "]";
			Say(rndSay);

			mTime += 0.1f;
			CallEventDelayed(mTime, "chat_close_mouth");
			mTime += 0.1f;
			CallEventDelayed(mTime, "chat_move_mouth");
		}
	}

	// chat_close_mouth
	void BaseChatArray_OnChatCloseMouth()
	{
		if (CHAT_NO_CLOSE_MOUTH) // some monsters express chat by shaking their spine controller - setting them to 0 may look odd, so use this in those cases
			return;
		SetProp(ENT_ME, "controller1", 0);
	}

	// chat_open_mouth
	// not used here in, but maybe useful externally
	void BaseChatArray_OnChatOpenMouth()
	{
		SetProp(ENT_ME, "controller1", -1);
	}

	// chat_face_speaker
	void BaseChatArray_OnChatFaceSpeaker(string speaker = "")
	{
		if (!speaker.isEmpty())
			CHAT_CURRENT_SPEAKER = speaker;
		else
			OnChatFindSpeakerId();
		SetMoveDest(CHAT_CURRENT_SPEAKER, 9999);
	}

	// chat_find_speaker_id
	void BaseChatArray_OnChatFindSpeakerId()
	{
		CBaseEntity@ lastSpoke = EntityOf(ENT_LASTSPOKE);
		if (IsAlive(lastSpoke))
		{
			if (RangeTo(lastSpoke) < 512.0f)
				CHAT_CURRENT_SPEAKER = EntityId(lastSpoke);
		}
		else if (IsAlive(CHAT_LAST_USED_MENU))
		{
			if (RangeTo(CHAT_LAST_USED_MENU) < 512.0f)
				CHAT_CURRENT_SPEAKER = EntityId(CHAT_LAST_USED_MENU);
		}
		else if (!IsAlive(CHAT_CURRENT_SPEAKER))
		{
			DebugPrint("failed to find speaker, wild guess");
			CHAT_CURRENT_SPEAKER = FindOneInSphere("player", 512);
		}
		else if (!IsAlive(CHAT_CURRENT_SPEAKER))
		{
			// final fail safe - unlesss there are no players on the server ^_^
			SetVar("PLAYER_LIST", GetActivePlayers());
			CHAT_CURRENT_SPEAKER = GetToken(GetVar("PLAYER_LIST"), 0);
		}
	}

	// chat_now
	// <text> [time] [anim|"none"] [event|"none"] ["clear_que"]
	void BaseChatArray_OnChatNow(string text = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "", string sound4 = "")
	{
		bool clearQue = false;
		bool addToQue = false;
		bool exitSub = false;

		// make up time, if not supplied
		if (displayTime.isEmpty())
		{
			int lineLength = int(text.length());
			if (lineLength > 100) {}
			float lineRatio = Divide(lineLength, 100.0f);
			displayTime = Text(Ratio(lineRatio, 1.5f, 6));
		}

		if (displayTime == "clear_que")
			clearQue = true;
		if (animation == "clear_que")
			clearQue = true;
		if (eventName == "clear_que")
			clearQue = true;
		if (CHAT_RESET_ON_NEW)
			clearQue = true;

		if (displayTime == "add_to_que")
			addToQue = true;
		if (animation == "add_to_que")
			addToQue = true;
		if (eventName == "add_to_que")
			addToQue = true;

		if (displayTime == "add_to_que")
			displayTime = "";
		if (animation == "add_to_que")
			animation = "";
		if (eventName == "add_to_que")
			eventName = "";
		if (displayTime == "clear_que")
			displayTime = "";
		if (animation == "clear_que")
			animation = "";
		if (eventName == "clear_que")
			eventName = "";

		string chatSound = "none";
		if (StartsWith(animation, "sound:"))
			chatSound = animation;
		if (StartsWith(eventName, "sound:"))
			chatSound = eventName;
		if (StartsWith(sound, "sound:"))
			chatSound = sound;
		if (StartsWith(sound2, "sound:"))
			chatSound = sound2;
		if (StartsWith(sound3, "sound:"))
			chatSound = sound3;
		if (StartsWith(sound4, "sound:"))
			chatSound = sound4;
		if (chatSound != "none")
		{
			float soundLength = int(chatSound.length()) - 6.0f;
			chatSound = LegacyFunction("mid", chatSound, 6, soundLength);
			DebugPrint(chatSound);
		}

		if (CHAT_AUTO_FACE && !Truthy(GetVar("CHAT_TEMP_NO_AUTO_FACE")))
			OnChatFaceSpeaker();

		if (!addToQue && CHAT_BUSY)
		{
			if (clearQue)
				OnNpcChatWasBusy("started_new");
			if (!clearQue)
			{
				if (CHAT_IGNORE_WHILE_BUSY)
				{
					DebugPrint("chat_now: Attempted to start new chat ( " + text + " ) while already in conversation and Ignore flag set");
					OnNpcChatWasBusy("ignored");
					exitSub = true;
				}
				else
				{
					OnNpcChatWasBusy("added");
				}
			}
		}
		if (exitSub)
			return;

		if (clearQue)
			OnChatClearQue("chat_now");

		string chatDelay = displayTime;
		if (chatDelay.isEmpty())
			chatDelay = Text(CHAT_DELAY);

		string chatAnim = animation;
		if (chatAnim.isEmpty())
			chatAnim = "none";

		string chatEvent = eventName;
		if (chatEvent.isEmpty())
			chatEvent = "none";

		ArrayAdd("CONVO_QUE_LINES", text);
		ArrayAdd("CONVO_QUE_DELAYS", chatDelay);
		ArrayAdd("CONVO_QUE_ANIMS", chatAnim);
		ArrayAdd("CONVO_QUE_EVENTS", chatEvent);
		ArrayAdd("CONVO_QUE_SOUNDS", chatSound);

		if (!CHAT_QUE_ACTIVE)
		{
			CHAT_QUE_ACTIVE = true;
			OnChatCycleQue();
		}
	}

	// chat_pause
	void BaseChatArray_OnChatPause()
	{
		CHAT_QUE_ACTIVE = false;
	}

	// chat_resume
	void BaseChatArray_OnChatResume()
	{
		if (!CHAT_QUE_ACTIVE)
		{
			CHAT_QUE_ACTIVE = true;
			OnChatCycleQue();
		}
	}

	// game_death
	void BaseChatArray_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!CHAT_BUSY)
			return;
		OnChatPause();
	}

	// ext_dump_chat
	// debuggary
	// <chat sequence>
	void BaseChatArray_OnExtDumpChat(string chatSequence = "")
	{
		DUMP_CONVO = chatSequence;
		int count = GetArrayCount(DUMP_CONVO);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDumpChat();
		}
	}

	// dump_chat
	void BaseChatArray_OnDumpChat()
	{
		int curIdx = loopIteration;
		string curLinesAname = DUMP_CONVO;
		string curDelays = DUMP_CONVO + "_DELAYS";
		string curAnims = DUMP_CONVO + "_ANIMS";
		string curEvents = DUMP_CONVO + "_EVENTS";
		string curSounds = DUMP_CONVO + "_SOUNDS";

		string curText = GetArray(curLinesAname, Text(curIdx));
		string curDelay = GetArray(curDelays, Text(curIdx));
		string curAnim = GetArray(curAnims, Text(curIdx));
		string curEvent = GetArray(curEvents, Text(curIdx));
		string curSound = GetArray(curSounds, Text(curIdx));

		DebugPrint("dump " + DUMP_CONVO + " # " + curIdx + " txt[ " + Left(curText, 11) + " ] del " + curDelay + " anim " + curAnim + " evt " + curEvent + " snd " + curSound);
	}

	// chat_add_to_que
	void BaseChatArray_OnChatAddToQue()
	{
		int curIdx = loopIteration;

		string curLine = GetArray(CHAT_LINES_ANAME, Text(curIdx));
		string curDelay = GetArray(CHAT_DELAYS_ANAME, Text(curIdx));
		string curAnim = GetArray(CHAT_ANIMS_ANAME, Text(curIdx));
		string curEvent = GetArray(CHAT_EVENTS_ANAME, Text(curIdx));
		string curSound = GetArray(CHAT_SOUNDS_ANAME, Text(curIdx));

		DebugPrint("chat_add_to_que: " + curIdx + " [ " + Left(curLine, 20) + " ... ]");

		ArrayAdd("CONVO_QUE_LINES", curLine);
		ArrayAdd("CONVO_QUE_DELAYS", curDelay);
		ArrayAdd("CONVO_QUE_ANIMS", curAnim);
		ArrayAdd("CONVO_QUE_EVENTS", curEvent);
		ArrayAdd("CONVO_QUE_SOUNDS", curSound);
	}

	// chat_clear_que
	// [calling_event]
	void BaseChatArray_OnChatClearQue(string callingEvent = "")
	{
		DebugPrint("chat_clear_que called from " + callingEvent);
		// local QUE_SIZE $get_array_amt(CONVO_QUE_LINES)
		// if QUE_SIZE > 0
		CHAT_SPOOL_OUT_ALL_COUNT = GetArrayCount("CONVO_QUE_LINES");
		OnChatClearQueLoop();
	}

	// chat_clear_que_loop
	void BaseChatArray_OnChatClearQueLoop()
	{
		CHAT_SPOOL_OUT_COUNT = 0.0f;
		OnSpoolOutLine();
		CHAT_SPOOL_OUT_ALL_COUNT -= 1.0f;
		if (!(CHAT_SPOOL_OUT_ALL_COUNT > 0.0f))
			return;
		CallEventDelayed(0.26f, "chat_clear_que_loop");
	}

	// chat_cycle_que
	void BaseChatArray_OnChatCycleQue()
	{
		bool exitSub = false;
		int curDelay;
		string curDelayText;

		if (!CHAT_QUE_ACTIVE)
			return;

		if (GetArrayCount("CONVO_QUE_LINES") == 0)
		{
			// que is dry, exit
			CHAT_BUSY = false;
			CHAT_QUE_ACTIVE = false;
			CHAT_IGNORE_WHILE_BUSY = false;
			exitSub = true;
		}
		else
		{
			curDelayText = GetArray("CONVO_QUE_DELAYS", "0");
			curDelay = Int(curDelayText);
			CHAT_END_TIME = GameTime() + curDelay;

			float chatEndPlus = curDelay;
			string chatEndPlusText;
			chatEndPlus += 0.1f;
			if (chatEndPlus < 1.0f) // make sure chat has time to spool
				chatEndPlus = 1.0f;
			CallEventDelayed(chatEndPlus, "chat_cycle_que");
		}
		if (exitSub)
			return;

		// do current line in que
		// if game.time > CHAT_END_TIME
		// not redundant, as we may be on the last line
		curDelayText = GetArray("CONVO_QUE_DELAYS", "0");
		curDelay = Int(curDelayText);
		CHAT_END_TIME = GameTime() + curDelay;

		// dbg chat_cycle_que $get_array_amt(CONVO_QUE_LINES) lines in que
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string curText = GetArray("CONVO_QUE_LINES", "0");
			string curDelayValue = GetArray("CONVO_QUE_DELAYS", "0");
			string curAnim = GetArray("CONVO_QUE_ANIMS", "0");
			string curEvent = GetArray("CONVO_QUE_EVENTS", "0");
			string curSound = GetArray("CONVO_QUE_SOUNDS", "0");
			DebugPrint("chat_cycle_que line# " + GetArrayCount("CONVO_QUE_LINES") + " txt [ " + Left(curText, 11) + " ] delay " + curDelayValue + " anim " + curAnim + " evnt " + curEvent + " snd " + curSound);
		}

		string curLine = GetArray("CONVO_QUE_LINES", "0");
		float curLen = int(curLine.length()) + int(Eval("game.monster.name").length()) + 6.0f; // " says,"

		if (curLen < CHAT_MAX_LINE_LEN)
			SayText(curLine);
		else
			SayText("[ERROR: LINE TOO LONG!] [ " + CHAT_LINES_ANAME + " " + int(curLen) + " / " + CHAT_MAX_LINE_LEN + " ]");

		CHAT_BUSY = true;

		string curAnimValue = GetArray("CONVO_QUE_ANIMS", "0");
		if (curAnimValue != "none")
		{
			if (curAnimValue != "no_convo")
				PlayAnim(CHAT_PLAYANIM_STYLE, curAnimValue);
		}
		else if (CHAT_USE_CONV_ANIMS)
			OnChatConvoAnim();

		string curSoundValue = GetArray("CONVO_QUE_SOUNDS", "0");
		if (curSoundValue != "none")
			PlaySound(0, 10, curSoundValue);

		string curEventValue = GetArray("CONVO_QUE_EVENTS", "0");
		if (curEventValue != "none")
		{
			DebugPrint("calling chat_event " + curEventValue);
			if (StartsWith(curEventValue, "!"))
			{
				// do event on chat step, instead of end of chat step
				float lenCurEvent = int(curEventValue.length()) - 1.0f;
				curEventValue = Right(curEventValue, int(lenCurEvent));
				CallEventOrDelay(curEventValue);
			}
			else
			{
				CallEventDelayed(curDelay, curEventValue);
			}
		}

		if (CHAT_MOVE_MOUTH)
			OnChatMoveMouth(curDelayText);

		// remove line from que
		CHAT_SPOOL_OUT_COUNT = 0.0f;
		OnSpoolOutLine();
	}

	// spool_out_line
	void BaseChatArray_OnSpoolOutLine()
	{
		CHAT_SPOOL_OUT_COUNT += 1.0f;
		if (CHAT_SPOOL_OUT_COUNT == 1.0f)
			ArrayRemoveAt("CONVO_QUE_LINES", 0);
		if (CHAT_SPOOL_OUT_COUNT == 2.0f)
			ArrayRemoveAt("CONVO_QUE_DELAYS", 0);
		if (CHAT_SPOOL_OUT_COUNT == 3.0f)
			ArrayRemoveAt("CONVO_QUE_ANIMS", 0);
		if (CHAT_SPOOL_OUT_COUNT == 4.0f)
			ArrayRemoveAt("CONVO_QUE_EVENTS", 0);
		if (CHAT_SPOOL_OUT_COUNT == 5.0f)
			ArrayRemoveAt("CONVO_QUE_SOUNDS", 0);
		if (!(CHAT_SPOOL_OUT_COUNT < 5.0f))
			return;
		CallEventDelayed(0.05f, "spool_out_line");
	}

	// npc_chat_was_busy
	void BaseChatArray_OnNpcChatWasBusy(string status = "")
	{
		DebugPrint("npc_chat_was_busy " + status);
		if (!CHAT_USE_BUSY_MESSAGE)
			return;
		if (status != "ignored")
			return;
		OnChatBusyMessage();
	}

	// chat_busy_message
	void BaseChatArray_OnChatBusyMessage()
	{
		if (!IsAlive(CHAT_CURRENT_SPEAKER))
			OnChatFindSpeakerId();
		PlayerMessageDark(CHAT_CURRENT_SPEAKER, "It would be polite to wait until " + NameOf(ENT_ME) + " has finished speaking.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseChatArray_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseChatArray_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnChatAddText(string sequenceName = "", string lineText = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "") { BaseChatArray_OnChatAddText(sequenceName, lineText, displayTime, animation, eventName, sound, sound2, sound3); } // chat_add_text
	void OnChatStartSequence(string sequenceName = "", string option = "", string option2 = "", string option3 = "") { BaseChatArray_OnChatStartSequence(sequenceName, option, option2, option3); } // chat_start_sequence
	void OnChatConvoAnim() { BaseChatArray_OnChatConvoAnim(); } // chat_convo_anim
	void OnChatMoveMouth(string duration = "") { BaseChatArray_OnChatMoveMouth(duration); } // chat_move_mouth
	void OnChatCloseMouth() { BaseChatArray_OnChatCloseMouth(); } // chat_close_mouth
	void OnChatOpenMouth() { BaseChatArray_OnChatOpenMouth(); } // chat_open_mouth
	void OnChatFaceSpeaker(string speaker = "") { BaseChatArray_OnChatFaceSpeaker(speaker); } // chat_face_speaker
	void OnChatFindSpeakerId() { BaseChatArray_OnChatFindSpeakerId(); } // chat_find_speaker_id
	void OnChatNow(string text = "", string displayTime = "", string animation = "", string eventName = "", string sound = "", string sound2 = "", string sound3 = "", string sound4 = "") { BaseChatArray_OnChatNow(text, displayTime, animation, eventName, sound, sound2, sound3, sound4); } // chat_now
	void OnChatPause() { BaseChatArray_OnChatPause(); } // chat_pause
	void OnChatResume() { BaseChatArray_OnChatResume(); } // chat_resume
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnExtDumpChat(string chatSequence = "") { BaseChatArray_OnExtDumpChat(chatSequence); } // ext_dump_chat
	void OnDumpChat() { BaseChatArray_OnDumpChat(); } // dump_chat
	void OnChatAddToQue() { BaseChatArray_OnChatAddToQue(); } // chat_add_to_que
	void OnChatClearQue(string callingEvent = "") { BaseChatArray_OnChatClearQue(callingEvent); } // chat_clear_que
	void OnChatClearQueLoop() { BaseChatArray_OnChatClearQueLoop(); } // chat_clear_que_loop
	void OnChatCycleQue() { BaseChatArray_OnChatCycleQue(); } // chat_cycle_que
	void OnSpoolOutLine() { BaseChatArray_OnSpoolOutLine(); } // spool_out_line
	void OnNpcChatWasBusy(string status = "") { BaseChatArray_OnNpcChatWasBusy(status); } // npc_chat_was_busy
	void OnChatBusyMessage() { BaseChatArray_OnChatBusyMessage(); } // chat_busy_message
	void OnCurDelay() {} // CUR_DELAY
	void OnCurEvent() {} // CUR_EVENT
	void OnLChatEndPlus() {} // L_CHAT_END_PLUS
	void OnMTime() {} // M_TIME

	// This file's events and timers by their .script names
	bool BaseChatArray_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chat_add_text") { OnChatAddText(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "chat_add_to_que") { OnChatAddToQue(); return true; }
		if (name == "chat_busy_message") { OnChatBusyMessage(); return true; }
		if (name == "chat_clear_que") { OnChatClearQue(Param(params, 0)); return true; }
		if (name == "chat_clear_que_loop") { OnChatClearQueLoop(); return true; }
		if (name == "chat_close_mouth") { OnChatCloseMouth(); return true; }
		if (name == "chat_convo_anim") { OnChatConvoAnim(); return true; }
		if (name == "chat_cycle_que") { OnChatCycleQue(); return true; }
		if (name == "chat_face_speaker") { OnChatFaceSpeaker(Param(params, 0)); return true; }
		if (name == "chat_find_speaker_id") { OnChatFindSpeakerId(); return true; }
		if (name == "chat_move_mouth") { OnChatMoveMouth(Param(params, 0)); return true; }
		if (name == "chat_now") { OnChatNow(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "chat_open_mouth") { OnChatOpenMouth(); return true; }
		if (name == "chat_pause") { OnChatPause(); return true; }
		if (name == "chat_resume") { OnChatResume(); return true; }
		if (name == "chat_start_sequence") { OnChatStartSequence(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "dump_chat") { OnDumpChat(); return true; }
		if (name == "ext_dump_chat") { OnExtDumpChat(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_chat_was_busy") { OnNpcChatWasBusy(Param(params, 0)); return true; }
		if (name == "spool_out_line") { OnSpoolOutLine(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_chat_array"]
shared class BaseChatArrayScript : ScriptEntity, BaseChatArray
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseChatArray_DispatchEvent(name, params);
	}
}
