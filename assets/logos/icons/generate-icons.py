#!/usr/bin/env python3
"""
Generate PARfolio icons and favicons from source image.
Trims whitespace, adds padding, and creates multiple sizes.
"""

import os
import sys
from PIL import Image, ImageChops

def trim_whitespace(image, border_percent=10):
    """
    Trim whitespace from image and add padding.

    Args:
        image: PIL Image object
        border_percent: Percentage of image size to add as padding
    """
    # Convert to RGBA if not already
    if image.mode != 'RGBA':
        image = image.convert('RGBA')

    # Get the bounding box of non-white pixels
    # Create a white background
    bg = Image.new('RGBA', image.size, (255, 255, 255, 255))
    diff = ImageChops.difference(image, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()

    if bbox:
        # Crop to content
        image = image.crop(bbox)

        # Calculate padding
        width, height = image.size
        max_dim = max(width, height)
        padding = int(max_dim * border_percent / 100)

        # Create new image with padding (make it square)
        new_size = max_dim + (padding * 2)
        new_image = Image.new('RGBA', (new_size, new_size), (255, 255, 255, 0))

        # Calculate position to center the content
        x = (new_size - width) // 2
        y = (new_size - height) // 2

        new_image.paste(image, (x, y), image)
        return new_image

    return image

def generate_icon_sizes(source_path, output_dir):
    """
    Generate various icon sizes from source image.

    Args:
        source_path: Path to source image
        output_dir: Directory to save generated icons
    """
    # Icon sizes to generate
    sizes = {
        'favicon-16x16.png': 16,
        'favicon-32x32.png': 32,
        'favicon-48x48.png': 48,
        'favicon-64x64.png': 64,
        'icon-128x128.png': 128,
        'apple-touch-icon.png': 180,  # Apple touch icon
        'icon-192x192.png': 192,       # Android
        'icon-512x512.png': 512,       # High-res
        'icon-1024x1024.png': 1024,    # Original trimmed
    }

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Load and process source image
    print(f"Loading image: {source_path}")
    img = Image.open(source_path)

    # Trim whitespace and add padding
    print("Trimming whitespace and adding padding...")
    trimmed = trim_whitespace(img, border_percent=8)

    # Save trimmed version
    trimmed_path = os.path.join(output_dir, 'icon-original-trimmed.png')
    trimmed.save(trimmed_path, 'PNG', quality=100)
    print(f"Saved: {trimmed_path}")

    # Generate all sizes
    print("\nGenerating icon sizes:")
    for filename, size in sizes.items():
        output_path = os.path.join(output_dir, filename)

        # Resize with high-quality resampling
        resized = trimmed.resize((size, size), Image.Resampling.LANCZOS)

        # Save as PNG
        resized.save(output_path, 'PNG', quality=100)
        print(f"  ✓ {filename} ({size}x{size})")

    # Generate multi-size favicon.ico
    print("\nGenerating favicon.ico...")
    favicon_sizes = [(16, 16), (32, 32), (48, 48)]
    favicon_images = []

    for size in favicon_sizes:
        resized = trimmed.resize(size, Image.Resampling.LANCZOS)
        favicon_images.append(resized)

    favicon_path = os.path.join(output_dir, 'favicon.ico')
    favicon_images[0].save(
        favicon_path,
        format='ICO',
        sizes=favicon_sizes,
        append_images=favicon_images[1:]
    )
    print(f"  ✓ favicon.ico (multi-size)")

    print(f"\n✅ All icons generated successfully in: {output_dir}")
    print(f"\nGenerated {len(sizes) + 1} PNG files + 1 ICO file")

if __name__ == '__main__':
    # Source image path
    source = '/Users/nicoladevera/Downloads/Gemini_Generated_Image_erfr9nerfr9nerfr.png'

    # Output directory
    output = '/Users/nicoladevera/Developer/parfolio/assets/logos/icons'

    # Check if source exists
    if not os.path.exists(source):
        print(f"❌ Error: Source image not found: {source}")
        sys.exit(1)

    # Generate icons
    generate_icon_sizes(source, output)
