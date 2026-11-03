# Game 4 — D&D-style Turn-Based Battle

**Combat type (required to declare): Speed-Based Turn-Based.**
Speed = D&D initiative. At battle start every combatant rolls `d20 + DEX mod`;
the sorted list is the turn order. Each combatant picks an action and it
resolves immediately, then the next one in order goes. The order loops each round.

## Combatants (stats live on each Combatant node as exported vars)

| Name    | Side   | HP | AC | DEX mod | Attack bonus | Damage |
|---------|--------|----|----|---------|--------------|--------|
| Fighter | Player | 24 | 15 | +1      | +5           | 1d8+3  |
| Cleric  | Player | 18 | 13 | +0      | +3           | 1d6+1  |
| Goblin  | Enemy  | 12 | 13 | +2      | +4           | 1d6+2  |
| Orc     | Enemy  | 20 | 12 | +0      | +5           | 1d10+2 |

## Rules (kept minimal)

- **To hit:** `d20 + attack bonus >= target AC`. Natural 20 = crit (roll damage dice twice). Natural 1 = auto miss.
- **Defend:** +4 AC until that combatant's next turn.
- **Death:** HP 0 → removed from the turn order.

## Player commands (need 5 unique — we have 6)

| Command      | Who      | Effect                                                     |
|--------------|----------|------------------------------------------------------------|
| Attack       | Both     | Normal weapon attack vs one enemy                          |
| Power Strike | Fighter  | −3 to hit, damage 2d8+3                                    |
| Defend       | Both     | +4 AC until next turn                                      |
| Heal         | Cleric   | Ally heals 1d8+2 (no roll to hit)                          |
| Potion       | Both     | Item: heal self/ally 2d4+2, shared party stock of 3        |
| Focus        | Both     | Unique mechanic (see below)                                |

## Enemy commands (need 2)

- **Attack** — random living player target.
- **Defend** — +4 AC until next turn.
- AI: 75% Attack / 25% Defend (Defend chance goes up when below half HP).

## Requirement mapping

| Requirement (weight)  | How it is met                                                        |
|-----------------------|----------------------------------------------------------------------|
| Players (20%)         | Fighter + Cleric; take/deal damage; 6 commands                       |
| Enemies (20%)         | Goblin + Orc; take/deal damage; Attack + Defend                      |
| Battle Handler (30%)  | `BattleHandler` node: initiative, turn loop, commands, hit/damage, win/loss |
| UI (10%)              | CommandMenu → TargetMenu → BattleLog text; consistent combatant cards |
| RNG (10%)             | Initiative d20, to-hit d20, damage dice, crits, enemy AI choice      |
| Unique (10%)          | **Focus**: skip your turn to gain *Advantage* on your next attack (roll 2d20, keep the higher) |

## Scene layout

```
scenes/battle.tscn  (main scene)
Battle (Node2D)
├── BattleHandler (Node)          ← battle_handler.gd: turn order, rules, win/loss
├── PlayerParty (Node2D)
│   ├── Fighter  (combatant.tscn)
│   └── Cleric   (combatant.tscn)
├── EnemyParty (Node2D)
│   ├── Goblin   (combatant.tscn)
│   └── Orc      (combatant.tscn)
└── UI (CanvasLayer)              ← battle_ui.gd
    ├── InitiativeLabel           turn order readout
    ├── CommandMenu (VBox)        Attack (others to be added)
    ├── TargetMenu (VBox, hidden) target buttons are added at runtime + Back
    ├── BattleLog (RichTextLabel) "Goblin attacks Cleric: 14 vs AC 13, hit for 5"
    └── ResultPanel (hidden)      Victory! / Defeat + Restart

scenes/combatant.tscn
Combatant (Node2D)                ← combatant.gd: stats, take_damage, HP bar
├── Sprite2D                      placeholder icon; swap in sprites in assets/
├── NameLabel
├── HPBar (ProgressBar)
├── HPLabel
└── TurnMarker (hidden)           shown on whoever's turn it is
```

## Status (MVP)

Scripts:
- `scripts/combatant.gd` — stats (set per character in the Inspector / battle.tscn), `take_damage`, `is_alive`, HP bar.
- `scripts/battle_handler.gd` — initiative, turn loop, target menu, attack roll, log, win/loss.

Done:
- [x] Initiative roll + turn order (shown at the top)
- [x] Player **Attack** (pick target → d20 vs AC → damage, crits on 20, auto-miss on 1)
- [x] Enemies attack a random living player
- [x] Battle log text, turn marker, HP bars, downed combatants fade out
- [x] Victory / Defeat panel + Restart

TODO for the group (add a Button under `UI/CommandMenu` for each command and connect its `pressed` signal to BattleHandler):
- [ ] **Defend** — +4 AC until that character's next turn.
- [ ] **Power Strike** (Fighter only) — −3 to hit, 2d8+3 damage.
- [ ] **Heal** (Cleric only) — heal an ally 1d8+2.
- [ ] **Potion** — shared stock of 3, heals 2d4+2.
- [ ] **Focus** (unique mechanic) — skip turn, next attack rolls two d20s and keeps the higher.
- [ ] Hide/disable class-only buttons on the wrong character.
- [ ] **Enemy Defend** + AI in the enemy part of `start_turn()` (75/25 split, more Defend when below half HP).
- [ ] Real sprites (Tiny RPG pack from game-3 → `assets/`) and nicer UI.
