from PIL import Image
import sys
import numpy as np

def process_hero(input_path, output_path):
    try:
        print(f"Processing {input_path}...")
        img = Image.open(input_path).convert("RGBA")
        data = np.array(img)
        r, g, b, a = data.T

        # Green Chroma Key (Target: 0, 255, 0)
        # Improved Mask: 
        # heavily penalize green.
        # If Green is significantly higher than Red and Blue, it's background.
        
        # Standard: g > r+20 & g > b+20
        # Aggressive: g > r+10 & g > b+10 & g > 50
        mask = (g > r + 15) & (g > b + 15) & (g > 60)
        
        data[..., 3][mask.T] = 0
        img_transparent = Image.fromarray(data)
        
        # Trim whitespace
        bg = Image.new(img_transparent.mode, img_transparent.size, (0,0,0,0))
        diff = Image.frombytes(img_transparent.mode, img_transparent.size, img_transparent.tobytes())
        bbox = diff.getbbox()
        
        if bbox:
            print(f"Trimming to {bbox}")
            # Add a small padding (e.g., 20px) so it's not tight
            left, upper, right, lower = bbox
            pad = 20
            left = max(0, left - pad)
            upper = max(0, upper - pad)
            right = min(img.width, right + pad)
            lower = min(img.height, lower + pad)
            
            final_img = img_transparent.crop((left, upper, right, lower))
        else:
            final_img = img_transparent
            
        final_img.save(output_path)
        print(f"Saved to {output_path}")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 2:
        process_hero(sys.argv[1], sys.argv[2])
