# Contributing to Sprun but for Campfire Flagship

Thank you for your interest in contributing to this project! This document provides guidelines for feature requests, bug reports, and contributions.

## Feature Requests

When requesting a new feature, please create a GitHub issue with the following information:

### Feature Request Template

```markdown
## Feature Name
[Clear, descriptive title]

## Description
[What does this feature do? How will it improve the game?]

## Priority
- [ ] Critical (game-breaking without it)
- [ ] High (significantly improves gameplay)
- [ ] Medium (nice to have)
- [ ] Low (future consideration)

## User Story
As a [type of user], I want [goal] so that [benefit].

## Detailed Requirements

### Functionality
- [Requirement 1]
- [Requirement 2]
- [etc.]

### Technical Considerations
- [Technical detail 1]
- [Technical detail 2]

## Dependencies
- [List any features that must be implemented first]
- [List any systems this interacts with]

## Assets Needed
- [ ] Art/Sprites: [describe]
- [ ] Sound/Music: [describe]
- [ ] Animations: [describe]

## Testing Criteria
How will we know this feature works correctly?
- [ ] Test case 1
- [ ] Test case 2

## Mockups/Examples
[Include any sketches, screenshots from other games, or visual references]

## Additional Context
[Any other information that might be helpful]
```

## Bug Reports

When reporting a bug, please include:

### Bug Report Template

```markdown
## Bug Description
[Clear, concise description of the bug]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [etc.]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Severity
- [ ] Critical (game crashes, data loss, can't play)
- [ ] High (major feature broken)
- [ ] Medium (feature partially works)
- [ ] Low (minor visual/text issue)

## Environment
- Game Version: [e.g., 0.0.4]
- Platform: [e.g., Windows, Linux, Web]
- Godot Version: [if applicable]

## Screenshots/Logs
[Include any relevant screenshots or error messages]

## Additional Information
[Anything else that might help debug the issue]
```

## Code Contributions

### Getting Started

1. **Familiarize yourself with the codebase**
   - Review `FEATURES.md` for current feature status
   - Check `notes/to-do.txt` for upcoming work
   - Read the `README.md` for project overview

2. **Set up your development environment**
   - Install Godot 4.6 or later
   - Clone the repository
   - Open the project in Godot

3. **Choose what to work on**
   - Check open issues
   - Look at the "In Progress" section in `FEATURES.md`
   - Coordinate with maintainers if working on large features

### Development Guidelines

#### Code Style
- Follow existing code patterns in the project
- Use meaningful variable and function names
- Comment complex logic
- Keep functions focused and concise

#### GDScript Conventions
- Use `snake_case` for variables and functions
- Use `PascalCase` for class names
- Indent with tabs (project convention)
- Add type hints where possible: `var health: int = 100`

#### Scene Organization
- Keep scene hierarchies clean and logical
- Use meaningful node names
- Group related nodes under parent nodes
- Document complex node setups with comments

#### Testing
- Test your changes in-game before submitting
- Verify changes work at different resolutions
- Check for console errors
- Test edge cases

### Commit Messages

Write clear, descriptive commit messages:

```
Good:
- "Add Freeze debuff with turn order penalty"
- "Fix damage calculation rounding error"
- "Implement Manhattan distance pathfinding"

Not so good:
- "Update"
- "Fix bug"
- "Changes"
```

### Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Keep commits focused and atomic
   - Test thoroughly

3. **Update documentation**
   - Update `FEATURES.md` if adding/completing features
   - Update `README.md` if changing core functionality
   - Add comments to complex code

4. **Submit pull request**
   - Describe what the PR does
   - Reference any related issues
   - Include screenshots for visual changes
   - List testing performed

5. **Code review**
   - Address feedback from reviewers
   - Make requested changes
   - Maintain a respectful, collaborative tone

## Project Structure

```
Sprun-but-for-Campfire-Flagship/
├── addons/              # Godot plugins
├── inGame/              # In-game scenes and scripts
├── notes/               # Development notes and to-do lists
├── placeholderArt/      # Temporary art assets
├── root/                # Root game systems
├── shaders/             # Custom shaders
├── project.godot        # Godot project configuration
├── FEATURES.md          # Feature roadmap
├── CONTRIBUTING.md      # This file
└── README.md            # Project overview
```

## Communication

- **Questions?** Open a GitHub issue with the "question" label
- **Feature ideas?** Use the feature request template
- **Found a bug?** Use the bug report template
- **Want to contribute?** Comment on an issue or create a new one

## Design Philosophy

This project aims to:
- Balance humor and seriousness
- Create engaging turn-based combat
- Innovate with dimension-switching mechanics
- Be accessible at any resolution
- Maintain clean, maintainable code

## Recognition

Contributors will be credited in the game's credits sequence. Thank you for helping make this game better!

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file if present).

---

**Questions?** Feel free to reach out or open an issue for clarification.

**Thank you for contributing!** 🎮
