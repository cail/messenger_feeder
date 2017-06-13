
require 'sqlite3'
require "erb"
require 'pathname'
require 'fileutils'
require 'find'
require 'optparse'

MT_IMG = 0x498
MT_STICKER = 0xC08
MT_VID = 0x618

MT_TEXT = 0x448
MT_TEXT_MY = 0x441
MT_TEXT_rich = 0x800408
MT_TEXT_JOINED = 0x4408
MT_TEXT_REMOVE = 0x200408
MT_TEXT_MEJOINED = 0x4401
# sure?
MT_LIKE = 1024
MT_TEXT_MASK = 0x400

ET_SOMENOTIFY = 0x3
ET_MSG = 0x0

load 'chatinfo.rb'
load 'gen.rb'
load 'gen_erb.rb'
load 'gen_file.rb'


ID=/\w+/
PATH=/.+/
CHAT=/\d+\:\w+/

options = {}
options[:chats] = []

opp = OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-u", "--user USER", "User ID") do |v|
    options[:id] = v
  end
  opts.on("-d", "--db PATH", "DB Path (overrides user id)") do |v|
    options[:db] = v
  end
  opts.on("-c", "--chat CID:OUTNAME", "chat to readout in form chatid:symbolicname") do |v|
    options[:chats] |= []
    options[:chats] << v
  end
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end

opp.parse!

dbpath = "/Users/#{ENV['USER']}/Library/Application Support/ViberPC"

if options[:db]
	dbname = options[:db]
else
	if !options[:id]
		dbname = dbpath + "/*/viber.db"
		dbname = Dir[dbpath+"/*"].select { |f| f =~ /\d{8,}/ }.first + "/viber.db"		
		puts "Autodetected db:\n#{dbname}"
	else
		dbname = dbpath + "/#{options[:id]}/viber.db"
	end
end

if !File.exist?(dbname)
	puts "Cant find Viber DB:\n"
	puts dbname
	puts
	puts opp.help
end

# Open a database
db = SQLite3::Database.new dbname, {:results_as_hash => true}

ci = ChatInfo.new(db)

if options[:chats].length == 0
	puts "Please specify chat id"
	ci.chats.each { |c| 
		print c['ChatID'].to_s + "  " + c["Name"] + "\n"
	}
	puts opp.help
	exit
end

erbpath = "html_templ"
cgen = GenERB.new(@db, erbpath+"/head.erb", erbpath+"/msg.erb", erbpath+"/tail.erb")

fgen = GenFile.new("files")
fgen.verbose = true if options[:verbose]

gen = Gen.new(db)
gen.setup(fgen, cgen)

options[:chats].each { |c|

	cm = /(\d+)(\:(.+))?/.match(c)

	cid = cm[1]
	cname = cm[3] || "chat_"+cid

	puts "Generating " + cid + " " + cname
    gen.run(cid, cname+".html")

}

#gen.run(77, "np_xxx.html")
#gen.run(85, "np_boltalka.html")
#gen.run(87, "np_baraholka.html")
