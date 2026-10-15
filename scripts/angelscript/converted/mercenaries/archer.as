#pragma context server

// Converted from mercenaries/archer.script by msc_transpiler.
// A Human Archer

#include "runtime/ScriptEntity.as"

[script "mercenaries/archer"]
class MercenariesArcher : ScriptEntity
{
	// Constants
	string SOUND_DEATH = "voices/human/male_die.wav";

	// Variables (an unset .script variable reads as its own name)
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAINYELL = "voices/human/male_hit1.wav";
	string SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
	string SND_ATTACK1 = "voices/human/male_hit1.wav";
	string SND_ATTACK2 = "voices/human/male_hit2.wav";
	string SND_ATTACK3 = "voices/human/male_hit3.wav";
	string SND_BOW = "weapons/bow/bow.wav";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ATTACK_DAMAGE = "7";
	string ATTACK_HITCHANCE = "90%";
	int FLEE_HEALTH = 10;
	string FLEE_CHANCE = "15%";
	bool IS_FLEEING = false;
	string CAN_FLINCH = "CAN_FLINCH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	bool SEE_ENEMY = true;

	// dropstuff
	void MercenariesArcher_OnDropstuff()
	{
		// 60% chance of dropping arrows
		if (!(RandomInt(0, 100) >= 40))
			return;

		GiveItem("proj_arrow_iron", 30);
	}

	// dropstuff
	void MercenariesArcher_OnDropstuff_2()
	{
		// 90% chance of dropping bow
		if (!(RandomInt(0, 100) >= 10))
			return;

		GiveItem("bows_shortbow");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(120);
		// ov 180
		SetWidth(32);
		SetHeight(85);
		SetRace("orc");
		SetName("Human Archer");
		SetRoam(true);
		SetSkillLevel(0);
		SetGold(RandomInt(6, 10));
		SetHearingSensitivity(3);
		SetModel("npc/archer.mdl");
		SetDamageTaken("all", 0.8f);
		SetModelBody(0, 2);
		SetModelBody(1, 1);
		SetModelBody(2, 3);
		SetIdleAnim("idle1");
		SetMoveAnim("walk");
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAINYELL = "voices/human/male_hit1.wav";
		SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
		SND_ATTACK1 = "voices/human/male_hit1.wav";
		SND_ATTACK2 = "voices/human/male_hit2.wav";
		SND_ATTACK3 = "voices/human/male_hit3.wav";
		SND_BOW = "weapons/bow/bow.wav";
		CAN_FLINCH = "1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		MOVE_RANGE = "40";
		ATTACK_RANGE = 600.0f;
		ATTACK_HITRANGE = 650.0f;
		ATTACK_DAMAGE = "7";
		ATTACK_HITCHANCE = "90%";
		FLINCH_DELAY = "4";
		FLEE_HEALTH = 10;
		FLEE_CHANCE = "15%";
		IS_FLEEING = false;
		SetStat("parry", 5);

		OnHuntLook();
	}

	// wield_battleaxe
	// Wield weapons
	void OnWieldBattleaxe()
	{
		SetModelBody(2, 2);
	}

	// drop_battleaxe
	void OnDropBattleaxe()
	{
		SetModelBody(2, 0);
	}

	// grab_arrow
	void OnGrabArrow()
	{
		SetModelBody(3, 1);
	}

	// hunt_look
	// Hunting
	void OnHuntLook()
	{
		CallEventDelayed(0.2f, "hunt_look");
		// (never true here, the rest is skipped) see enemy
	}

	// wander
	void OnWander()
	{
		SetMoveAnim(ANIM_WALK);
		SEE_ENEMY = false;
	}

	// hunt_attack
	// Attack
	void OnHuntAttack()
	{
		if (!(0.0f <= ATTACK_RANGE))
			return;

		SetMoveDest(ENT_LASTSEEN, ATTACK_RANGE);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		// Deal damage
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 0)), ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, 0, "none");
		SetModelBody(3, 0);
		PlaySound(2, 10, SND_BOW);
	}

	// warcry
	// War cry
	void OnWarcry()
	{
		PlaySound(2, 10, SOUND_WARCRY1);
	}

	// attackstrike
	// Attack grunts
	void OnAttackstrike()
	{
		PlayRandomSound(2, 10, SND_ATTACK1, SND_ATTACK2, SND_ATTACK3, "none");
	}

	// struck
	// Hit by someone
	void OnStruck()
	{
		PlayRandomSound(2, 10, SOUND_PAINYELL, SND_STRUCK2, SOUND_PAINYELL);
		OnFlinch();

		// Change targets to attacker
		OnRetaliate();
	}

	// flinch
	void OnFlinch()
	{
		if (CAN_FLINCH != "1")
			return;
		PlayAnim("critical", "flinch");
		CAN_FLINCH = "0";
		CallEventDelayed(0.0f, FLINCH_DELAY);
	}

	// resetflinch
	void OnResetflinch()
	{
		CAN_FLINCH = "1";
	}

	// retaliate
	void OnRetaliate()
	{
		if (RandomInt(1, 3) != 1)
			return;

		SetMoveDest(ENT_LASTSTRUCK, 9999);
		Look();
		OnHuntLook();
	}

	// checkflee
	void OnCheckflee()
	{
		// Chance of fleeing at low health
		if (!(0.0f <= FLEE_HEALTH))
			return;
		if (!(RandomInt(0, 100) < Float(FLEE_CHANCE)))
			return;

		SetMoveAnim(ANIM_RUN);
		SetMoveDest("flee", ENT_LASTSTRUCK, 300);
		IS_FLEEING = true;
		CallEventDelayed(0.0f, "0.5");
	}

	// stopflee
	void OnStopflee()
	{
		IS_FLEEING = false;
	}

	// facenewenemy
	void OnFacenewenemy()
	{
		// Face my new enemy, if i didn't decide to flee
		if ((IS_FLEEING ? 1 : 0) != 0)
			return;

		SetMoveDest("moveto", ENT_LASTSTRUCK, 9999);
		Look(1024);
	}

	// death
	void OnDeath()
	{
		PlaySound(2, 10, SOUND_DEATH);
		SetModelBody(2, 0);
		OnDropstuff();
	}

	// dropstuff
	void OnDropstuff()
	{
		MercenariesArcher_OnDropstuff();
		MercenariesArcher_OnDropstuff_2();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/archer.mdl");
		CallEventDelayed(0.2f, "hunt_look");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attackstrike") { OnAttackstrike(); return true; }
		if (name == "checkflee") { OnCheckflee(); return true; }
		if (name == "death") { OnDeath(); return true; }
		if (name == "drop_battleaxe") { OnDropBattleaxe(); return true; }
		if (name == "dropstuff") { OnDropstuff(); return true; }
		if (name == "facenewenemy") { OnFacenewenemy(); return true; }
		if (name == "flinch") { OnFlinch(); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "hunt_attack") { OnHuntAttack(); return true; }
		if (name == "hunt_look") { OnHuntLook(); return true; }
		if (name == "resetflinch") { OnResetflinch(); return true; }
		if (name == "retaliate") { OnRetaliate(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "stopflee") { OnStopflee(); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "wander") { OnWander(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		if (name == "wield_battleaxe") { OnWieldBattleaxe(); return true; }
		return false;
	}
}
