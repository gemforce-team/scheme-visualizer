def init
	@tree = nil
end

def event i, v
	scheme_parse v.chomp.split.join if i == "source"
end

def scheme_parse source
	if not valid? source
		messageBox 1, 	"You have to provide a valid spec or comb scheme as found in GemForce's recipes.\n" +
						"Take care that\n\t" +
						"-the parentheses are balanced\n\t" +
						"-no other characters are used than b,k,m,o,r,y,(,),+\n\t" +
						"-no redundant characters exist", "Invalid Scheme", "okexclaimationdefbutton1"
		return
	end
	
	output "valid", source
	
	@tree = Fork.new
	@tree.me = source
	
	watch "node", @tree.node(64).me + ", " + @tree.node(31).layer.to_s
end

def valid? source
	pos, neg, add = 0, 0, 0
	source.each_char do |c|
		if c == "("
			pos += 1
		elsif c == ")"
			neg += 1
		elsif c == "+"
			add += 1
		end
	end
	if pos - neg == 0
		if not source.match /[\-\*\/]|[^bkmory1-9\(\)\+]|\+{2,}/
			return true if pos == add
		end
	else
		return false
	end
end
