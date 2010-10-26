require "fileutils"

class NcssRunner

  def process(attchfolder, outfolder)
      Dir.entries(attchfolder).each do |folder|
	      next unless folder =~ /Files-Java-.*/
	      outfile = `basename #{folder}`.split(/-/)[2].chomp
        puts "#{outfolder}/#{outfile}.xml"
        `javancss-32.53/bin/javancss -recursive -all -xml -out #{outfolder}/#{outfile}.xml #{attchfolder}/#{folder}`
      end
  end
  
end

FileUtils.mkpath("out/ncss")
NcssRunner.new.process("../attachments", "out/ncss")
