# Contributing to Resource Browser

Thank you for your interest in contributing! This project is beginner-friendly and welcomes contributions.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/resource-browser.git
   cd resource-browser
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Create a branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### 1. Make Your Changes

Edit the relevant files in:
- `lib/` - Application code
- `web/` - Web-specific files
- Documentation files (`.md`)

### 2. Test Your Changes

```bash
# Run the app
flutter run -d chrome

# Test your feature thoroughly
# Check for errors in browser console (F12)
```

### 3. Follow Code Style

The project uses:
- **Dart style guide**: Follow standard Dart conventions
- **Comments**: Add clear comments for complex logic
- **Documentation**: Update relevant `.md` files

### 4. Commit Your Changes

```bash
# Stage your changes
git add .

# Commit with a clear message
git commit -m "Add: Brief description of your change"
```

**Commit Message Format:**
- `Add:` for new features
- `Fix:` for bug fixes
- `Update:` for changes to existing features
- `Docs:` for documentation changes
- `Refactor:` for code improvements without functionality changes

### 5. Push and Create Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Project Structure

```
lib/
├── main.dart              # Entry point
├── models/                # Data structures
├── services/              # Business logic
├── screens/               # Full-page views
└── widgets/               # Reusable components

web/
├── index.html            # Web entry point
├── manifest.json         # Web app config
└── resources/            # Resource files (not tracked)
```

## Areas for Contribution

### 🟢 Beginner-Friendly
- Fix typos in documentation
- Improve code comments
- Add examples to README
- Create sample resource files
- Test and report bugs

### 🟡 Intermediate
- Add search functionality
- Implement sorting
- Improve error handling
- Add loading indicators
- Create new file type viewers
- Improve responsive design

### 🔴 Advanced
- Implement automatic file scanning
- Add state management (Provider/Riverpod)
- Create folder navigation
- Add authentication
- Optimize performance
- Add comprehensive tests

## Feature Requests

Have an idea? Great! Please:

1. **Check existing issues** first
2. **Open an issue** describing the feature
3. **Wait for feedback** before implementing
4. **Discuss approach** if it's a major change

## Bug Reports

Found a bug? Please open an issue with:

- **Clear title**: "Bug: Video player controls not working"
- **Steps to reproduce**: Numbered list
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: Flutter version, browser, OS
- **Screenshots**: If applicable

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows project style
- [ ] Comments added for complex logic
- [ ] Tested thoroughly in browser
- [ ] No console errors
- [ ] Documentation updated if needed
- [ ] Commit messages are clear

### PR Description Should Include

- **What**: Brief description of changes
- **Why**: Reason for the changes
- **How**: Approach taken
- **Testing**: How you tested it
- **Screenshots**: If UI changes

### Example PR Description

```markdown
## Add Search Functionality

### What
Adds a search bar to filter resources by name.

### Why
Users requested ability to quickly find specific files.

### How
- Added SearchBar widget to home_screen.dart
- Implemented filtering logic
- Used TextEditingController for input

### Testing
- Tested with 50+ files
- Works with partial matches
- Case-insensitive search
- No performance issues

### Screenshots
[Screenshot of search in action]
```

## Code Style Guidelines

### Dart Conventions

```dart
// Good: Clear, descriptive names
class ResourceItem { }
String fileName;
void loadResources() { }

// Bad: Unclear names
class RI { }
String fn;
void load() { }
```

### Comments

```dart
// Good: Explains WHY
// Sort by name to match user expectations
resources.sort((a, b) => a.name.compareTo(b.name));

// Bad: Explains obvious WHAT
// Sort the resources
resources.sort((a, b) => a.name.compareTo(b.name));
```

### Documentation Comments

```dart
/// Creates a new ResourceItem from a file path.
/// 
/// The [filePath] should be a relative path from the web root.
/// Returns a ResourceItem with type auto-detected from extension.
factory ResourceItem.fromPath(String filePath) {
  // Implementation
}
```

## Documentation Updates

If your change affects:
- Features → Update README.md
- Architecture → Update DEVELOPMENT.md
- UI → Update VISUAL_GUIDE.md
- Setup → Update QUICKSTART.md

## Testing

### Manual Testing Checklist

- [ ] App runs without errors
- [ ] Feature works as intended
- [ ] No console errors (F12)
- [ ] Works in Chrome
- [ ] Works in Edge (optional)
- [ ] No visual regressions
- [ ] Existing features still work

### Future: Automated Tests

We plan to add:
- Unit tests for models/services
- Widget tests for UI components
- Integration tests for full flows

## Questions?

- **Read the docs**: Check DEVELOPMENT.md first
- **Open an issue**: For general questions
- **Start small**: Begin with documentation or small fixes

## Recognition

Contributors will be:
- Listed in the project (future CONTRIBUTORS.md)
- Mentioned in release notes
- Appreciated by the community! 🙏

## Code of Conduct

Be kind and respectful. This is a learning-focused project.

- ✅ Help others learn
- ✅ Be patient with beginners
- ✅ Give constructive feedback
- ✅ Celebrate progress
- ❌ No harassment or discrimination

## Getting Help

Stuck? Need guidance?

1. Read the documentation
2. Check existing issues
3. Open a new issue with "Question:" prefix
4. Be specific about what you need help with

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing! 🎉**

Every contribution, no matter how small, helps make this project better!
