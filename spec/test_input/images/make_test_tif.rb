#!/usr/bin/env ruby

abort "Usage: #{$PROGRAM_NAME} COLOR..." unless ARGV.size > 0

ARGV.each do |color|
  cmd = "convert -size 100x100 xc:#{color} -profile sRGBIEC6196621.icc #{color}.tif"
  system cmd
end
