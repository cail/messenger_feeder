
class Gen

	def initialize db
		@db = db
		@gens = []
	end	

	def setup (*gens)
		@gens = gens
	end

	def run(chatid, fname)

		# Create a database
		rows = @db.execute <<-SQL
		  SELECT EventInfo.*, Contact.* FROM EventInfo JOIN Contact ON EventInfo.ContactID == Contact.ContactID WHERE ChatID == #{chatid};
		SQL

		f = File.open(fname, "w")

		@gens.each { |g|
			g.gen_head f
		}

		#[-1000..-1]
		(rows).each { |r| 

			@gens.each { |g|
				g.gen_msg(f,r)
			}
		}

		@gens.each { |g|
			g.gen_tail f
		}

	end

end