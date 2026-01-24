# PARfolio Logo Generation Prompts

**Version:** 1.0
**Last Updated:** January 2026
**Purpose:** AI image generation prompts for creating PARfolio logo assets

---

## Table of Contents

1. [General Guidelines](#general-guidelines)
2. [Primary Wordmark Variants](#primary-wordmark-variants)
3. [App Icons (Square 1:1)](#app-icons-square-11)
4. [Favicons & Small Icons](#favicons--small-icons)
5. [Vertical Lockups](#vertical-lockups)
6. [Model-Specific Tips](#model-specific-tips)
7. [Post-Processing Requirements](#post-processing-requirements)

---

## General Guidelines

### Style Foundation

All PARfolio logos follow these core principles:

- **Aesthetic:** Clean, modern, professional with approachable warmth
- **Typography Style:** Classic serif for "PAR" (bold, authoritative), modern sans-serif for "folio" (clean, friendly)
- **Color Philosophy:** Vibrant lime green (#65a30d) representing growth and transformation, amber gold (#f59e0b) for warmth and achievement
- **Form:** Flat design with subtle layering, rounded corners, no complex shadows
- **Avoid:** Gradients (except approved app icon backgrounds), 3D effects, ornate decorations, overly playful styles

### Color Specifications

**Primary Colors:**
- Lime 500: `#65a30d` / `rgb(101, 163, 13)` / Pantone 2292 C
- Lime 400: `#84cc16` / `rgb(132, 204, 22)` / (lighter variant)
- Lime 100: `#ecfccb` / `rgb(236, 252, 203)` / (pale tint)

**Secondary Colors:**
- Amber 500: `#f59e0b` / `rgb(245, 158, 11)` / Pantone 1375 C
- Gray 700: `#374151` / `rgb(55, 65, 81)` / (neutral dark)

**Backgrounds:**
- White: `#ffffff`
- Transparent: For SVG exports

### Typography Notes

- **"PAR"** should appear in a **bold, classical serif font** similar to: Libre Baskerville Bold, Playfair Display Bold, Lora Bold, or Georgia Bold
- **"folio"** should appear in a **clean, semi-bold sans-serif font** similar to: Inter Semi-Bold, Open Sans Semi-Bold, Roboto Medium, or Helvetica Medium
- **Letter spacing:** Natural/default for both (no excessive tracking)
- **Proportion:** "PAR" and "folio" should be the same vertical height

---

## Primary Wordmark Variants

### 1. Full Wordmark with Sunburst Accent (Recommended)

**Aspect Ratio:** 4:1 (horizontal rectangle)
**Resolution:** 4000x1000px (high-res), scale down as needed

**Base Prompt:**
```
Logo wordmark design for "PARfolio". "PAR" in bold serif font (lime green #65a30d), "folio" in semi-bold sans-serif font (dark gray #374151). Golden sunburst sparkle icon replacing the dot on the letter 'i'. Flat modern design, clean professional style, white background. Horizontal layout.
```

**Detailed Prompt:**
```
Professional logo wordmark design. Text: "PARfolio" where "PAR" is displayed in a bold classical serif typeface (similar to Libre Baskerville Bold) in vibrant lime green color (#65a30d hex). "folio" is displayed in a clean semi-bold sans-serif typeface (similar to Inter Semi-Bold) in dark charcoal gray (#374151 hex). Both words are on the same baseline, same vertical height. The dot above the letter 'i' in "folio" is replaced with a decorative golden sunburst icon (#f59e0b hex) - an 8-pointed star/sparkle with radiating lines. Flat design aesthetic, no gradients, no shadows, crisp edges. White background. Professional, modern, approachable. Ultra high resolution, vector-quality appearance. Aspect ratio 4:1.
```

**Negative Prompt:**
```
gradient, 3D effect, shadow, drop shadow, outline, stroke around text, ornate decoration, script font, handwritten, cursive, bubble letters, distortion, skew, rotation, watermark, photographic, textured background, neon, glow effect
```

**Variations to Generate:**

#### 1a. Wordmark with PAR Underline
**Additional Detail:**
```
Include three small rectangular blocks below "PAR" - first block in pale lime (#ecfccb), second in medium lime (#84cc16), third in dark lime (#65a30d). Each block 12px tall, rounded corners, aligned with letters P, A, R respectively.
```

#### 1b. Wordmark with Mic Accent
**Additional Detail:**
```
Replace the sunburst with a minimal microphone icon as the dot on 'i' - simple vertical capsule shape in amber (#f59e0b), small stand line below. Minimalist icon style.
```

#### 1c. Wordmark Minimal (Simple Dot)
**Additional Detail:**
```
Use a simple circular dot above 'i' in amber color (#f59e0b), no decorative elements.
```

---

## App Icons (Square 1:1)

### 2. Stacked PAR Icon (Primary App Icon)

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 2048x2048px (scale to 1024x1024 for iOS)

**Base Prompt:**
```
App icon design, square format. Three white circles stacked vertically with letters P, A, R in bold serif font (lime green). Vibrant lime green gradient background from #65a30d to #84cc16. Modern flat design, professional.
```

**Detailed Prompt:**
```
iOS/Android app icon design, perfect square 1:1 aspect ratio. Background: smooth linear gradient from lime green (#65a30d hex) at top to lighter lime (#84cc16 hex) at bottom. Three circular badges stacked vertically in the center - top circle (white with 95% opacity), middle circle (solid white), bottom circle (white with 95% opacity). Each circle contains a single bold serif letter: top circle has "P", middle has "A", bottom has "R" - all letters in dark lime green (#65a30d hex), Libre Baskerville Bold style. Circles are evenly spaced with small gaps between them. Flat design, no shadows on circles, clean modern aesthetic. The composition should fit within safe zone (80px margin from edges for 1024px canvas). Ultra high resolution, crisp edges.
```

**Negative Prompt:**
```
rounded corners on canvas (OS applies this), transparency, complex shadows, 3D effects, gradients within circles, multiple colors on letters, thin lines, small details, photographic elements, realistic textures, borders
```

### 3. Connected Flow Icon

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 2048x2048px

**Base Prompt:**
```
App icon, square format. Three circles arranged horizontally with connecting lines between them. Letters P, A, R in each circle. Lime green gradient background. Flat modern design.
```

**Detailed Prompt:**
```
Square app icon design (1:1 aspect ratio). Background: vibrant lime green gradient from #65a30d to #84cc16, diagonal from top-left to bottom-right. Three circular elements arranged horizontally across the center: left circle in pale lime (#ecfccb hex), center circle in white (#ffffff), right circle in pale lime (#ecfccb hex). Short connecting lines between circles in white color. Bold serif letters "P" (left), "A" (center), "R" (right) in dark lime green (#65a30d hex for center), darker lime (#4d7c0f hex for outer letters). Flat design, clean and minimal, professional appearance. Safe zone compliant for app icons.
```

**Negative Prompt:**
```
3D, shadows, gradients within circles, ornate designs, thin fonts, small text, photorealistic, texture, noise, borders, rounded square canvas
```

### 4. Circle Badge (PAR in Circle)

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 2048x2048px

**Base Prompt:**
```
App icon, perfect circle with "PAR" text in the center. White circle on lime green gradient background. Bold serif font, clean and simple.
```

**Detailed Prompt:**
```
Minimalist app icon design, square canvas 1:1. Background: lime green gradient (#65a30d to #84cc16). Large white circle (#ffffff) centered, taking up 70% of canvas. Inside the circle: bold serif text "PAR" in dark lime green (#65a30d hex), Libre Baskerville Bold style, centered both horizontally and vertically. Flat design, no shadows, no outlines, clean professional aesthetic. Generous whitespace inside circle around text.
```

**Negative Prompt:**
```
multiple circles, decorative elements, borders, 3D effects, shadows, gradients on text, ornate design, small text
```

### 5. P Monogram

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 2048x2048px

**Base Prompt:**
```
Minimal app icon with large letter "P" in a white circle. Lime green background, small golden sparkle accent. Clean modern design.
```

**Detailed Prompt:**
```
Minimalist monogram app icon, square format. Background: lime green gradient from #65a30d to #84cc16. Large white circle centered, 70% of canvas size. Inside circle: oversized bold serif letter "P" in lime green (#65a30d hex), Libre Baskerville Bold, vertically centered. Small golden sunburst icon (#f59e0b hex) in top-right area of circle - 8-pointed star shape, subtle accent. Flat design, clean, professional, ample negative space.
```

**Negative Prompt:**
```
multiple letters, lowercase, thin fonts, borders, 3D effects, complex decorations, shadows, gradients on letter
```

---

## Favicons & Small Icons

### 6. P Only Favicon

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 512x512px (will scale to 16x16, 32x32, 64x64)

**Base Prompt:**
```
Favicon design, simple letter "P" on solid lime green background. Bold serif font, white color, rounded corners, minimal and legible.
```

**Detailed Prompt:**
```
Favicon icon design for web browser tabs. Perfect square with rounded corners (12px radius at 64px size). Solid lime green background (#65a30d hex). Single bold serif letter "P" in white (#ffffff), Libre Baskerville Bold style, large and centered - letter takes up 60% of canvas height. Maximum legibility optimized for 16x16px rendering. Flat design, no gradients, no shadows, ultra-clean. High contrast for visibility.
```

**Negative Prompt:**
```
multiple letters, small text, thin fonts, gradients, shadows, complex shapes, decorative elements, low contrast
```

**Critical Note:** This design MUST remain legible when scaled to 16x16px. Test at actual size.

### 7. Three Dots Favicon

**Aspect Ratio:** 1:1 (perfect square)
**Resolution:** 512x512px

**Base Prompt:**
```
Favicon design, three dots arranged horizontally on lime green background. Simple, minimal, flat design.
```

**Detailed Prompt:**
```
Minimal favicon icon, square with rounded corners (12px radius). Solid lime green background (#65a30d hex). Three circular dots arranged horizontally across center: left dot in pale lime (#ecfccb), center dot in white, right dot in pale lime. Dots are evenly spaced, each dot is 1/6th of canvas width. Flat design, clean, optimized for small sizes down to 16x16px.
```

**Negative Prompt:**
```
text, letters, gradients, shadows, connecting lines, complex shapes, decorative elements
```

---

## Vertical Lockups

### 8. Icon + Wordmark Stacked

**Aspect Ratio:** 1:1.8 (vertical rectangle)
**Resolution:** 2000x3600px

**Base Prompt:**
```
Vertical logo layout. Three connected circles at top (P, A, R letters), "PARfolio" wordmark stacked below. White background, professional design.
```

**Detailed Prompt:**
```
Vertical logo lockup design for mobile splash screens. Top third: three circles arranged horizontally with connecting lines - circles contain letters P, A, R in bold serif. Middle and bottom: stacked wordmark with "PAR" on one line (bold serif, lime green #65a30d), "folio" on line below (sans-serif, gray #374151). All elements center-aligned. 40px spacing between icon and text. White background. Clean, professional, flat design. Aspect ratio 1:1.8.
```

**Negative Prompt:**
```
horizontal layout, gradients, shadows, decorative borders, photographic elements, 3D effects
```

### 9. Wordmark Only Stacked

**Aspect Ratio:** 1:2 (tall vertical)
**Resolution:** 2000x4000px

**Base Prompt:**
```
Vertical stacked wordmark. "PAR" on top line (bold serif, lime green), "folio" below (sans-serif, gray). White background, tight line spacing.
```

**Detailed Prompt:**
```
Vertical wordmark design. Two lines of text, center-aligned. Top line: "PAR" in bold serif font (Libre Baskerville Bold), lime green color (#65a30d hex), large size. Bottom line: "folio" in semi-bold sans-serif (Inter Semi-Bold), dark gray (#374151 hex), same width as "PAR". Tight line height (1.1), small vertical gap between lines. White background, clean and minimal. Flat design.
```

**Negative Prompt:**
```
horizontal, icons, decorative elements, gradients, shadows, borders
```

---

## Model-Specific Tips

### For Midjourney

**Recommended Parameters:**
```
--style raw --s 50 --q 2 --ar [ratio] --v 6
```

**Prefix to add:**
```
vector logo design, flat illustration, clean professional branding,
```

**Suffix to add:**
```
, white background, high resolution, crisp edges, vector quality --no gradient shadow 3d
```

**Example Full Prompt:**
```
vector logo design, flat illustration, clean professional branding, Logo wordmark design for "PARfolio". "PAR" in bold serif font (lime green #65a30d), "folio" in semi-bold sans-serif font (dark gray #374151). Golden sunburst sparkle icon replacing the dot on the letter 'i'. Flat modern design, clean professional style, white background, high resolution, crisp edges, vector quality --no gradient shadow 3d --style raw --s 50 --q 2 --ar 4:1 --v 6
```

### For DALL-E 3

**Recommended Settings:**
- Quality: HD
- Size: 1024x1024 (square) or 1792x1024 (wide) or 1024x1792 (tall)
- Style: Natural (NOT vivid)

**Prefix to add:**
```
Clean vector logo design, minimalist branding,
```

**Suffix to add:**
```
. Flat design style, professional and modern, white solid background, ultra high resolution, perfect symmetry, crisp clean edges.
```

**Important:** DALL-E may add unwanted artistic elements. Use negative prompts heavily and specify "flat design" multiple times.

### For Stable Diffusion (SDXL)

**Recommended Model:** SDXL 1.0 with "Flat Design" or "Logo Design" LoRA

**Positive Prompt Template:**
```
(logo design:1.4), (flat vector art:1.3), (clean professional branding:1.2), [YOUR PROMPT], white background, (high resolution:1.2), (crisp edges:1.3), (perfect symmetry:1.1), minimalist, modern
```

**Negative Prompt Template:**
```
(gradient:1.4), (shadow:1.4), (3d:1.5), (depth:1.3), (texture:1.3), photorealistic, painting, sketch, drawing, ornate, decorative, complex, busy, cluttered, blurry, low quality, watermark, signature
```

**Settings:**
- Steps: 40-60
- CFG Scale: 7-9
- Sampler: DPM++ 2M Karras or Euler A
- Resolution: 1024x1024 minimum

### For Adobe Firefly

**Style Preset:** Graphic (NOT Art or Photo)
**Content Type:** Design

**Prompt Tips:**
- Lead with "Logo design for..."
- Specify "vector style" and "flat design"
- Mention "brand identity" for more polished results
- Use "clean" and "professional" repeatedly

---

## Post-Processing Requirements

All AI-generated logos MUST go through the following refinement:

### 1. Typography Correction
- ✅ Replace AI-generated text with actual fonts (Libre Baskerville Bold + Inter Semi-Bold)
- ✅ Ensure "PAR" and "folio" are identical heights
- ✅ Verify baseline alignment
- ✅ Confirm proper letter spacing (optical spacing, not mathematical)

### 2. Color Correction
- ✅ Replace approximate colors with exact hex values:
  - Lime 500: `#65a30d`
  - Lime 400: `#84cc16`
  - Lime 100: `#ecfccb`
  - Amber 500: `#f59e0b`
  - Gray 700: `#374151`
  - White: `#ffffff`

### 3. Clean-up
- ✅ Remove any AI artifacts or imperfections
- ✅ Ensure crisp edges (no blur or anti-aliasing issues)
- ✅ Verify perfect symmetry where intended
- ✅ Remove background noise or texture
- ✅ Confirm solid fills (no gradients unless specified for app icons)

### 4. Vector Conversion
- ✅ Convert raster output to SVG using:
  - Adobe Illustrator: Image Trace (High Fidelity Logo preset)
  - Figma: Vectorize plugin
  - Online: vectorizer.ai or svgurt.com
- ✅ Simplify paths for cleaner code
- ✅ Name layers appropriately (e.g., "PAR-text", "folio-text", "sunburst-icon")

### 5. Export Variants
- ✅ Create color variations (white on dark, dark on light)
- ✅ Generate size variations (full, medium, small)
- ✅ Export in required formats (SVG, PNG at 1x, 2x, 3x)

### 6. Quality Checks

**Legibility Test:**
- ✅ Scale down to minimum sizes and verify readability
- ✅ Test on actual devices/contexts (browser tab, phone home screen, etc.)
- ✅ Check grayscale version for sufficient contrast

**Consistency Test:**
- ✅ Compare to design system specifications
- ✅ Verify alignment with other brand elements
- ✅ Ensure matches approved color palette

**Technical Test:**
- ✅ Confirm file sizes are reasonable (SVG < 50KB, PNG < 200KB)
- ✅ Verify no embedded fonts (convert to outlines/paths)
- ✅ Check color mode (RGB for digital, CMYK for print)

---

## Batch Generation Workflow

### Recommended Order

1. **Start with Primary Wordmark** (easiest to get right)
   - Generate 5-10 variations
   - Select best, refine in vector editor
   - Use as reference for other variants

2. **Create App Icons** (Stacked PAR, Connected Flow)
   - Maintain consistency with wordmark colors
   - Test at actual app icon sizes immediately

3. **Generate Favicons** (P Only, Three Dots)
   - Simplest designs
   - Critical to test at 16x16px

4. **Design Vertical Lockups**
   - Combine elements from previous steps
   - May require manual assembly in design software

### Multi-Model Strategy

For best results, generate each logo variant with 2-3 different AI models, then:
1. Compare outputs
2. Select strongest elements from each
3. Combine manually in design software (Figma, Illustrator)
4. Polish to perfection

**Why:** No single AI model excels at all aspects. Midjourney may nail composition, DALL-E may get typography closer, Stable Diffusion may produce cleaner vectors.

---

## Iterative Refinement Prompts

If initial generation isn't perfect, use these refinement prompts:

### To Improve Typography
```
Focus on typography perfection. "PAR" must be in a classical bold serif font exactly matching Libre Baskerville Bold. "folio" must be in a clean sans-serif matching Inter Semi-Bold. Both words must be identical height, perfectly aligned baseline. Professional typographic precision.
```

### To Simplify Design
```
Reduce complexity. Remove all decorative elements except [specify]. Flat design, minimal, clean, simple shapes only. No gradients, no shadows, no textures. Pure vector illustration.
```

### To Adjust Colors
```
Color correction: Use exact hex values - lime green #65a30d for "PAR", charcoal gray #374151 for "folio", amber gold #f59e0b for accent. Solid flat colors, no gradients, no color variations.
```

### To Fix Symmetry
```
Perfect geometric symmetry and alignment. All circles must be perfectly circular. All lines perfectly straight. All spacing mathematically equal. Professional precision.
```

---

## Legal & Usage Notes

**AI-Generated Content:**
- All AI-generated logos are starting points requiring human refinement
- Do NOT use raw AI outputs without post-processing
- Ensure final logos do not infringe on existing trademarks

**Font Licensing:**
- Libre Baskerville: SIL Open Font License (free for commercial use)
- Inter: SIL Open Font License (free for commercial use)
- When converting text to outlines, verify license permits this

**Color Trademarks:**
- Lime green (#65a30d) is not trademarked by PARfolio
- Ensure final colors are unique enough to avoid confusion with competitors

---

## Quick Reference: One-Line Prompts

For rapid prototyping, use these condensed prompts:

| Variant | Quick Prompt |
|---------|--------------|
| **Primary Wordmark** | `Logo: "PARfolio" - "PAR" bold serif lime green #65a30d, "folio" sans-serif gray #374151, sunburst on i, flat design, white bg` |
| **Stacked PAR Icon** | `Square app icon: 3 white circles stacked vertically with P,A,R letters, lime green gradient background, flat design` |
| **Connected Flow** | `Square icon: 3 circles horizontal with P,A,R, connecting lines, lime green background, flat minimal` |
| **P Only Favicon** | `Favicon: bold letter P white on solid lime green #65a30d, rounded square, ultra simple` |
| **Vertical Lockup** | `Vertical logo: 3-dot icon top, "PAR" below, "folio" below that, stacked center-aligned, white bg` |

---

**For Best Results:**
1. Start with detailed prompts
2. Generate multiple variations
3. Iterate based on specific issues
4. Post-process in professional design software
5. Test at actual usage sizes
6. Validate against design system specs

---

**End of Logo Generation Prompts**
