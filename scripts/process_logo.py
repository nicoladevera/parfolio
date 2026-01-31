import os
from PIL import Image, ImageChops

def trim(im):
    bg = Image.new(im.mode, im.size, im.getpixel((0,0)))
    diff = ImageChops.difference(im, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return im.crop(bbox)
    return im

def remove_background(img, threshold=240):
    img = img.convert("RGBA")
    datas = img.getdata()

    new_data = []
    for item in datas:
        # If the pixel is very bright (near white), make it transparent
        if item[0] > threshold and item[1] > threshold and item[2] > threshold:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)

    img.putdata(new_data)
    return img

def main():
    input_path = "/Users/nicoladevera/.gemini/antigravity/brain/41b5621c-dcb5-4e11-9880-9f569938169c/uploaded_media_1769869043240.png"
    output_dir = "/Users/nicoladevera/Developer/parfolio/assets/logos/wordmark/png"
    output_path = os.path.join(output_dir, "parfolio-wordmark-nav.png")

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    print(f"Loading image from {input_path}...")
    img = Image.open(input_path)
    
    # First remove background to ensure we don't include it in the crop calculation if it's not perfectly uniform
    print("Removing white background...")
    img = remove_background(img)
    
    # Then trim whitespace
    print("Trimming whitespace...")
    # For RGBA images with transparency, we can trim based on the alpha channel
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
    
    print(f"Saving processed logo to {output_path}...")
    img.save(output_path, "PNG")
    print("Done!")

if __name__ == "__main__":
    main()
