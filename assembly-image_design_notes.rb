require 'assembly-image'


module Assembly
  class Image

  end
end

img = Assembly::Image.new(
  # User arguments and params.
  IMAGE_FILE_PATH,

  # Computed items.
  exif   => MiniExiftool,
  pixdem => N,
  layers => N,
)

e = img.load_exif

puts img.exif.imageheight
puts e.imageheigt

jp2_img = img.create_jp2(
  output_jp2        => 'foo/blah.jp2',  # Default: input filename with jp2 extension.
  overwrite         => true,            # Default: false.
  output_profile    => 'foo/xxx.icc',   # Default: see code.
  preserve_tmp_tiff => true,            # Default: false.
)
