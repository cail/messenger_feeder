class GenFile

	def initialize(dir)
		@dir = dir || "files"
		@verbose = false
		begin
			FileUtils.mkdir @dir
		rescue
		end
	end

	def verbose=(v)
		@verbose = v
	end

	def get_file(f)
		fname = Pathname.new(f).basename.to_s		
		tgt = @dir + "/" + fname
		if File.exist? tgt
			puts "     SKIPPIN #{tgt}" if @verbose
			return tgt
		end
		puts "COPY #{f} #{tgt}" if @verbose
		begin
			FileUtils.cp f, tgt
		rescue
		end
		return tgt
	end


	def gen_head f
	end

	def gen_msg(f, r)
		if r["PayloadPath"]
			r["PayloadPath"] = get_file(r["PayloadPath"])
		end
		if r["ThumbnailPath"]
			r["ThumbnailPath"] = get_file(r["ThumbnailPath"])
		end
	end

	def gen_tail f
	end

end
