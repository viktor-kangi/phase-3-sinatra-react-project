class ApplicationController < Sinatra::Base
  require 'rmagick'

  # Generate a meme
  post '/meme' do
    # Get the meme image file from the request
    meme_file = params[:image]

    # Read the meme image file and add the top and bottom text
    image = Magick::Image.read(meme_file.tempfile.path).first
    top_text = params[:top_text] || ''
    bottom_text = params[:bottom_text] || ''
    draw = Magick::Draw.new
    draw.annotate(image, 0,0,0,0, top_text) {
      self.gravity = Magick::NorthGravity
      self.fill = 'white'
      self.stroke = 'black'
      self.stroke_width = 2
      self.pointsize = 30
      self.font_family = 'Arial'
    }
    draw.annotate(image, 0,0,0,0, bottom_text) {
      self.gravity = Magick::SouthGravity
      self.fill = 'white'
      self.stroke = 'black'
      self.stroke_width = 2
      self.pointsize = 30
      self.font_family = 'Arial'
    }

    # Save the generated meme to a file
    meme_path = 'path/to/generated/meme.jpg'
    image.write(meme_path)

    # Return the path to the generated meme
    { meme_path: meme_path }.to_json
  end
end
