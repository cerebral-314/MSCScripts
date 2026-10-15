#pragma context server

// Converted from keledrosruins/keledros.script by msc_transpiler.
// Thothie - I percieve anything else in the Keledros script that would cause brain death
// - Changelog got out of hand, resetting :)
// - Fixed issues spawning too many guards
// - Now attacks players who hide behind upper pillar with different spells to prevent crash/sploits
// - Fixed issue where would get backup after death and cast 'one last spell'
// - Can't be sploited by flooding spell spam
// - Various new drops added
// - Some drops removed (available in Keledrosprelude2)
// - Added vulnerability to Rebuke Undead + Counter Attack

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class KeledrosruinsKeledros
{
	// Constants
	bool I_AM_TURNABLE = false;
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_RESTORATION = 0.5f;
	bool NPC_HEARDSOUND_OVERRIDE = true;
	bool NPC_AUTO_DEATH = false;
	string SKEL_RESPAWN_CHANCE = "100%";
	int SKEL_RESPAWN_LIVES = 1;
	string ANIM_RESPAWN_DEADIDLE = "lying_on_stomach";
	int SKEL_HP = 2750;
	string CAST_SCRIPT = "keledrosruins/keledros_cl_cast";
	int HIGHER_THAN_ME_THRESHOLD = 140;
	int AIM_RATIO = 80;
	string SOUND_STRUCK1 = "voices/human/male_hit2.wav";
	string SOUND_STRUCK2 = "voices/human/male_hit1.wav";
	string SOUND_STRUCK3 = "voices/human/male_hit3.wav";
	string SOUND_STRUCK4 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK5 = "weapons/cbar_hitbod1.wav";
	string SOUND_ATTACK1 = "none";
	string SOUND_ATTACK2 = "none";
	string SOUND_DEATH = "voices/human/male_die.wav";
	string SOUND_BOOM = "monsters/bear/giantbearstep2.wav";
	string SOUND_POISON = "x/x_laugh1.wav";
	float SPELL_FREQ = 7.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	string LIGHTNING_SPRITE = "lgtning.spr";
	bool NPC_IS_BOSS = false;
	int TOTAL_GUARDS = 0;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float NPC_GIVE_EXP = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool INTRODUCED = false;
	bool ALLOW_CHANGE = false;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_FLEE = "CAN_FLEE";
	Vector3 NEXT_TARGET = Vector3();
	CBaseEntity@ NEXT_TARGET_ID = null;
	bool SCANNING_TARGETS = false;
	CBaseEntity@ START_TARG = null;
	string CANT_TRACK = "CANT_TRACK";
	string CAN_HEAR = "CAN_HEAR";
	bool DID_ALE_INTRO = false;
	int RE_REBUKING = 0;
	string KSPELL_TARGET = "KSPELL_TARGET";
	bool SPAWNED = false;
	bool I_DIED = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool AM_SKELE = false;
	float ATTACK_DMG_LOW = 0.0f;
	float ATTACK_DMG_HIGH = 0.0f;
	int ATTACK_SPEED = 0;
	int ATTACK_CONE_OF_FIRE = 0;
	float SKEL_RESPAWN_TIMES = 0.0f;
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "1";
	string FLEE_DISTANCE = "4096";
	bool FIRE_BALL_DELAY = false;
	float AS_ATTACKING = 0.0f;
	bool REBUKE_DELAY = false;
	CBaseEntity@ REBUKE_TARGET = null;
	bool RETAL_DELAY = false;
	bool DID_BURST_A = false;
	bool DID_BURST_B = false;
	bool DID_BURST_C = false;
	bool DID_BURST_D = false;
	bool FIRE_PULSE_DELAY = false;
	bool FIRE_PULSE = false;

	// unnamed block (first think)
	void KeledrosruinsKeledros_FirstThink()
	{
		if (StartsWith(ToLowerCase(MapName()), "keledros"))
			NPC_IS_BOSS = true;

		IS_UNHOLY = true;

		SetGlobal("DEAD_GUARDS", 2); // Sets up dead guard global var - starts at 3, so he thinks all guards are dead and summons the first batch, sets to 0 at summon
		TOTAL_GUARDS = 2; // total number of infernals

		// trackers for archers
		SetGlobal("TWO_IS_DEAD", 1);
		SetGlobal("THREE_IS_DEAD", 1);
		SetGlobal("FOUR_IS_DEAD", 1);

		// Human form
		ATTACK_HITCHANCE = "0%";
		NPC_GIVE_EXP = 500.0f;
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_ATTACK = "castspell";

		INTRODUCED = false;
		ALLOW_CHANGE = false;

		MOVE_RANGE = "30";
		ATTACK_RANGE = 2000.0f;
		ATTACK_HITRANGE = 130.0f;

		CAN_HUNT = "0"; // base_npc_attack - Variable, because it changes
		CAN_ATTACK = "0"; // base_npc_attack - Variable, because it changes
		NPC_MOVE_TARGET = "enemy"; // base_npc_attack - Only target players
		RETALIATE_CHANCE = "85%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
		LIGHTNING_SPRITE = "lgtning.spr";
	}

	// game_precache
	void KeledrosruinsKeledros_OnGamePrecache()
	{
		PrecacheFile("items/proj_fire_ball");
		PrecacheFile("items/proj_fire_dart");
	}

	// npc_spawn
	void KeledrosruinsKeledros_OnNpcSpawn(string npc = "")
	{
		SetHealth(SKEL_HP);
		if (!AM_GENERIC)
			SetName("The Insane Wizard, Keledros");
		if (AM_GENERIC)
			SetName("Insane Wizard");
		SetFieldOfView(359);
		SetWidth(40);
		SetHeight(80);
		SetRoam(false);
		SetRace("demon");
		SetNoPush(true);
		SetModel("monsters/keledros.mdl");
		SetStepSize(16); // override basic step size due to Keledrosruins pits/catwalks are not monsterclipped
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);

		SetHearingSensitivity(11);

		OnNpcatkSuspendAi();

		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 1);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("fire", 1);
		SetDamageTaken("holy", 2);
		SetDamageTaken("cold", 0.2f);

		if (AM_GENERIC)
			CallEventDelayed(0.1f, "go_intro");

		if (AM_GENERIC)
			return;

		SetAngle("face", Vector3(0, -90, 0)); // dont do this! let the mapper set! >< (will undo if I ever ripent keledrosruins)

		OnScanForPlayers();

		SetInvincible(true);
	}

	// scan_for_players
	void KeledrosruinsKeledros_OnScanForPlayers()
	{
		if (INTRODUCED)
			return;
		CallEventDelayed(0.1f, "scan_for_players");

		string playerId = FindOneInSphere("player", 384);
		if (IsPlayer(playerId))
		{
			OnNpcatkTarget2(playerId);
			// dbg player in sphere $get(PLAYER_ID,name)
			OnGoIntro();
		}

		if (!Truthy(LegacyFunction("cansee", "player", 384)))
			return;
		OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSEEN)));
		// dbg saw player $get(ent_lastseen,name)
		OnGoIntro();
	}

	// go_intro
	void KeledrosruinsKeledros_OnGoIntro()
	{
		if (INTRODUCED)
			return;
		INTRODUCED = true;
		SetSayTextRange(2048);
		if (!AM_GENERIC)
			SayText("What's this? Visitors?");
		CallEventDelayed(2.5f, "start_it_up_yo");
		// hearingsensitivity 0
		bool exitSub = true;
	}

	// game_heardsound
	void KeledrosruinsKeledros_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (IsPlayer(ENT_LASTHEARD) && SCANNING_TARGETS)
		{
			NEXT_TARGET = OriginOf(ENT_LASTHEARD);
			@NEXT_TARGET_ID = EntityOf(ENT_LASTHEARD);
		}
		if (I_DIED && RangeTo(NPCATK_TARGET) > RangeTo(ENT_LASTHEARD))
			OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTHEARD)));

		if (INTRODUCED)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		SetMoveDest(ENT_LASTHEARD, 9999);
		if (!(RangeTo(ENT_LASTHEARD) < 450.0f))
			return;
		OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTHEARD)));
		// dbg heard player $get(ent_lastheard,name)
		OnGoIntro();
	}

	// start_it_up_yo
	void KeledrosruinsKeledros_OnStartItUpYo()
	{
		SetMoveAnim(ANIM_WALK);
		SCANNING_TARGETS = true;
		CallEventDelayed(1.0f, "scan_targets");
		CallEventDelayed(SPELL_FREQ, "do_spells");

		OnNpcatkResumeAi();

		// setmovedest (-558,663,334)  30 // tele -558 663 334
		UseTrigger("lights");

		if (!AM_GENERIC)
			SayText("Please do stay for some...games.");
		CAN_HUNT = "1";
		ANIM_ATTACK = "castspell";
		SetRoam(true);
		SetInvincible(false);

		// hearingsensitivity 0
		PlayAnim("once", ANIM_ATTACK);

		@START_TARG = EntityOf(ENT_LASTHEARD);

		CANT_TRACK = "1";
		CAN_HEAR = "0";
		MOVE_RANGE = "30";
		SetMoveDest(RelativePosition(Vector3(0, 600, 0)), MOVE_RANGE); // try to encourage him not to go upstairs

		CallEventDelayed(10.0f, "start_wander");
	}

	// scan_targets
	void KeledrosruinsKeledros_OnScanTargets()
	{
		if (!SCANNING_TARGETS)
			return;
		if (!CanSee("enemy"))
			return;
		NEXT_TARGET = OriginOf(ENT_LASTSEEN);
		@NEXT_TARGET_ID = EntityOf(ENT_LASTSEEN);
		CallEventDelayed(0.5f, "scan_targets");
	}

	// start_wander
	void KeledrosruinsKeledros_OnStartWander()
	{
		MOVE_RANGE = "10000";
	}

	// do_spells
	void KeledrosruinsKeledros_OnDoSpells()
	{
		CallEventDelayed(SPELL_FREQ, "do_spells");

		if (I_DIED)
			return;
		if (SUSPEND_AI)
			return;
		SCANNING_TARGETS = false;
		SetMoveDest(NEXT_TARGET, 9999);
		PlayAnim("once", ANIM_ATTACK);
	}

	// castspell
	// Deal damage
	void KeledrosruinsKeledros_OnCastspell()
	{
		bool exitSub = false;
		bool validCon = false;
		string effectScript = "EFFECT_SCRIPT";
		int setDamage = 0;
		int setDuration = 0;

		if (!DID_ALE_INTRO)
		{
			DID_ALE_INTRO = true;
			if (Contains(ToLowerCase(MapName()), "aleyesu"))
				OnDoAleIntro();
		}

		if (I_DIED) // no more getting back up to cast a spell
			return;

		if (!(SKEL_RESPAWN_TIMES < 1.0f))
			return;

		SCANNING_TARGETS = true;

		// dont combine counter-holy with spell
		if (RE_REBUKING == 1)
		{
			RE_REBUKING = 0;
			exitSub = true;
		}
		if (exitSub)
			return;

		// Pick a random attack, any attack
		int random = RandomInt(0, 3);

		if (random == 3)
		{
			// 'cept that one if I've used it recently
			if (SPAWNED)
				random = RandomInt(0, 2);
			// Thothie - or if some guards still alive (based on Infernal Count)
			if (Float(GetVar("DEAD_GUARDS")) < TOTAL_GUARDS)
				random = RandomInt(0, 2);
		}

		// Calculate the spell's position
		Vector3 pos = NEXT_TARGET;
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		// calculate target's vertical distance
		Vector3 mePos = OriginOf(ENT_ME);
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(HUNT_LASTTARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ;
		KSPELL_TARGET = HUNT_LASTTARGET;
		targetZDifference -= myZ;

		// must be within 1024 units, or visible to target
		if (Distance(MyOrigin(), pos) < 1024.0f)
			validCon = true;
		if (CanSee(EntityId(NEXT_TARGET_ID)))
			validCon = true;
		if (!validCon)
			return;

		bool targetHigherThanMe = false;
		if (targetZDifference > HIGHER_THAN_ME_THRESHOLD)
			targetHigherThanMe = true;

		// dbg MyZ MY_Z TargetZ TARGET_Z Diff TARGET_Z_DIFFERENCE TargHigher TARGET_HIGHER_THAN_ME
		if (!targetHigherThanMe)
		{
			effectScript = "effects/sfx_lightning";
			if (random == 0)
			{
				// Blizzard
				// dbg KELEDROS casts BLIZZARD
				effectScript = "monsters/summon/summon_blizzard";
				setDamage = 10;
				setDuration = 5;
				PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "magic/ice_strike.wav");
			}
			if (random == 1)
			{
				// Firewall
				// dbg KELEDROS casts FIREWALL
				effectScript = "monsters/summon/keledros_fire_wall";
				setDamage = 40;
				setDuration = 10;
				PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "magic/fireball_strike.wav");
			}
			if (random == 2)
			{
				// Lightning storm
				// dbg KELEDROS casts LIGHTNING STORM
				effectScript = "monsters/summon/summon_lightning_storm";
				setDamage = 20;
				setDuration = 10;
				PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "magic/lightning_strike.wav");
			}
			if (random == 3)
			{
				// Trigger all of the spawners - Thothie - rather, only those that aren't still alive
				// Archers that are still alive shouldn't respawn (this is handled internally by each spawner)
				// Infernals should all be dead before he recasts this (at least 2 must die)
				// Yell really loudly
				SetSayTextRange(1000);
				SayText("Come forth my undead minions!");
				SetSayTextRange(768);
				PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "magic/heal_powerup.wav");

				// infernals
				CallExternal(FindByName("spawner5"), "make_undead");
				CallExternal(FindByName("spawner6"), "make_undead");
				SetGlobal("DEAD_GUARDS", 0); // reset dead_guards counter

				// archers on seperate system
				// dbg Archers Dead ONE_IS_DEAD TWO_IS_DEAD THREE_IS_DEAD FOUR_IS_DEAD
				CallExternal(FindByName("spawner1"), "make_undead");
				CallExternal(FindByName("spawner2"), "make_undead");
				CallExternal(FindByName("spawner3"), "make_undead");
				CallExternal(FindByName("spawner4"), "make_undead");

				// Can be summoned through map instead
				UseTrigger("spawn_archers");

				// Prevent constant spawning
				SPAWNED = true;
				CallEventDelayed(0.0f, "20");
			}
		}

		// end if !TARGET_HIGHER_THAN_ME
		if (!targetHigherThanMe && !I_DIED)
			CreateNpc(effectScript, pos, self, AnglesOf(ENT_ME).y, setDamage, setDuration);

		if (targetHigherThanMe)
		{
			SetSayTextRange(2048);
			SayText("No use hiding up there!");

			// this bit prevents people sploitng rafters from hiding from Keledros
			// also prevents him from crashing server with lightning spell placed in library pillar
			int altSpellChoice = RandomInt(1, 2);
			if (altSpellChoice == 1)
			{
				// Massive Fireball for guy hiding in rafters
				float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
				SetAngle("add_view.x", aimAngle);

				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
				TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 10, 35)), "none", 1000, 400, 1, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
			}
			if (altSpellChoice == 2)
			{
				// Massive Lightning Bolt for guy hiding in rafters
				SetVolume(10);
				PlaySound(2, 10, "debris/beamstart15.wav");
				Effect("beam", "point", LIGHTNING_SPRITE, 200, RelativePosition(Vector3(0, 0, 0)), OriginOf(KSPELL_TARGET), Vector3(255, 255, 0), 150, 50, 0.5f);
				DoDamage(KSPELL_TARGET, "direct", 200, 100, ENT_ME, "lightning");
				ApplyEffect(HUNT_LASTTARGET, "effects/dot_lightning", 10, self, 10);
			}
		}

		ClientEvent("new", "all", CAST_SCRIPT, IndexOf(ENT_ME), 15, 2); // Left Hand effect
		ClientEvent("new", "all", CAST_SCRIPT, IndexOf(ENT_ME), 19, 2); // Right Hand effect
	}

	// npc_struck
	// Hit by someone
	void KeledrosruinsKeledros_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// game_death
	// Rise from the dead
	// ==================
	void KeledrosruinsKeledros_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool doDrop = false;

		I_DIED = true;
		ANIM_ATTACK = "lying_on_stomach";

		if (!AM_SKELE)
		{
			// saytextrange 1024
			if (!AM_GENERIC)
				SayText("This isn't the end!");

			int deathanim = RandomInt(0, 1);

			ANIM_DEATH = "diesimple";
			if (deathanim == 1)
				ANIM_DEATH = "dieforward";

			PlayAnim("hold", ANIM_DEATH);

			SetAlive(true);
			// setsolid 		none
			SetMoveDest("none");
			SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
			SetInvincible(true);
			SetRoam(false);
			CAN_ATTACK = "0";
			CAN_HUNT = "0";
			CAN_RETALIATE = "0";
			CAN_HEAR = "1";
			PLAYING_DEAD = "1";

			CallEventDelayed(7.0f, "skel_respawn");
		}

		if (AM_SKELE)
		{
			PlayAnim("critical", ANIM_DEATH);
			// //dbg Got Here! ITEM_MESSAGE
			// cant use var in info messages, cant use playermessage to target all - most frustrating...
			// fixed - use locals
			UseTrigger("wizard_died", "topodahill_chest");

			string mapName = ToLowerCase(MapName());
			if (mapName == "keledrosruins")
				doDrop = true;
			if (mapName == "aleyesu")
				doDrop = true;
			if (doDrop)
				CreateNpc("chests/keledros", RelativePosition(Vector3(0, 0, 0)));

			if (!AM_GENERIC)
			{
				// local MESSAGE_TITLE "Critical Item Dropped"
				// local FIN_ITEM_MESSAGE "Keledros has dropped "
				// stradd FIN_ITEM_MESSAGE ITEM_MESSAGE
				// infomsg all MESSAGE_TITLE FIN_ITEM_MESSAGE
				mapName = ToLowerCase(MapName());
				if (mapName == "keledrosruins")
				{
					Vector3 tSpawn = MyOrigin() + RelativePosition(Vector3(0, 0, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 45, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 90, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 135, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_50", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 180, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_50", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 225, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 270, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);

					tSpawn = MyOrigin() + RelativePosition(Vector3(0, 315, 0), Vector3(0, 100, 40));
					CreateNpc("chests/bag_o_gold_25", tSpawn);
				}
			}
		}
	}

	// skel_respawn
	void KeledrosruinsKeledros_OnSkelRespawn()
	{
		AM_SKELE = true;
		CANT_TRACK = "0";
		// Undead Form
		SetModel("monsters/skeleton3.mdl");
		SetDamageTaken("slash", 0.7f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("blunt", 1.2f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("all", 0.7f);
		// akedmg holy 1.5 //I think this is multiplying from his base?
		if (!AM_GENERIC)
			SetName("The animated remains of Keledros");
		SetHearingSensitivity(11);
		ATTACK_HITCHANCE = "85%";
		ATTACK_DMG_LOW = 15.0f;
		ATTACK_DMG_HIGH = 30.0f;
		MOVE_RANGE = "150";
		ATTACK_RANGE = 175.0f;
		ATTACK_HITRANGE = 200.0f;
		ANIM_RUN = "walk";
		ANIM_ATTACK = "attack1";
		ATTACK_SPEED = 1000;
		ATTACK_CONE_OF_FIRE = 6;
		ALLOW_CHANGE = true;

		SOUND_STRUCK1 = "zombie/zo_pain2.wav";
		SOUND_STRUCK2 = "zombie/zo_pain2.wav";
		SOUND_STRUCK3 = "zombie/zo_pain2.wav";
		SOUND_ATTACK1 = "zombie/claw_miss1.wav";

		SetSkillLevel(NPC_GIVE_EXP); // reset XP

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		PlayAnim("critical", "getup");
		SetSolid("box");
		SetBoundingBox("npcsize");
		SKEL_RESPAWN_TIMES += 1.0f;

		SetHealth(SKEL_HP);

		CallEventDelayed(2.5f, "skel_respawn_revived");
	}

	// skel_respawn_revived
	void KeledrosruinsKeledros_OnSkelRespawnRevived()
	{
		PLAYING_DEAD = "0";

		SetMoveDest(HUNT_LASTTARGET, 9999);
		SetRoam(true);
		SetInvincible(false);
		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		CAN_RETALIATE = "1";
		CAN_HEAR = "1";
		CAN_FLEE = "1";
		SetVar("kele.recharging", 0);
		FLEE_HEALTH = 0;
		FLEE_CHANCE = "1";
		FLEE_DISTANCE = "4096";
		SayText("You can't defeat me so easily!");

		string mapName = ToLowerCase(MapName());
	}

	// unnamed block (timer)
	void KeledrosruinsKeledros_Timer()
	{
		CallEventDelayed(1.0f, "KeledrosruinsKeledros_Timer");

		if ((ALLOW_CHANGE ? 1 : 0) != 1)
			return;

		if (Truthy(PLAYING_DEAD))
			return;

		float dist = DistanceTo(ENT_LASTSEEN);
		if (dist < 300.0f)
		{
			ANIM_ATTACK = "attack1";
			MOVE_RANGE = "150";
			ATTACK_RANGE = 175.0f;
		}
		if (dist > 300.0f)
		{
			ANIM_ATTACK = "attack2";
			MOVE_RANGE = "500";
			ATTACK_RANGE = 600.0f;
		}
	}

	// attack_1
	void KeledrosruinsKeledros_OnAttack12()
	{
		float dmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, dmg, ATTACK_HITCHANCE);
	}

	// npc_targetsighted
	void KeledrosruinsKeledros_OnNpcTargetsighted(string target = "")
	{
		if (!AM_SKELE)
			return;

		if (FIRE_BALL_DELAY)
			return;
		FIRE_BALL_DELAY = true;
		CallEventDelayed(2.0f, "reset_fire_delay");
		if (!(RangeTo(target) > 128.0f))
			return;
		AS_ATTACKING = GameTime();
		PlayAnim("once", "attack2");
	}

	// reset_fire_delay
	void KeledrosruinsKeledros_OnResetFireDelay()
	{
		FIRE_BALL_DELAY = false;
	}

	// attack_2
	void KeledrosruinsKeledros_OnAttack22()
	{
		// local AIM_ANGLE $get(ent_lastseen,dist)		//Aim up a bit
		// divide AIM_ANGLE AIM_RATIO			//
		// setangle add_view.x AIM_ANGLE			//
		float lclAtkdmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		int attackType = RandomInt(1, 2);
		if (attackType == 1)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_fire_dart", RelativePosition(Vector3(0, 10, 35)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
			TossProjectile("proj_fire_dart", RelativePosition(Vector3(0, 10, 35)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
			TossProjectile("proj_fire_dart", RelativePosition(Vector3(0, 10, 35)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
			TossProjectile("proj_fire_dart", RelativePosition(Vector3(0, 10, 35)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
		}
		if (attackType == 2)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 10, 35)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
		}

		ANIM_ATTACK = "attack1";
		MOVE_RANGE = "150";
		ATTACK_RANGE = 175.0f;

		ALLOW_CHANGE = false;

		CallEventDelayed(0.0f, "2");
	}

	// allow_change
	void KeledrosruinsKeledros_OnAllowChange()
	{
		ALLOW_CHANGE = true;
	}

	// allow_spawn
	void KeledrosruinsKeledros_OnAllowSpawn()
	{
		SPAWNED = false;
	}

	// turn_undead
	void KeledrosruinsKeledros_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;

		if (AM_SKELE)
			return;

		if (REBUKE_DELAY)
			return;
		REBUKE_DELAY = true;
		CallEventDelayed(2.0f, "reset_rebuke_delay");

		RE_REBUKING = 1;

		PlayAnim("once", "castspell");

		SetMoveDest(@exorcist, 9999);

		SetSayTextRange(1024);
		SayText("Your so-called 'divine' magics shall only get you burned!");

		@REBUKE_TARGET = exorcist;

		CallEventDelayed(1.0f, "rebuke_rebuker");
	}

	// reset_rebuke_delay
	void KeledrosruinsKeledros_OnResetRebukeDelay()
	{
		REBUKE_DELAY = false;
	}

	// rebuke_rebuker
	void KeledrosruinsKeledros_OnRebukeRebuker(string target = "")
	{
		// Massive Fireball for Mr. Divination
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_POISON);

		int altSpellChoice = RandomInt(1, 2);
		if (altSpellChoice == 1)
		{
			// Massive Fireball
			altSpellChoice = RandomInt(1, 2);
			float aimAngle = Divide(DistanceTo(REBUKE_TARGET), AIM_RATIO); // Aim up a bit
			SetAngle("add_view.x", aimAngle);

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
			TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 10, 5)), "none", 1000, 400, 1, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		}

		if (altSpellChoice == 2)
		{
			// Massive Lightning Bolt
			SetVolume(10);
			PlaySound(2, 10, "debris/beamstart15.wav");
			Effect("beam", "point", LIGHTNING_SPRITE, 200, RelativePosition(Vector3(0, 0, 0)), OriginOf(REBUKE_TARGET), Vector3(255, 255, 0), 150, 50, 0.5f);
			DoDamage(REBUKE_TARGET, "direct", 200, 100, ENT_ME, "lightning");
			ApplyEffect(target, "effects/dot_lightning", 10, self, 10);
		}
	}

	// game_damaged
	string KeledrosruinsKeledros_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (AM_SKELE)
			return result;
		if (!Contains(damageType, "holy"))
			return result;
		if (RETAL_DELAY)
			return result;
		RETAL_DELAY = true;
		SetSayTextRange(1024);
		SayText("Holy weapons call for unholy magic!");
		CallEventDelayed(6.0f, "reset_retal_delay");
		CallEventDelayed(1.0f, "rebuke_rebuker");
		return result;
	}

	// reset_retal_delay
	void KeledrosruinsKeledros_OnResetRetalDelay()
	{
		RETAL_DELAY = false;
	}

	// game_struck
	void KeledrosruinsKeledros_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		NEXT_TARGET = OriginOf(ENT_LASTSTRUCK);
		@NEXT_TARGET_ID = EntityOf(ENT_LASTSTRUCK);

		if (AM_SKELE && !FIRE_PULSE_DELAY)
		{
			if (!DID_BURST_A && MyHealth() < 2500.0f && RangeTo(ENT_LASTSTRUCK) < 256.0f)
			{
				DID_BURST_A = true;
				CallEventDelayed(0.1f, "fire_pulse");
			}

			if (!DID_BURST_B && MyHealth() < 2000.0f && RangeTo(ENT_LASTSTRUCK) < 256.0f)
			{
				DID_BURST_B = true;
				CallEventDelayed(0.1f, "fire_pulse");
			}

			if (!DID_BURST_C && MyHealth() < 1500.0f && RangeTo(ENT_LASTSTRUCK) < 256.0f)
			{
				DID_BURST_C = true;
				CallEventDelayed(0.1f, "fire_pulse");
			}

			if (!DID_BURST_D && MyHealth() < 500.0f && RangeTo(ENT_LASTSTRUCK) < 256.0f)
			{
				DID_BURST_D = true;
				CallEventDelayed(0.1f, "fire_pulse");
			}
		}
	}

	// fire_pulse
	void KeledrosruinsKeledros_OnFirePulse()
	{
		if (FIRE_PULSE_DELAY)
			return;
		if (!(MyHealth() > 0.0f))
			return;
		FIRE_PULSE_DELAY = true;
		CallEventDelayed(5.0f, "reset_fire_pulse_delay");

		FIRE_PULSE = true;
		PlayAnim("critical", "throw_scientist");
		CreateNpc("monsters/summon/flame_burst", RelativePosition(Vector3(0, 0, 0)), self, 20.0f);
		OnNpcatkSuspendAi("1");
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 512, 0.0f, "100%", 0.0f, "reflective", "target");
		CallEventDelayed(0.2f, "reset_fire_pulse");
	}

	// reset_fire_pulse_delay
	void KeledrosruinsKeledros_OnResetFirePulseDelay()
	{
		FIRE_PULSE_DELAY = false;
	}

	// reset_fire_pulse
	void KeledrosruinsKeledros_OnResetFirePulse()
	{
		FIRE_PULSE = false;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string KeledrosruinsKeledros_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!FIRE_PULSE)
			return result;
		if (!(RangeTo(target) < 256.0f))
			return result;
		AddVelocity(target, RelativeVelocity(Vector3(0, 800, 800)));
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { KeledrosruinsKeledros_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KeledrosruinsKeledros_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		KeledrosruinsKeledros_OnTurnUndead(holyDamage, exorcist);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KeledrosruinsKeledros_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttack_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		KeledrosruinsKeledros_OnGameHeardsound(soundType, origin, dangerRadius);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KeledrosruinsKeledros_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, KeledrosruinsKeledros_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, KeledrosruinsKeledros_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		KeledrosruinsKeledros_OnNpcTargetsighted(target);
	}

	void OnScanForPlayers() { KeledrosruinsKeledros_OnScanForPlayers(); } // scan_for_players
	void OnGoIntro() { KeledrosruinsKeledros_OnGoIntro(); } // go_intro
	void OnStartItUpYo() { KeledrosruinsKeledros_OnStartItUpYo(); } // start_it_up_yo
	void OnScanTargets() { KeledrosruinsKeledros_OnScanTargets(); } // scan_targets
	void OnStartWander() { KeledrosruinsKeledros_OnStartWander(); } // start_wander
	void OnDoSpells() { KeledrosruinsKeledros_OnDoSpells(); } // do_spells
	void OnCastspell() { KeledrosruinsKeledros_OnCastspell(); } // castspell
	void OnNpcStruck(float damage = 0.0f) { KeledrosruinsKeledros_OnNpcStruck(damage); } // npc_struck
	void OnSkelRespawn() { KeledrosruinsKeledros_OnSkelRespawn(); } // skel_respawn
	void OnSkelRespawnRevived() { KeledrosruinsKeledros_OnSkelRespawnRevived(); } // skel_respawn_revived
	void OnAttack12() { KeledrosruinsKeledros_OnAttack12(); } // attack_1
	void OnResetFireDelay() { KeledrosruinsKeledros_OnResetFireDelay(); } // reset_fire_delay
	void OnAttack22() { KeledrosruinsKeledros_OnAttack22(); } // attack_2
	void OnAllowChange() { KeledrosruinsKeledros_OnAllowChange(); } // allow_change
	void OnAllowSpawn() { KeledrosruinsKeledros_OnAllowSpawn(); } // allow_spawn
	void OnResetRebukeDelay() { KeledrosruinsKeledros_OnResetRebukeDelay(); } // reset_rebuke_delay
	void OnRebukeRebuker(string target = "") { KeledrosruinsKeledros_OnRebukeRebuker(target); } // rebuke_rebuker
	void OnResetRetalDelay() { KeledrosruinsKeledros_OnResetRetalDelay(); } // reset_retal_delay
	void OnFirePulse() { KeledrosruinsKeledros_OnFirePulse(); } // fire_pulse
	void OnResetFirePulseDelay() { KeledrosruinsKeledros_OnResetFirePulseDelay(); } // reset_fire_pulse_delay
	void OnResetFirePulse() { KeledrosruinsKeledros_OnResetFirePulse(); } // reset_fire_pulse
	void OnSpellFreq() {} // SPELL_FREQ
	void OnDoAleIntro() {} // do_ale_intro

	// This file's events and timers by their .script names
	bool KeledrosruinsKeledros_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "allow_change") { OnAllowChange(); return true; }
		if (name == "allow_spawn") { OnAllowSpawn(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "castspell") { OnCastspell(); return true; }
		if (name == "do_spells") { OnDoSpells(); return true; }
		if (name == "fire_pulse") { OnFirePulse(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "go_intro") { OnGoIntro(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "rebuke_rebuker") { OnRebukeRebuker(Param(params, 0)); return true; }
		if (name == "reset_fire_delay") { OnResetFireDelay(); return true; }
		if (name == "reset_fire_pulse") { OnResetFirePulse(); return true; }
		if (name == "reset_fire_pulse_delay") { OnResetFirePulseDelay(); return true; }
		if (name == "reset_rebuke_delay") { OnResetRebukeDelay(); return true; }
		if (name == "reset_retal_delay") { OnResetRetalDelay(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "scan_targets") { OnScanTargets(); return true; }
		if (name == "skel_respawn") { OnSkelRespawn(); return true; }
		if (name == "skel_respawn_revived") { OnSkelRespawnRevived(); return true; }
		if (name == "start_it_up_yo") { OnStartItUpYo(); return true; }
		if (name == "start_wander") { OnStartWander(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		if (name == "KeledrosruinsKeledros_Timer") { KeledrosruinsKeledros_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "keledrosruins/keledros"]
shared class KeledrosruinsKeledrosScript : BaseMonsterScript, KeledrosruinsKeledros
{
	// Variables every script that includes this file declares
	bool AM_GENERIC = false;

	// Variables declared by included files, with the value they start with in this script
	KeledrosruinsKeledrosScript()
	{
		NPC_AUTO_DEATH = false;
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		SOUND_DEATH = "voices/human/male_die.wav";
		FLEE_DISTANCE = "4096";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/animarmor.mdl");
		Precache("monsters/keledros.mdl");
		Precache("monsters/skeleton3.mdl");
		CallEventDelayed(1.0f, "KeledrosruinsKeledros_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeledrosruinsKeledros_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return KeledrosruinsKeledros_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
