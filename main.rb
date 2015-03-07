def init
	@tree = nil
end

def event i, v
	scheme_parse v.chomp.split.join if i == "source"
end

def scheme_parse source
	if not valid? source
		messageBox 1, "Invalid Scheme\n\nTake care that the parentheses are balanced.", "Caution", "okcancelexclaimationdefbutton1"
		return
	end
	
	@tree = Fork.new
	@tree.me = source
	
	watch "last", @tree.left(4).is_last?
	watch "value", @tree.left(4).me
	#watch "right", tree.left(0).right.me
	#watch "layer", tree.left(0).layer
end

def valid? source
	pos, neg = 0, 0
	source.each_char do |c|
		if c == "("
			pos += 1
		elsif c == ")"
			neg += 1
		end
	end
	if pos - neg == 0
		return true
	else
		return false
	end
end
