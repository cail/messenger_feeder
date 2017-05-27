require 'ostruct'

class ChatInfo

	def initialize(db)
		@db = db
	end

	def chats
		chats = @db.execute <<-SQL
		  SELECT * FROM ChatInfo;
		SQL
		chats.each { |c|
			ccontacts = @db.execute %{
				SELECT ChatRelation.*, Contact.* FROM ChatRelation 
				   JOIN Contact ON ChatRelation.ContactID == Contact.ContactID
				   WHERE ChatID == #{c["ChatID"]}
			}
			c["Contacts"] = ccontacts
			
			if c["Name"].length == 0
				c["Name"] = ccontacts.map { |cc| cc["ClientName"] }.join(', ')
			end

		}
		chats
	end

end