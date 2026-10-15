#pragma context server

// Converted from edana/masterp.script by msc_transpiler.
// Master Priest Sembelbin rewrite 9:47 AM 7/13/2010 by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/help/first_npc.as"
#include "converted/monsters/base_xmass.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class EdanaMasterp
{
	// Constants
	string IDLE_ANIMLIST = "idle1;idle3;idle4;idle5;idle6;idle7";
	float CHAT_DELAY = 5.0f;
	bool CHAT_AUTO_HAIL = true;
	bool CHAT_AUTO_JOB = true;
	bool CHAT_AUTO_RUMOR = true;
	bool CHAT_NEVER_INTERRUPT = true;
	bool XMASS_OLD_GUY = true;

	// Variables (an unset .script variable reads as its own name)
	int DID_INTRO = 0;
	int EVIDENCE_FOUND = 0;
	bool RING_EXPLAINED = false;
	CBasePlayer@ RING_BEARER = null;
	CBaseEntity@ NAME_REQ_ID = null;
	bool DID_CHANGE_INTRO = false;
	bool SENDING_YN = false;
	bool CHAT_MENU_ON = false;
	CBasePlayer@ USER_ID = null;
	bool CHANGING_NAME = false;

	// game_spawn
	void EdanaMasterp_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetName("Sembelbin");
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		SetNoPush(true);

		SetSayTextRange(1024);

		SetIdleAnim("idle1");

		CatchSpeech("say_hi", "hail", "hi", "j0", "yo", "waddup", "wassup", "gweets", "greetings");
		CatchSpeech("say_rumor", "deed", "rumor", "rumour");
		CatchSpeech("say_job", "job", "work", "quest");

		CatchSpeech("say_apostles", "apostle");
		CatchSpeech("say_bloodrose", "blood");
		CatchSpeech("say_changes", "changes");
		CatchSpeech("say_city", "city", "cities");
		CatchSpeech("say_elves", "elve", "elf", "elve");
		CatchSpeech("say_forest", "forest", "sfor");
		CatchSpeech("say_history", "Undamael", "history");
		CatchSpeech("say_thornlands", "land");
		CatchSpeech("say_loreldians", "loreldians");
		CatchSpeech("say_malgor", "malgor", "lor ");
		CatchSpeech("say_orcs", "orc", "orcs");
		CatchSpeech("say_helena", "helena");
		CatchSpeech("say_felewyn", "felewyn");
		CatchSpeech("say_temple", "temple", "church");
		CatchSpeech("say_temple3x", "more");
		CatchSpeech("say_torkalath", "tork");
		CatchSpeech("say_undead", "undead");
		CatchSpeech("say_unbal", "unbalance");
		CatchSpeech("say_unquest", "unquest");
		CatchSpeech("say_pathos", "pathos");
		CatchSpeech("say_thelost", "lost", "fate");
		CatchSpeech("say_aob", "age of");
		CatchSpeech("say_urdual", "urdual");
		CatchSpeech("say_shad", "shad");
		CatchSpeech("say_maldora", "mald");

		CatchSpeech("say_pillarquest", "xyphemox", "ring", "rune", "runes");
		CatchSpeech("say_allIknow", "zahlon", "erste");

		OnLoadChat();

		OnScanForPlayers();
	}

	// scan_for_players
	void EdanaMasterp_OnScanForPlayers()
	{
		if (DID_INTRO == 0)
			CallEventDelayed(2.0f, "scan_for_players");

		if (DID_INTRO != 0)
			return;

		if (!CanSee("player"))
			return;
		if (!(MaxHealthOf(ENT_LASTSEEN) < 10.0f))
			return;

		DID_INTRO = 1;
		OnDoIntro();
	}

	// unnamed block (timer)
	void EdanaMasterp_Timer()
	{
		CallEventDelayed(Random(8, 12), "EdanaMasterp_Timer");
		if (CHAT_BUSY)
			return;
		float nIdles = GetTokenCount(IDLE_ANIMLIST) - 1.0f;
		int rndIdle = RandomInt(0, int(nIdles));
		string rndIdleAnim = GetToken(IDLE_ANIMLIST, rndIdle);
		PlayAnim("once", rndIdleAnim);
	}

	// do_intro
	void EdanaMasterp_OnDoIntro()
	{
		if (CHAT_BUSY)
			return;
		OnChatNow("Ahh, another adventurer! Please, come here and speak with me!", "3.0", "gluonshow");
	}

	// load_chat
	void EdanaMasterp_OnLoadChat()
	{
		// note, overflow happens around colum 100
		OnChatAddText("say_intro", "Ahh, another adventurer! Please, come here and speak with me!", "3.0", "gluonshow");
		OnChatAddText("say_intro", "I've been recently disturbed by the [changes] around the [Thornlands].");

		OnChatAddText("say_hi", "Greetings, young adventurer. What brings you here? I have knowledge of many things...", Text(CHAT_DELAY), "talkright");
		OnChatAddText("say_hi", "I can tell you of the [history], the [land], the [cities] and other places; and of the [Unbalance] that has recently reached our [temple].");

		OnChatAddText("say_city", "We are on the outskirts of Edana, the largest city in the Southeast. To the northeast is [Helena], on the borders of the plains of Daragoth.", "6.0");
		OnChatAddText("say_city", "Beyond those dangerous planes lies Deralia, the jewel of civilization and capital of the kingdom.");
		OnChatAddText("say_city", "North of [Thornlands], past the nexus of [Bloodrose], lies the [Elven] city Kray Eldorad.");
		OnChatAddText("say_city", "But troubles in the [Bloodrose] pass have made travel difficult, and thus sightings of [elves] are rare indeed.");

		OnChatAddText("say_bloodrose", "Bloodrose lies beyond the [Thornlands], between the human lands, and those of the [elves].");
		OnChatAddText("say_bloodrose", "Strange troubles there have all but cut off the connections between our two peoples.");

		OnChatAddText("say_elves", "The elves are the first of the Enlightened Races, most closely resembling the goddess who created them.");
		OnChatAddText("say_elves", "They are a people of fierce honor, and wondrous majesty.");

		OnChatAddText("say_loreldians", "The Loreldians, former keepers of this world, masters of a forbidden magic that nearly destroyed all that is.");
		OnChatAddText("say_loreldians", "After the great Wars of Fate, only but a handful remained, and they vowed to banish themselves from this world.");
		OnChatAddText("say_loreldians", "This, to save it from inevitable destruction at their own hands, for they had indeed become that powerful.");
		OnChatAddText("say_loreldians", "Three were elected by [Pathos] to stay behind, and these are the great guardian gods we know today as The Triad:");
		OnChatAddText("say_loreldians", "[Felewyn] of Order, [Torkalath] of Chaos, and [Urdual] of Balance.");

		OnChatAddText("say_unbal", "Recently, the [undead] have begun returning, plaguing the lands. Also, an alarming number of [orcs] have appeared.");
		OnChatAddText("say_unbal", "These are all thought to be indications of a great imbalance, looming on the horizon.");

		OnChatAddText("say_pathos", "The Golden God, the Shining One, the Guardian who awaits beyond The Gate of Dreams, many are the names of this most exalted, and most distant god of gods.", "7.0");
		OnChatAddText("say_pathos", "He has no temples, but each temple of The Triad has an aspect of Pathos within it, for it is He who chose our gods from among His people before leaving this world.", "7.0");
		OnChatAddText("say_pathos", "It is He who saved the world from the War of Fate through self-sacrifice and denial of His own desires and those of His own kin.", "7.0");
		OnChatAddText("say_pathos", "It is He who returned from The Beyond, for a time, to save us from destruction at the hands of the mad [Lor Malgoriand], ending the [Age of Blood].", "7.0");
		OnChatAddText("say_pathos", "The Triad of gods he left to guard us complement one another and sustain the world. It is in His infinite wisdom that this diametric opposition was created.", "7.0");
		OnChatAddText("say_pathos", "For Pathos knew, while no [Loreldian] has within Himself the power to slay another, and it requires two to imprison a third...", "7.0");
		OnChatAddText("say_pathos", "...it takes no less than three to destroy a forth forever.");
		OnChatAddText("say_pathos", "Thus is the eternal reign of The Triad ensured, as is their eternal struggle, from which all progress is born.");

		OnChatAddText("say_temple", "This temple is dedicated to Urdual, the venerable and wise deity of balance.");
		OnChatAddText("say_temple", "Urdual's fate is to balance. Where there is too much order, he creates chaos. Where there is too much chaos, he creates order.");
		OnChatAddText("say_temple", "It is he who forged the hearty Dwarves, who can live deep within the mountains, and thus separate themselves from the cycles of chaos and order.");
		OnChatAddText("say_temple", "Do you wish to know [more] of the temple?");

		OnChatAddText("say_temple_more", "There's a reason for the somewhat 'unusual' way a temple of [Urdual] such as this is built.");
		OnChatAddText("say_temple_more", "Each stone that forms this delicate structure has been blessed in another order's temple.");
		OnChatAddText("say_temple_more", "The dark side of this temple is imbued with the strength of the god of chaos and freedom, [Torkalath]...");
		OnChatAddText("say_temple_more", "While the bright side is imbued with the power of order and law that emanates from [Felewyn's] shrines.");
		OnChatAddText("say_temple_more", "The gold between them represents the founding power of [Pathos] which binds them together in common cause.");
		OnChatAddText("say_temple_more", "It's a delicate balance. Would one side be slightly too weak or powerful, the entire temple may crack and crumble.");
		OnChatAddText("say_temple_more", "If the power of chaos or order overwhelms an area, the nearby temples of [Urdual] often become asymmetric, and crack.");
		OnChatAddText("say_temple_more", "Many such 'cracked' temples are scattered across the land...", "3.0");
		OnChatAddText("say_temple_more", "Most are filled with monsters, bent on spawning yet more unbalance.", "3.0");
		OnChatAddText("say_temple_more", "Here, all is well enough, for now. But watch your step, for the paths of light and darkness are known to be a bit tricky.");

		OnChatAddText("say_history", "Much of history is tainted by darkness, and amongst the darkest of these taints is the Lord Undamael.");
		OnChatAddText("say_history", "The final abominable creation of [Lor Malgoriand], surviving even his master's defeat, he was eventually overcome by the power of a cabal of five powerful magi.", "7.0");
		OnChatAddText("say_history", "The army of [undead], which was under his command, has scattered. But some say the lord himself still lives on...");
		OnChatAddText("say_history", "It is said that it is he who causing the eternal night which has befallen the [forest] to the west.");

		OnChatAddText("say_forest", "The forest to the west was once beautiful, but ever since the evil came, the place has been cursed.");
		OnChatAddText("say_forest", "Now it is called Eswen Meldanual, meaning 'Forest of Midnight.'");

		OnChatAddText("say_malgor", "Ahh, Lor Malgoriand, as he was dubbed by the elves, litterally 'The Bringer of Darkness.'");
		OnChatAddText("say_malgor", "Hundreds of years ago he brought ruin and death to three quarters of the known world!");
		OnChatAddText("say_malgor", "If not for Lor Malgoriand, we would not have to deal with the [orcs] and mayhaps not even the [undead].");
		OnChatAddText("say_malgor", "Though he began as an [Apostle] of [Torkalath], tasked with restoring the balance, he had become infected with the madness of [The Lost].");
		OnChatAddText("say_malgor", "Though defeated by the [Apostles] after much bloodshed, his power and his minions still linger...");
		OnChatAddText("say_malgor", "...and there are many who believe he may one day return.");

		OnChatAddText("say_thelost", "In times before man and dwarf and even elf, there were the Gods of Fate, known as [Loreldians], who banished themselves from this world.");
		OnChatAddText("say_thelost", "But among these gods were those that refused to leave... Thus began the war of the gods, The Great War of Fate.");
		OnChatAddText("say_thelost", "When the war concluded, those gods of hate and greed had their very existence stricken from all time and memory, and thus are forever known only as 'The Lost'.", "7.0");
		OnChatAddText("say_thelost", "But their power was such and their hate was so strong, that even with their souls shredded and scattered across the cosmos, the shadow of their evil remained.", "7.0");
		OnChatAddText("say_thelost", "That hate now infects the outermost edges of the very Threads of Fate, and is constantly searching for ways into our world.");
		OnChatAddText("say_thelost", "Sometimes it succeeds and causes great disturbances, manifestations of pure violence and destruction. Mindless horrors beyond imagining.", "7.0");
		OnChatAddText("say_thelost", "Sometimes those truly lost in misery, hatred, or despair, find themselves possessed by the power of this ancient force.");
		OnChatAddText("say_thelost", "Such was the case of [Lor Malgoriand], once a mighty [Apostle] of [Torakalath], he was seduced by the power of The Lost.");
		OnChatAddText("say_thelost", "This was unbeknownst to all, until it was too late.");

		OnChatAddText("say_apostles", "The Apostles are the warriors of Fate, patrons of the gods, their power drawn upon that of the [Loreldians] themselves.");
		OnChatAddText("say_apostles", "None knows what became of those who helped defeat [Lor Malgoriand] at the close of the [Age of Blood].");
		OnChatAddText("say_apostles", "We only pray that they can be called upon once again when the need will arise, as there is no doubt it will.");

		OnChatAddText("say_rumor", "Rumors? Well... I do know of one... Let me tell you a local story...");
		OnChatAddText("say_rumor", "Years ago, Deralia was ruled by a Tyrant-King. Only one man dared to challenge him: Kustrin, then mayor of Edana.");
		OnChatAddText("say_rumor", "Kustrin was assassinated, which so infuriated his son that he went to Deralia to settle the score.");
		OnChatAddText("say_rumor", "The king was arrogant, and not about to show fear of a little boy. He accepted the challenge to a duel.");
		OnChatAddText("say_rumor", "What the king did not know was that the son had been studying swordplay all his life: thus the king was slain.");
		OnChatAddText("say_rumor", "The boy's name?  You'll soon meet him if you haven't already.  But watch out, don't tread on his flowers!");

		OnChatAddText("say_pq", "Oh my, that ancient ring belonged to the legendary high priest Zahlon Erste.");
		OnChatAddText("say_pq", "Xyphemox was his title name in the Order of Urdual.", "3.0");
		OnChatAddText("say_pq", "Legend has it that he was slain shortly after imprisoning the undead sorcerer [Shadahar].");
		OnChatAddText("say_pq", "It is foretold... That a fool of great power shall release [Shadahar] from his tomb.");
		OnChatAddText("say_pq", "Thus marking the beginning of a great imbalance.", "3.0");
		OnChatAddText("say_pq", "Perhaps you are that fool?", "2.0", "retina");

		OnChatAddText("say_allIknow", "That is all I know on the subject, for I no longer venture beyond these halls.");
		OnChatAddText("say_allIknow", "If there is more to discover, I'm afraid it is up to you to do so.");

		OnChatAddText("gave_ring", "I suppose you are that fool after all.", Text(CHAT_DELAY), "idle4");
		OnChatAddText("gave_ring", "The prophecy is clear, as is my duty, though I am loathed to perform it.");
		OnChatAddText("gave_ring", "I shall restore the magic of this ring, and return it to you, as is ordained.");
		OnChatAddText("gave_ring", "But woe is thee, for thou art the Ring Bearer, and harbinger of [Shadahar's] return.", Text(CHAT_DELAY), "gluonshow");
		OnChatAddText("gave_ring", "Do with this ring as thou wilt, and I pray this evil shall yet be turned to good by your hand.", Text(CHAT_DELAY), "kneel");

		OnChatAddText("say_felewyn", "Felewyn is the goddess of order and law. [Elves] worship her as their creator, save for those who serve [Torkalath] or [Urdual].");
		OnChatAddText("say_felewyn", "But those few are shunned, sometimes even hunted, by their more traditional kin.");
		OnChatAddText("say_felewyn", "It is she who brought forth the herd animals and the hive-minded worker insects and other creatures of a calm and orderly nature in ages past...");
		OnChatAddText("say_felewyn", "She encourages those would uphold the law of the land over their own selfish desires, who protect the weak from the strong, and maintain discipline and order.");

		OnChatAddText("say_torkalath", "Torkalath is the god of strength, of freedom, and of chaos. He believes in strengthening ones self through strife and struggle.");
		OnChatAddText("say_torkalath", "He encourages those who defend their individuality, who resist conformity, and those who realize their fullest potential in whatever they may do.");
		OnChatAddText("say_torkalath", "He created the great predatory beasts of the land during the recovery that followed the War of Fate, granting them strength, cunning, and grace.");
		OnChatAddText("say_torkalath", "It is He who eventually forged the soul of man: ever striving and ever ambitious, flexible, adaptable, and clever.");
		OnChatAddText("say_torkalath", "He gifted the [Orcs] to [Lor Malgoriand] at the beginning of the [Age of Blood], and created many of the other great warrior races that dot the lands.");

		OnChatAddText("say_urdual", "Urdual is the god of balance.", "3.0");
		OnChatAddText("say_urdual", "The eldest of The Triad, His wisdom is sought after by the other two gods to determine the path of the ever-swinging pendulum of order and chaos.");
		OnChatAddText("say_urdual", "[Torkalath] and [Felewyn] are at constant odds, and thus [Urdual] serves as the mediator between the two opposing forces of law and freedom.");
		OnChatAddText("say_urdual", "After the War of Fate, it was He who established the never ending cycles of nature. May they endure eternally.");
		OnChatAddText("say_urdual", "It is He who created the dwarven race, hearty and stoic, and as unshakable as the stones.");
		OnChatAddText("say_urdual", "They dwell in the mountains that they may separate themselves from the constant conflicts of the lands. This allows them to play as impartial observers.");
		OnChatAddText("say_urdual", "...Though it seems their quizzical nature rarely allows them to be exactly that.");

		OnChatAddText("say_aob", "The Age of Blood of centuries past, describes the nearly two hundred year long war that ended The Crystal Eon of perfect order that came before it.");
		OnChatAddText("say_aob", "It began at a time when order was so strong that all was stagnant, and they very freedom of thought itself was threatened!", "7.0");
		OnChatAddText("say_aob", "But so violent was this war, that it broke beyond any new equilibrium, and into a terminal bloody chaos that threatened to engulf the world.", "7.0");
		OnChatAddText("say_aob", "[Lor Malgoriand], Torkalath's newest [Apostle], the strongest He had ever imbued with power, had been tasked with ending The Crystal Eon...", "7.0");
		OnChatAddText("say_aob", "...but alas, he was mad with grief from the moment of his endowment.");
		OnChatAddText("say_aob", "This made him vulnerable to the influence of [The Lost], and before even the gods themselves had known it, he was consumed by the harnessing of their power.", "7.0");
		OnChatAddText("say_aob", "It was for this reason that even when Torkalath revoked the power He had given His creation, [Lor Malgoriand] did not die.");
		OnChatAddText("say_aob", "Instead, he grew only stronger, and more possessed of hatred.");
		OnChatAddText("say_aob", "The war ended, with the return of the prophetic [Pathos], the rise of the [Apostle] Lanethan...");
		OnChatAddText("say_aob", "...and the eventual slaying of [Lor Malgoriand] at the hands of [Felewyn] Herself.");
		OnChatAddText("say_aob", "[Pathos] has left us again, returning to his sleeping comrades, and the [Apostles] of that age have also vanished, but He promised that,");
		OnChatAddText("say_aob", "'In the The Beyond He dreams only of us, and thus He watches, and will return, should He be needed again.");

		OnChatAddText("say_orcs", "The orcs were the first living, breathing tools of [Lor Malgoriand].");
		OnChatAddText("say_orcs", "The first were the ice dwelling Maragor tribe, but soon after came the heat loving Borsh, or the [Shadahar] Tribe, as they are now known...");
		OnChatAddText("say_orcs", "Lastly, he created the huge and all encompassing Black Hand tribe.");
		OnChatAddText("say_orcs", "The Black Hand raids villages regularly in these parts to this day. It wasn't so long ago they nearly destroyed [Helena].");
		OnChatAddText("say_orcs", "Although the orcs and the [undead] were both tools of [Lor Malgoriand], without their master, it seems they are no longer willing to cooperate.");
		OnChatAddText("say_orcs", "This is fortunate for us! Indeed, it is the main reason we've managed to maintain the kingdom for so long, despite the hardships.");

		OnChatAddText("say_undead", "The undead and the [orcs] were among the many vile tools of [Lor Malgoriand] of [The Lost], amongst other evils.");
		OnChatAddText("say_undead", "Recently, a great force of undead has begun clawing its way up through the ground.");
		OnChatAddText("say_undead", "If you can find some way to slow their progress, I would be very grateful.");
		OnChatAddText("say_undead", "Bring me any relics you can find upon their dismembered corpses, and I will judge their usefulness.");

		OnChatAddText("say_name_change", "For a fee, I can submit for a change of name permit from the King of Deralia, and officially change your name throughout the lands.");
		OnChatAddText("say_name_change", "Beware, however, this fee increases exponentially each time, beginning at 100 gold.");
		OnChatAddText("say_name_change", "Do you really wish to have your name changed?");

		OnChatAddText("say_shad", "Shadahar was a feared necromancer just prior to the [Age of Blood].");
		OnChatAddText("say_shad", "Though his more ambitious activities were kept in check by the forces of order, that were so prevalent at the time, he built many great palaces.", "7.0");
		OnChatAddText("say_shad", "These were necropolises, where he stored armies of the dead, and other abominations, as he lie in wait for an age when he could rise to power.", "7.0");
		OnChatAddText("say_shad", "Before his dreams could be realized, however, he was imprisoned by the Xyphemox Zahlon Erste.");
		OnChatAddText("say_shad", "His greatest palace, a hall of great majesty hidden somewhere in the Aluhandra desert, lay abandon for centuries.");
		OnChatAddText("say_shad", "But at the end of the [Age of Blood], the Borsh [orc] tribe, having been soundly defeated by the [elves], took refuge within its walls.", "7.0");
		OnChatAddText("say_shad", "As they bided their time there, they were soon infected with its power.");
		OnChatAddText("say_shad", "Their chief, the immortal Rungahr, together with his shamans, unlocked many of the necromancer's secrets.");
		OnChatAddText("say_shad", "Under their chief's guidance, these enchanted orcs have become the most powerful in all the lands, and thus renamed themselves the tribe of Shadahar.", "7.0");
		OnChatAddText("say_shad", "Thankfully, however, they rarely wander very far from their home of Shadahar, for it is the source of their power.");

		OnChatAddText("say_maldora", "Ah Maldora... He is a mysterious one. A powerful wizard indeed, some say he may even be the reincarnation of [Lor Malgoriand] himself.", "7.0");
		OnChatAddText("say_maldora", "There have been rumors of sightings of an ancient [Loreldian] flying fortress, at the very northern edges of the lands.");
		OnChatAddText("say_maldora", "These same rumors claim that Maldora resides within that fortress.");
		OnChatAddText("say_maldora", "Such fortresses have not been seen since the [Age of Blood] and even then, they were indeed rare.");
		OnChatAddText("say_maldora", "Thus, if the rumors to be believed, then Maldora has achieved power almost beyond imagination. Who knows what evil he may bring upon us all?");
	}

	// say_hi
	void EdanaMasterp_OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnChatStartSequence("say_hi");
	}

	// say_city
	void EdanaMasterp_OnSayCity()
	{
		OnChatStartSequence("say_city");
	}

	// say_bloodrose
	void EdanaMasterp_OnSayBloodrose()
	{
		OnChatStartSequence("say_bloodrose");
	}

	// say_elves
	void EdanaMasterp_OnSayElves()
	{
		OnChatStartSequence("say_elves");
	}

	// say_loreldians
	void EdanaMasterp_OnSayLoreldians()
	{
		OnChatStartSequence("say_loreldians");
	}

	// say_unbal
	void EdanaMasterp_OnSayUnbal()
	{
		OnChatStartSequence("say_unbal");
	}

	// say_thornlands
	void EdanaMasterp_OnSayThornlands()
	{
		OnChatNow("The Thornlands was once a beautiful place to visit, but the [unbalance] has destroyed its former luster.");
	}

	// say_changes
	void EdanaMasterp_OnSayChanges()
	{
		OnChatNow("The grass rots. Birds and beasts die. The land is sick. Something must be done to stop the [undead].");
	}

	// say_job
	void EdanaMasterp_OnSayJob(CBasePlayer@ player = null)
	{
		if (CHAT_BUSY)
			OnChatBusyMessage();
		if (CHAT_BUSY)
			return;
		OnChatNow("Well newcomers often look into town for such matters.");
		if (EVIDENCE_FOUND == 0)
			return;
		CallEventDelayed(CHAT_DELAY, "say_job2");
	}

	// say_job2
	void EdanaMasterp_OnSayJob2(string target = "")
	{
		OnChatNow("Maybe you could become an errand runner for the next mayor?", "3.0", "retina");
	}

	// worldevent_evidence_found
	void EdanaMasterp_OnWorldeventEvidenceFound()
	{
		EVIDENCE_FOUND = 1;
	}

	// say_pathos
	// new
	void EdanaMasterp_OnSayPathos()
	{
		OnChatStartSequence("say_pathos");
	}

	// say_temple
	void EdanaMasterp_OnSayTemple()
	{
		OnChatStartSequence("say_temple");
	}

	// say_temple3x
	void EdanaMasterp_OnSayTemple3x()
	{
		OnChatStartSequence("say_temple_more");
	}

	// say_history
	void EdanaMasterp_OnSayHistory()
	{
		OnChatStartSequence("say_history");
	}

	// say_forest
	void EdanaMasterp_OnSayForest(CBasePlayer@ speaker = null)
	{
		OnChatStartSequence("say_forest");
	}

	// say_malgor
	void EdanaMasterp_OnSayMalgor()
	{
		OnChatStartSequence("say_malgor");
	}

	// say_thelost
	// new
	void EdanaMasterp_OnSayThelost()
	{
		OnChatStartSequence("say_thelost");
	}

	// say_apostles
	void EdanaMasterp_OnSayApostles()
	{
		OnChatStartSequence("say_apostles");
	}

	// say_rumor
	void EdanaMasterp_OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		OnChatStartSequence("say_rumor");
	}

	// say_pillarquest
	void EdanaMasterp_OnSayPillarquest()
	{
		if (Truthy(ItemExists(ENT_LASTSPOKE, "item_runicsymbol2")))
		{
			OnChatStartSequence("say_allIknow");
		}
		else if (Truthy(ItemExists(ENT_LASTSPOKE, "item_runicsymbol")))
		{
			RING_EXPLAINED = true;
			OnChatStartSequence("say_pq");
		}
	}

	// show_ring
	void EdanaMasterp_OnShowRing()
	{
		RING_EXPLAINED = true;
		OnChatStartSequence("say_pq");
	}

	// gave_ring
	void EdanaMasterp_OnGaveRing(CBasePlayer@ ringBearer = null)
	{
		@RING_BEARER = ringBearer;
		OnChatStartSequence("gave_ring");
		CallEventDelayed(16.0f, "gave_ring2");
	}

	// gave_ring2
	void EdanaMasterp_OnGaveRing2()
	{
		Offer(RING_BEARER, "item_runicsymbol2");
	}

	// say_felewyn
	void EdanaMasterp_OnSayFelewyn()
	{
		OnChatStartSequence("say_felewyn");
	}

	// say_torkalath
	void EdanaMasterp_OnSayTorkalath()
	{
		OnChatStartSequence("say_torkalath");
	}

	// say_urdual
	void EdanaMasterp_OnSayUrdual()
	{
		OnChatStartSequence("say_urdual");
	}

	// say_aob
	// new
	void EdanaMasterp_OnSayAob()
	{
		OnChatStartSequence("say_aob");
	}

	// say_helena
	void EdanaMasterp_OnSayHelena(CBasePlayer@ talkingPlayer = null)
	{
		OnChatNow("Helena is a trading outpost in the center of the human lands. Recently rebuilt, it still struggles to survive.");
	}

	// say_undead
	void EdanaMasterp_OnSayUndead()
	{
		OnChatStartSequence("say_undead");
	}

	// say_orcs
	void EdanaMasterp_OnSayOrcs()
	{
		OnChatStartSequence("say_orcs");
	}

	// say_shad
	void EdanaMasterp_OnSayShad()
	{
		OnChatStartSequence("say_shad");
	}

	// say_maldora
	void EdanaMasterp_OnSayMaldora()
	{
		OnChatStartSequence("say_maldora");
	}

	// say_unquest
	// ===========
	void EdanaMasterp_OnSayUnquest()
	{
		PlayAnim("critical", "magic");
		InfoMessage(ENT_LASTSPOKE, "DEBUG", "Quests data is being removed from your character.");
		Quest("unset", ENT_LASTSPOKE, "emote_sitting");
		Quest("unset", ENT_LASTSPOKE, "quest_ring");
	}

	// change_name_intro
	void EdanaMasterp_OnChangeNameIntro(CBasePlayer@ target = null)
	{
		if (CHAT_BUSY)
			OnChatBusyMessage();
		if (CHAT_BUSY)
			return;

		if (!IsPlayer(target))
			@NAME_REQ_ID = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(target))
			@NAME_REQ_ID = target;

		OnChatStartSequence("say_name_change");
		CallEventDelayed(12.0f, "send_name_change_menu");

		DID_CHANGE_INTRO = true;
		SENDING_YN = true;
		CHAT_MENU_ON = false;
	}

	// send_name_change_menu
	void EdanaMasterp_OnSendNameChangeMenu()
	{
		OpenMenu(NAME_REQ_ID);
	}

	// game_menu_cancel
	void EdanaMasterp_OnGameMenuCancel(CBasePlayer@ player = null)
	{
		if (!DID_CHANGE_INTRO)
			return;
		DID_CHANGE_INTRO = false;
		CHAT_MENU_ON = true;
	}

	// game_menu_getoptions
	void EdanaMasterp_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		int changeNameFee = 0;

		@USER_ID = player;

		if (!SENDING_YN)
		{
			if (!DID_CHANGE_INTRO)
			{
				menuItem.title = "Change my name";
				menuItem.type = "callback";
				menuItem.callback = "change_name_intro";
				RegisterMenuItem(menuItem);
			}

			if (Truthy(ItemExists(player, "item_runicsymbol")))
			{
				if (!RING_EXPLAINED)
				{
					menuItem.title = "Show the Expended Ring";
					menuItem.type = "callback";
					menuItem.callback = "show_ring";
					RegisterMenuItem(menuItem);
				}
				else
				{
					menuItem.title = "Give the Expended Ring";
					menuItem.type = "payment";
					menuItem.data = "item_runicsymbol";
					menuItem.callback = "gave_ring";
					RegisterMenuItem(menuItem);
				}
			}
		}

		if (SENDING_YN)
		{
			int changeNameTimes = Int(GetQuestData(player, "n"));
			// dbg got_name_change_fee CHANGE_NAME_TIMES from $get(PARAM1,name)
			if (changeNameTimes == 0)
				changeNameFee = 100;
			if (changeNameTimes == 1)
				changeNameFee = 1000;
			if (changeNameTimes == 2)
				changeNameFee = 10000;
			if (changeNameTimes == 3)
				changeNameFee = 100000;
			if (changeNameTimes == 4)
				changeNameFee = 1000000;
			if (changeNameTimes >= 5)
				changeNameFee = 10000000;

			menuItem.title = "Yes";
			menuItem.type = "payment";
			menuItem.data = "gold:" + changeNameFee;
			menuItem.callback = "change_name_yes";
			menuItem.cb_failed = "change_name_payment_failed";
			RegisterMenuItem(menuItem);

			SayText("The fee for this service, in your case, would be " + changeNameFee + " gold.");

			menuItem.title = "no";
			menuItem.type = "callback";
			menuItem.callback = "change_name_no";
			RegisterMenuItem(menuItem);

			SENDING_YN = false;
			CHAT_MENU_ON = true;
		}
	}

	// change_name_payment_failed
	void EdanaMasterp_OnChangeNamePaymentFailed()
	{
		PlayAnim("critical", "no");
		OnChatNow("I'm afraid you do not have sufficient funds to cover the king's fees.", "3.0", "none", "clear_que");
		DID_CHANGE_INTRO = false;
		CHAT_MENU_ON = true;
	}

	// change_name_no
	void EdanaMasterp_OnChangeNameNo()
	{
		PlayAnim("critical", "yes");
		OnChatNow("That is quite all right, it is better to be certain of one's identity than to change it on a whim.", "4.0", "none", "clear_que");
		DID_CHANGE_INTRO = false;
		CHAT_MENU_ON = true;
	}

	// change_name_yes
	void EdanaMasterp_OnChangeNameYes()
	{
		OnChatNow("Speak forth the name you shall hence forth be known as...", "3.0", "none", "clear_que");
		CHANGING_NAME = true;
	}

	// game_heardtext
	// PARAM1=text PARAM2=player_id (general catch for local speech)
	void EdanaMasterp_OnGameHeardtext(string text = "", CBasePlayer@ speaker = null)
	{
		bool exitSub = false;
		bool niceTry = false;

		if (!CHANGING_NAME)
			return;
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			PlayerMessageGreen(speaker, "Zomg " + NameOf(speaker) + " spoke to me! " + NameOf(ENT_LASTSPOKE));
		// ent_lastspoke not working in this context :\
		if (speaker !is NAME_REQ_ID)
			SayText("Shush, " + NameOf(NAME_REQ_ID) + " here is going to provide me with his new name.");
		if (speaker !is NAME_REQ_ID)
			return;
		string newName = text;
		string space = " ";
		if (Left(newName, 1) == space)
		{
			SayText("I'm sorry, but you cannot begin your name with a space.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (newName != LegacyFunction("alphanum", newName, space))
		{
			SayText("I'm sorry, but your name seems to have some characters in it that will not fit in the paperwork.");
			InfoMessage(NAME_REQ_ID, "Alphanumerics and Spaces Only Please", "Otherwise, bad things would happen.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (int(newName.length()) > 30)
		{
			SayText("I'm sorry, but your name is too long.");
			InfoMessage(NAME_REQ_ID, "Name must be under 30 characters", "Otherwise, bad things would happen.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (newName == "'Saint") {}
		if (newName == "Thothie")
			niceTry = true;
		if (newName == "'Saint") {}

		if (niceTry)
		{
			SayText("Yeeeaaah... No.");
			PlayAnim("critical", "no");
			return;
		}

		newName = LegacyFunction("alphanum", newName, space); // final sanitize

		float changeNameTimes = Float(GetQuestData(NAME_REQ_ID, "n"));
		changeNameTimes = int(changeNameTimes) + 1.0f;
		Quest("set", NAME_REQ_ID, "n", changeNameTimes);
		string oldName = NameOf(NAME_REQ_ID);
		LegacyCommand("playername", @NAME_REQ_ID, newName);
		string msgTxt = "From this day forth, " + oldName + " shall now be known as " + newName + "!";

		InfoMessage("all", "A PROCLOMATION RINGS THROUGHOUT THE LAND!", msgTxt);
		PlayAnim("critical", "talkright");
		string outStr = "Very well, from this day forth your name shall be " + newName;
		OnChatNow(outStr, "3.0", "none", "abort");
		DID_CHANGE_INTRO = false;
		CHANGING_NAME = false;
		CHAT_MENU_ON = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
		EdanaMasterp_OnGameSpawn(playerRace, playerGender);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		EdanaMasterp_OnGameMenuGetoptions(player);
	}

	void OnScanForPlayers() { EdanaMasterp_OnScanForPlayers(); } // scan_for_players
	void OnDoIntro() { EdanaMasterp_OnDoIntro(); } // do_intro
	void OnLoadChat() { EdanaMasterp_OnLoadChat(); } // load_chat
	void OnSayHi(CBasePlayer@ talkingPlayer = null) { EdanaMasterp_OnSayHi(talkingPlayer); } // say_hi
	void OnSayCity() { EdanaMasterp_OnSayCity(); } // say_city
	void OnSayBloodrose() { EdanaMasterp_OnSayBloodrose(); } // say_bloodrose
	void OnSayElves() { EdanaMasterp_OnSayElves(); } // say_elves
	void OnSayLoreldians() { EdanaMasterp_OnSayLoreldians(); } // say_loreldians
	void OnSayUnbal() { EdanaMasterp_OnSayUnbal(); } // say_unbal
	void OnSayThornlands() { EdanaMasterp_OnSayThornlands(); } // say_thornlands
	void OnSayChanges() { EdanaMasterp_OnSayChanges(); } // say_changes
	void OnSayJob(CBasePlayer@ player = null) { EdanaMasterp_OnSayJob(player); } // say_job
	void OnSayJob2(string target = "") { EdanaMasterp_OnSayJob2(target); } // say_job2
	void OnWorldeventEvidenceFound() { EdanaMasterp_OnWorldeventEvidenceFound(); } // worldevent_evidence_found
	void OnSayPathos() { EdanaMasterp_OnSayPathos(); } // say_pathos
	void OnSayTemple() { EdanaMasterp_OnSayTemple(); } // say_temple
	void OnSayTemple3x() { EdanaMasterp_OnSayTemple3x(); } // say_temple3x
	void OnSayHistory() { EdanaMasterp_OnSayHistory(); } // say_history
	void OnSayForest(CBasePlayer@ speaker = null) { EdanaMasterp_OnSayForest(speaker); } // say_forest
	void OnSayMalgor() { EdanaMasterp_OnSayMalgor(); } // say_malgor
	void OnSayThelost() { EdanaMasterp_OnSayThelost(); } // say_thelost
	void OnSayApostles() { EdanaMasterp_OnSayApostles(); } // say_apostles
	void OnSayRumor(CBasePlayer@ talkingPlayer = null) { EdanaMasterp_OnSayRumor(talkingPlayer); } // say_rumor
	void OnSayPillarquest() { EdanaMasterp_OnSayPillarquest(); } // say_pillarquest
	void OnShowRing() { EdanaMasterp_OnShowRing(); } // show_ring
	void OnGaveRing(CBasePlayer@ ringBearer = null) { EdanaMasterp_OnGaveRing(ringBearer); } // gave_ring
	void OnGaveRing2() { EdanaMasterp_OnGaveRing2(); } // gave_ring2
	void OnSayFelewyn() { EdanaMasterp_OnSayFelewyn(); } // say_felewyn
	void OnSayTorkalath() { EdanaMasterp_OnSayTorkalath(); } // say_torkalath
	void OnSayUrdual() { EdanaMasterp_OnSayUrdual(); } // say_urdual
	void OnSayAob() { EdanaMasterp_OnSayAob(); } // say_aob
	void OnSayHelena(CBasePlayer@ talkingPlayer = null) { EdanaMasterp_OnSayHelena(talkingPlayer); } // say_helena
	void OnSayUndead() { EdanaMasterp_OnSayUndead(); } // say_undead
	void OnSayOrcs() { EdanaMasterp_OnSayOrcs(); } // say_orcs
	void OnSayShad() { EdanaMasterp_OnSayShad(); } // say_shad
	void OnSayMaldora() { EdanaMasterp_OnSayMaldora(); } // say_maldora
	void OnSayUnquest() { EdanaMasterp_OnSayUnquest(); } // say_unquest
	void OnChangeNameIntro(CBasePlayer@ target = null) { EdanaMasterp_OnChangeNameIntro(target); } // change_name_intro
	void OnSendNameChangeMenu() { EdanaMasterp_OnSendNameChangeMenu(); } // send_name_change_menu
	void OnGameMenuCancel(CBasePlayer@ player = null) { EdanaMasterp_OnGameMenuCancel(player); } // game_menu_cancel
	void OnChangeNamePaymentFailed() { EdanaMasterp_OnChangeNamePaymentFailed(); } // change_name_payment_failed
	void OnChangeNameNo() { EdanaMasterp_OnChangeNameNo(); } // change_name_no
	void OnChangeNameYes() { EdanaMasterp_OnChangeNameYes(); } // change_name_yes
	void OnGameHeardtext(string text = "", CBasePlayer@ speaker = null) { EdanaMasterp_OnGameHeardtext(text, speaker); } // game_heardtext
	void OnChatDelay() {} // CHAT_DELAY

	// This file's events and timers by their .script names
	bool EdanaMasterp_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "change_name_intro") { OnChangeNameIntro(PlayerParam(params, 0)); return true; }
		if (name == "change_name_no") { OnChangeNameNo(); return true; }
		if (name == "change_name_payment_failed") { OnChangeNamePaymentFailed(); return true; }
		if (name == "change_name_yes") { OnChangeNameYes(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "game_heardtext") { OnGameHeardtext(Param(params, 0), PlayerParam(params, 1)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gave_ring") { OnGaveRing(PlayerParam(params, 0)); return true; }
		if (name == "gave_ring2") { OnGaveRing2(); return true; }
		if (name == "load_chat") { OnLoadChat(); return true; }
		if (name == "say_aob") { OnSayAob(); return true; }
		if (name == "say_apostles") { OnSayApostles(); return true; }
		if (name == "say_bloodrose") { OnSayBloodrose(); return true; }
		if (name == "say_changes") { OnSayChanges(); return true; }
		if (name == "say_city") { OnSayCity(); return true; }
		if (name == "say_elves") { OnSayElves(); return true; }
		if (name == "say_felewyn") { OnSayFelewyn(); return true; }
		if (name == "say_forest") { OnSayForest(PlayerParam(params, 0)); return true; }
		if (name == "say_helena") { OnSayHelena(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_history") { OnSayHistory(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_loreldians") { OnSayLoreldians(); return true; }
		if (name == "say_maldora") { OnSayMaldora(); return true; }
		if (name == "say_malgor") { OnSayMalgor(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_pathos") { OnSayPathos(); return true; }
		if (name == "say_pillarquest") { OnSayPillarquest(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_shad") { OnSayShad(); return true; }
		if (name == "say_temple") { OnSayTemple(); return true; }
		if (name == "say_temple3x") { OnSayTemple3x(); return true; }
		if (name == "say_thelost") { OnSayThelost(); return true; }
		if (name == "say_thornlands") { OnSayThornlands(); return true; }
		if (name == "say_torkalath") { OnSayTorkalath(); return true; }
		if (name == "say_unbal") { OnSayUnbal(); return true; }
		if (name == "say_undead") { OnSayUndead(); return true; }
		if (name == "say_unquest") { OnSayUnquest(); return true; }
		if (name == "say_urdual") { OnSayUrdual(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "send_name_change_menu") { OnSendNameChangeMenu(); return true; }
		if (name == "show_ring") { OnShowRing(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		if (name == "EdanaMasterp_Timer") { EdanaMasterp_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "edana/masterp"]
shared class EdanaMasterpScript : BaseChatArrayScript, EdanaMasterp, FirstNpc, BaseXmass
{
	// Variables declared by included files, with the value they start with in this script
	EdanaMasterpScript()
	{
		CHAT_DELAY = 5.0f;
		CHAT_AUTO_HAIL = true;
		CHAT_AUTO_JOB = true;
		CHAT_AUTO_RUMOR = true;
		CHAT_NEVER_INTERRUPT = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
		CallEventDelayed(Float(Eval("$randf(8.0,12.0)")), "EdanaMasterp_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return EdanaMasterp_DispatchEvent(name, params)
			|| FirstNpc_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
