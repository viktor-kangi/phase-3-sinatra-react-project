require 'rmagick'

# Load the meme image
image = Magick::Image.read("meme.jpg").first

# Resize the image to a specific width and height
width = 400
height = 400
image.resize_to_fit!(width, height)

# Write the image to a file (optional)
image.write("resized_meme.jpg")

# Display the image on a web page
puts "<img src='resized_meme.jpg' alt='Meme'>"
