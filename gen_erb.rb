

class GenERB

	def initialize(db, erbhead, erbmsg, erbtail)
		@db = db

	    @erbhead = ERB.new(File.read(erbhead))
	    @erbmsg = ERB.new(File.read(erbmsg))
	    @erbtail = ERB.new(File.read(erbtail))

	end

	def gen_head f
		f.print @erbhead.result
	end

	def gen_msg(f, r)

		_MessageType = r["MessageType"]
		_EventType = r["EventType"]
		time = Time.at r["TimeStamp"]

		if _EventType == ET_MSG
		    b = binding
			f.print @erbmsg.result b
		end
	end

	def gen_tail f
	end

end

