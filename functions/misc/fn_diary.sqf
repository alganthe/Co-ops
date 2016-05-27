/*
* Author: alganthe
* Adds the required briefing entries.
*
* Arguments:
* >NONE
*
* Return Value:
* nothing
*/
player createDiarySubject ["rules", "Rules"];
player createDiarySubject ["teamspeak", "Teamspeak"];
player createDiarySubject ["Co-ops", "Co-ops"];

//-------------------------------------------------- Rules
player createDiaryRecord ["rules", ["Enforcement",
"your rules here"
]];

//-------------------------------------------------- Teamspeak
player createDiaryRecord ["teamspeak", ["TS3",
"
<br/> Teamspeak:
<br/> http://www.teamspeak.com/?page=downloads
<br/> your adress here
"
]];

//-------------------------------------------------- Mission related, don't touch
player createDiaryRecord ["Co-ops", ["FAQ",
"
<br/> Q: How do I paradrop?
<br/> A: If it's enabled talk to the arsenal guy when an AO is up, an action will show up.
<br/>
<br/> Q: Why is my view distance really low even when my video options says it's high?
<br/> A: Scroll down and click on view settings.
<br/>
<br/> Q: How long do vehicles take to respawn?
<br/> A: It can vary from server to server, it's highly configurable, ask on side chat.
<br/>
<br/> Q: I can't revive my comrades, how can I do that?
<br/> A: You need to be a medic, just get close to the unit, scroll down and click revive.
"
]];

player createDiaryRecord ["Co-ops", ["credits",
"
<br/> Credits:
<br/> vehicle pad scripts: Ahoyworld
<br/> player icons on map: Quicksilver
<br/> ACE3 ported funcs: see the respective funcs headers
<br/> CBA_A3 for the glorious PFHs
<br/> the rest: alganthe
<br/>
<br/> Contributors:
<br/> yourstruly
"
]];

player createDiaryRecord ["Co-ops", ["current issues",
"
<br/> You have issues to report?
<br/> Go here ----> https://github.com/alganthe/Co-ops/issues
"
]];
