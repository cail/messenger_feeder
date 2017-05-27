
require 'sqlite3'
require "erb"
require 'pathname'
require 'fileutils'

load 'chatinfo.rb'
load 'gen.rb'
load 'gen_erb.rb'
load 'gen_file.rb'

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

dbname = "/Users/igor//Library/Application Support/ViberPC/79200302232/viber.db"

# Open a database
db = SQLite3::Database.new dbname, {:results_as_hash => true}

ci = ChatInfo.new(db)

ci.chats.each { |c| 
	print c['ChatID'].to_s + "  " + c["Name"] + "\n"
}

chatid = 77

erbpath = "html_templ"
cgen = GenERB.new(@db, erbpath+"/head.erb", erbpath+"/msg.erb", erbpath+"/tail.erb")
fgen = GenFile.new("files#{chatid}")

gen = Gen.new(db)
gen.setup(fgen, cgen)
gen.run(77, "np_xxx.html")
#gen.run(85, "np_boltalka.html")
#gen.run(87, "np_baraholka.html")
