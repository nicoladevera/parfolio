from PIL import Image, ImageOps
import sys
import os

def get_bbox_with_threshold(img, threshold=20):
    """
    Returns a bounding box for the image where the alpha channel 
    is greater than the given threshold.
    """
    alpha = img.split()[-1]
    # Create a binary mask: 255 if alpha > threshold, else 0
    mask = Image.eval(alpha, lambda a: 255 if a > threshold else 0)
    return mask.getbbox()

def process_image(input_path, output_path, angle=-5, threshold=20, padding=60):
    try:
        print(f"Opening image: {input_path}")
        img = Image.open(input_path)
        
        # Ensure RGBA
        img = img.convert("RGBA")
        
        # 1. Initial crop with threshold
        bbox = get_bbox_with_threshold(img, threshold)
        if bbox:
            print(f"Original bbox (threshold={threshold}): {bbox}")
            img = img.crop(bbox)
        else:
            print("Warning: No content found above threshold!")

        # 2. Tilt (Rotate)
        print(f"Rotating by {angle} degrees...")
        img = img.rotate(angle, expand=True, resample=Image.BICUBIC)
        
        # 3. Final crop with threshold
        bbox = get_bbox_with_threshold(img, threshold)
        if bbox:
            print(f"Post-rotation bbox (threshold={threshold}): {bbox}")
            img = img.crop(bbox)
        
        # 4. Add Padding (to prevent "humongous" look in fixed-width containers)
        if padding > 0:
            print(f"Adding padding: {padding}px")
            # Create new image with specific padding
            new_width = img.width + (2 * padding)
            new_height = img.height + (2 * padding)
            padded_img = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))
            # Paste centered
            padded_img.paste(img, (padding, padding))
            img = padded_img
            
        img.save(output_path)
        print(f"Successfully saved processed image to {output_path}")
        
    except Exception as e:
        print(f"Error processing image: {e}")
        sys.exit(1)

if __name__ == "__main__":
    base_dir = os.getcwd()
    input_file = os.path.join(base_dir, 'marketing/assets/hero_phone_v4.png')
    # Output v12
    output_file = os.path.join(base_dir, 'marketing/assets/hero_phone_v12.png')
    
    # Threshold 5 (trim faint artifacts <2% opacity), Padding 80 (Approved size)
    process_image(input_file, output_file, angle=-5, threshold=5, padding=80)
