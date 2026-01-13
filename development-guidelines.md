# Development Guidelines

These guidelines apply to **all Flutter code in this project**.
This is an **MVP-focused Flutter Web app** built for speed and simplicity.

---

## Core Principle

**Anything we create with Flutter Web must produce crawlable, semantic HTML output.**

- UI is not just visual — it is **content**
- SEO and web crawling are first-class requirements
- Routes must be **URL-addressable** for deep-linking

> If a search engine cannot read it, it does not exist.

---

## Code Quality Standards

- **Keep it Simple**: We are building an MVP. Avoid premature abstraction.
- **Readable Code**: Variables and methods should be self-explanatory.
- **Comments**: Explain **WHY**, not WHAT.

---

## Flutter Best Practices

### Visuals & Animation
- **Animate Everything (Tastefully)**: Use `flutter_animate` for declarative animations.
- **Complex Animations**: Use `lottie` for high-fidelity vector animations.
- **Scroll Effects**: Use `visibility_detector` to trigger animations when elements scroll into view.

### SEO & Semantics
- Use semantic widgets: `Text`, `SelectableText`, `Image`, `Link`.
- Avoid content-heavy `CustomPainter` or Canvas-only rendering.

### Icons
- Use **Remix Icons** (`remixicon` package) for a consistent style.
- Material Icons (`Icons.*`) should be avoided unless necessary.

---

## State Management

### MVP Approach: StatefulWidget & setState
- **Primary Pattern**: Use `StatefulWidget` and `setState` for most features.
- **Simplicity**: Do not introduce BLoC, Provider, or Riverpod unless state complexity explicitly demands it (e.g., global auth state).
- **Controllers**: Use `ScrollController`, `TextEditingController`, and `AnimationController` directly in `State` classes.
- **Disposal**: Always `dispose()` controllers to prevent memory leaks.

---

## Design System

### Styles (`KStyle`)
Defined in `lib/constants/color_style.dart`.

**Colors**
- access via `KStyle.cPrimary`, `KStyle.cBrand`, etc.
- **Primary**: `cPrimary` (Black/Dark)
- **Brand**: `cBrand` (Orange/Yellow)
- **Backgrounds**: `cBg1`, `cBg2`

**Typography**
- **Font Family**: **Inria Serif** (via Google Fonts).
- **Styles**: `tTitleXXL` (32px), `tTitleXL` (20px), `tBodyL` (18px), etc.

### Theme (`KTheme`)
Defined in `lib/services/app_theme.dart`.
- Uses `ThemeData.light()`.
- customized for scaffold background and core defaults.

---

## Project Structure

```
lib/
├── constants/
│   ├── color_style.dart    # KStyle (Colors & Fonts)
│   └── constants.dart
├── features/
│   └── home/               # Feature-based organization
│       ├── screens/
│       └── widgets/
├── services/
│   └── app_theme.dart      # KTheme
├── widgets/                # Shared/Common widgets
└── main.dart
```

---

## Resources

- **Flutter Animate**: https://pub.dev/packages/flutter_animate
- **Remix Icons**: https://remixicon.com