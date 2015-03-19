# Need to download ImageMagick, ffmpeg
# Install delegates for ImageMagick

# Create a directory and copy the original images there for manipulation:
cd /Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/IncuCyte_Images/
# Which images are we stitching to together
ls *.tif
# Remove temp directory & contents if there
rm -rf temp
# Make a new temp directory to hold images to stitch together, copy images to this folder
mkdir temp
cp *.jpg temp/.
# # Rename .tif to .tiff
# cd temp/
# for file in *.tif; do
#   convert *.tif *.jpg
#     # mv "$file" "`basename $file .tif`.tiff"
# done
## Resize the images:
# mogrify -resize 200x200 *.jpg
# Create the morph images
# convert temp/*.jpg -delay 10 -morph 5 temp/%05d.jpg
# Stitch them together into a video
cd ./temp
ffmpeg -r 5 -i image%03d.jpg -c:v libx264 -vf fps=25 -pix_fmt yuv420p video.mp4

-f image2 -r 25 -i image%03d.tif -vcodec libx264 movie.mp4

ffmpeg -r 30 -i "image%03d.tif" -c:v libx264 -crf 23 -pix_fmt yuv420p FeatureTour.mp4