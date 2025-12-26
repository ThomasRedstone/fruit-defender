# Fruit Defender - Vision & MVP Design Document

## 1. Game Overview
Fruit Defender is a tower defense game where players defend against waves of anthropomorphic fruit enemies. The enemies travel along a fixed path towards a base. The game features an 8-bit pixel art aesthetic.

## 2. Technical Stack (MVP - Flutter)
- **Framework**: Flutter (Web Target for MVP).
- **Language**: Dart.
- **Game Engine**: Flame.
- **CI/CD**: GitHub Actions (Deploy to GitHub Pages).

## 3. Core Mechanics

### 3.1. Game Loop
- **Update Phase**: Update positions of all enemies, projectiles, and cooldowns.
- **Render Phase**: Clear canvas, draw map, draw towers, enemies, projectiles, and effects.
- **Wave System**: 
  - Waves spawn groups of enemies with defined intervals.
  - Difficulty increases linearly (HP/Speed multipliers).

### 3.2. Economy
- **Money**: Earned by defeating enemies.
- **Costs**: Towers cost money to place and upgrade.
- **Selling**: Towers can be sold for 100% of total value (Base + Upgrades).

## 4. MVP Content Scope

We will start with a reduced subset of the full vision to ensure a solid foundation.

### 4.1. Towers (MVP)
1. **Wizard (Basic)**
   - Role: Balanced Damage, Medium Range, Medium Speed.
   - Attack: Fires magical bolts.
   - Upgrade: Increases fire rate.
2. **Sniper (Heavy)**
   - Role: Infinite Range, High Damage, Very Slow Speed.
   - Attack: Instant hit or fast projectile, single target.
   - Target Priority: Strongest enemy.
   - Upgrade: Increases damage massively.
3. **Ninja (Rapid)**
   - Role: Medium Range, Low Damage, Very Fast Speed.
   - Attack: Throws shurikens.
   - Upgrade: Increases attack speed.
4. **Factory (Eco)**
   - Role: Generates Money.
   - Mechanic: Creates money that must be hovered over to collect, with half being automatically collected after a delay.
*(Future: Beserker, Missile, Sherriff, Pirate, Beast Handler, Fruit Spawner)*

### 4.2. Enemies (MVP)
1. **Apple (Standard)**
   - Balanced Health and Speed.
2. **Banana (Fast)**
   - Low Health, High Speed.
3. **Pineapple (Tank)**
   - High Health, Slow Speed.

*(Future: Orange - splitting, etc.)*

### 4.3. Maps
- **Level 1**: "The Orchard". A simple winding path on a grass background.
- **Pathing**: Defined by a set of waypoints (x, y).

## 5. UI/UX
- **Canvas**: Displays the game world.
- **HUD (HTML Overlay)**:
  - Top Bar: Lives, Money, Current Wave.
  - Bottom/Side Panel: Tower selection, Tower details (when selected), Upgrade/Sell buttons.
  - Floating Text: Damage numbers, Money gained.

## 6. Future Roadmap
- Inter-round upgrades (Permabuffs).
- Shop system (Unlock new towers).
- Complex enemy behaviors (splitting, stunning).
- Elemental status effects.
