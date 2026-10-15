#pragma context server

// Converted from mercenaries/merc2.script by msc_transpiler.
// Mercenary

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"
#include "converted/help/first_hireling.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Merc2
{
	// Constants
	string SUM_SAY_COME = "Whaddya need?";
	string SUM_SAY_ATTACK = "Right! Have at it then!";
	string SUM_SAY_HUNT = "Hunt... Hunt... Hunt...";
	string SUM_SAY_DEFEND = "Got your back - dunno who has mine though...";
	string SUM_SAY_DEATH = "Gads! I knew I shoulda been a shop keeper!";
	string SUM_REPORT_SUFFIX = ", boss.";
	string ANIM_SITIDLE = "sitidle";
	int ATTACK_SPEED = 1200;
	int ARROW_DAMAGE_LOW = 7;
	int ARROW_DAMAGE_HIGH = 15;
	int ATTACK_CONE_OF_FIRE = 2;
	string SOUND_ALERT1 = "npc/prepdie.wav";
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
	void Merc2_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "shootorcbow";
		MOVE_RANGE = "600";
		ATTACK_RANGE = 650.0f;

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
	void Merc2_OnSummonSpawn()
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
		SetModel("npc/archer.mdl");
		SetModelBody(2, 2);
		SetIdleAnim(ANIM_SITIDLE);
		SetMoveAnim(ANIM_WALK);

		IS_HIRED = false;
		CONVERSE_PLAYER = false;
		SEE_PLAYER_NOW = false;
		SEE_ENEMY = false;

		SetStat("parry", 10, 10, 10);

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
	void Merc2_OnHiredByPlayer(CBasePlayer@ player = null)
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
	void Merc2_OnNpcTargetsighted(string target = "")
	{
		if (HUNT_LASTTARGET == SUMMON_MASTER)
		{
			if (DistanceTo(HUNT_LASTTARGET) < 256.0f)
				SetMoveAnim(ANIM_WALK);
		}
		else if (EntityId(EntityOf(ENT_LASTSEEN)) != HUNT_LASTTARGET)
			PlayRandomSound(Int(Eval("game.sound.voice")), VOLUME, SOUND_ALERT1, "none", "none", "none");
	}

	// shoot_arrow
	// Deal damage
	void Merc2_OnShootArrow()
	{
		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), 0.0f); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		float lclAtkdmg = Random(ARROW_DAMAGE_LOW, ARROW_DAMAGE_HIGH);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 16)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, "SND_BOW");
	}

	// grab_arrow
	// Called from the animation...
	void Merc2_OnGrabArrow()
	{
		// Just pulled an arrow out of quiver
		SetModelBody(3, 1); // Show arrow
	}

	// npc_struck
	// Hit by someone
	void Merc2_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), VOLUME, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (IS_HIRED)
			OnRestGetup();
	}

	// unnamed block (timer)
	// See player, get up and offer services
	void Merc2_Timer()
	{
		CallEventDelayed(2.0f, "Merc2_Timer");

		if ((IS_HIRED ? 1 : 0) != 0)
			return;

		SetRace("human");
		if (!CanSee("ally"))
			return;
		OnStandandtalk();
	}

	// standandtalk
	void Merc2_OnStandandtalk()
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
	void Merc2_OnOffer1()
	{
		SayText("You shouldn't be alone here.");
		Say("[30]", "[30]", "[30]", "[30]", "[20]", "[20]", "[30]");
		CallEventDelayed(2.0f, "offer_2");
	}

	// offer_2
	void Merc2_OnOffer2()
	{
		SayText("I'll show you around these plains, if you pay me " + HIRE_PRICE + " gold");
		Say("[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]", "[30]");
		PlayAnim("once", "yes");
		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdown
	void Merc2_OnSitdown()
	{
		if ((IS_HIRED ? 1 : 0) != 0)
			return;
		SEE_PLAYER_NOW = false;
		OnSitdownlater();
		OnSitdownnow();
	}

	// sitdownlater
	void Merc2_OnSitdownlater()
	{
		SetRace("human");
		Look(256);
		OnSitdownlater2();
	}

	// sitdownlater2
	void Merc2_OnSitdownlater2()
	{
		Look(256);
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		SEE_PLAYER_NOW = true;

		CallEventDelayed(5.0f, "sitdown");
	}

	// sitdownnow
	void Merc2_OnSitdownnow()
	{
		if ((SEE_PLAYER_NOW ? 1 : 0) != 0)
			return;

		CONVERSE_PLAYER = false;
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_target_lost
	// Regen
	void Merc2_OnNpcatkTargetLost()
	{
		if (MERC_RESTING)
			return;
		CallEventDelayed(RandomInt(2, 5), "rest_checksit");
	}

	// game_movingto_dest
	void Merc2_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (!MERC_RESTING)
			return;
		OnRestGetup();
	}

	// rest_checksit
	void Merc2_OnRestChecksit()
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
	void Merc2_OnRestGetup()
	{
		SetIdleAnim(ANIM_IDLE);
		MERC_RESTING = false;
	}

	// game_recvoffer_gold
	// Get hired
	void Merc2_OnGameRecvofferGold()
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
		Merc2_OnNpcTargetsighted(target);
	}

	void OnSummonSpawn() { Merc2_OnSummonSpawn(); } // summon_spawn
	void OnHiredByPlayer(CBasePlayer@ player = null) { Merc2_OnHiredByPlayer(player); } // hired_by_player
	void OnShootArrow() { Merc2_OnShootArrow(); } // shoot_arrow
	void OnGrabArrow() { Merc2_OnGrabArrow(); } // grab_arrow
	void OnNpcStruck(float damage = 0.0f) { Merc2_OnNpcStruck(damage); } // npc_struck
	void OnStandandtalk() { Merc2_OnStandandtalk(); } // standandtalk
	void OnOffer1() { Merc2_OnOffer1(); } // offer_1
	void OnOffer2() { Merc2_OnOffer2(); } // offer_2
	void OnSitdown() { Merc2_OnSitdown(); } // sitdown
	void OnSitdownlater() { Merc2_OnSitdownlater(); } // sitdownlater
	void OnSitdownlater2() { Merc2_OnSitdownlater2(); } // sitdownlater2
	void OnSitdownnow() { Merc2_OnSitdownnow(); } // sitdownnow
	void OnNpcatkTargetLost() { Merc2_OnNpcatkTargetLost(); } // npcatk_target_lost
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { Merc2_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnRestChecksit() { Merc2_OnRestChecksit(); } // rest_checksit
	void OnRestGetup() { Merc2_OnRestGetup(); } // rest_getup
	void OnGameRecvofferGold() { Merc2_OnGameRecvofferGold(); } // game_recvoffer_gold
	void OnBasesummonAttackall() {} // basesummon_attackall

	// This file's events and timers by their .script names
	bool Merc2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "hired_by_player") { OnHiredByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_target_lost") { OnNpcatkTargetLost(); return true; }
		if (name == "offer_1") { OnOffer1(); return true; }
		if (name == "offer_2") { OnOffer2(); return true; }
		if (name == "rest_checksit") { OnRestChecksit(); return true; }
		if (name == "rest_getup") { OnRestGetup(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "sitdown") { OnSitdown(); return true; }
		if (name == "sitdownlater") { OnSitdownlater(); return true; }
		if (name == "sitdownlater2") { OnSitdownlater2(); return true; }
		if (name == "sitdownnow") { OnSitdownnow(); return true; }
		if (name == "standandtalk") { OnStandandtalk(); return true; }
		if (name == "summon_spawn") { OnSummonSpawn(); return true; }
		if (name == "Merc2_Timer") { Merc2_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "mercenaries/merc2"]
shared class Merc2Script : BaseSummonScript, Merc2, FirstHireling
{
	// Variables declared by included files, with the value they start with in this script
	Merc2Script()
	{
		SUM_SAY_COME = "Whaddya need?";
		SUM_SAY_ATTACK = "Right! Have at it then!";
		SUM_SAY_HUNT = "Hunt... Hunt... Hunt...";
		SUM_SAY_DEFEND = "Got your back - dunno who has mine though...";
		SUM_SAY_DEATH = "Gads! I knew I shoulda been a shop keeper!";
		SUM_REPORT_SUFFIX = ", boss.";
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
		Precache("npc/archer.mdl");
		CallEventDelayed(2.0f, "Merc2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Merc2_FirstThink();
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
		return Merc2_DispatchEvent(name, params)
			|| FirstHireling_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
