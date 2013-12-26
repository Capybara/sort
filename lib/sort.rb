#!/usr/bin/env ruby
# encoding: UTF-8
# Written by: j on 12-23-2013 
# ruby 2.0.0p353
require 'fileutils'

# test arguments for trailing '/', emptiness and validity
class CheckInput
  attr_reader :dir
  def initialize
    if ARGV.empty?
      @dir = Dir.pwd
    else
      @dir=ARGV[0]
    end
    @dir += '/' unless @dir[-1] == '/'
    unless Dir.exist?(@dir)
      return puts "#{@dir} is not a valid directory"
      abort
    end
  end
end

EXTENSTIONS = { Archives: ['zip','gz','tar','bz'], GPG: ['gpg'], Apps: ['app'], Books: ['pdf','epub','mobi'], Images: ['jpeg','jpg','png','gif','tiff'], Ruby: ['rb'], Shell: ['sh'], Python: ['py'], Javascript: ['js'], HTML: ['html'], Text: ['txt'] }
class Clean
  attr_reader :files_moved
    def initialize
      @files_moved = 0
    end
  def sort(dir='./', files_older=10)
        EXTENSTIONS.each do |type,extens|
        key = type.to_s
        extens.each do |ext|
          query = dir + '*.' + ext
          Dir.glob(query) do |s|
            if File.mtime(s) < (Time.now - (files_older))
              unless s.include?("#{File.basename($0)}")
                FileUtils.mkdir_p "#{dir + key}"
                begin
                  FileUtils.mv( s, "#{dir + key}/" )
                  @files_moved += 1
                rescue Exception => e
                  puts "couldn't move #{s}"
                  puts "#{e}"
                end
              end
            end
          end
        end
      end
  end
end
