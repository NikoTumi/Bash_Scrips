#!/bin/bash

# Prompt the user for the input image path
zenity --file-selection --title="Select an image file" --file-filter='*.png *.jpg *.jpeg' > /tmp/input_image_path.txt
input_image_path=$(cat /tmp/input_image_path.txt)
echo "Input image path: $input_image_path"

# Set the output image path
output_image_path="${input_image_path%.*}_icon.png"
echo "Output image path: $output_image_path"

# Image dimensions
image_dimensions="256x256"
echo "Image dimensions: $image_dimensions"

# Corner radius
corner_radius="20"
echo "Corner radius: $corner_radius"

# Create a mask with rounded corners
mask=$(convert -size $image_dimensions xc:none -draw "roundrectangle 0,0,$image_dimensions,$corner_radius,$corner_radius" png:- | tr -d '\0')

# Round the corners of the input image
convert $input_image_path \
-resize $image_dimensions \
png:- > $output_image_path

convert \
-size $image_dimensions xc:none \
-fill white \
-draw 'roundRectangle 0,0 256,256 35,35' $output_image_path \
-compose SrcIn \
-composite $output_image_path

echo "The output image has been saved to $output_image_path"

