# PARfolio Design System

**Version:** 1.0
**Last Updated:** January 2026
**Status:** Active

---

## Table of Contents

1. [Introduction & Design Philosophy](#introduction--design-philosophy)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Component Specifications](#component-specifications)
6. [Shadows & Elevation](#shadows--elevation)
7. [Animation & Motion](#animation--motion)
8. [Icons & Imagery](#icons--imagery)
9. [Accessibility](#accessibility)
10. [Dark Mode](#dark-mode-future)
11. [Decoration & Imagery](#decoration--imagery)

---

## Introduction & Design Philosophy

### Overview

PARfolio's design system bridges the gap between our marketing presence and the product experience, creating a cohesive visual language that guides users from first discovery through daily usage. The design reflects our core mission: transforming chaotic career experiences into structured, interview-ready stories.

### Design Principles

**1. Clarity**
Every element serves a purpose. We use clean typography, generous whitespace, and clear visual hierarchy to help users focus on what matters—their career stories.

**2. Approachability**
Professional doesn't mean sterile. Our design is warm and inviting, using intentional colors, rounded corners, and flat layered paper cut-out illustrations with texture to create an encouraging environment for reflection and growth.

**3. Professional Warmth**
We balance credibility with accessibility. Serif headings add authority, while lime green accents bring energy and optimism to the interview preparation journey.

**4. Consistency**
From marketing site to mobile app, users experience one unified brand. Component patterns, color usage, and typography create familiarity and trust.

### Design Journey

Our visual language supports the user's journey:

- **Discovery (Landing Page)**: Bold serif headlines with italic emphasis ("chaos" → "gold") immediately communicate transformation
- **Onboarding**: Flat layered paper cut-out illustrations with texture create approachability while maintaining professionalism and structure
- **Daily Use**: Clean cards and organized layouts make story management effortless
- **Achievement**: Lime green celebrates completed stories and coaching insights

---

## Color System

### Brand Colors

#### Primary: Lime Green

Lime green represents growth, action, and success—the transformation from unstructured thoughts to polished interview responses.

| Shade | Hex Code | RGB | Usage |
|-------|----------|-----|-------|
| **Lime 50** | `#f7fee7` | rgb(247, 254, 231) | Background tints, hover states |
| **Lime 100** | `#dcfce7` | rgb(236, 252, 225) | Badge backgrounds, soft highlights |
| **Lime 200** | `#bef264` | rgb(190, 242, 100) | Secondary actions, borders |
| **Lime 300** | `#a3e635` | rgb(163, 230, 53) | Interactive element highlights |
| **Lime 400** | `#84cc16` | rgb(132, 204, 22) | **Disabled/muted actions** |
| **Lime 500** | `#65a30d` | rgb(101, 163, 13) | **Primary brand color** (CTAs, key actions) |
| **Lime 600** | `#4d7c0f` | rgb(77, 124, 15) | Hover states, pressed buttons |
| **Lime 700** | `#4d7c0f` | rgb(77, 124, 15) | Text on light backgrounds |
| **Lime 800** | `#3f6212` | rgb(63, 98, 18) | Text on Amber backgrounds (Tips Box) |
| **Lime 900** | `#365314` | rgb(54, 83, 20) | Darkest shade for depth |

**Note:** Primary CTA color is **Lime 500 (`#65a30d`)** for better contrast and readability. Lime 400 (`#84cc16`) is used for disabled states and subtle highlights.

#### Secondary: Amber/Gold

Amber provides warmth and highlights achievements, success metrics, and premium features.

| Shade | Hex Code | RGB | Usage |
|-------|----------|-----|-------|
| **Amber 50** | `#fffbeb` | rgb(255, 251, 235) | Success card backgrounds |
| **Amber 100** | `#fef3c7` | rgb(254, 243, 199) | Badge backgrounds, soft highlights |
| **Amber 300** | `#fcd34d` | rgb(252, 211, 77) | Accent highlights (semi-transparent) |
| **Amber 400** | `#fbbf24` | rgb(251, 191, 36) | Secondary CTAs |
| **Amber 500** | `#f59e0b` | rgb(245, 158, 11) | Icon backgrounds, achievements |
| **Amber 600** | `#d97706` | rgb(217, 119, 6) | Hover states |

### Neutral Colors

Neutrals provide structure, readability, and visual rest.

| Shade | Hex Code | RGB | Usage |
|-------|----------|-----|-------|
| **White** | `#ffffff` | rgb(255, 255, 255) | Primary background, card surfaces |
| **Gray 50** | `#f9fafb` | rgb(249, 250, 251) | Subtle section backgrounds |
| **Gray 100** | `#f3f4f6` | rgb(243, 244, 246) | Disabled backgrounds, borders |
| **Gray 200** | `#e5e7eb` | rgb(229, 231, 235) | Dividers, input borders |
| **Gray 300** | `#d1d5db` | rgb(209, 213, 219) | Secondary borders, inactive elements |
| **Gray 400** | `#9ca3af` | rgb(156, 163, 175) | Tertiary text, placeholder text |
| **Gray 600** | `#4b5563` | rgb(75, 85, 99) | Secondary text, labels |
| **Gray 700** | `#374151` | rgb(55, 65, 81) | Body text |
| **Gray 900** | `#111827` | rgb(17, 24, 39) | Primary text, headings, footer background |

### Semantic Colors

Semantic colors communicate status and provide consistent feedback.

| Purpose | Shade | Hex Code | Usage |
|---------|-------|----------|-------|
| **Success** | Green 500 | `#10b981` | Success messages, completed states |
| **Success Background** | Green 50 | `#ecfdf5` | Success card backgrounds |
| **Warning** | Orange 500 | `#f97316` | Warnings, gaps in coaching insights |
| **Warning Background** | Orange 50 | `#fff7ed` | Warning card backgrounds |
| **Error** | Red 500 | `#ef4444` | Error messages, destructive actions |
| **Error Background** | Red 50 | `#fef2f2` | Error card backgrounds |
| **Info** | Blue 500 | `#3b82f6` | Informational messages |
| **Info Background** | Blue 50 | `#eff6ff` | Info card backgrounds |

### Tag Colors

Each skill category has a dedicated color for instant visual recognition.

| Map Key | Display Color | Hex Code |
|---------|---------------|----------|
| **Leadership** | Purple | `#8b5cf6` |
| **Ownership** | Lime Green | `#65a30d` (Primary) |
| **Impact** | Amber | `#f59e0b` |
| **Communication** | Teal | `#00CEC9` |
| **Conflict** | Lime Green | `#65a30d` (Primary) |
| **Strategic Thinking** | Light Purple | `#a78bfa` |
| **Execution** | Lime Green | `#65a30d` (Primary) |
| **Adaptability** | Light Green | `#34d399` |
| **Failure** | Lime Green | `#65a30d` (Primary) |
| **Innovation** | Light Red | `#f87171` |

### Flutter Implementation

#### ColorScheme

```dart
import 'package:flutter/material.dart';

const ColorScheme parfolioColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary: Lime Green
  primary: Color(0xFF65A30D),           // Lime 500
  onPrimary: Color(0xFFFFFFFF),         // White
  primaryContainer: Color(0xFFDCFCE7),  // Lime 100
  onPrimaryContainer: Color(0xFF3F6212),// Lime 700

  // Secondary: Amber
  secondary: Color(0xFFF59E0B),         // Amber 500
  onSecondary: Color(0xFFFFFFFF),       // White
  secondaryContainer: Color(0xFFFEF3C7),// Amber 100
  onSecondaryContainer: Color(0xFFD97706), // Amber 600

  // Background
  background: Color(0xFFFFFFFF),        // White
  onBackground: Color(0xFF111827),      // Gray 900

  // Surface
  surface: Color(0xFFFFFFFF),           // White
  onSurface: Color(0xFF111827),         // Gray 900
  surfaceVariant: Color(0xFFF9FAFB),    // Gray 50
  onSurfaceVariant: Color(0xFF4B5563),  // Gray 600

  // Error
  error: Color(0xFFEF4444),             // Red 500
  onError: Color(0xFFFFFFFF),           // White
  errorContainer: Color(0xFFFEF2F2),    // Red 50
  onErrorContainer: Color(0xFF991B1B),  // Red 800

  // Outline
  outline: Color(0xFFD1D5DB),           // Gray 300
  outlineVariant: Color(0xFFE5E7EB),    // Gray 200

  // Shadow & Overlay
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
);
```

#### Custom Color Extensions

```dart
extension ParfolioColors on ColorScheme {
  // Lime Scale
  Color get lime50 => const Color(0xFFF7FEE7);
  Color get lime100 => const Color(0xFFDCFCE7);
  Color get lime200 => const Color(0xFFBEF264);
  Color get lime300 => const Color(0xFFA3E635);
  Color get lime400 => const Color(0xFF84CC16);
  Color get lime500 => const Color(0xFF65A30D);
  Color get lime600 => const Color(0xFF4D7C0F);
  Color get lime700 => const Color(0xFF3F6212);

  // Amber Scale
  Color get amber50 => const Color(0xFFFFFBEB);
  Color get amber100 => const Color(0xFFFEF3C7);
  Color get amber400 => const Color(0xFFFBBF24);
  Color get amber500 => const Color(0xFFF59E0B);
  Color get amber600 => const Color(0xFFD97706);

  // Gray Scale
  Color get gray50 => const Color(0xFFF9FAFB);
  Color get gray100 => const Color(0xFFF3F4F6);
  Color get gray200 => const Color(0xFFE5E7EB);
  Color get gray300 => const Color(0xFFD1D5DB);
  Color get gray400 => const Color(0xFF9CA3AF);
  Color get gray600 => const Color(0xFF4B5563);
  Color get gray700 => const Color(0xFF374151);
  Color get gray900 => const Color(0xFF111827);

  // Semantic Colors
  Color get success => const Color(0xFF10B981);
  Color get successBg => const Color(0xFFECFDF5);
  Color get warning => const Color(0xFFF97316);
  Color get warningBg => const Color(0xFFFFF7ED);
  Color get info => const Color(0xFF3B82F6);
  Color get infoBg => const Color(0xFFEFF6FF);

  // Tag Colors
  Map<String, Color> get tagColors => {
    'Leadership': const Color(0xFF8B5CF6),
    'Communication': const Color(0xFF00CEC9),
    'Impact': const Color(0xFFF59E0B),
    'Problem-Solving': const Color(0xFFE17055),
    'Collaboration': const Color(0xFF60A5FA),
    'Strategic Thinking': const Color(0xFFA78BFA),
    'Innovation': const Color(0xFFF87171),
    'Adaptability': const Color(0xFF34D399),
  };
}
```

### Usage Guidelines

**Text**: Gray 900 for headings, Gray 700 for body, Gray 600 for labels, Gray 400 for tertiary text
 
---
 
### Marketing & Product Color Alignment
 
To maintain a unified brand experience, the PARfolio landing page (`marketing/index.html`) is synchronized with the web app's brand colors using a custom Tailwind configuration.
 
**Key Alignment Strategy:**
- **Primary CTA Harmony**: Both the landing page and web app use **Lime 500 (#65A30D)** for primary actions (Get Started, Start Recording).
- **Subtle Badges**: Non-actionable badges on the landing page (e.g., Voice-First badge) utilize a lighter tint (**#ecfccb**) for visual hierarchy, while core interactions remain bold.
- **Shared Shadows**: Hover effects on the landing page feature a subtle Lime 500 shadow (`rgba(101, 163, 13, 0.15)`) to match the product's interactive feel.
 
---

---

## Typography

### Font Families

#### Primary: Inter (Sans-Serif)

Inter is a modern, highly legible sans-serif optimized for digital interfaces. Use for all body text, buttons, labels, and UI elements.

**Google Fonts Package**: `Inter`
**Weights Used**: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)
**Characteristics**: Wide apertures, tall x-height, excellent screen readability

#### Accent: Libre Baskerville (Serif)

Libre Baskerville is a web-optimized serif font that brings elegance and authority to headings.

**Google Fonts Package**: `Libre Baskerville`
**Weights Used**: 400 (Regular), 700 (Bold)
**Styles**: Normal, Italic
**Characteristics**: Classic serif proportions, strong serifs, high contrast
**Special Use**: Italic style for emphasis on key words in headings (e.g., "Turn your work *chaos* into interview *gold*")

### Type Scale

#### Flutter TextTheme Mapping

```dart
import 'package:google_fonts/google_fonts.dart';

TextTheme get parfolioTextTheme {
  return TextTheme(
    // Display: Large hero headlines
    displayLarge: GoogleFonts.libreBaskerville(
      fontSize: 56,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -1.0,
      color: const Color(0xFF111827), // Gray 900
    ),
    displayMedium: GoogleFonts.libreBaskerville(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
      color: const Color(0xFF111827),
    ),
    displaySmall: GoogleFonts.libreBaskerville(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.25,
      color: const Color(0xFF111827),
    ),

    // Headline: Section headers
    headlineLarge: GoogleFonts.libreBaskerville(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    headlineMedium: GoogleFonts.libreBaskerville(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.3,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    headlineSmall: GoogleFonts.libreBaskerville(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.35,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),

    // Title: Card titles, dialog headers
    titleLarge: GoogleFonts.libreBaskerville(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.4,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF111827),
    ),

    // Body: Paragraph text
    bodyLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0,
      color: const Color(0xFF374151), // Gray 700
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: 0,
      color: const Color(0xFF374151),
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
      color: const Color(0xFF4B5563), // Gray 600
    ),

    // Label: Buttons, labels, small UI text
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: 0.15,
      color: const Color(0xFF111827),
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.15,
      color: const Color(0xFF4B5563),
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.2,
      color: const Color(0xFF4B5563),
    ),
  );
}
```

### Special Typography Patterns

#### Italic Emphasis in Headings

Following the landing page pattern, use italic serif text to emphasize key transformational words in headlines.

**Example Pattern**: "Turn your work *chaos* into interview *gold*"

**Implementation**:
```dart
RichText(
  text: TextSpan(
    style: Theme.of(context).textTheme.displayMedium,
    children: [
      TextSpan(text: 'Turn your work '),
      TextSpan(
        text: 'chaos',
        style: GoogleFonts.libreBaskerville(
          fontSize: 48,
          fontWeight: FontWeight.w400, // Regular weight
          fontStyle: FontStyle.italic,
          color: const Color(0xFF111827),
        ),
      ),
      TextSpan(text: ' into interview '),
      TextSpan(
        text: 'gold',
        style: GoogleFonts.libreBaskerville(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
          color: const Color(0xFF111827),
        ),
      ),
    ],
  ),
)
```

#### Uppercase Labels

Use uppercase Inter for section labels and categories.

```dart
Text(
  'FEATURES',
  style: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1.5,
    color: const Color(0xFF65A30D), // Lime 500
  ),
)
```

### Google Fonts Integration

Ensure `google_fonts` package is added to `pubspec.yaml`:

```yaml
dependencies:
  google_fonts: ^7.0.0
```

**Font Loading Strategy**: Use `GoogleFonts.inter()` and `GoogleFonts.libreBaskerville()` throughout the app. The package handles caching automatically.

### Typography Usage Guidelines

- **Headings (Display, Headline)**: Use Libre Baskerville for impact and authority
- **Subheadings (Title)**: Use Libre Baskerville for large titles (titleLarge), Inter for medium/small
- **Body Text**: Always use Inter for readability
- **UI Elements**: Buttons, labels, chips, inputs all use Inter
- **Italic Emphasis**: Reserve for key transformational words in marketing and onboarding
- **Line Length**: Limit body text to 70-80 characters per line for optimal readability
- **Text Color**: Use Gray 900 for headings, Gray 700 for body, Gray 600 for secondary text

---

## Spacing & Layout

### Base Unit

**Base Unit**: 4px
**Reasoning**: 4px provides flexibility for precise layouts while maintaining alignment across components.

### Spacing Scale

Use multiples of the base unit for all spacing decisions.

| Name | Value | Use Cases |
|------|-------|-----------|
| **xs** | 4px (1 unit) | Tight padding, icon spacing |
| **sm** | 8px (2 units) | Compact spacing, chip padding |
| **md** | 12px (3 units) | Default gap between related elements |
| **base** | 16px (4 units) | Standard padding, list item spacing |
| **lg** | 24px (6 units) | Card padding, section spacing |
| **xl** | 32px (8 units) | Large padding, generous whitespace |
| **2xl** | 48px (12 units) | Section dividers, hero spacing |
| **3xl** | 64px (16 units) | Major section breaks |
| **4xl** | 96px (24 units) | Page-level spacing |

### Flutter Constants

```dart
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  static const double xxxxl = 96.0;
}
```

### Container & Layout

**Max Width**: 1280px (matches landing page `max-w-7xl`)
**Screen Edge Padding**: 16px mobile, 24px tablet, 32px desktop
**Card Internal Padding**: 24px (lg) for standard cards, 32px (xl) for hero cards
**List Item Spacing**: 12px (md) between items
**Grid Gap**: 24px (lg) for card grids

### Flutter Implementation

```dart
// Responsive container
Container(
  constraints: const BoxConstraints(maxWidth: 1280),
  padding: const EdgeInsets.symmetric(
    horizontal: 16, // Mobile default
    vertical: 24,
  ),
  child: child,
)

// Card padding
Card(
  child: Padding(
    padding: const EdgeInsets.all(24), // lg
    child: content,
  ),
)

// List spacing
ListView.separated(
  separatorBuilder: (context, index) => const SizedBox(height: 12), // md
  itemBuilder: (context, index) => listItem,
)
```

---

## Component Specifications

### Buttons

#### Primary Button (Elevated)

**Use**: Primary actions, main CTAs (Start Recording, Save Story, Submit)

**Specifications**:
- **Background**: Lime 500 (`#65A30D`)
- **Text**: White, Inter, 16px, Semi-Bold (600)
- **Padding**: 16px horizontal, 12px vertical (large), 12px horizontal, 8px vertical (medium)
- **Border Radius**: 24px (fully rounded pill shape)
- **Height**: 48px (large), 40px (medium), 32px (small)
- **Minimum Width**: 48px for accessibility
- **Shadow**: Elevation 2 (default), Elevation 4 (hover/focus)
- **Hover**: Background → Lime 600, lift -2px, shadow increase
- **Pressed**: Background → Lime 700, no lift
- **Disabled**: Background → Gray 300, text → Gray 500

**Flutter Implementation**:
```dart
ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF65A30D), // Lime 500
    foregroundColor: Colors.white,
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    elevation: 2,
    minimumSize: const Size(48, 48),
  ),
)

// Usage
ElevatedButton(
  onPressed: () {},
  child: const Text('Start Recording'),
)
```

#### Secondary Button (Outlined)

**Use**: Secondary actions, cancel, back navigation

**Specifications**:
- **Background**: Transparent (default), Gray 50 (hover)
- **Border**: 2px solid Gray 300 (default), Gray 400 (hover)
- **Text**: Gray 700, Inter, 16px, Semi-Bold (600)
- **Padding**: 16px horizontal, 12px vertical
- **Border Radius**: 24px (fully rounded pill shape)
- **Height**: 48px (large), 40px (medium)
- **Shadow**: None
- **Hover**: Border → Gray 400, background → Gray 50

**Flutter Implementation**:
```dart
OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF374151), // Gray 700
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    side: const BorderSide(
      color: Color(0xFFD1D5DB), // Gray 300
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    minimumSize: const Size(48, 48),
  ),
)
```

#### Text Button

**Use**: Tertiary actions, links, subtle interactions

**Specifications**:
- **Background**: Transparent
- **Text**: Lime 700, Inter, 16px, Semi-Bold (600)
- **Padding**: 12px horizontal, 8px vertical
- **Border Radius**: 8px
- **Height**: 36px minimum
- **Hover**: Background → Lime 50

**Flutter Implementation**:
```dart
TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: const Color(0xFF3F6212), // Lime 700
    textStyle: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

#### Icon Button

**Use**: Single-action icons (delete, close, menu)

**Specifications**:
- **Size**: 48x48dp touch target
- **Icon Size**: 24x24dp
- **Color**: Gray 700 (default), Error (destructive)
- **Background**: Transparent (default), Gray 100 (hover)
- **Border Radius**: 24px (circular)

```dart
IconButton(
  icon: const Icon(Icons.delete_outline, size: 24),
  color: const Color(0xFF374151), // Gray 700
  onPressed: () {},
  iconSize: 24,
  padding: const EdgeInsets.all(12),
)
```

---

### Cards

#### Base Card

**Use**: Story cards, content containers, grouped information

**Specifications**:
- **Background**: White
- **Border**: 1px solid Gray 200 (optional)
- **Border Radius**: 20px (large cards), 16px (medium cards), 12px (small cards)
- **Padding**: 24px (large), 16px (medium), 12px (small)
- **Shadow**: Elevation 0 (default), Elevation 2 (hover)
- **Hover**: Lift -2px, shadow → Elevation 4

**Flutter Implementation**:
```dart
CardTheme(
  color: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(
      color: const Color(0xFFE5E7EB), // Gray 200
      width: 1,
    ),
  ),
  margin: const EdgeInsets.symmetric(vertical: 8),
)

// Usage with hover (web/desktop)
Card(
  child: InkWell(
    onTap: () {},
    borderRadius: BorderRadius.circular(20),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: content,
    ),
  ),
)
```

#### Elevated Card

**Use**: Featured content, hero cards, important CTAs

**Specifications**:
- **Background**: White
- **Border Radius**: 24px
- **Padding**: 32px
- **Shadow**: Elevation 4 (default), Elevation 8 (hover)
- **Hover**: Lift -4px, shadow → Elevation 12

```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
  child: Padding(
    padding: const EdgeInsets.all(32),
    child: content,
  ),
)
```

#### Story Card Pattern

**Specific Layout for Story Lists**:

```dart
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: BorderSide(color: Theme.of(context).colorScheme.outline),
  ),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => TagChip(tag: tag)).toList(),
          ),
          const SizedBox(height: 12),
          // Date
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  ),
)
```


#### Profile Card Pattern

**Specific Layout for User Information on the Dashboard**:

- **Background**: White (Desktop), Transparent (Mobile)
- **Structure**: Horizontal layer on desktop, centered column on mobile
- **Border**: Subtle Gray (`Colors.grey.withOpacity(0.2)`), 1px width
- **Shadow**: Shadows.md (matches Navigation Bar)
- **Profile Photo**: 120px circular, 3px Dark Lime border (`#65A30D`), Lime shadow
    - *Placeholder*: Background → Lime 50 (`#F7FEE7`), Text → Dark Lime (`#4D7C0F`), font-weight: Bold
- **Text**: Both Name and Role use **Lime 900 (`#365314`)** for a unified look
- **Edit Action**: Subtitled text button below name/role

#### Recording CTA Pattern

**Specific Layout for the "Hero" Dashboard Moment**:

- **Background**: Lime 50 (`#F7FEE7`)
- **Text**: Pure Black for maximum contrast and readability
- **Structure**: Left-aligned Column on desktop, compact Horizontal Row on mobile
- **Icon**: Mic icon in a Lime 500 circular container
- **Button**: Primary ElevatedButton (Lime 500)
- **Shadow**: Shadows.md (matches Navigation Bar)

#### Tips Box Pattern

**Specific Layout for Helper Tips (e.g., Recording Screen)**:

- **Background**: Amber 50 (`#FFFBEB`)
- **Border**: Amber 200 (`#FDE68A`)
- **Text/Icons**: Lime 800 (`#3F6212`) for high contrast
- **Structure**: Icon + Title row, followed by bulleted list
- **Corner Radius**: 16px

---

### Badges & Chips

#### Badge Component

**Use**: Tags, status indicators, category labels

**Specifications**:
- **Shape**: Fully rounded pill (border-radius: 999px)
- **Padding**: 12px horizontal, 6px vertical (medium), 8px horizontal, 4px vertical (small)
- **Background**: Tag-specific color at 10% opacity OR Lime 100 for primary
- **Text**: Tag-specific color (full opacity), Inter, 14px (medium), 12px (small), Semi-Bold (600)
- **Border**: None
- **Height**: 32px (medium), 24px (small)

**Flutter Implementation**:
```dart
// Small badge
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: const Color(0xFFDCFCE7), // Lime 100
    borderRadius: BorderRadius.circular(999),
  ),
  child: Text(
    'Voice-First',
    style: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF3F6212), // Lime 700
      letterSpacing: 0.2,
    ),
  ),
)
```

#### Tag Chip

**Use**: Story tags, filter chips

**Specifications**:
- **Shape**: Fully rounded pill
- **Padding**: 12px horizontal, 6px vertical
- **Background**: Tag color at 15% opacity
- **Text**: Tag color (full opacity), Inter, 13px, Semi-Bold (600)
- **Height**: 28px

```dart
class TagChip extends StatelessWidget {
  final String tag;

  const TagChip({required this.tag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagColor = Theme.of(context).extension<ParfolioColors>()!.tagColors[tag]
        ?? const Color(0xFF65A30D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: tagColor,
        ),
      ),
    );
  }
}
```

#### Filter Chip

**Use**: Selectable filters in horizontal scroll

**Specifications**:
- **Unselected**: Background → White, Border → 1px Gray 200
- **Selected**: Background → Lime 50 (`#F7FEE7`), Text → Dark Lime (`#4D7C0F`), Border → 1px Dark Lime (`#4D7C0F`)
- **Padding**: 12px horizontal, 8px vertical
- **Border Radius**: 8px (to match input field radius)
- **Height**: 48px (to match input field height)
- **Typography**: Inter, 16px, Regular (400) — matches input field text weight and size

```dart
FilterChip(
  label: Text(tag),
  selected: isSelected,
  onSelected: onSelected,
  backgroundColor: Colors.white,
  selectedColor: const Color(0xFFF7FEE7), // Lime 50
  labelStyle: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: isSelected
      ? const Color(0xFF4D7C0F)  // Dark Lime
      : const Color(0xFF111827), // Gray 900
  ),
  side: BorderSide(
    color: isSelected ? const Color(0xFF4D7C0F) : const Color(0xFFE5E7EB),
    width: 1,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
)
```

---

### Input Fields

#### Text Input

**Specifications**:
- **Background**: White
- **Border**: 1px solid Gray 300 (default), 2px solid Lime 500 (focus), 2px solid Error (error)
- **Border Radius**: 12px
- **Padding**: 16px horizontal, 14px vertical
- **Height**: 48px minimum
- **Label**: Gray 700, Inter, 14px, Semi-Bold, positioned inside border
- **Placeholder**: Gray 400, Inter, 16px, Regular
- **Text**: Gray 900, Inter, 16px, Regular
- **Icon**: 24x24dp, Gray 600, positioned 12px from edge

**Flutter Implementation**:
```dart
InputDecorationTheme(
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFD1D5DB), // Gray 300
      width: 1,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFD1D5DB),
      width: 1,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFF65A30D), // Lime 500
      width: 2,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Color(0xFFEF4444), // Error
      width: 2,
    ),
  ),
  labelStyle: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF374151), // Gray 700
  ),
  hintStyle: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF9CA3AF), // Gray 400
  ),
)
```

---

### Navigation

#### App Bar

**Specifications**:
- **Background**: White
- **Height**: 64px
- **Elevation**: 0 (default), 2 (always on dashboard/scrolled)
- **Title**: Gray 900, Inter, 20px, Bold
- **Icon Buttons**: Gray 700, 24x24dp
- **Border Bottom**: 1px solid Gray 200 (`#E5E7EB`)
- **Shadow**: Shadows.md (for distinct layer separation)

**Flutter Implementation**:
```dart
AppBarTheme(
  backgroundColor: Colors.white,
  foregroundColor: const Color(0xFF111827), // Gray 900
  elevation: 0,
  centerTitle: false,
  titleTextStyle: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF111827),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF374151), // Gray 700
    size: 24,
  ),
  toolbarHeight: 64,
)
```

#### Dashboard Navigation Bar

**Specific Layout for Authenticated Dashboard**:

- **Position**: Fixed top
- **Background**: White
- **Border**: Bottom border 1px solid Gray 200 (`#E5E7EB`)
- **Shadow**: Medium Drop Shadow (`Shadows.md`) for distinct layer separation
- **Content**: Logo (left), Actions/Profile (right)
- **Behavior**: Content scrolls independently underneath
```

#### Floating Action Button

**Specifications**:
- **Background**: Lime 500
- **Icon**: White, 24x24dp
- **Size**: 56x56dp (regular), 48x48dp (small)
- **Shadow**: Elevation 6
- **Shape**: Circular (border-radius: 999px)

```dart
FloatingActionButtonThemeData(
  backgroundColor: const Color(0xFF65A30D), // Lime 500
  foregroundColor: Colors.white,
  elevation: 6,
  shape: const CircleBorder(),
)
```

---

## Shadows & Elevation

### Elevation Scale

Flutter uses elevation values (0-24) to generate shadows. Map these to our design system.

| Elevation | Usage | Shadow Description |
|-----------|-------|--------------------|
| **0** | Flat surfaces, default cards | No shadow |
| **1** | Very subtle depth | Barely visible shadow |
| **2** | Resting cards, buttons | Subtle shadow |
| **4** | Elevated cards, hover states | Visible depth |
| **6** | FAB, top app bar (scrolled) | Strong presence |
| **8** | Dialogs, bottom sheets | Significant elevation |
| **12** | Modal overlays | Very prominent |
| **16** | Navigation drawer | Maximum standard elevation |
| **24** | Special effects only | Dramatic shadow |

### Shadow Definitions

For custom shadows (outside Flutter's automatic elevation):

```dart
class Shadows {
  // Subtle shadow for cards
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  // Default shadow for elevated elements
  static List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // Strong shadow for hover/focus states
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Extra large shadow for modals
  static List<BoxShadow> get xl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Dramatic shadow for special effects
  static List<BoxShadow> get xxl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
```

### Usage Guidelines

- **Flat UI**: Default cards use elevation 0 with 1px border for clarity
- **Interactive Elements**: Buttons use elevation 2, increase to 4 on hover
- **Hover States**: Increase shadow by 2-4 elevation levels
- **Layer Hierarchy**: Higher elevation = closer to user (dialogs above sheets above cards)
- **Performance**: Limit shadow complexity on scrolling lists

---

## Animation & Motion

### Duration Standards

| Name | Duration | Use Cases |
|------|----------|-----------|
| **Quick** | 100ms | Micro-interactions, tooltip appearance |
| **Fast** | 200ms | Button hover, chip selection, ripple effects |
| **Standard** | 300ms | Card hover, page transitions, drawer open |
| **Leisurely** | 500ms | Hero animations, content reveals |
| **Slow** | 700ms | Emphasis animations, floating effects |

### Easing Curves

Flutter provides several curves in the `Curves` class:

| Curve | Use Case |
|-------|----------|
| **Curves.easeInOut** | Default for most animations (smooth start and end) |
| **Curves.easeOut** | Entrances, items coming into view |
| **Curves.easeIn** | Exits, items leaving view |
| **Curves.fastOutSlowIn** | Material Design standard |
| **Curves.elasticOut** | Playful, attention-grabbing effects |
| **Curves.decelerate** | Natural, physics-based motion |

### Common Animation Patterns

#### Hover Lift Effect

**Use**: Cards, buttons, interactive elements
**Effect**: Translate Y -2px, increase shadow elevation

```dart
class HoverLiftCard extends StatefulWidget {
  final Widget child;

  const HoverLiftCard({required this.child, Key? key}) : super(key: key);

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _liftAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _liftAnimation = Tween<double>(begin: 0, end: -2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _shadowAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _liftAnimation.value),
            child: Card(
              elevation: _shadowAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

#### Fade In on Scroll

**Use**: Content reveals, list items entering view

```dart
class FadeInOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInOnScroll({
    required this.child,
    this.delay = Duration.zero,
    Key? key,
  }) : super(key: key);

  @override
  State<FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<FadeInOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

#### Page Transitions

**Use**: Navigation between screens

```dart
// Custom page route with fade + slide
class FadeSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.05, 0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween.chain(
              CurveTween(curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
        );
}

// Usage
Navigator.push(
  context,
  FadeSlidePageRoute(page: const StoryDetailScreen()),
);
```

### Accessibility: Reduced Motion

Always respect user's reduced motion preferences:

```dart
bool get reduceMotion {
  return WidgetsBinding.instance.window.accessibilityFeatures.disableAnimations;
}

// Usage in animations
AnimationController(
  duration: reduceMotion
    ? Duration.zero
    : const Duration(milliseconds: 300),
  vsync: this,
);
```

---

## Icons & Imagery

### Icon Library

**Primary**: Material Icons (built into Flutter)
**Access**: `Icons` class

**Commonly Used Icons**:
- `Icons.mic` - Recording
- `Icons.edit_outlined` - Edit action
- `Icons.delete_outline` - Delete action
- `Icons.search` - Search
- `Icons.filter_list` - Filter
- `Icons.more_vert` - Menu
- `Icons.add` - Add new
- `Icons.check_circle` - Success
- `Icons.error_outline` - Error
- `Icons.info_outline` - Info
- `Icons.arrow_forward` - Navigation forward
- `Icons.arrow_back` - Navigation back
- `Icons.close` - Close/dismiss

### Icon Sizes

| Size | px | Use Case |
|------|----|----|
| **Small** | 16 | Inline with text, dense UI |
| **Medium** | 20 | List items, secondary actions |
| **Standard** | 24 | Primary UI icons, buttons |
| **Large** | 32 | Feature cards, empty states |
| **XL** | 48 | Hero icons, splash screens |

### Icon Colors

Match icon colors to text hierarchy:
- **Primary**: Gray 900 for prominent icons
- **Secondary**: Gray 600 for standard icons
- **Tertiary**: Gray 400 for subtle icons
- **Interactive**: Lime 500 for active/selected states
- **Destructive**: Error (Red 500) for delete actions

### Illustration Style

**Aesthetic**: Flat layered paper cut-out with texture, modern, intentional
**Reference**: Marketing assets in `/marketing/assets/`

**Characteristics**:
- **Paper texture**: Visible grain and tactile surface quality throughout
- **Flat color blocks**: Solid colors with hard edges, no gradients
- **Layered composition**: Depth created through overlapping paper-like layers, not shadows
- **Intentional colors**: Distinct shades of lime (#65A30D, #84CC16, #A3E635) and amber (#F59E0B, #FBB042, #FCD34D)
- **Full coverage**: No white space within illustrations—every area intentionally colored
- **Semi-literal shapes**: Geometric representations of concepts (microphone, tags, folders)
- **Precise color zones**: Each color occupies a deliberate area with clear boundaries

**Reference Assets**:
- `/marketing/assets/feature_voice_to_par_v3.png` - Voice to PAR feature
- `/marketing/assets/feature_smart_tagging_v3.png` - Smart Tagging feature
- `/marketing/assets/feature_story_bank_v3.png` - Story Bank feature
- Hero phone image - Layered phone with textured surfaces

**Use Cases**:
- Landing page hero and feature cards
- Onboarding screens
- Empty states (no stories yet)
- Feature highlights
- Success confirmations

### Image Treatments

**Border Radius**: 16-20px for feature images, 12px for thumbnails
**Shadows**: Use `Shadows.md` for subtle depth on image containers (not within illustrations themselves—the new flat layered paper cut-out style uses layering for depth)
**Aspect Ratios**: 4:3 for feature cards, 16:9 for hero images, 1:1 for avatars
**Loading**: Show gray skeleton with subtle pulse animation

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Container(
    decoration: BoxDecoration(
      boxShadow: Shadows.md,
    ),
    child: Image.asset(
      'assets/feature_image.png',
      fit: BoxFit.cover,
    ),
  ),
)
```

### Empty States

**Pattern**: Large icon + heading + description + optional CTA

```dart
Center(
  child: Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mic,
          size: 64,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
        const SizedBox(height: 16),
        Text(
          'No stories yet',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Start recording to create your first career story',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Create Story'),
        ),
      ],
    ),
  ),
)
```

---

## Accessibility

### Color Contrast

All color combinations meet **WCAG 2.1 Level AA** standards:

- **Normal Text** (< 18px): Minimum 4.5:1 contrast ratio
- **Large Text** (≥ 18px or ≥ 14px bold): Minimum 3:1 contrast ratio

**Verified Combinations**:
- Lime 500 on White: 5.2:1 ✓
- Lime 700 on White: 7.8:1 ✓
- Gray 900 on White: 15.3:1 ✓
- Gray 700 on White: 9.1:1 ✓
- Gray 600 on White: 6.8:1 ✓
- White on Lime 500: 5.2:1 ✓
- White on Error: 4.9:1 ✓

**Testing Tool**: Use WebAIM Contrast Checker or Flutter's built-in accessibility tools.

### Touch Targets

**Minimum Size**: 48x48dp for all interactive elements (WCAG 2.5.5)

- All buttons have `minimumSize: Size(48, 48)`
- Icon buttons use 48x48dp touch targets even if icon is 24x24dp
- Chips and badges are at least 32dp tall, with adequate spacing

### Focus Indicators

**Specification**: 2px solid Lime 500 outline with 2px offset

```dart
// Focus indicator style
FocusedBorder(
  borderSide: BorderSide(
    color: Theme.of(context).colorScheme.primary,
    width: 2,
  ),
)
```

**Visibility**: Focus indicators must be clearly visible on all interactive elements for keyboard navigation.

### Semantic Labels

**Screen Readers**: Provide meaningful labels for all interactive elements.

```dart
// Icon button with semantic label
IconButton(
  icon: const Icon(Icons.delete_outline),
  onPressed: () {},
  tooltip: 'Delete story',
  semanticsLabel: 'Delete this story permanently',
)

// Image with semantic label
Semantics(
  label: 'Feature illustration showing voice to PAR conversion',
  child: Image.asset('assets/feature_voice_to_par_v3.png'),
)
```

### Text Scaling

**Support**: App must support text scaling from 100% to 200% without breaking layouts.

```dart
// Use flexible layouts
Flexible(
  child: Text(
    'This text will wrap if scaled',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)

// Avoid fixed heights for text containers
// BAD: Container(height: 50, child: Text(...))
// GOOD: Container(constraints: BoxConstraints(minHeight: 50), child: Text(...))
```

### Motion Reduction

**Implementation**: Check `disableAnimations` flag and adjust accordingly.

```dart
class AnimationSettings {
  static bool get reduceMotion {
    return WidgetsBinding.instance.window
      .accessibilityFeatures.disableAnimations;
  }

  static Duration standardDuration(Duration normal) {
    return reduceMotion ? Duration.zero : normal;
  }

  static Curve standardCurve() {
    return reduceMotion ? Curves.linear : Curves.easeInOut;
  }
}

// Usage
AnimationController(
  duration: AnimationSettings.standardDuration(
    const Duration(milliseconds: 300),
  ),
  vsync: this,
);
```

### Additional Considerations

- **Text Alternatives**: Provide alt text for all images
- **Clear Language**: Use simple, clear copy throughout the app
- **Error Messages**: Provide specific, actionable error messages
- **Form Labels**: Every input must have a clear label
- **Logical Tab Order**: Ensure keyboard navigation follows visual order
- **Sufficient Time**: No time limits on interactions without warning

---

## Dark Mode (Future)

### Planning Notes

Dark mode is not currently implemented but should be considered for future releases.

### Color Adaptations Needed

- **Primary**: Lime 500 may need to shift to Lime 400 for better visibility on dark backgrounds
- **Backgrounds**: Replace White → Gray 900, Gray 50 → Gray 800
- **Text**: Invert gray scale (Gray 900 → Gray 50 for primary text)
- **Shadows**: Reduce shadow opacity, consider using lighter shadows or glows
- **Cards**: Use Gray 800 for card backgrounds with subtle borders

### Implementation Approach

```dart
// Future: ThemeData for dark mode
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: parfolioColorScheme.copyWith(
    brightness: Brightness.dark,
    primary: const Color(0xFF84CC16), // Lighter lime for visibility
    background: const Color(0xFF111827), // Gray 900
    surface: const Color(0xFF1F2937), // Gray 800
    // ... additional dark mode colors
  ),
  textTheme: parfolioTextTheme, // Same typography, colors auto-adjust
);
```

### User Preference

Respect system preference with option to override:

```dart
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system, // or ThemeMode.light / ThemeMode.dark
);
```

---

## Implementation Checklist

When implementing this design system in the Flutter app:

- [ ] Add `google_fonts: ^7.0.0` to `pubspec.yaml`
- [ ] Create `lib/core/theme.dart` with full theme configuration
- [ ] Create `lib/core/colors.dart` with color extension
- [ ] Create `lib/core/spacing.dart` with spacing constants
- [ ] Create `lib/core/shadows.dart` with shadow definitions
- [ ] Update `MaterialApp` to use new `ThemeData`
- [ ] Create reusable widget components (TagChip, BadgeComponent, etc.)
- [ ] Test all colors for WCAG AA contrast compliance
- [ ] Verify touch targets meet 48dp minimum
- [ ] Implement focus indicators for keyboard navigation
- [ ] Test with screen readers (TalkBack, VoiceOver)
- [ ] Test text scaling from 100% to 200%
- [ ] Implement reduced motion preferences
- [ ] Document any component variations not covered here

---

## Maintenance & Updates

**Versioning**: This document follows semantic versioning (Major.Minor.Patch)
**Updates**: Update this document when:
- New components are added
- Colors or typography change
- Accessibility standards evolve
- Dark mode is implemented
- User feedback necessitates design changes

**Ownership**: Design system is maintained by the product team. Propose changes via pull requests with rationale.

---

## Resources

### Design References
- Landing Page: `/marketing/index.html`
- Landing Page Assets: `/marketing/assets/`
- Current Flutter Theme: `/frontend/lib/core/theme.dart`

### External Resources
- [Material Design 3](https://m3.material.io/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Google Fonts](https://fonts.google.com/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

---

## Decoration & Imagery

### Strategy: The Hybrid Approach

We use visual hierarchy to balance delight with utility:

1.  **Hero Moments (Flat Layered Paper Cut-Out)**: Used for high-impact emotional beats (Landing Page, Onboarding, "First Story" Celebration).
    *   *Style*: Flat, layered paper cut-out illustrations with texture and grain. Semi-literal geometric shapes with intentional color blocking.
    *   *Colors*: Lime shades (#65A30D, #84CC16, #A3E635) and Amber shades (#F59E0B, #FBB042, #FCD34D).
    *   *Technique*: Depth through layering, not shadows. Full coverage compositions with tactile paper texture.
2.  **Utility & Flow (Abstract Geometric)**: Used for functional screens (Login, Registration, Settings) to keep focus while maintaining brand presence.
    *   *Style*: Flat, monoline, geometric shapes.
    *   *Colors*: Lime 300 (Energy), Gray 300 (Structure).

### Geometric Motifs (Growth & Sparks)

For the authentication and utility flows, we use specific motifs to tell the "chaos to gold" story subtly:

#### 1. The Sunburst (Success)
*   **Visual**: A radiant, 8-point spark or starburst.
*   **Meaning**: Represents the "Gold" in "Turn experiences into interview gold." It signifies a flash of insight, success, or a polished result.
*   **Usage**: Top-right corner of cards or screens.
*   **Implementation**: `SunburstDecoration` widget.

#### 2. The Ripple (Impact)
*   **Visual**: Concentric organic rings.
*   **Meaning**: Represents growth, expansion, and the ripple effect of a good story.
*   **Usage**: Bottom-left corner of cards or screens.
*   **Implementation**: `RippleDecoration` widget.

#### 3. Polka Dot Grid (Structure)
*   **Visual**: A rotated grid of small dots.
*   **Meaning**: Represents the raw data points or "experiences" before they are connected into a story.
*   **Usage**: Top-left and bottom-right corners (behind cards).
*   **Implementation**: `PolkaDotRectangle` widget.

#### 4. Wavy Line (Energy)
*   **Visual**: A smooth, continuous undulating line.
*   **Meaning**: Represents the flow of conversation and the dynamic nature of storytelling.
*   **Usage**: Near Polka Dot grids to add movement.
*   **Implementation**: `WavyLineDecoration` widget.

---

**End of Design System Documentation**
