#pragma context server

// Converted from a3/merc1.script by msc_transpiler.
// Mercenary

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"
#include "converted/help/first_hireling.as"

[script "a3/merc1"]
class A3Merc1 : BaseSummonScript, FirstHireling
{
	// Constants
	string ANIM_SITIDLE = "sitidle";
	int DMG_MIN = 1;
	int DMG_MAX = 3;
	string ATTACK_HITCHANCE = "80%";
	string SOUND_ALERT1 = "npc/prepdie.wav";
	string SOUND_ATTACK1 = "weapons/swingsmall.wav";
	string SOUND_ATTACK2 = "weapons/swingsmall.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	int VOLUME = 5;
	string RETALIATE_CHANGETARGET_CHANCE = "75%";

	// Variables (an unset .script variable reads as its own name)
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool CONVERSE_PLAYER = false;
	bool SEE_PLAYER_NOW = false;
	bool SEE_ENEMY = false;
	int HIRE_PRICE = 0;
	string MASTER_NAME = "MASTER_NAME";
	bool MERC_RESTING = false;

	// Variables declared by included files, with the value they start with in this script
	A3Merc1()
	{
		SUM_SAY_COME = "On my way, sir.";
		SUM_SAY_ATTACK = "On it!";
		SUM_SAY_HUNT = "There'll be some good eatin's tonight!";
		SUM_SAY_DEFEND = "Got yer back.";
		SUM_SAY_DEATH = "I really need to charge more for this.";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SUMMON_VICINITY = 360;
	}

	// unnamed block (first think)
	void A3Merc1_FirstThink()
	{
		ANIM_DEATH = "dieforward1";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "swordswing1_L";
		MOVE_RANGE = "64";
		ATTACK_RANGE = 72.0f;
		ATTACK_HITRANGE = 120.0f;

		CAN_RETALIATE = "1";
		CAN_ATTACK = "0";
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		CAN_HUNT = "0";
		CAN_HEAR = "1";
		CAN_FLINCH = "1";
		FLINCH_ANIM = "raflinch";
		FLINCH_CHANCE = "10%";

		NO_STUCK_CHECKS = "1";
	}

	// unnamed block (timer)
	// See player, get up and offer services
	void A3Merc1_Timer()
	{
		CallEventDelayed(2.0f, "A3Merc1_Timer");

		if (IS_HIRED)
			return;

		SetRace("human");
		if (!CanSee("ally"))
			return;
		OnStandandtalk();
	}

	// npc_targetsighted
	// See Enemy
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (HUNT_LASTTARGET == SUMMON_MASTER)
		{
			if (DistanceTo(HUNT_LASTTARGET) < 256.0f)
				SetMoveAnim(ANIM_WALK);
		}
		else if (EntityId(EntityOf(ENT_LASTSEEN)) != HUNT_LASTTARGET)
			PlayRandomSound(Int(Eval("game.sound.voice")), VOLUME, SOUND_ALERT1, "none", "none", "none");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseSummon_OnGameMenuGetoptions(player); // monsters/summon/base_summon
		MenuItem menuItem;

		if (!IS_HIRED)
		{
			menuItem.id = "payment";
			menuItem.title = "Pay " + HIRE_PRICE + " gold";
			menuItem.type = "payment";
			menuItem.data = "gold:" + HIRE_PRICE;
			menuItem.callback = "menu_recv_payment";
			menuItem.cb_failed = "menu_recv_payment_failed";
			RegisterMenuItem(menuItem);
		}

		if (IS_HIRED)
		{
			menuItem.id = "disband";
			menuItem.title = "Disband";
			menuItem.type = "callback";
			menuItem.callback = "menu_disband";
			RegisterMenuItem(menuItem);
		}
	}

	// summon_spawn
	void OnSummonSpawn()
	{
		MenuItem menuItem;

		SetHealth(35);
		SetName("Holden, the Guide");
		SetWidth(32);
		SetHeight(64);
		SetRoam(false);
		SetHearingSensitivity(3);
		SetSkillLevel(0);
		SetRace("neutral");
		SetModel("npc/guard1.mdl");
		SetModelBody(1, 0);
		SetIdleAnim(ANIM_SITIDLE);
		SetMoveAnim(ANIM_WALK);

		IS_HIRED = false;
		CONVERSE_PLAYER = false;
		SEE_PLAYER_NOW = false;
		SEE_ENEMY = false;

		SetStat("parry", 10, 10, 10);

		HIRE_PRICE = RandomInt(4, 16);
		menuItem.id = "hire";
		SetLocal("reg.mitem.access", "all");
		menuItem.title = "Hire for ";
		LegacyCommand("stradd", "reg.mitem.title", HIRE_PRICE);
		LegacyCommand("stradd", "reg.mitem.title", " gold");
		menuItem.type = "payment";
		menuItem.data = "gold:";
		LegacyCommand("stradd", "reg.mitem.data", HIRE_PRICE);
		menuItem.callback = "hired_by_player";

		RegisterMenuItem(menuItem);

		OnNpcatkSuspendAi();

		OnBasesummonAttackall(); // Premptive attack
	}

	// hired_by_player
	// PARAM1 - player
	void OnHiredByPlayer(CBasePlayer@ player = null)
	{
		LegacyCommand("menuitem.remove", "hire");
		IS_HIRED = true;
		CAN_HUNT = "1";
		OnNpcatkResumeAi();
		ANIM_IDLE = "idle1";
		SUMMON_MASTER = EntityId(player);
		MASTER_NAME = NameOf(SUMMON_MASTER) + "!";
		CAN_ATTACK = "1";
		SetRace("human");
		SayText("Lead on, " + MASTER_NAME);
		OnBsSetDefendMode();
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", "yes");
	}

	// attack_1
	// Deal damage
	void OnAttack12()
	{
		PlaySound(Int(Eval("game.sound.weapon")), VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);

		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(Random(DMG_MIN, DMG_MAX)), ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), VOLUME, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (IS_HIRED)
			OnRestGetup();
	}

	// standandtalk
	void OnStandandtalk()
	{
		if ((CONVERSE_PLAYER ? 1 : 0) != 0)
			return;
		if (!Truthy(LegacyFunction("cansee", "ally", 90)))
			return;

		CONVERSE_PLAYER = true;
		PlayAnim("once", "sitstand");
		SetIdleAnim("idle1");

		CallEventDelayed(5.0f, "offer_1");
	}

	// offer_1
	void OnOffer1()
	{
		SayText("You shouldn't be alone here.");
		Say("[30]", "[30]", "[30]", "[30]", "[20]", "[20]", "[30]");
		CallEventDelayed(2.0f, "offer_2");
	}

	// offer_2
	void OnOffer2()
	{
		string offerText = "I'll show you around these plains, if you pay me " + HIRE_PRICE + " gold.";
		SayText(offerText);
		Say("[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]");
		PlayAnim("once", "yes");
		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdown
	void OnSitdown()
	{
		if (IS_HIRED)
			return;
		SEE_PLAYER_NOW = false;
		OnSitdownlater();
		OnSitdownnow();
	}

	// sitdownlater
	void OnSitdownlater()
	{
		SetRace("human");
		Look(256);
		OnSitdownlater2();
	}

	// sitdownlater2
	void OnSitdownlater2()
	{
		Look(256);
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		SEE_PLAYER_NOW = true;

		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdownnow
	void OnSitdownnow()
	{
		if ((SEE_PLAYER_NOW ? 1 : 0) != 0)
			return;

		CONVERSE_PLAYER = false;
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_target_lost
	// Regen
	void OnNpcatkTargetLost()
	{
		if (MERC_RESTING)
			return;
		CallEventDelayed(RandomInt(2, 5), "rest_checksit");
	}

	// game_movingto_dest
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (!MERC_RESTING)
			return;
		OnRestGetup();
	}

	// rest_checksit
	void OnRestChecksit()
	{
		if (IS_HUNTING)
			return;
		if (!(MyHealth() < MyMaxHealth()))
			return;

		MERC_RESTING = true;
		SetIdleAnim(ANIM_SITIDLE);
		GiveHealth(1);
		CallEventDelayed(5.0f, "rest_checksit");

		if (!(MyHealth() >= MyMaxHealth()))
			return;
		CallEventDelayed(3.0f, "rest_getup");
	}

	// rest_getup
	void OnRestGetup()
	{
		SetIdleAnim(ANIM_IDLE);
		MERC_RESTING = false;
	}

	// menu_recv_payment
	// Get hired
	void OnMenuRecvPayment(CBasePlayer@ player = null)
	{
		if ((CONVERSE_PLAYER ? 1 : 0) != 1)
			return;

		ReceiveOffer("accept");
		OnHiredByPlayer(player);
	}

	// menu_recv_payment_failed
	void OnMenuRecvPaymentFailed(CBasePlayer@ player = null)
	{
		ReceiveOffer("reject");
		SayText("I will not be persuaded for a lower price! " + HIRE_PRICE + " Nothing more, nothing less.");
		Say("[10]", "[10]", "[10]", "[6]", "[12]", "[4]", "[20]", "[10]", "[10]");
		PlayAnim("once", "no");
	}

	// menu_disband
	void OnMenuDisband()
	{
		SayText("I guess this is where we part ways. It was a pleasure working for you.");
		PlayAnim("once", "yes");
		MASTER_NAME = "\\/NULL\\/";
		SetRace("neutral");
		SetHealth(35);
		IS_HIRED = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		BaseMonsterShared_OnGameTargetedByPlayer(player); // monsters/base_monster_shared
		FirstHireling_OnGameTargetedByPlayer(player); // help/first_hireling
	}

	void OnBasesummonAttackall() {} // basesummon_attackall

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("npc/guard1.mdl");
		CallEventDelayed(2.0f, "A3Merc1_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		A3Merc1_FirstThink();
		BaseSummon_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "hired_by_player") { OnHiredByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "menu_disband") { OnMenuDisband(); return true; }
		if (name == "menu_recv_payment") { OnMenuRecvPayment(PlayerParam(params, 0)); return true; }
		if (name == "menu_recv_payment_failed") { OnMenuRecvPaymentFailed(PlayerParam(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_target_lost") { OnNpcatkTargetLost(); return true; }
		if (name == "offer_1") { OnOffer1(); return true; }
		if (name == "offer_2") { OnOffer2(); return true; }
		if (name == "rest_checksit") { OnRestChecksit(); return true; }
		if (name == "rest_getup") { OnRestGetup(); return true; }
		if (name == "sitdown") { OnSitdown(); return true; }
		if (name == "sitdownlater") { OnSitdownlater(); return true; }
		if (name == "sitdownlater2") { OnSitdownlater2(); return true; }
		if (name == "sitdownnow") { OnSitdownnow(); return true; }
		if (name == "standandtalk") { OnStandandtalk(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		if (name == "A3Merc1_Timer") { A3Merc1_Timer(); return true; }
		return FirstHireling_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
