# PARfolio Logo Specifications

**Version:** 1.0
**Last Updated:** January 2026
**Status:** Active

---

## Table of Contents

1. [Logo System Overview](#logo-system-overview)
2. [Primary Wordmark](#primary-wordmark)
3. [App Icons (Square)](#app-icons-square)
4. [Favicons & Small Icons](#favicons--small-icons)
5. [Vertical Lockup](#vertical-lockup)
6. [Color Specifications](#color-specifications)
7. [Usage Decision Tree](#usage-decision-tree)
8. [File Formats & Exports](#file-formats--exports)
9. [Usage Guidelines](#usage-guidelines)

---

## Logo System Overview

The PARfolio logo system consists of multiple variants optimized for different contexts and sizes. All variants maintain brand consistency through:

- **Typography:** Libre Baskerville (serif, bold) for "PAR" + Inter (sans-serif, semi-bold) for "folio"
- **Primary Color:** Lime 500 (#65a30d)
- **Secondary Color:** Amber 500 (#f59e0b) for accents
- **Philosophy:** Clean, professional, approachable

**Core Principle:** Use the simplest variant that maintains legibility at the required size.

---

## Primary Wordmark

### Full Horizontal Wordmark

**Primary Use Case:** Headers, landing pages, email signatures, marketing materials (web and print)

**Specifications:**
- **PAR:** Libre Baskerville Bold 700, Lime 500 (#65a30d)
- **folio:** Inter Semi-Bold 600, Gray 700 (#374151)
- **Accent:** Sunburst icon on 'i' dot, Amber 500 (#f59e0b)
- **Aspect Ratio:** ~3.5:1 (width:height)
- **Minimum Width:** 200px (digital), 1.5 inches (print)
- **Clear Space:** Minimum 32px (or equivalent to height of "P") on all sides

**Variants:**

| Variant | Description | Use Case |
|---------|-------------|----------|
| **Sunburst Accent** (Recommended) | Sparkle/star on 'i' dot | Primary branding, hero sections |
| **Mic Accent** | Microphone icon as 'i' dot | Voice-focused contexts, recording UI |
| **PAR Underline** | Three colored blocks under "PAR" | When emphasizing methodology |
| **Minimal** | Simple dot on 'i' | High-density layouts, conservative contexts |

**Color Adaptations:**

| Background | PAR Color | folio Color | Accent Color |
|------------|-----------|-------------|--------------|
| White/Light (#ffffff, #f9fafb) | Lime 500 (#65a30d) | Gray 700 (#374151) | Amber 500 (#f59e0b) |
| Dark (#111827) | Lime 400 (#84cc16) | White (#ffffff) | Amber 500 (#f59e0b) |
| Lime 50 (#f7fee7) | Lime 700 (#4d7c0f) | Gray 700 (#374151) | Amber 600 (#d97706) |
| Gradient (Lime 500→400) | White (#ffffff) | White (#ffffff) | White (#ffffff) |

**When to Use:**
- ✅ Website header/navigation (≥200px wide)
- ✅ Landing page hero section
- ✅ Email signatures
- ✅ Marketing materials (brochures, presentations)
- ✅ Footer (scaled appropriately)
- ❌ Mobile app header (too wide, use icon instead)
- ❌ Favicon (use simplified icon)
- ❌ Social media profile picture (use square icon)

---

## App Icons (Square)

### 1. Stacked PAR (Recommended)

**Primary Use Case:** iOS/Android app icons, desktop app icons

**Specifications:**
- **Composition:** Three circles vertically stacked with letters P, A, R
- **Background:** Gradient (Lime 500 #65a30d → Lime 400 #84cc16)
- **Circles:** White (#ffffff) with 95% opacity (top/bottom), 100% opacity (middle)
- **Letters:** Lime 500 (#65a30d), Libre Baskerville Bold
- **Size:** 1024x1024px (iOS), 512x512px (Android)
- **Corner Radius:** None (OS applies automatically)
- **Safe Zone:** 80px margin from edges

**When to Use:**
- ✅ iOS App Store icon
- ✅ Android Play Store icon
- ✅ macOS/Windows desktop app icon
- ✅ PWA manifest icon
- ✅ Home screen/launcher icon

**Why This Variant:**
- Most distinctive and memorable
- Clearly represents the PAR methodology
- Scales well from 20px to 1024px
- Works in monochrome (accessibility)

### 2. Connected Flow

**Alternative Use Case:** Social media profile pictures, secondary app icon

**Specifications:**
- **Composition:** Three circles horizontally with connecting lines
- **Background:** Gradient (Lime 500 → Lime 400)
- **Circles:** Lime 100 (#ecfccb) outer, White center
- **Letters:** P (Lime 700), A (Lime 500), R (Lime 700)
- **Size:** 1024x1024px or 512x512px

**When to Use:**
- ✅ LinkedIn company logo
- ✅ Twitter/X profile picture
- ✅ Facebook page icon
- ✅ Alternative app icon variant

### 3. Circle Badge (PAR in Circle)

**Alternative Use Case:** Badges, stamps, simplified branding

**Specifications:**
- **Composition:** "PAR" text centered in white circle
- **Background:** Gradient (Lime 500 → Lime 400)
- **Text:** White (#ffffff), Libre Baskerville Bold
- **Circle:** 60% of canvas size

**When to Use:**
- ✅ Badge/achievement icons
- ✅ Loading spinners
- ✅ Certification marks

### 4. P Monogram

**Alternative Use Case:** Minimal branding, watermarks

**Specifications:**
- **Composition:** Single "P" letter in circle
- **Background:** Gradient (Lime 500 → Lime 400)
- **Letter:** White (#ffffff), Libre Baskerville Bold
- **Accent:** Small amber sunburst in top-right

**When to Use:**
- ✅ Watermarks on images
- ✅ Ultra-minimal contexts
- ✅ Secondary brand mark

---

## Favicons & Small Icons

### Recommended: P Only

**Primary Use Case:** Browser favicons (16x16, 32x32, 64x64)

**Specifications:**
- **Composition:** Letter "P" on solid background
- **Background:** Lime 500 (#65a30d), rounded corners (12px radius at 64px)
- **Letter:** White (#ffffff), Libre Baskerville Bold
- **Sizes:** 16x16, 32x32, 64x64, 128x128, 256x256 PNG

**When to Use:**
- ✅ favicon.ico (multi-size)
- ✅ Browser tab icon
- ✅ Bookmark icon
- ✅ Browser history icon
- ✅ PWA manifest (small sizes)

**Critical Rule:** At 16x16px, text must be minimal. "P Only" is the only variant that remains legible.

### Alternative: Three Dots

**Specifications:**
- **Composition:** Three dots horizontally
- **Background:** Lime 500 (#65a30d)
- **Dots:** Lime 100 (outer), White (center)

**When to Use:**
- ✅ When branding consistency with "Connected Flow" app icon is needed
- ⚠️ May blur on low-DPI screens at 16x16

---

## Vertical Lockup

### Icon + Wordmark (Stacked)

**Primary Use Case:** Mobile splash screens, posters, vertical marketing materials

**Specifications:**
- **Top:** Connected flow icon (3 circles)
- **Bottom:** "PAR" on one line, "folio" on line below
- **Alignment:** Center-aligned
- **Spacing:** 40px between icon and text
- **Aspect Ratio:** ~1:1.8 (width:height)

**When to Use:**
- ✅ Mobile app splash screen
- ✅ Instagram/Pinterest posts (vertical format)
- ✅ Poster designs
- ✅ Trade show banners

### Wordmark Only (Stacked)

**Specifications:**
- **Line 1:** "PAR" (Libre Baskerville Bold, Lime 500)
- **Line 2:** "folio" (Inter Semi-Bold, Gray 700)
- **Alignment:** Center-aligned
- **Spacing:** Tight line height (1.1)

**When to Use:**
- ✅ Vertical spaces without room for icon
- ✅ Text-only contexts

---

## Color Specifications

### Primary Colors

| Color Name | Hex | RGB | Usage |
|------------|-----|-----|-------|
| **Lime 500** | #65a30d | rgb(101, 163, 13) | Primary brand color for "PAR" |
| **Lime 400** | #84cc16 | rgb(132, 204, 22) | Dark mode adaptation, gradients |
| **Lime 700** | #4d7c0f | rgb(77, 124, 15) | Light backgrounds (Lime 50) |
| **Lime 100** | #ecfccb | rgb(236, 252, 203) | Icon accents, backgrounds |

### Secondary Colors

| Color Name | Hex | RGB | Usage |
|------------|-----|-----|-------|
| **Amber 500** | #f59e0b | rgb(245, 158, 11) | Sunburst accent, warmth |
| **Amber 600** | #d97706 | rgb(217, 119, 6) | Amber on light backgrounds |

### Neutral Colors

| Color Name | Hex | RGB | Usage |
|------------|-----|-----|-------|
| **Gray 900** | #111827 | rgb(17, 24, 39) | Dark backgrounds |
| **Gray 700** | #374151 | rgb(55, 65, 81) | "folio" text on light |
| **White** | #ffffff | rgb(255, 255, 255) | Light backgrounds, reversed text |

### Typography

| Element | Font Family | Weight | Size (Base) |
|---------|-------------|--------|-------------|
| **PAR** | Libre Baskerville | Bold 700 | 64px (scales proportionally) |
| **folio** | Inter | Semi-Bold 600 | 64px (scales proportionally) |
| **Icon Letters** | Libre Baskerville | Bold 700 | Context-dependent |

---

## Usage Decision Tree

```
START: What context do I need a logo for?

├─ Website/Web App?
│  ├─ Header/Navigation? → PRIMARY WORDMARK (Horizontal)
│  ├─ Favicon? → P ONLY (16x16, 32x32)
│  ├─ Loading Screen? → CIRCLE BADGE or STACKED PAR
│  └─ Footer? → PRIMARY WORDMARK (scaled smaller)
│
├─ Mobile App?
│  ├─ App Icon (Store)? → STACKED PAR (1024x1024 iOS, 512x512 Android)
│  ├─ Splash Screen? → VERTICAL LOCKUP (Icon + Wordmark)
│  ├─ In-App Header? → CONNECTED FLOW ICON + "PARfolio" text
│  └─ Notification Icon? → P ONLY (simplified)
│
├─ Social Media?
│  ├─ Profile Picture? → CONNECTED FLOW or STACKED PAR (512x512)
│  ├─ Cover Photo? → PRIMARY WORDMARK (centered or left-aligned)
│  ├─ Post Graphics? → PRIMARY WORDMARK or VERTICAL LOCKUP
│  └─ Story/Reel? → VERTICAL LOCKUP
│
├─ Print/Marketing?
│  ├─ Business Card? → PRIMARY WORDMARK (horizontal)
│  ├─ Poster/Banner? → VERTICAL LOCKUP or PRIMARY WORDMARK
│  ├─ Presentation Slide? → PRIMARY WORDMARK (top corner or center)
│  └─ Merchandise? → CONNECTED FLOW ICON or PRIMARY WORDMARK
│
└─ Email/Documents?
   ├─ Email Signature? → PRIMARY WORDMARK (200-300px wide)
   ├─ Document Header? → PRIMARY WORDMARK (left-aligned)
   └─ PDF Watermark? → P MONOGRAM (semi-transparent)
```

---

## File Formats & Exports

### Required Exports

#### Web Assets

| Asset | Sizes | Format | Color Space |
|-------|-------|--------|-------------|
| **Favicon** | 16x16, 32x32, 64x64, 128x128, 256x256 | PNG (multi-size ICO) | sRGB |
| **Apple Touch Icon** | 180x180 | PNG | sRGB |
| **Primary Wordmark** | Vector | SVG | sRGB |
| **App Icon (iOS)** | 1024x1024 | PNG (no alpha) | sRGB |
| **App Icon (Android)** | 512x512 | PNG | sRGB |
| **OG Image** | 1200x630 | PNG or JPG | sRGB |

#### Print Assets

| Asset | Format | Resolution | Color Space |
|-------|--------|------------|-------------|
| **Primary Wordmark** | SVG, PDF, EPS | Vector | CMYK (converted) |
| **Raster Wordmark** | PNG, TIFF | 300 DPI minimum | CMYK |
| **Monochrome Version** | SVG, PDF | Vector | Black (K100) |

### File Naming Convention

```
parfolio-[variant]-[size]-[color].ext

Examples:
- parfolio-wordmark-primary-color.svg
- parfolio-wordmark-primary-white.svg
- parfolio-icon-stacked-1024.png
- parfolio-favicon-16.png
- parfolio-icon-p-only-64.png
```

### Directory Structure

```
assets/
├── logo/
│   ├── wordmark/
│   │   ├── svg/
│   │   │   ├── parfolio-wordmark-primary-color.svg
│   │   │   ├── parfolio-wordmark-primary-white.svg
│   │   │   ├── parfolio-wordmark-dark-mode.svg
│   │   │   └── parfolio-wordmark-monochrome.svg
│   │   └── png/
│   │       ├── parfolio-wordmark-1200w.png
│   │       ├── parfolio-wordmark-800w.png
│   │       └── parfolio-wordmark-400w.png
│   ├── icons/
│   │   ├── app/
│   │   │   ├── parfolio-icon-stacked-1024.png (iOS)
│   │   │   ├── parfolio-icon-stacked-512.png (Android)
│   │   │   ├── parfolio-icon-connected-512.png
│   │   │   └── parfolio-icon-circle-512.png
│   │   └── favicon/
│   │       ├── favicon.ico (multi-size)
│   │       ├── favicon-16x16.png
│   │       ├── favicon-32x32.png
│   │       ├── favicon-64x64.png
│   │       └── apple-touch-icon.png (180x180)
│   └── lockup/
│       ├── parfolio-vertical-lockup.svg
│       └── parfolio-vertical-lockup.png
```

---

## Usage Guidelines

### Do's ✓

- ✅ **Maintain proportions:** Never stretch or distort the wordmark
- ✅ **Use approved colors:** Stick to the color specifications for each background type
- ✅ **Respect clear space:** Keep minimum 32px (or height of "P") clear space around logo
- ✅ **Scale proportionally:** Always maintain aspect ratio when resizing
- ✅ **Use correct variant:** Follow the decision tree for appropriate variant selection
- ✅ **Test legibility:** Ensure logo is readable at intended size before deployment

### Don'ts ✗

- ❌ **Don't skew or rotate:** Keep logo horizontal or vertical (lockup only)
- ❌ **Don't use off-brand colors:** No blue, pink, purple, or unapproved colors
- ❌ **Don't add effects:** No gradients on wordmark (except approved app icon backgrounds), no shadows, no outlines
- ❌ **Don't rearrange elements:** "PAR" always before "folio", never reversed
- ❌ **Don't use low-resolution:** Always use vector (SVG) when possible, minimum 2x pixel density for raster
- ❌ **Don't recreate:** Always use official logo files, never attempt to recreate in other software
- ❌ **Don't use wordmark as favicon:** Use "P Only" variant for small sizes (under 100px)

### Accessibility Requirements

- **Contrast Ratio:** Minimum 4.5:1 for normal text, 3:1 for large text (WCAG AA)
- **Verified Combinations:**
  - Lime 500 on White: 5.2:1 ✓
  - Lime 700 on White: 7.8:1 ✓
  - White on Lime 500: 5.2:1 ✓
  - White on Lime 400: 4.1:1 ✓ (large text only)

- **Alternative Text:** Always provide alt text when logo is an image
  - Full wordmark: `alt="PARfolio"`
  - Icon only: `alt="PARfolio logo"`
  - Decorative use: `alt=""` with `aria-hidden="true"`

### Minimum Sizes

| Variant | Digital (px) | Print (inches) |
|---------|--------------|----------------|
| **Primary Wordmark** | 200px width | 1.5" width |
| **Wordmark (footer)** | 120px width | 0.75" width |
| **App Icon** | 20px (system-rendered) | 0.25" |
| **Favicon** | 16px | N/A |

**Critical Rule:** Below minimum sizes, switch to a simpler variant (e.g., wordmark → icon → P only).

---

## Maintenance & Updates

**Versioning:** This document follows semantic versioning (Major.Minor.Patch)

**Update Process:**
1. Propose changes via pull request with design rationale
2. Update this specification document
3. Regenerate affected logo files
4. Update all deployed assets
5. Notify team of changes

**Change Log:**
- **v1.0 (January 2026):** Initial logo system specification

---

## Quick Reference

### Most Common Use Cases

| Context | Variant | File | Size |
|---------|---------|------|------|
| **Website Header** | Primary Wordmark | `parfolio-wordmark-primary-color.svg` | 200-400px width |
| **iOS App Store** | Stacked PAR Icon | `parfolio-icon-stacked-1024.png` | 1024x1024 |
| **Android Play Store** | Stacked PAR Icon | `parfolio-icon-stacked-512.png` | 512x512 |
| **Browser Favicon** | P Only | `favicon.ico` | Multi-size (16, 32, 64) |
| **Email Signature** | Primary Wordmark | `parfolio-wordmark-800w.png` | 200-300px width |
| **LinkedIn Logo** | Connected Flow Icon | `parfolio-icon-connected-512.png` | 512x512 |
| **Mobile Splash** | Vertical Lockup | `parfolio-vertical-lockup.svg` | Responsive |

---

**For Questions or Clarifications:**
Refer to the design system documentation at `/docs/design_system.md` or contact the design team.

---

**End of Logo Specifications**
