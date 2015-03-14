extend Gems

def init
	@tree = nil
	@background = Color.new 255, 190, 220, 250
	@black = Color.new 255, 30, 28, 26
	@red = Color.new 255, 200, 32, 38
	@orange = Color.new 255, 250, 140, 20
	@yellow = Color.new 255, 240, 220, 10
	@grey = Color.new 255, 130
	@brush = Brush.new
	@grade = 1
	@steps = 1
	#setViewSize 0, [0, 5, 120, 60]
	redraw
end

def event i, v
	if i == "source"
		@tree = Fork.new
		@tree.me = v
		n = -1
		row = @tree.last
		until n != -1
			n = amount @tree, row - 1
			row -=1
		end
		@steps = n
		watch "steps", n
		redraw
	end
end

def amount tree, row
	result = -1
	nodes = 2**row
	r = nodes * 2 - 2
	l = nodes - 1
	r.downto(l) do |n|
		if tree.node(n) != nil
			result = 1 + n - l
			if result < 2**(row - 1)
				result = -1
			end
			break
		end
	end
	return result
end

def draw v
	#return if @brush == nil
	@brush.setColor @background
	v.drawRectangle @brush, [0, 0, v.width, v.height]
	return if @tree == nil or @steps == nil
	
	deepest = @tree.last
	nodes = 2**deepest
	hori = v.width / nodes
	vert = v.height / deepest
	obj = nil
	
	deepest.downto(0) do |row|
		low = 2**row - 1
		high = low + @steps
		width = 2**(deepest - row) * hori
		
		(low..high).each do |id|
			x = (id - low) * width + (width * 0.5)
			obj = @tree.node(id)
			if obj != nil
				x = (id - low) * width + (width * 0.5)
				y = hori * 0.5 + row * (vert - hori / deepest)
				grade = obj.value
				gem = nil
				@brush.setColor case obj.me 
				when "b" 
					@black
				when "r"
					@red
				when "o", "m"
					@orange
				when "y", "k"
					@yellow
				else
					@grey
				end
				v.drawPath @brush, method("g" + grade.to_s).call([x, y], hori * 0.5)
				
				if row > 0
					if id.even?
						v.drawLine Pen.new(@grey, 0.125), [x, y - hori * 0.75], [x - width * 0.5, (row-1) * vert + hori * 0.75]
					else
						v.drawLine Pen.new(@grey, 0.125), [x, y - hori * 0.75], [x + width * 0.5, (row-1) * vert + hori * 0.75]
					end
				end
				
			end
		end
	end
end
