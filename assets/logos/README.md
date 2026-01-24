# PARfolio Logo Assets

**Quick reference guide for using PARfolio logos.**

For complete specifications, see [`logo_specifications.md`](./logo_specifications.md).
For AI generation prompts, see [`logo_generation_prompts.md`](./logo_generation_prompts.md).

---

## Directory Structure

```
assets/logos/
├── README.md                           ← You are here
├── logo_specifications.md              ← Complete usage guidelines
├── logo_generation_prompts.md          ← AI prompts for generating logos
├── logo_wordmark_refined.html          ← Interactive mockups (open in browser)
├── wordmark/
│   ├── svg/                            ← Vector wordmarks (primary format)
│   └── png/                            ← Raster wordmarks (web, email)
├── icons/
│   ├── app/                            ← App icons (iOS, Android, desktop)
│   └── favicon/                        ← Web favicons (16px-256px)
└── lockup/                             ← Vertical lockups (mobile, posters)
```

---

## Quick Selection Guide

**"Which logo file should I use?"**

| Context | File to Use | Location |
|---------|-------------|----------|
| **Website Header** | Primary Wordmark (SVG) | `wordmark/svg/parfolio-wordmark-primary-color.svg` |
| **Website Favicon** | P Only (16x16, 32x32) | `icons/favicon/favicon.ico` |
| **iOS App Store** | Stacked PAR (1024x1024) | `icons/app/parfolio-icon-stacked-1024.png` |
| **Android Play Store** | Stacked PAR (512x512) | `icons/app/parfolio-icon-stacked-512.png` |
| **Email Signature** | Primary Wordmark (PNG) | `wordmark/png/parfolio-wordmark-800w.png` |
| **LinkedIn Profile** | Connected Flow (512x512) | `icons/app/parfolio-icon-connected-512.png` |
| **Mobile Splash Screen** | Vertical Lockup (SVG) | `lockup/parfolio-vertical-lockup.svg` |
| **Presentation Slide** | Primary Wordmark (SVG/PNG) | `wordmark/svg/parfolio-wordmark-primary-color.svg` |

---

## File Naming Convention

All logo files follow this pattern:
```
parfolio-[variant]-[size]-[color].ext
```

### Examples:
- `parfolio-wordmark-primary-color.svg` - Primary full wordmark on light backgrounds
- `parfolio-wordmark-primary-white.svg` - Primary wordmark for dark backgrounds
- `parfolio-icon-stacked-1024.png` - Stacked PAR app icon for iOS
- `parfolio-favicon-16.png` - 16x16 favicon

---

## Logo Variants

### 1. Primary Wordmark (Horizontal)

**"PARfolio"** - Full text logo with sunburst accent on 'i'

- **Colors:** "PAR" (Lime 500 #65a30d), "folio" (Gray 700 #374151)
- **Use for:** Headers, landing pages, marketing materials
- **Min Width:** 200px digital / 1.5" print
- **Formats:** SVG (preferred), PNG

**Color Variations:**
- `*-color.svg` - Standard (lime + gray on white)
- `*-white.svg` - All white on dark backgrounds
- `*-dark-mode.svg` - Lime 400 + white on dark
- `*-monochrome.svg` - Black only for print

### 2. App Icons (Square)

**Stacked PAR** (Recommended Primary)
- Three circles vertically with P, A, R letters
- Lime gradient background
- Use for: iOS/Android app icons

**Connected Flow** (Alternative)
- Three circles horizontally with connecting lines
- Use for: Social media profiles

**Circle Badge**
- "PAR" text in white circle
- Use for: Badges, simplified contexts

**P Monogram**
- Single "P" letter with sunburst accent
- Use for: Watermarks, ultra-minimal

### 3. Favicons

**P Only** (Recommended)
- Simple "P" on lime square
- Most legible at tiny sizes (16x16)

**Three Dots** (Alternative)
- Three horizontal dots
- Use when consistency with "Connected Flow" icon needed

### 4. Vertical Lockup

**Icon + Wordmark Stacked**
- Connected flow icon above "PAR" / "folio" text
- Use for: Mobile splash screens, vertical posters

**Wordmark Only Stacked**
- "PAR" above "folio" (no icon)
- Use for: Vertical spaces without room for icon

---

## Color Reference

| Color | Hex | RGB | Usage |
|-------|-----|-----|-------|
| **Lime 500** | `#65a30d` | rgb(101, 163, 13) | Primary brand (PAR text) |
| **Lime 400** | `#84cc16` | rgb(132, 204, 22) | Dark mode, gradients |
| **Lime 700** | `#4d7c0f` | rgb(77, 124, 15) | On light backgrounds |
| **Amber 500** | `#f59e0b` | rgb(245, 158, 11) | Sunburst accent |
| **Gray 700** | `#374151` | rgb(55, 65, 81) | "folio" text |
| **White** | `#ffffff` | rgb(255, 255, 255) | Reversed text |

---

## Required File Exports

When generating new logo assets, ensure these files exist:

### Wordmark (Horizontal)
- [ ] `wordmark/svg/parfolio-wordmark-primary-color.svg`
- [ ] `wordmark/svg/parfolio-wordmark-primary-white.svg`
- [ ] `wordmark/svg/parfolio-wordmark-dark-mode.svg`
- [ ] `wordmark/svg/parfolio-wordmark-monochrome.svg`
- [ ] `wordmark/png/parfolio-wordmark-1200w.png` (for high-res displays)
- [ ] `wordmark/png/parfolio-wordmark-800w.png` (for email signatures)
- [ ] `wordmark/png/parfolio-wordmark-400w.png` (for standard web)

### App Icons
- [ ] `icons/app/parfolio-icon-stacked-1024.png` (iOS App Store)
- [ ] `icons/app/parfolio-icon-stacked-512.png` (Android Play Store)
- [ ] `icons/app/parfolio-icon-connected-512.png` (Social media alternative)
- [ ] `icons/app/parfolio-icon-circle-512.png` (Badge variant)
- [ ] `icons/app/parfolio-icon-p-mono-512.png` (Monogram variant)

### Favicons
- [ ] `icons/favicon/favicon.ico` (multi-size: 16, 32, 64)
- [ ] `icons/favicon/favicon-16x16.png`
- [ ] `icons/favicon/favicon-32x32.png`
- [ ] `icons/favicon/favicon-64x64.png`
- [ ] `icons/favicon/apple-touch-icon.png` (180x180 for iOS)

### Lockups
- [ ] `lockup/parfolio-vertical-lockup.svg`
- [ ] `lockup/parfolio-vertical-lockup.png` (1000x1800 or similar)

---

## Usage Rules (Quick Version)

### ✅ Do:
- Use approved color combinations (see color reference)
- Maintain aspect ratio when resizing
- Keep minimum 32px clear space around logo
- Use SVG format whenever possible
- Test legibility at intended size

### ❌ Don't:
- Skew, rotate, or distort the logo
- Use off-brand colors (no blue, pink, purple)
- Add shadows, gradients, or effects
- Rearrange "PAR" and "folio"
- Use wordmark as favicon (too small)
- Recreate logo in other software (use official files)

---

## Minimum Sizes

| Variant | Digital | Print |
|---------|---------|-------|
| Primary Wordmark | 200px width | 1.5" width |
| Wordmark (footer) | 120px width | 0.75" width |
| App Icon | 20px (system) | 0.25" |
| Favicon | 16px | N/A |

**Below minimum size?** Switch to a simpler variant (wordmark → icon → P only).

---

## Generating New Logos

### Method 1: AI Generation (Starting Point)

Use the prompts in [`logo_generation_prompts.md`](./logo_generation_prompts.md) with:
- Midjourney (best composition)
- DALL-E 3 (good typography)
- Stable Diffusion SDXL (clean vectors)
- Adobe Firefly (polished results)

**CRITICAL:** AI outputs require post-processing:
1. Replace AI text with real fonts (Libre Baskerville + Inter)
2. Correct colors to exact hex values
3. Clean up artifacts and imperfections
4. Convert to vector (SVG)
5. Test at actual usage sizes

### Method 2: Manual Design (Recommended for Final Assets)

Use design software with official fonts:
1. **Fonts Required:**
   - Libre Baskerville Bold (for "PAR")
   - Inter Semi-Bold (for "folio")
   - Both are free (SIL Open Font License)

2. **Design Software:**
   - Figma (recommended, web-based)
   - Adobe Illustrator
   - Sketch (macOS only)
   - Inkscape (free, open-source)

3. **Follow Specifications:**
   - Reference `logo_specifications.md` for exact measurements
   - Use mockup file `logo_wordmark_refined.html` as visual guide
   - Match colors exactly (no approximations)

---

## Testing Checklist

Before deploying any logo file:

- [ ] **Legibility:** Readable at minimum size?
- [ ] **Colors:** Match exact hex values?
- [ ] **Typography:** Using correct fonts (or converted to outlines)?
- [ ] **Format:** SVG for web, PNG at 2x-3x for retina displays?
- [ ] **File Size:** Reasonable (SVG < 50KB, PNG < 200KB)?
- [ ] **Accessibility:** Sufficient contrast (WCAG AA: 4.5:1 for text)?
- [ ] **Context Test:** Looks good on actual device/platform?

---

## Quick Decision Tree

**Can't decide which logo to use? Ask yourself:**

1. **Is it smaller than 100px wide?**
   - YES → Use icon or favicon variant
   - NO → Continue to #2

2. **Is it a square space?**
   - YES → Use app icon (Stacked PAR or Connected Flow)
   - NO → Continue to #3

3. **Is it a vertical layout?**
   - YES → Use vertical lockup
   - NO → Continue to #4

4. **Is it for web/digital?**
   - YES → Use primary wordmark (SVG)
   - NO → Continue to #5

5. **Is it for print?**
   - YES → Use primary wordmark (PDF/EPS for vector, PNG at 300 DPI for raster)
   - NO → You probably need the primary wordmark anyway

**Still not sure?** See full decision tree in `logo_specifications.md`.

---

## Resources

- **Design System:** `/docs/design_system.md`
- **Full Logo Specs:** `./logo_specifications.md`
- **AI Generation Prompts:** `./logo_generation_prompts.md`
- **Interactive Mockups:** `./logo_wordmark_refined.html` (open in browser)

---

## Support

**Need a logo variant that doesn't exist?**
1. Check if it's in the specification (maybe just not generated yet)
2. Use AI generation prompts to create starting point
3. Post-process following guidelines in `logo_generation_prompts.md`
4. Add to appropriate folder with proper naming convention

**Found an issue with existing logos?**
- Verify against `logo_specifications.md`
- Regenerate following proper process
- Update this README if specifications changed

---

**Last Updated:** January 2026
**Version:** 1.0
**Maintainer:** PARfolio Design Team
