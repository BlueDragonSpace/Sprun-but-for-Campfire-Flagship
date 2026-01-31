# Quick Feature Request Guide

## The Problem

If you're here because you got an issue that just says "what feature" - you're not alone! This was a placeholder that needed clarification.

## The Solution

We've now created proper documentation to help with feature requests and development:

### 📋 For Feature Ideas

1. **Check existing features first:** Look at [FEATURES.md](FEATURES.md) to see what's already planned or implemented
2. **Create a proper issue:** Use the templates in [CONTRIBUTING.md](CONTRIBUTING.md)
3. **Be specific:** Include:
   - What the feature does
   - Why it's needed
   - How it should work
   - Priority level

### 🐛 For Bugs

1. **Check known bugs:** See the "Critical Bugs" section in [FEATURES.md](FEATURES.md)
2. **Report with details:** Use the bug report template in [CONTRIBUTING.md](CONTRIBUTING.md)
3. **Include:**
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if relevant

### 💻 For Development

1. **Pick a feature:** Choose from [FEATURES.md](FEATURES.md)
2. **Follow guidelines:** Read [CONTRIBUTING.md](CONTRIBUTING.md)
3. **Test thoroughly:** Make sure changes work at different resolutions
4. **Submit a PR:** Include clear description and testing notes

## Current Priority Features

Based on the roadmap, here are the top priorities:

### 🔥 Highest Priority (Version 0.9-1.0)
1. **3D Pathfinding** - Currently in progress but needs optimization
   - Make it faster
   - Better obstacle navigation
   - Visualization

2. **Grid-Based Movement System** - Foundation for many other features
   - 2D and 3D grids
   - Movement distance calculation
   - Position shifting between dimensions

3. **Attack System Improvements** - Core combat mechanics
   - Hitboxes
   - Line of sight
   - Ranged vs melee distinction

### ⚠️ Critical Bugs to Fix
1. Damage calculation rounding error
2. Turn order offset when enemies die
3. Intent display showing wrong target (visual bug)

### 🎯 High Value Features (Version 2.0-3.0)
1. Enemy attacks as reusable Actions
2. Custom UI theme
3. Back button for action selection
4. Visual effects (MegaLazer, etc.)

## Example Feature Request

Here's a good example of a feature request:

---

**Feature Name:** Back Button for Action Selection

**Description:** Allow players to undo their action selection and go back to the previous character during the player input phase.

**Priority:** High - Quality of life improvement that significantly improves user experience

**User Story:** As a player, I want to be able to go back and change my previous character's action so that I don't have to restart the entire turn if I make a mistake.

**Requirements:**
- Add "Back" button to action selection UI
- Store action history for current turn
- Revert character state when going back
- Clear future selections when reverting
- Disable back button on first character
- Works across dimension switches

**Testing:**
- [ ] Back button appears after first character selects action
- [ ] Clicking back returns to previous character
- [ ] Previous character's action is cleared
- [ ] Can select different action after going back
- [ ] Can go back multiple characters
- [ ] Back button disabled on first character

---

## Need Help?

- **Not sure what to work on?** Check the "In Progress" or "High Priority" sections in FEATURES.md
- **Have questions?** Open a GitHub issue with the "question" label
- **Want to discuss features?** Start a discussion on the repository

## Quick Links

- [FEATURES.md](FEATURES.md) - Complete feature roadmap
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [README.md](README.md) - Project overview
- [notes/to-do.txt](notes/to-do.txt) - Detailed development notes

---

**Remember:** Clear feature requests lead to better implementation. Take the time to explain your idea thoroughly!
