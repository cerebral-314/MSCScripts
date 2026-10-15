#pragma context server

// Converted from mercenaries/merc1.script by msc_transpiler.
// Mercenary

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"
#include "converted/help/first_hireling.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MercenariesMerc1
{
	// Constants
	string SUM_SAY_COME = "Comin' right to ya sir.";
	string SUM_SAY_ATTACK = "Yes sir, that thing's gonna die right quick!";
	string SUM_SAY_HUNT = "Gotta be somethin to smack around here somewhere...";
	string SUM_SAY_DEFEND = "Watchin' yer back, sir.";
	string SUM_SAY_DEATH = "Mom alway said I'd end up this way.";
	string SUM_REPORT_SUFFIX = ", sir.";
	string ANIM_SITIDLE = "sitidle";
	int DMG_MIN = 5;
	int DMG_MAX = 12;
	string ATTACK_HITCHANCE = "80%";
	string SOUND_ALERT1 = "npc/prepdie.wav";
	string SOUND_ATTACK1 = "weapons/swingsmall.wav";
	string SOUND_ATTACK2 = "weapons/swingsmall.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	int VOLUME = 5;
	string RETALIATE_CHANGETARGET_CHANCE = "75%";
	int SUMMON_VICINITY = 360;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool IS_HIRED = false;
	bool CONVERSE_PLAYER = false;
	bool SEE_PLAYER_NOW = false;
	bool SEE_ENEMY = false;
	int HIRE_PRICE = 0;
	string SUMMON_MASTER = "SUMMON_MASTER";
	string MASTER_NAME = "MASTER_NAME";
	bool MERC_RESTING = false;

	// unnamed block (first think)
	void MercenariesMerc1_FirstThink()
	{
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
	}

	// summon_spawn
	void MercenariesMerc1_OnSummonSpawn()
	{
		MenuItem menuItem;

		SetHealth(150);
		SetName("Mercenary");
		// ov 359
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
		SetDamageTaken("all", 0.8f);

		HIRE_PRICE = RandomInt(30, 50);
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

		GiveHealth(-3);
		OnBasesummonAttackall(); // Premptive attack
	}

	// hired_by_player
	// PARAM1 - player
	void MercenariesMerc1_OnHiredByPlayer(CBasePlayer@ player = null)
	{
		LegacyCommand("menuitem.remove", "hire");
		IS_HIRED = true;
		ANIM_IDLE = "idle1";
		SUMMON_MASTER = EntityId(player);
		MASTER_NAME = NameOf(SUMMON_MASTER) + "!";
		CAN_HUNT = "1";
		CAN_ATTACK = "1";
		SetRace("human");
		SayText("Lead on, " + MASTER_NAME);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", "yes");
	}

	// npc_targetsighted
	// See Enemy
	void MercenariesMerc1_OnNpcTargetsighted(string target = "")
	{
		if (HUNT_LASTTARGET == SUMMON_MASTER)
		{
			if (DistanceTo(HUNT_LASTTARGET) < 256.0f)
				SetMoveAnim(ANIM_WALK);
		}
		else if (EntityId(EntityOf(ENT_LASTSEEN)) != HUNT_LASTTARGET)
			PlayRandomSound(Int(Eval("game.sound.voice")), VOLUME, SOUND_ALERT1, "none", "none", "none");
	}

	// attack_1
	// Deal damage
	void MercenariesMerc1_OnAttack12()
	{
		PlaySound(Int(Eval("game.sound.weapon")), VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(DMG_MIN, DMG_MAX), ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void MercenariesMerc1_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), VOLUME, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (IS_HIRED)
			OnRestGetup();
	}

	// unnamed block (timer)
	// See player, get up and offer services
	void MercenariesMerc1_Timer()
	{
		CallEventDelayed(2.0f, "MercenariesMerc1_Timer");

		if ((IS_HIRED ? 1 : 0) != 0)
			return;

		SetRace("human");
		if (!CanSee("ally"))
			return;
		OnStandandtalk();
	}

	// standandtalk
	void MercenariesMerc1_OnStandandtalk()
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
	void MercenariesMerc1_OnOffer1()
	{
		SayText("You shouldn't be alone here.");
		Say("[30]", "[30]", "[30]", "[30]", "[20]", "[20]", "[30]");
		CallEventDelayed(2.0f, "offer_2");
	}

	// offer_2
	void MercenariesMerc1_OnOffer2()
	{
		SayText("I'll show you around these plains, if you pay me " + HIRE_PRICE + " gold");
		Say("[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]");
		PlayAnim("once", "yes");
		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdown
	void MercenariesMerc1_OnSitdown()
	{
		if ((IS_HIRED ? 1 : 0) != 0)
			return;
		SEE_PLAYER_NOW = false;
		OnSitdownlater();
		OnSitdownnow();
	}

	// sitdownlater
	void MercenariesMerc1_OnSitdownlater()
	{
		SetRace("human");
		Look(256);
		OnSitdownlater2();
	}

	// sitdownlater2
	void MercenariesMerc1_OnSitdownlater2()
	{
		Look(256);
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		SEE_PLAYER_NOW = true;

		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdownnow
	void MercenariesMerc1_OnSitdownnow()
	{
		if ((SEE_PLAYER_NOW ? 1 : 0) != 0)
			return;

		CONVERSE_PLAYER = false;
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_target_lost
	// Regen
	void MercenariesMerc1_OnNpcatkTargetLost()
	{
		if (MERC_RESTING)
			return;
		CallEventDelayed(RandomInt(2, 5), "rest_checksit");
	}

	// game_movingto_dest
	void MercenariesMerc1_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (!MERC_RESTING)
			return;
		OnRestGetup();
	}

	// rest_checksit
	void MercenariesMerc1_OnRestChecksit()
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
	void MercenariesMerc1_OnRestGetup()
	{
		SetIdleAnim(ANIM_IDLE);
		MERC_RESTING = false;
	}

	// game_recvoffer_gold
	// Get hired
	void MercenariesMerc1_OnGameRecvofferGold()
	{
		if ((CONVERSE_PLAYER ? 1 : 0) != 1)
			return;
		if (Float(Eval("game.offer.gold")) == HIRE_PRICE)
		{
			ReceiveOffer("accept");
			OnHiredByPlayer(ToPlayer(EntityOf(ENT_LASTGAVE)));
		}
		else if (Float(Eval("game.offer.gold")) > HIRE_PRICE)
		{
			ReceiveOffer("reject");
			SayText("It's okay, really. " + HIRE_PRICE + " is all I need.");
			Say("[10]", "[10]", "[10]", "[10]", "[10]", "[10]", "[4]");
			PlayAnim("once", "no");
		}
		else if (Float(Eval("game.offer.gold")) < HIRE_PRICE)
		{
			ReceiveOffer("reject");
			SayText("I will not be persuaded for a lower price! " + HIRE_PRICE + " Nothing more, nothing less.");
			Say("[10]", "[10]", "[10]", "[6]", "[12]", "[4]", "[20]", "[10]", "[10]");
			PlayAnim("once", "no");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		BaseMonsterShared_OnGameTargetedByPlayer(player); // monsters/base_monster_shared
		FirstHireling_OnGameTargetedByPlayer(player); // help/first_hireling
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		MercenariesMerc1_OnNpcTargetsighted(target);
	}

	void OnSummonSpawn() { MercenariesMerc1_OnSummonSpawn(); } // summon_spawn
	void OnHiredByPlayer(CBasePlayer@ player = null) { MercenariesMerc1_OnHiredByPlayer(player); } // hired_by_player
	void OnAttack12() { MercenariesMerc1_OnAttack12(); } // attack_1
	void OnNpcStruck(float damage = 0.0f) { MercenariesMerc1_OnNpcStruck(damage); } // npc_struck
	void OnStandandtalk() { MercenariesMerc1_OnStandandtalk(); } // standandtalk
	void OnOffer1() { MercenariesMerc1_OnOffer1(); } // offer_1
	void OnOffer2() { MercenariesMerc1_OnOffer2(); } // offer_2
	void OnSitdown() { MercenariesMerc1_OnSitdown(); } // sitdown
	void OnSitdownlater() { MercenariesMerc1_OnSitdownlater(); } // sitdownlater
	void OnSitdownlater2() { MercenariesMerc1_OnSitdownlater2(); } // sitdownlater2
	void OnSitdownnow() { MercenariesMerc1_OnSitdownnow(); } // sitdownnow
	void OnNpcatkTargetLost() { MercenariesMerc1_OnNpcatkTargetLost(); } // npcatk_target_lost
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { MercenariesMerc1_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnRestChecksit() { MercenariesMerc1_OnRestChecksit(); } // rest_checksit
	void OnRestGetup() { MercenariesMerc1_OnRestGetup(); } // rest_getup
	void OnGameRecvofferGold() { MercenariesMerc1_OnGameRecvofferGold(); } // game_recvoffer_gold
	void OnBasesummonAttackall() {} // basesummon_attackall

	// This file's events and timers by their .script names
	bool MercenariesMerc1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "hired_by_player") { OnHiredByPlayer(PlayerParam(params, 0)); return true; }
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
		if (name == "MercenariesMerc1_Timer") { MercenariesMerc1_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "mercenaries/merc1"]
shared class MercenariesMerc1Script : BaseSummonScript, MercenariesMerc1, FirstHireling
{
	// Variables declared by included files, with the value they start with in this script
	MercenariesMerc1Script()
	{
		SUM_SAY_COME = "Comin' right to ya sir.";
		SUM_SAY_ATTACK = "Yes sir, that thing's gonna die right quick!";
		SUM_SAY_HUNT = "Gotta be somethin to smack around here somewhere...";
		SUM_SAY_DEFEND = "Watchin' yer back, sir.";
		SUM_SAY_DEATH = "Mom alway said I'd end up this way.";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SUMMON_VICINITY = 360;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("npc/guard1.mdl");
		CallEventDelayed(2.0f, "MercenariesMerc1_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MercenariesMerc1_FirstThink();
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
		return MercenariesMerc1_DispatchEvent(name, params)
			|| FirstHireling_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
