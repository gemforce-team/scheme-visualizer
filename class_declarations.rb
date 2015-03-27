class Fork
	@@id = []
	def initialize layer = 0, id = 0, reset = false
		@@id = [] if reset
		@layer = layer
		if @@id[@layer] == nil
			@@id[@layer] = 0
		else
			@@id[@layer] += 1
		end
		
		@me = ""
		@left = nil
		@right = nil
		@last = 0
		@id = id
		@test = []
		@value = 0
	end
	
	attr_reader :id
	attr_accessor :value, :x, :y, :from
	
	def layer
		return @layer
	end
	
	def me= source
		@me = disclose source
		split @me
	end
	
	def me
		return @me
	end
	
	def left layer = @layer
		if layer == @layer
			return @left
		else
			return @left.left layer
		end
	end
	
	def right layer = @layer
		if layer == @layer
			return @right
		else
			return @right.right layer
		end
	end
	
	def is_last?
		if @last == 1
			return true
		else
			return false
		end
	end
	
	def last
		@test = []
		if @last == 1
			@test << @layer
		else
			@test << @left.last
			@test << @right.last
		end
		return @test.flatten.max
	end
	
	def flatten
		if @layer != last
			return [self, left.flatten, right.flatten]
		else
			return [self]
		end
	end
	
	def disclose source
		start, stop, state, count = 0, 0, 0, 0
		result = ""
	
		source.each_char.with_index do |c, i|
			if c == "("
				count += 1
			elsif c == ")"
				count -= 1
			end
			if count == 0
				if i + 1 == source.length
					stop = i - 1
				else
					break
				end
			end
		end
	
		if count == 0 and stop > 0
			result = source[1..stop]
			if result.start_with? "(" and result.end_with? ")"
				result = disclose result
			end
		else
			result = source
		end
	
		return result
	end

	def find_closing source
		count = 0
	
		source.each_char.with_index do |c, i|
			if c == "("
				count += 1
			elsif c == ")"
				count -= 1
			end
			if count == 0
				return i
			end
		end
	end

	def split source
		offset, id = 0, 0
		left, right = "", ""
		
		if source.start_with? "("
			offset = find_closing source
			left = disclose source[0..offset]
			right = disclose source[(offset + 2)..(source.length - 1)]
			
			@left = Fork.new @layer + 1, @id * 2
			@left.me = left
			@right = Fork.new @layer + 1, @id * 2 + 1
			@right.me = right
			@left.from = @right.from = self
		elsif source.include? "+"
			@left = Fork.new @layer + 1, @id * 2
			@right = Fork.new @layer + 1, @id * 2 + 1
			@left.me, @right.me = source.split("+", 2)
			@left.from = @right.from = self
		elsif source.match /[1-9]/
			@left = Fork.new @layer + 1, @id * 2
			@right = Fork.new @layer + 1, @id * 2 + 1
			offset = source.to_i - 1
			@left.me = @right.me = if offset == 1 then "" else offset.to_s end + $'
			@left.from = @right.from = self
		else
			@value = 1
			@last = 1
		end
	end
	
	def calc
		node = self
		
		if node.value == 0
			if node.is_last?
				return 1
			else
				lv = node.left.calc
				rv = node.right.calc
				if lv == nil and rv == nil
					node.value = 1
					return node.value
				elsif lv == rv
					node.value = lv + 1
					return node.value
				else
					node.value = [lv, rv].max
					return node.value
				end
			end
		else
			return node.value
		end
	end
	
	def to_s
		return "<" + @me + ":" + @layer.to_s + ":" + @id.to_s + ":" + @value.to_s + ">"
	end
end

class Node
	def initialize
		@left, @right, @result = 0, 0, 0
	end
	
	def left= value
		if value == ""
			@left = 0
		elsif value.to_i == 0
			@left = 1
		else
			@left = value.to_i
		end
		calc
	end
	def left
		@left
	end
	
	def right= value
		if value == ""
			@right = 0
		elsif value.to_i == 0
			@right = 1
		else
			@right = value.to_i
		end
		calc
	end
	def right
		@right
	end
	
	def result
		@result
	end
	
	def calc
		if @left == @right
			@result = @left + 1
		else
			@result = [@left, @right].max
		end
	end
	
	def to_s
		return "\"" + @left.to_s + ", " + @right.to_s + ", " + @result.to_s + "\""
	end
end
