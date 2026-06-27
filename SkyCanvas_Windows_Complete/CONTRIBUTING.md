# Contributing to SkyCanvas

Thank you for your interest in contributing to SkyCanvas! 🌟

## Ways to Contribute

### 1. Report Bugs 🐛
Found a bug? [Open an issue](https://github.com/yourusername/skycanvas/issues)

Include:
- Operating system and version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

### 2. Suggest Features 💡
Have an idea? [Open a feature request](https://github.com/yourusername/skycanvas/issues)

Tell us:
- What problem does it solve?
- How should it work?
- Who would benefit?

### 3. Improve Documentation 📝
- Fix typos
- Add examples
- Clarify instructions
- Translate to other languages

### 4. Write Code 💻
- Fix bugs
- Implement features
- Optimize performance
- Add tests

### 5. Test & Review 🧪
- Test on different devices
- Review pull requests
- Verify accuracy of astronomy calculations
- Test with different projectors

## Getting Started

### Prerequisites
- Git
- Flutter SDK 3.0+
- Python 3.9+
- Windows/macOS/Linux

### Setup Development Environment

```bash
# Clone repository
git clone https://github.com/yourusername/skycanvas.git
cd skycanvas

# Install Python dependencies
pip install -r python/requirements.txt

# Install Flutter dependencies
flutter pub get

# Run the app
flutter run -d windows
```

## Code Style

### Dart (Flutter)
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` before committing
- Format code with `flutter format .`
- Maximum line length: 80 characters

### Python
- Follow [PEP 8](https://pep8.org/)
- Use type hints
- Add docstrings to functions
- Maximum line length: 100 characters

## Project Structure

```
skycanvas/
├── lib/                    # Flutter app
│   ├── main.dart          # Entry point
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable widgets
│   ├── models/            # Data models
│   └── services/          # Business logic
├── python/                # Astronomy engine
│   └── sky_engine.py      # Core calculations
├── assets/                # Images, data
└── test/                  # Tests
```

## Pull Request Process

### 1. Fork & Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes
- Write clear, concise commits
- Follow code style guidelines
- Add tests if applicable

### 3. Test
```bash
# Flutter tests
flutter test

# Python tests
python -m pytest
```

### 4. Submit PR
- Clear title and description
- Reference related issues
- Include screenshots for UI changes

### 5. Code Review
- Address reviewer feedback
- Keep discussions respectful
- Be patient - reviews take time

## Commit Message Guidelines

Use conventional commits:

```
feat: add constellation labels
fix: correct moon phase calculation
docs: update installation instructions
style: format code with flutter format
refactor: simplify star rendering logic
test: add tests for astronomy service
chore: update dependencies
```

## Testing Guidelines

### Manual Testing Checklist
- [ ] App launches without errors
- [ ] All UI controls work
- [ ] Astronomy calculations are accurate
- [ ] No performance issues
- [ ] Works on target platforms

### Automated Tests
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for critical flows

## Astronomy Accuracy

When contributing astronomy features:

### Verify Against
- [Stellarium](https://stellarium.org/) (open-source planetarium)
- [NASA JPL Horizons](https://ssd.jpl.nasa.gov/horizons/)
- [In-The-Sky.org](https://in-the-sky.org/)

### Test Cases
- Different locations (northern/southern hemisphere)
- Different dates (past, present, future)
- Edge cases (polar regions, date boundaries)

## Adding New Features

### Feature Development Workflow

1. **Discuss First**
   - Open an issue
   - Get feedback from maintainers
   - Agree on approach

2. **Create Branch**
   ```bash
   git checkout -b feature/feature-name
   ```

3. **Implement**
   - Write code
   - Add tests
   - Update documentation

4. **Test**
   - Manual testing
   - Automated tests
   - Cross-platform testing

5. **Submit PR**
   - Clear description
   - Screenshots/video
   - Link to issue

## Areas Needing Help

### High Priority
- [ ] More star catalogs (Hipparcos, Tycho)
- [ ] Constellation artwork
- [ ] Deep space objects (Messier catalog)
- [ ] Satellite tracking (ISS, Starlink)
- [ ] macOS support improvements

### Medium Priority
- [ ] Automated tests
- [ ] Performance optimization
- [ ] UI/UX improvements
- [ ] Accessibility features
- [ ] Internationalization (i18n)

### Low Priority
- [ ] Advanced features (telescope control)
- [ ] VR/AR support
- [ ] Mobile apps (Android/iOS)
- [ ] Web version

## Code of Conduct

### Our Standards

**Be respectful**
- Respect different viewpoints
- Accept constructive criticism
- Focus on what's best for the project

**Be inclusive**
- Welcome newcomers
- Use inclusive language
- Be patient with questions

**Be collaborative**
- Share knowledge
- Help others learn
- Credit contributions

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

### Enforcement
Violations may result in:
1. Warning
2. Temporary ban
3. Permanent ban

Report issues to: conduct@skycanvas.app

## Recognition

Contributors will be:
- ✅ Listed in CONTRIBUTORS.md
- ✅ Mentioned in release notes
- ✅ Credited in app "About" section
- ✅ Given special Discord role

## Questions?

- **General questions**: [GitHub Discussions](https://github.com/yourusername/skycanvas/discussions)
- **Bug reports**: [GitHub Issues](https://github.com/yourusername/skycanvas/issues)
- **Chat**: [Discord](https://discord.gg/skycanvas)
- **Email**: contribute@skycanvas.app

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for making SkyCanvas better! 🌟**
