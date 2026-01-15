from PIL import Image
import numpy as np
import sys

def process_magenta_screen(input_path, output_path):
    """
    Robustly removes magenta background and eliminates purple fringing.
    """
    try:
        # Load image and ensure it's RGBA
        img = Image.open(input_path).convert("RGBA")
        data = np.array(img, dtype=float)
        
        # Target color is pure magenta (255, 0, 255)
        # We also sample the top-left pixel in case the magenta isn't perfectly pure
        sampled_bg = data[0, 0, :3]
        print(f"Sampled BG color: {sampled_bg}")
        
        # Calculate distance from background color in RGB space
        rgb = data[..., :3]
        dist = np.linalg.norm(rgb - sampled_bg, axis=-1)
        
        # Thresholds for alpha channel ramp
        # Increased inner threshold to be more aggressive with background removal
        inner_threshold = 70.0  
        outer_threshold = 130.0
        
        # Create soft alpha mask using distance
        alpha = np.clip((dist - inner_threshold) / (outer_threshold - inner_threshold), 0, 1)
        
        # Apply soft alpha to the existing alpha channel
        data[..., 3] *= alpha
        
        # Despill: Remove magenta and white/gray influence from the edges
        # We also limit the brightness of pixels that are nearly white/gray at the edges
        r, g, b = data[..., 0], data[..., 1], data[..., 2]
        
        # Aggressive despill and halo removal
        despill_mask = (alpha < 0.95)
        
        # Clamp Red, Green, and Blue to remove bright edge halos
        # If it's an edge pixel, we want it to blend into the darkness/background
        r[despill_mask] = np.minimum(r[despill_mask], g[despill_mask] + 10)
        b[despill_mask] = np.minimum(b[despill_mask], g[despill_mask] + 10)
        # Also limit overall brightness at the edge to avoid "white" glow
        data[despill_mask, :3] *= 0.8 

        
        # Convert back to uint8
        result_data = np.clip(data, 0, 255).astype(np.uint8)
        result_img = Image.fromarray(result_data)
        
        # Trim whitespace automatically
        bbox = result_img.getbbox()
        if bbox:
            # Add 20px padding for safety
            left, upper, right, lower = bbox
            pad = 20
            result_img = result_img.crop((
                max(0, left - pad),
                max(0, upper - pad),
                min(img.width, right + pad),
                min(img.height, lower + pad)
            ))
        
        result_img.save(output_path)
        print(f"Successfully saved clean hero image to {output_path}")

    except Exception as e:
        print(f"Error processing image: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python process_hero_magenta.py <input_path> <output_path>")
    else:
        process_magenta_screen(sys.argv[1], sys.argv[2])
