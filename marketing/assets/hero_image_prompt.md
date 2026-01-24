# Hero Image Generation Reference

This document stores the AI generation prompt used for the processed landscape hero image (`hero_transformation_v4.png`).

## Source Image Specification
- **Prompt:** 
  > Horizontal landscape hero image for a career interview prep app. Shows 4 diverse young professionals in business casual attire, photographed from waist up. Each person stands in their own tall vertical rectangular card with rounded corners. The card backgrounds use LIME GREEN colors, progressively darker from left to right: #dcfce7 (palest), #bef264 (light lime), #84cc16 (medium lime), #65a30d (vibrant lime). People are in desaturated grayscale/sepia style with paper cut-out effect and subtle white outline border. Left person is thinking with a thought bubble containing question marks. Right person speaks confidently with an orange checkmark speech bubble. The overall background MUST be bright pure MAGENTA PINK #FF00FF for easy chroma key removal. Cards are clearly separated with gaps between them, floating on the magenta background. Modern graphic design aesthetic.
- **Reference Model:** Imagen 3 / Gemini Pro Vision

## Post-Processing
The source image was processed using the custom script:
`marketing/process_hero_magenta.py`

This script:
1. Auto-samples the magenta background.
2. Removes it with a soft distance mask for smooth edges.
3. Applies a "despill" to remove purple fringing.
4. Trims excess whitespace.
