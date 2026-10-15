#pragma context server

// Converted from monsters/base_chat.script by msc_transpiler.
// generic chat menu options
// EXAMPLE USAGE
// setvard CHAT_STEPS 3 //number of chat steps
// setvard ANIM_STEP1 panic //animation to play on first step
// setvard CHAT_STEP1 "Wow, this base_chat thing sure is complicated!" //sentence to use on first step
// setvard CHAT_STEP2 "I guess..."
// setvard CHAT_STEP_DELAY2 2.0	//custom delay for second step
// setvard CHAT_STEP3 "I mean, it sure has evolved over the years."
// callevent chat_loop
// - other useful events and vars
// callevent convo_anim //plays a scientist-model compatible conversation animation from the token list stored below in CONVO_ANIMS (you can override this string for use with other models)
// callevent bchat_mouth_move //moves the model's mouth, if it has the proper controller (causes other models to wiggle a little, which sometimes works nearly as well)
// callevent bchat_auto_mouth_move <seconds> //as above but moves mouth for X seconds
// callevent bchat_open_mouth //opens mouth and leaves it open
// callevent bchat_open_close //closes mouth
// CHAT_EVENT_STEPX - Call this event when finished speaking this step text
// - default behavior
// base_chat registers "say_hi" "say_jobs" and "say_rumors" callbacks on the interaction menu
// these can be disabled by setting NO_HAIL, NO_JOB, NO_RUMOR, to 1, as desired
// (this was to more quickly uniform the chat menu amongst existing NPC's when it was first implemented.)
// CHAT_DELAY contains the default pause between sentences. The default value is 3 seconds.
// Note: You can use single-quotes when setting vars (') but not double (") except to deliniate.
// Base_Chat also handles christmas event text/music and the bloodstone ring quest is centralized here

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseChat
{
	// Constants
	string CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;";
	float CHAT_DELAY = 3.0f;
	string RQUEST_NAMES = "0;Galan;Narad;Darrelin;Rudolf;Vadrel;Edrin;Thordac;Slinker;Slinker;Gerald;Mosor;Cathain;";

	// Variables (an unset .script variable reads as its own name)
	bool HAS_BASE_CHAT_INCLUDE = true;
	bool BUSY_CHATTING = false;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string ANIM_STEP1 = "ANIM_STEP1";
	string CHAT_EVENT_STEP1 = "CHAT_EVENT_STEP1";
	string CHAT_SOUND1 = "CHAT_SOUND1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string ANIM_STEP2 = "ANIM_STEP2";
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	string CHAT_SOUND2 = "CHAT_SOUND2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string ANIM_STEP3 = "ANIM_STEP3";
	string CHAT_EVENT_STEP3 = "CHAT_EVENT_STEP3";
	string CHAT_SOUND3 = "CHAT_SOUND3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string ANIM_STEP4 = "ANIM_STEP4";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	string CHAT_SOUND4 = "CHAT_SOUND4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string ANIM_STEP5 = "ANIM_STEP5";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
	string CHAT_SOUND5 = "CHAT_SOUND5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
	string ANIM_STEP6 = "ANIM_STEP6";
	string CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
	string CHAT_SOUND6 = "CHAT_SOUND6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
	string ANIM_STEP7 = "ANIM_STEP7";
	string CHAT_EVENT_STEP7 = "CHAT_EVENT_STEP7";
	string CHAT_SOUND7 = "CHAT_SOUND7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
	string ANIM_STEP8 = "ANIM_STEP8";
	string CHAT_EVENT_STEP8 = "CHAT_EVENT_STEP8";
	string CHAT_SOUND8 = "CHAT_SOUND8";
	string CHAT_STEP9 = "CHAT_STEP9";
	string CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
	string ANIM_STEP9 = "ANIM_STEP9";
	string CHAT_EVENT_STEP9 = "CHAT_EVENT_STEP9";
	string CHAT_SOUND9 = "CHAT_SOUND9";
	string CHAT_STEP10 = "CHAT_STEP10";
	string CHAT_DELAY_STEP10 = "CHAT_DELAY_STEP10";
	string ANIM_STEP10 = "ANIM_STEP10";
	string CHAT_EVENT_STEP10 = "CHAT_EVENT_STEP10";
	string CHAT_SOUND10 = "CHAT_SOUND10";
	float BC_TOTAL_MOUTH_TIME = 0.0f;
	float BC_END_AUTO_MOUTH_MOVE = 0.0f;
	int CHAT_STEPS = 0;
	bool TRADE_RING = false;

	// unnamed block (first think)
	void BaseChat_FirstThink()
	{
		HAS_BASE_CHAT_INCLUDE = true;
	}

	// game_spawn
	void BaseChat_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void BaseChat_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		DebugPrint("base_chat game_menu_getoptions");

		if (GetVar("CAN_CHAT") == "0")
			return;
		if (Truthy(GetVar("NO_CHAT")))
			return;

		OnBchatBeforeMenus();

		if (!Truthy(GetVar("NO_HAIL")))
		{
			DebugPrint("base_chat reghail");
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);
		}

		if (!Truthy(GetVar("NO_JOB")))
		{
			DebugPrint("base_chat regjob");
			menuItem.title = "Ask about Jobs";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}

		if (!Truthy(GetVar("NO_RUMOR")))
		{
			DebugPrint("base_chat regrumor");
			menuItem.title = "Ask about Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_rumor";
			RegisterMenuItem(menuItem);
		}

		// dbg $item_exists(PARAM1,item_ring)
		DebugPrint("game_menu_getoptions Ring Check");

		if (IsPlayer(player) && Truthy(ItemExists(player, "item_ring")))
		{
			string rquestStageText = GetQuestData(player, "r");
			int rquestStage = Int(rquestStageText);
			if (rquestStage >= 1)
			{
				string rquestName = GetToken(RQUEST_NAMES, rquestStage);
				if (Contains(Eval("game.monster.name"), rquestName))
				{
					// set this to 1 if npc has a quest, then to 0 when completed
					if (Float(GetVar("REQ_QUEST_NOTDONE")) == 1.0f)
					{
						menuItem.title = "Ask about the ring";
						menuItem.type = "callback";
						menuItem.data = rquestStageText;
						menuItem.callback = "rquest_rub_my_back_first";
						RegisterMenuItem(menuItem);
					}
					if (!Truthy(GetVar("REQ_QUEST_NOTDONE")))
					{
						menuItem.title = "Ask about the ring";
						menuItem.type = "callback";
						menuItem.data = rquestStageText;
						menuItem.callback = "give_runaround";
						RegisterMenuItem(menuItem);
					}
				}
			}
		}

		OnBchatAfterMenus();

		DebugPrint("game_menu_getoptions Post Ring Check");
	}

	// say_rumor
	void BaseChat_OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
	}

	// face_speaker
	void BaseChat_OnFaceSpeaker(string speaker = "")
	{
		SetMoveDest(speaker, 9999);
	}

	// chat_loop
	void BaseChat_OnChatLoop()
	{
		string chatSound = "L_CHAT_SOUND";
		string chatEvent = "L_CHAT_EVENT";
		bool noAnim = false;
		bool noEvent = false;
		bool noSound = false;

		if (!BUSY_CHATTING)
		{
			BUSY_CHATTING = true;
			CHAT_STEP = 0.0f;
		}
		CHAT_STEP += 1.0f;
		if (CHAT_STEP == CHAT_STEPS)
		{
			BUSY_CHATTING = false;
			OnNpcChatDone(); // for external events
		}
		if (!(CHAT_STEP <= CHAT_STEPS))
			return;

		string anim = "none";
		string chatDelay = Text(CHAT_DELAY);
		string chatText = "none";

		if (CHAT_STEP == 1.0f)
		{
			chatText = CHAT_STEP1;
			anim = ANIM_STEP1;
			chatDelay = CHAT_DELAY_STEP1;
			chatSound = CHAT_SOUND1;
			CHAT_STEP1 = "CHAT_STEP1";
			CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
			ANIM_STEP1 = "ANIM_STEP1";
			chatEvent = CHAT_EVENT_STEP1;
			CHAT_EVENT_STEP1 = "CHAT_EVENT_STEP1";
			CHAT_SOUND1 = "CHAT_SOUND1";
		}
		if (CHAT_STEP == 2.0f)
		{
			chatText = CHAT_STEP2;
			anim = ANIM_STEP2;
			chatDelay = CHAT_DELAY_STEP2;
			chatSound = CHAT_SOUND2;
			CHAT_STEP2 = "CHAT_STEP2";
			CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
			ANIM_STEP2 = "ANIM_STEP2";
			chatEvent = CHAT_EVENT_STEP2;
			CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
			CHAT_SOUND2 = "CHAT_SOUND2";
		}
		if (CHAT_STEP == 3.0f)
		{
			chatText = CHAT_STEP3;
			anim = ANIM_STEP3;
			chatDelay = CHAT_DELAY_STEP3;
			chatSound = CHAT_SOUND3;
			CHAT_STEP3 = "CHAT_STEP3";
			CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
			ANIM_STEP3 = "ANIM_STEP3";
			chatEvent = CHAT_EVENT_STEP3;
			CHAT_EVENT_STEP3 = "CHAT_EVENT_STEP3";
			CHAT_SOUND3 = "CHAT_SOUND3";
		}
		if (CHAT_STEP == 4.0f)
		{
			chatText = CHAT_STEP4;
			anim = ANIM_STEP4;
			chatDelay = CHAT_DELAY_STEP4;
			chatSound = CHAT_SOUND4;
			CHAT_STEP4 = "CHAT_STEP4";
			CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
			ANIM_STEP4 = "ANIM_STEP4";
			chatEvent = CHAT_EVENT_STEP4;
			CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
			CHAT_SOUND4 = "CHAT_SOUND4";
		}
		if (CHAT_STEP == 5.0f)
		{
			chatText = CHAT_STEP5;
			anim = ANIM_STEP5;
			chatDelay = CHAT_DELAY_STEP5;
			chatSound = CHAT_SOUND5;
			CHAT_STEP5 = "CHAT_STEP5";
			CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
			ANIM_STEP5 = "ANIM_STEP5";
			chatEvent = CHAT_EVENT_STEP5;
			CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
			CHAT_SOUND5 = "CHAT_SOUND5";
		}
		if (CHAT_STEP == 6.0f)
		{
			chatText = CHAT_STEP6;
			anim = ANIM_STEP6;
			chatDelay = CHAT_DELAY_STEP6;
			chatSound = CHAT_SOUND6;
			CHAT_STEP6 = "CHAT_STEP6";
			CHAT_DELAY_STEP6 = "CHAT_DELAY_STEP6";
			ANIM_STEP6 = "ANIM_STEP6";
			chatEvent = CHAT_EVENT_STEP6;
			CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
			CHAT_SOUND6 = "CHAT_SOUND6";
		}
		if (CHAT_STEP == 7.0f)
		{
			chatText = CHAT_STEP7;
			anim = ANIM_STEP7;
			chatDelay = CHAT_DELAY_STEP7;
			chatSound = CHAT_SOUND7;
			CHAT_STEP7 = "CHAT_STEP7";
			CHAT_DELAY_STEP7 = "CHAT_DELAY_STEP7";
			ANIM_STEP7 = "ANIM_STEP7";
			chatEvent = CHAT_EVENT_STEP7;
			CHAT_EVENT_STEP7 = "CHAT_EVENT_STEP7";
			CHAT_SOUND7 = "CHAT_SOUND7";
		}
		if (CHAT_STEP == 8.0f)
		{
			chatText = CHAT_STEP8;
			anim = ANIM_STEP8;
			chatDelay = CHAT_DELAY_STEP8;
			chatSound = CHAT_SOUND8;
			CHAT_STEP8 = "CHAT_STEP8";
			CHAT_DELAY_STEP8 = "CHAT_DELAY_STEP8";
			ANIM_STEP8 = "ANIM_STEP8";
			chatEvent = CHAT_EVENT_STEP8;
			CHAT_EVENT_STEP8 = "CHAT_EVENT_STEP8";
			CHAT_SOUND8 = "CHAT_SOUND8";
		}
		if (CHAT_STEP == 9.0f)
		{
			chatText = CHAT_STEP9;
			anim = ANIM_STEP9;
			chatDelay = CHAT_DELAY_STEP9;
			chatSound = CHAT_SOUND9;
			CHAT_STEP9 = "CHAT_STEP9";
			CHAT_DELAY_STEP9 = "CHAT_DELAY_STEP9";
			ANIM_STEP9 = "ANIM_STEP9";
			chatEvent = CHAT_EVENT_STEP9;
			CHAT_EVENT_STEP9 = "CHAT_EVENT_STEP9";
			CHAT_SOUND9 = "CHAT_SOUND9";
		}
		if (CHAT_STEP == 10.0f)
		{
			chatText = CHAT_STEP10;
			anim = ANIM_STEP10;
			chatDelay = CHAT_DELAY_STEP10;
			chatSound = CHAT_SOUND10;
			CHAT_STEP10 = "CHAT_STEP10";
			CHAT_DELAY_STEP10 = "CHAT_DELAY_STEP10";
			ANIM_STEP10 = "ANIM_STEP10";
			chatEvent = CHAT_EVENT_STEP10;
			CHAT_EVENT_STEP10 = "CHAT_EVENT_STEP10";
			CHAT_SOUND10 = "CHAT_SOUND10";
		}

		if (StartsWith(anim, "ANIM_STEP"))
			noAnim = true;
		if (!noAnim)
			PlayAnim("critical", anim);

		SayText(chatText);

		if (StartsWith(chatDelay, "CHAT_DELAY_STEP"))
			chatDelay = Text(CHAT_DELAY);
		if (StartsWith(chatEvent, "CHAT_EVENT_STEP"))
			noEvent = true;
		if (!noEvent)
			CallEventOrDelay(chatDelay, chatEvent);

		if (StartsWith(chatSound, "CHAT_SOUND"))
			noSound = true;
		if (!noSound && chatSound != "none")
			PlaySound(0, 10, chatSound);

		if (!Truthy(GetVar("NO_MOUTH_MOVE")))
			OnBchatAutoMouthMove(chatDelay);

		if (!(CHAT_STEP < CHAT_STEPS))
			return;
		CallEventOrDelay(chatDelay, "chat_loop");
	}

	// bchat_mouth_move
	void BaseChat_OnBchatMouthMove()
	{
		BC_TOTAL_MOUTH_TIME = 0.0f;

		string rndSay1 = "[";
		float mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay1 += Text(mTime) + "]";

		string rndSay2 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay2 += Text(mTime) + "]";

		string rndSay3 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay3 += Text(mTime) + "]";

		string rndSay4 = "[";
		mTime = Random(0.1f, 0.3f);
		BC_TOTAL_MOUTH_TIME += mTime;
		rndSay4 += Text(mTime) + "]";

		Say(rndSay1, rndSay2, rndSay3, rndSay4);
		BC_TOTAL_MOUTH_TIME += 1.0f;
		CallEventDelayed(BC_TOTAL_MOUTH_TIME, "bchat_close_mouth");
	}

	// bchat_auto_mouth_move
	// <sentence_time> just keep moving mouth until sentence ends based on delay (looks better than pure random)
	void BaseChat_OnBchatAutoMouthMove(string sentenceTime = "")
	{
		if (sentenceTime.isEmpty())
		{
		}
		else
		{
			// do nadda
			// dbg ERROR: bchat_auto_mouth_move called without delay
			BC_END_AUTO_MOUTH_MOVE = GameTime() + Float(sentenceTime) - 1.0f; // give sec for sentence to end
		}

		// dbg bchat_auto_mouth_move ( PARAM1 )
		// if ( game.time < BC_END_AUTO_MOUTH_MOVE )
		// {
		// local RND_SAY "["
		// local M_TIME $randf(0.1,0.3)
		// stradd RND_SAY M_TIME
		// stradd RND_SAY "]"
		// say RND_SAY
		// callevent M_TIME bchat_auto_mouth_move
		// }
		// else
		// {
		// callevent 2.0 bchat_close_mouth
		// }
		if (GameTime() < BC_END_AUTO_MOUTH_MOVE)
		{
			string rndSay = "[";
			float mTime = Random(0.1f, 0.3f);
			rndSay += Text(mTime) + "]";
			Say(rndSay);

			mTime += 0.1f;
			CallEventDelayed(mTime, "bchat_close_mouth");
			mTime += 0.1f;
			CallEventDelayed(mTime, "bchat_auto_mouth_move");
		}
	}

	// bchat_mouth_twitch
	void BaseChat_OnBchatMouthTwitch()
	{
		float rndDist = Random(-1, 0);
		DebugPrint("bchat_mouth_twitch " + Text(rndDist));
		SetProp(ENT_ME, "controller1", rndDist);
	}

	// bchat_close_mouth
	void BaseChat_OnBchatCloseMouth()
	{
		if (Truthy(GetVar("NO_CLOSE_MOUTH"))) // some monsters express chat by shaking their spine controller - setting them to 0 may look odd, so use this in those cases
			return;
		SetProp(ENT_ME, "controller1", 0);
	}

	// bchat_open_mouth
	// not used here in, but maybe useful externally
	void BaseChat_OnBchatOpenMouth()
	{
		SetProp(ENT_ME, "controller1", -1);
	}

	// give_runaround
	void BaseChat_OnGiveRunaround(CBasePlayer@ player = null, string questStep = "")
	{
		if (BUSY_CHATTING)
			return;

		// Galan
		if (Float(questStep) == 1.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 4;
			CHAT_STEP1 = "My goodness, Olof sent you to me with this? It almost looks like one of those old bloodstone rings...";
			CHAT_STEP2 = "It's no good without the stone though. I remember Narad was saying he saw one once. They are very rare...";
			CHAT_STEP3 = "So it could be the same one. I don't remember WHERE he said he saw it though...";
			CHAT_STEP4 = "You can find him over in Daragoth, on the outskirts of Deralia. Provided the orcs and spiders haven't killed him.";
			OnChatLoop();
			Quest("set", player, "r", 2);
		}
		// Narad
		if (Float(questStep) == 2.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Oh, yeah, I've seen that ring before... In a play I believe... A famous actor had it...";
			CHAT_STEP2 = "Darrelin, was his name, I believe. Last I heard he moved out by the orc caves to aid actors travelling to Gatecity.";
			OnChatLoop();
			Quest("set", player, "r", 3);
		}
		// Darrelin
		if (Float(questStep) == 3.0f)
		{
			PlaySound(0, 10, "voices/mscave/actor-bloodstone.wav");
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Ah... That ring looks familiar... It almost looks like Rudolf's old battle ring.";
			CHAT_STEP2 = "I think he's up by the old mines playing adventurer again. He's far too old for that...";
			OnChatLoop();
			Quest("set", player, "r", 4);
		}
		// Rudolf (sets in script)
		if (Float(questStep) == 4.0f)
		{
			SayText("Nice ring by the way! You know, I think Vadrel used to have one just like it!");
			SayText("If memory serves me right, he was stationed at some old outpost.");
		}
		// Vadrel
		if (Float(questStep) == 5.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Ah yes, an old warrior friend of mine had one of those, very useful if you have the stone that goes in it.";
			CHAT_STEP2 = "Edrin, his name was. I believe he's now captain of the guard in Edana. He might be able to help you with it.";
			OnChatLoop();
			Quest("set", player, "r", 6);
		}
		// Edrin
		if (Float(questStep) == 6.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Oh, one of those old golden bloodstone rings, too bad the stone has come out of it.";
			CHAT_STEP2 = "It looks a lot like the one Thordac forged and used to wear. You can find him in Deralia.";
			OnChatLoop();
			Quest("set", player, "r", 7);
		}
		// Thordac
		if (Float(questStep) == 7.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Oh, wow! That old thing, I've not seen it since I sold it of to...";
			CHAT_STEP2 = "Slinker! Yeah, that was his name. Slimey guy - still slinks about here somewhere...";
			OnChatLoop();
			Quest("set", player, "r", 9);
		}
		// Slinker - oops, had him twice, hence the numbering ^_^
		if (Float(questStep) == 9.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 2;
			CHAT_STEP1 = "Oh that old ring... Was handy for extort... I mean handy for business back in the day.";
			CHAT_SOUND1 = "voices/deralia/slinker_ring.wav";
			CHAT_DELAY_STEP1 = "7.0";
			CHAT_STEP2 = "I lost it in a card game with Gerald a looong time ago. He runs the inn now.";
			CHAT_DELAY_STEP2 = "5.8";
			OnChatLoop();
			Quest("set", player, "r", 10);
		}
		// Gerald
		if (Float(questStep) == 10.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 3;
			CHAT_STEP1 = "Ah that, I won it in card game, if I recall correctly... Lost it in another the next day.";
			CHAT_STEP2 = "Long time ago that was, yet somehow you remember these things...";
			CHAT_STEP3 = "Eh, it was that whino, Mosor, over there in the corner who won it. He might know something about it.";
			OnChatLoop();
			Quest("set", player, "r", 11);
		}
		// Mosor
		if (Float(questStep) == 11.0f)
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 4;
			CHAT_STEP1 = "Oh that old thing, not seen it in... Must be twenty seasons now... Before I took to the drink so hard.";
			CHAT_STEP2 = "Yeaah, shouldn't have parted with it. I traded it for some ale to Cathain, who made a lot of money off it.";
			CHAT_STEP3 = "Boxing, as I recall. Suppose you have to be a warrior to make real use of it. Too bad the stone's gone.";
			CHAT_STEP4 = "He's the Quartermaster of the local militia... Might find him in the barracks.";
			OnChatLoop();
			Quest("set", player, "r", 12);
		}
		// Cathain
		if (Float(questStep) == 12.0f && !Truthy(ItemExists(player, "item_ring_percept")))
		{
			CHAT_STEP = 0.0f;
			CHAT_STEPS = 5;
			SetMoveAnim("idle1");
			SetRoam(false);
			SetMoveDest(@player, 9999);
			CHAT_STEP1 = "Oh wow! I've not seen that thing since I was in the boxing circuit!";
			CHAT_STEP2 = "I used to use it to outlast my opponents, let me wear them down before I go in for the kill!";
			CHAT_STEP3 = "Oh, I'm far too old for that now though. Easier just to keep the recruits in line around here.";
			CHAT_STEP4 = "I still have the stone though... It broke off in a fight! Never saw where the ring went till now.";
			CHAT_STEP5 = "Tell ya what, you look like someone who could use it. Give me 500 gold, and I'll give you the stone!";
			OnChatLoop();
			TRADE_RING = true;
			OnNpcatkSuspendAi();
		}
	}

	// rquest_rub_my_back_first
	void BaseChat_OnRquestRubMyBackFirst()
	{
		CallEventDelayed(3.0f, "say_job");
		SayText("Oh, I know a little something about that... If you could just help me with my 'little problem' first.");
	}

	// convo_anim
	// only good for models with scientist anims
	void BaseChat_OnConvoAnim()
	{
		float nAnims = GetTokenCount(CONV_ANIMS) - 1.0f;
		int rndAnim = RandomInt(0, int(nAnims));
		PlayAnim("critical", GetToken(CONV_ANIMS, rndAnim));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseChat_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseChat_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnSayRumor(CBasePlayer@ talkingPlayer = null) { BaseChat_OnSayRumor(talkingPlayer); } // say_rumor
	void OnFaceSpeaker(string speaker = "") { BaseChat_OnFaceSpeaker(speaker); } // face_speaker
	void OnChatLoop() { BaseChat_OnChatLoop(); } // chat_loop
	void OnBchatMouthMove() { BaseChat_OnBchatMouthMove(); } // bchat_mouth_move
	void OnBchatAutoMouthMove(string sentenceTime = "") { BaseChat_OnBchatAutoMouthMove(sentenceTime); } // bchat_auto_mouth_move
	void OnBchatMouthTwitch() { BaseChat_OnBchatMouthTwitch(); } // bchat_mouth_twitch
	void OnBchatCloseMouth() { BaseChat_OnBchatCloseMouth(); } // bchat_close_mouth
	void OnBchatOpenMouth() { BaseChat_OnBchatOpenMouth(); } // bchat_open_mouth
	void OnGiveRunaround(CBasePlayer@ player = null, string questStep = "") { BaseChat_OnGiveRunaround(player, questStep); } // give_runaround
	void OnRquestRubMyBackFirst() { BaseChat_OnRquestRubMyBackFirst(); } // rquest_rub_my_back_first
	void OnConvoAnim() { BaseChat_OnConvoAnim(); } // convo_anim
	void OnBcTotalMouthTime() {} // BC_TOTAL_MOUTH_TIME
	void OnLChatDelay() {} // L_CHAT_DELAY
	void OnMTime() {} // M_TIME
	void OnBchatAfterMenus() {} // bchat_after_menus
	void OnBchatBeforeMenus() {} // bchat_before_menus
	void OnNpcChatDone() {} // npc_chat_done
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool BaseChat_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bchat_auto_mouth_move") { OnBchatAutoMouthMove(Param(params, 0)); return true; }
		if (name == "bchat_close_mouth") { OnBchatCloseMouth(); return true; }
		if (name == "bchat_mouth_move") { OnBchatMouthMove(); return true; }
		if (name == "bchat_mouth_twitch") { OnBchatMouthTwitch(); return true; }
		if (name == "bchat_open_mouth") { OnBchatOpenMouth(); return true; }
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "convo_anim") { OnConvoAnim(); return true; }
		if (name == "face_speaker") { OnFaceSpeaker(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_runaround") { OnGiveRunaround(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "rquest_rub_my_back_first") { OnRquestRubMyBackFirst(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_chat"]
shared class BaseChatScript : ScriptEntity, BaseChat
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseChat_DispatchEvent(name, params);
	}
}
