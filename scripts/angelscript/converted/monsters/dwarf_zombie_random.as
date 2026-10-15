#pragma context server

// Converted from monsters/dwarf_zombie_random.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// Dwarf Zombie by Thothie, from ghoul_lesser
// Lesser Ghoul by Thothie - From Greater Ghoul
// - Fugly model - basically fast Zombie, xtra danage attack secondary
// - Differences: -stunatk <hp <size <damage

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/NPCs/dwarf_lantern_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfZombieRandom
{
	// Constants
	int MAX_TYPE = 4;
	string RETALIATE_CHANGETARGET_CHANCE = "80";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "25";
	string ATTACK_ACCURACY = "80%";
	string ATTACK2_ACCURACY = "75%";
	string ANIM_LEAP = "attack2";
	string ANIM_SLASH = "attack";
	string ANIM_NOD = "nod";
	string SOUND_IDLE1 = "agrunt/ag_idle2.wav";
	string SOUND_IDLE2 = "agrunt/ag_alert3.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle5.wav";
	string SOUND_ALERT = "agrunt/ag_alert2.wav";
	string SOUND_LEAP = "agrunt/ag_attack2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACKHIT3 = "zombie/claw_strike3.wav";
	string SOUND_DEATH = "agrunt/ag_die5.wav";
	string SOUND_STRUCK = "debris/flesh2.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain3.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain5.wav";
	float HURT_POINT = 0.5f;
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLYPAIN1 = "agrunt/ag_pain4.wav";
	string SOUND_HOLYPAIN2 = "agrunt/ag_die3.wav";
	string SOUND_STEP1 = "player/pl_grate1.wav";
	string SOUND_STEP2 = "player/pl_grate2.wav";
	string SOUND_STEP3 = "player/pl_grate3.wav";
	string SOUND_STEP4 = "player/pl_grate4.wav";
	string SOUND_NOD = "x/x_laugh1.wav";
	bool I_AM_TURNABLE = true;
	string LANTERN_COLOR = "LANTERN_COLOR";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_HEAR = "CAN_HEAR";
	bool CAN_WANDER = false;
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_FLEE = "CAN_FLEE";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	int MOVE_RAGE = 0;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	int MONSTER_WIDTH = 0;
	float LNT_R = 0.0f;
	float LNT_B = 0.0f;
	float LNT_G = 0.0f;
	bool JUST_SPAWNED = false;
	float NPC_GIVE_EXP = 0.0f;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK2_DAMAGE = "ATTACK2_DAMAGE";
	int ATTACK2_CHANCE = 0;
	string DROP_ITEM1 = "DROP_ITEM1";
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	Vector3 WALKING_MY_OLD_POS = Vector3();
	float WALK_STEP = 0.0f;
	float STUCK_COUNT = 0.0f;
	int ATTACK_VOLUME = 0;
	float STRUCK_BY_HOLY = 0.0f;
	bool DID_ALERT = false;
	string WEAPON_TYPE = "WEAPON_TYPE";
	bool IS_FLEEING = false;
	bool NPCATK_FLEE_RESTORETARGET = false;

	// unnamed block (first think)
	void DwarfZombieRandom_FirstThink()
	{
		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_HEAR = "1";
		CAN_WANDER = true;

		CAN_RETALIATE = "1";

		CAN_FLINCH = "0";

		CAN_FLEE = "1";
		FLEE_DISTANCE = "2048";

		ATTACK_RANGE = 125.0f;
		ATTACK_HITRANGE = 200.0f;
		MOVE_RAGE = 65;

		// defined in type selection (this seems to be overriding, even though it shouldn't)
		// setvard ATTACK_DAMAGE 30
		// setvard ATTACK2_DAMAGE 80
		// base anims
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk"; // zombies only run under special circumstances
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack"; // alternates between leap and slash

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 5;
		DROP_GOLD_MAX = 30;

		MONSTER_WIDTH = 32; // for anti-stuck

		// spookie random colourz
		int rnd = RandomInt(1, 5);
		if (rnd == 1)
		{
			LNT_R = Random(16, 64);
			LNT_B = 0.0f;
			LNT_G = 0.0f;
		}
		else if (rnd == 2)
		{
			LNT_R = 0.0f;
			LNT_G = Random(16, 64);
			LNT_B = 0.0f;
		}
		else if (rnd == 3)
		{
			LNT_R = 0.0f;
			LNT_G = 0.0f;
			LNT_B = Random(16, 64);
		}
		else if (rnd == 4)
		{
			LNT_R = 0.0f;
			LNT_G = Random(16, 64);
			LNT_B = Random(16, 64);
		}
		else if (rnd == 5)
		{
			LNT_R = Random(16, 64);
			LNT_G = 0.0f;
			LNT_B = Random(16, 64);
		}
	}

	// npc_spawn
	void DwarfZombieRandom_OnNpcSpawn(string npc = "")
	{
		if (Truthy(GetVar("ZOMBIE_QUEST_COMPLETE")))
			DeleteEntity(ENT_ME);

		JUST_SPAWNED = true; // expar
		SetName("Dwarven Zombie");
		// ov 110
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetRace("undead");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("holy", 2.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("lightning", 0.5f);
		SetHearingSensitivity(10);
		SetModel("dwarf/male1.mdl");

		SetModelBody(0, 2);
		SetModelBody(2, 0);

		OnPickWeaponType();

		if (MapName() == "gatecity")
		{
			// lots of insanely stupid monster clips in gatecity, ignore them
			SetMonsterClip(false);
		}

		if (Float(WEAPON_TYPE) == 0.0f)
		{
			// unarmed
			NPC_GIVE_EXP = 40.0f;
			SetHealth(150);
			SetModelBody(1, 0);
			ATTACK_DAMAGE = "20";
			ATTACK2_DAMAGE = "80";
			ATTACK_RANGE = 50.0f;
			ATTACK_HITRANGE = 100.0f;
			MOVE_RAGE = 48;
			ATTACK2_CHANCE = 0;
			DROP_GOLD_MIN = 5;
			DROP_GOLD_MAX = 15;
			if (RandomInt(1, 100) < 25 && !LANTERN_SET)
				OnSetLantern();
		}

		if (Float(WEAPON_TYPE) == 1.0f)
		{
			// small axe
			NPC_GIVE_EXP = 50.0f;
			SetHealth(200);
			SetModelBody(1, 1);
			ATTACK_DAMAGE = "30";
			ATTACK2_DAMAGE = "90";
			ATTACK_RANGE = 125.0f;
			ATTACK_HITRANGE = 175.0f;
			MOVE_RAGE = 48;
			ATTACK2_CHANCE = 0;
			DROP_GOLD_MIN = 10;
			DROP_GOLD_MAX = 20;
			DROP_ITEM1 = "axes_smallaxe"; // Used by base_monster
			DROP_ITEM1_CHANCE = "10%";
			if (RandomInt(1, 100) < 25 && !LANTERN_SET)
				OnSetLantern();
		}

		if (Float(WEAPON_TYPE) == 2.0f)
		{
			// big axe
			NPC_GIVE_EXP = 100.0f;
			SetHealth(300);
			SetModelBody(1, 2);
			ATTACK_DAMAGE = "40";
			ATTACK2_DAMAGE = "100";
			ATTACK_RANGE = 125.0f;
			ATTACK_HITRANGE = 200.0f;
			MOVE_RAGE = 65;
			ATTACK2_CHANCE = 25;
			DROP_GOLD_MIN = 15;
			DROP_GOLD_MAX = 30;
			DROP_ITEM1 = "axes_doubleaxe"; // Used by base_monster
			DROP_ITEM1_CHANCE = "10%";
		}

		if (Float(WEAPON_TYPE) == 3.0f)
		{
			// big sword
			NPC_GIVE_EXP = 200.0f;
			SetHealth(400);
			SetModelBody(1, 3);
			ATTACK_DAMAGE = "55";
			ATTACK2_DAMAGE = "150";
			ATTACK_RANGE = 125.0f;
			ATTACK_HITRANGE = 200.0f;
			MOVE_RAGE = 65;
			ATTACK2_CHANCE = 15;
			DROP_GOLD_MIN = 15;
			DROP_GOLD_MAX = 40;
			DROP_ITEM1 = "swords_bastardsword"; // Used by base_monster
			DROP_ITEM1_CHANCE = "5%";
		}

		if (Float(WEAPON_TYPE) == 4.0f)
		{
			// pickaxe
			NPC_GIVE_EXP = 175.0f;
			SetHealth(300);
			SetModelBody(1, 8);
			ATTACK_DAMAGE = "50";
			ATTACK2_DAMAGE = "150";
			ATTACK_RANGE = 125.0f;
			ATTACK_HITRANGE = 200.0f;
			MOVE_RAGE = 65;
			ATTACK2_CHANCE = 30;
			DROP_GOLD_MIN = 50;
			DROP_GOLD_MAX = 100; // miners has goldz
			if (RandomInt(1, 100) < 25 && !LANTERN_SET)
				OnSetLantern();
		}

		// setvard DROP_ITEM1 swords_bastardsword //Used by base_monster
		// setvard DROP_ITEM1_CHANCE 5%
		WALKING_MY_OLD_POS = OriginOf(ENT_ME);
		WALK_STEP = 1.0f;
		CallEventDelayed(1.0f, "walking");
	}

	// npcatk_get_postspawn_properties
	void DwarfZombieRandom_OnNpcatkGetPostspawnProperties()
	{
		// lot of stuck in ceiling crap going on in Gatecity
		// compensate
		// npcatk_to_ground
		if (ToLowerCase(MapName()) == "gatecity")
		{
			Vector3 myPos = OriginOf(ENT_ME);
			float myX = myPos.x;
			float myY = myPos.y;
			float myGround = GroundHeight(myPos);
			// add MY_GROUND 1
			DebugPrint("npcatk_get_postspawn_properties " + Text(myX) + " " + Text(myY) + " " + Text(myGround));
			SetOrigin(ENT_ME, Vector3(myX, myY, myGround));
		}

		// if ( $lcase(game.map.name) isnot gatecity )
		// {
		ATTACK_RANGE *= 0.5f;
		ATTACK_HITRANGE *= 0.5f;
	}

	// attack_1
	// called by modelanim attack @frame 6
	void DwarfZombieRandom_OnAttack12()
	{
		STUCK_COUNT = 0.0f;
		ATTACK_VOLUME = 5;
		OnNpcatkDodamage(ENTITY_ENEMY, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_ACCURACY);
		if (RandomInt(1, 100) < ATTACK2_CHANCE)
			ANIM_ATTACK = ANIM_LEAP;
	}

	// attack_2
	// called by modelanim attack2 @frame 9
	void DwarfZombieRandom_OnAttack22()
	{
		STUCK_COUNT = 0.0f;
		ATTACK_VOLUME = 10;
		OnNpcatkDodamage(ENTITY_ENEMY, Text(ATTACK_HITRANGE), ATTACK2_DAMAGE, ATTACK2_ACCURACY);
		ANIM_ATTACK = ANIM_SLASH;
		PlaySound(Int(GetVar("CHAN_ITEM")), 10, SOUND_LEAP);
		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/debuff_stun", RandomInt(2, 8), self);
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 2, RelativeVelocity(Vector3(10, -200, 10)), 0);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string DwarfZombieRandom_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		if (hit)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), ATTACK_VOLUME, SOUND_ATTACKHIT1, SOUND_ATTACKHIT2, SOUND_ATTACKHIT3);
		return result;
	}

	// npc_struck
	void DwarfZombieRandom_OnNpcStruck(float damage = 0.0f)
	{
		bool exitSub = false;

		float myHealth = HealthOf(ENT_ME);
		float hurtThreshold = MaxHealthOf(ENT_ME) * HURT_POINT;

		if (int(STRUCK_BY_HOLY) != 0)
		{
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 10, SOUND_HOLYPAIN1, SOUND_HOLYPAIN2);
			STRUCK_BY_HOLY = 0.0f;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (myHealth > hurtThreshold)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 8, SOUND_STRUCK, SOUND_STRUCK, SOUND_PAIN1);
		if (myHealth <= hurtThreshold)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), 8, SOUND_STRUCK, SOUND_STRUCK, SOUND_PAIN2);
	}

	// walking
	void DwarfZombieRandom_OnWalking()
	{
		// bit of a hack since the model has no walk events
		Vector3 myPos = OriginOf(ENT_ME);
		float travelDist = Distance(myPos, WALKING_MY_OLD_POS);

		if (travelDist > 32.0f)
		{
			if (WALK_STEP == 1.0f)
				PlaySound(Int(GetVar("CHAN_ITEM")), 2, SOUND_STEP1);
			if (WALK_STEP == 2.0f)
				PlaySound(Int(GetVar("CHAN_ITEM")), 2, SOUND_STEP2);
			if (WALK_STEP == 3.0f)
				PlaySound(Int(GetVar("CHAN_ITEM")), 2, SOUND_STEP3);
			if (WALK_STEP == 4.0f)
				PlaySound(Int(GetVar("CHAN_ITEM")), 2, SOUND_STEP4);
			WALK_STEP += 1.0f;
			if (WALK_STEP > 4.0f)
				WALK_STEP = 1.0f;
		}

		WALKING_MY_OLD_POS = myPos;
		CallEventDelayed(1.0f, "walking");
	}

	// npcatk_targetvalidate
	// play alert sound on spotting player
	void DwarfZombieRandom_OnNpcatkTargetvalidate(string target = "")
	{
		OnAlertDwarfZombie();
	}

	// alert_dwarf_zombie
	void DwarfZombieRandom_OnAlertDwarfZombie()
	{
		if (DID_ALERT)
			return;
		if (!CanSee("player")) // play alert sound for players only
			return;
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_ALERT);
		PlayAnim("critical", ANIM_NOD);
		DID_ALERT = true;
	}

	// pick_weapon_type
	void DwarfZombieRandom_OnPickWeaponType()
	{
		// pick random type (progressively meaner)
		// 0 - Unarmed
		// 1 - Small Axe
		// 2 - Great Axe
		// 3 - Broadsword
		int minType = 0;

		CBaseEntity@ mayorEnt = FindByName("dwarf_mayor");
		CBaseEntity@ mayorId = mayorEnt;

		if (Float(ScriptVarOf(mayorId, "ZOMBIE_QUEST")) == 1.0f)
		{
			// Zombies get meaner as quest nears completion
			int cZombieCount = Int(ScriptVarOf(mayorId, "ZOMBIE_COUNT"));
			string cZombieReq = ScriptVarOf(mayorId, "REQ_ZOMBIES");
			float quartWay = Float(cZombieReq);
			quartWay *= 0.2f;
			float halfWay = Float(cZombieReq);
			halfWay *= 0.4f;
			float almostThere = Float(cZombieReq);
			almostThere *= 0.6f;
			if (cZombieCount > quartWay)
				minType = 1;
			if (cZombieCount > halfWay)
				minType = 2;
			if (cZombieCount > almostThere)
				minType = 3;
		}
		WEAPON_TYPE = RandomInt(minType, MAX_TYPE);
	}

	// my_target_died
	void DwarfZombieRandom_OnMyTargetDied(string offender = "")
	{
		bool exitSub = false;

		if (JUST_SPAWNED)
		{
			JUST_SPAWNED = false;
			exitSub = true;
		}
		if (exitSub)
			return;

		// if !$cansee(player)
		PlayAnim("critical", ANIM_NOD);
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, SOUND_NOD);
	}

	// npcatk_flee
	void DwarfZombieRandom_OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		ANIM_RUN = "run";

		if (IS_FLEEING)
			return;

		PlayAnim("break");
		SetMoveDest(threatEntity, fleeDistance, "flee");
		SetMoveAnim(ANIM_RUN);

		IS_FLEEING = true;
		NPCATK_FLEE_RESTORETARGET = IS_HUNTING;
		if (!fleeDuration.isEmpty())
			CallEventOrDelay(fleeDuration, "npcatk_stopflee");
	}

	// npcatk_stopflee
	void DwarfZombieRandom_OnNpcatkStopflee()
	{
		ANIM_RUN = "walk";
	}

	// game_death
	void DwarfZombieRandom_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CBaseEntity@ mayorEnt = FindByName("dwarf_mayor");
		CBaseEntity@ mayorId = mayorEnt;

		// dbg Got mayor ID MAYOR_ID ( quest $get(MAYOR_ID,scriptvar,ZOMBIE_QUEST) count $get(MAYOR_ID,scriptvar,ZOMBIE_COUNT) )
		if (Float(ScriptVarOf(mayorId, "ZOMBIE_QUEST")) != 1.0f)
			return;

		CallExternal(mayorId, "zombie_died");

		int cZombieCount = Int(ScriptVarOf(mayorId, "ZOMBIE_COUNT"));
		string cZombieReqText = ScriptVarOf(mayorId, "REQ_ZOMBIES");
		int cZombieReq = Int(cZombieReqText);
		cZombieReqText = Text(cZombieReq);

		if (cZombieCount < cZombieReq)
		{
			int zCount = cZombieCount;
			PlayerMessage(ENT_LASTSTRUCK, "You have slain " + zCount + " / " + cZombieReqText + " dwarven zombies.");
		}

		if (cZombieCount != cZombieReq)
			return;
		PlayerMessageBlue(ENT_LASTSTRUCK, "You have completed the dwarven zombie quest. Return to the mayor for your reward.");
		SetGlobal("ZOMBIE_QUEST_COMPLETE", 1);
		CallExternal("all", "zombie_remove");
	}

	// zombie_remove
	void DwarfZombieRandom_OnZombieRemove()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
		DwarfZombieRandom_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttackNew_OnNpcatkGetPostspawnProperties(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkGetPostspawnProperties(); // monsters/base_monster_shared
		DwarfZombieRandom_OnNpcatkGetPostspawnProperties();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		DwarfZombieRandom_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		DwarfZombieRandom_OnNpcatkTargetvalidate(target);
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttackNew_OnNpcatkStopflee(); // monsters/base_npc_attack_new
		DwarfZombieRandom_OnNpcatkStopflee();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DwarfZombieRandom_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DwarfZombieRandom_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnAttack12() { DwarfZombieRandom_OnAttack12(); } // attack_1
	void OnAttack22() { DwarfZombieRandom_OnAttack22(); } // attack_2
	void OnNpcStruck(float damage = 0.0f) { DwarfZombieRandom_OnNpcStruck(damage); } // npc_struck
	void OnWalking() { DwarfZombieRandom_OnWalking(); } // walking
	void OnAlertDwarfZombie() { DwarfZombieRandom_OnAlertDwarfZombie(); } // alert_dwarf_zombie
	void OnPickWeaponType() { DwarfZombieRandom_OnPickWeaponType(); } // pick_weapon_type
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { DwarfZombieRandom_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnZombieRemove() { DwarfZombieRandom_OnZombieRemove(); } // zombie_remove

	// This file's events and timers by their .script names
	bool DwarfZombieRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "alert_dwarf_zombie") { OnAlertDwarfZombie(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "pick_weapon_type") { OnPickWeaponType(); return true; }
		if (name == "walking") { OnWalking(); return true; }
		if (name == "zombie_remove") { OnZombieRemove(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/dwarf_zombie_random"]
shared class DwarfZombieRandomScript : BaseMonsterNewScript, DwarfZombieRandom, DwarfLanternBase
{
	// Variables declared by included files, with the value they start with in this script
	DwarfZombieRandomScript()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		SOUND_DEATH = "agrunt/ag_die5.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfZombieRandom_FirstThink();
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
		return DwarfZombieRandom_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
