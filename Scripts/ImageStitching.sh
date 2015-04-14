# Need to download ImageMagick??, ffmpeg
# Install delegates for ImageMagick??
# Make sure resultant videos are placed in "www" folder within the shiny app for use inside shiny

# Create a directory and copy the original images there for manipulation:
cd /Users/maiasmith/Documents/SFU/ClarkeLab/IncuCyte_Sample_Images/
# cd /Users/maiasmith/Documents/SFU/ClarkeLab/ClarkeLab_github/IncuCyte_Images/
# Which images are we stitching to together
ls *.tif
# Remove temp directory & contents if there
rm -rf temp
# Make a new temp directory to hold images to stitch together, copy images to this folder
mkdir temp

### I HAD TO DO MANUAL CONVERSION TO JPG, and RENAMED the files to be "image001.jpg", "image002.jpg", etc........

cp *.jpg temp/.

# Stitch them together into a video
cd ./temp
ffmpeg -r 5 -i image%03d.jpg -c:v libx264 -vf fps=25 -pix_fmt yuv420p video.mp4


# these don't work...
-f image2 -r 25 -i image%03d.tif movie.mpg
ffmpeg -i image%03d.png -c:v huffyuv test.avi


## THIS WORKS

sips -s format pdf A1-1-P_282.tiff --out output.pdf


library("jpeg")
library("tiff")
img <- readTIFF("origin.tiff", native=TRUE)
writeJPEG(img, target = "Converted.jpeg", quality = 1)