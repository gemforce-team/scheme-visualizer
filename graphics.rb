extend Gems

def init
	@tree = nil
	@background = Color.new 255, 240
	@black = Color.new 255, 30, 28, 26
	@red = Color.new 255, 200, 32, 38
	@orange = Color.new 255, 250, 140, 20
	@yellow = Color.new 255, 240, 220, 10
	@grey = Color.new 255, 130
	@brush = Brush.new
	@grade = 1
	setViewSize 0, [0, 5, 70, 50]
end

def event i, v
	if i == "source"
		@tree = Fork.new
		@tree.me = v
		redraw
	
		watch "node", @tree.node(64).me + ", " + @tree.node(31).layer.to_s
		watch "t", @tree.last
	end
end

def draw v
	#return if @brush == nil
	@brush.setColor @background
	v.drawRectangle @brush, [0, 0, v.width, v.height]
	return if @tree == nil
	
	deepest = @tree.last
	nodes = 2**deepest
	size = v.width / (nodes + 2)
	vert = (v.height - size * 2) / deepest
	offset = []
	offset[1] = size
	obj = nil
	watch "size", size
	
	deepest.downto(0) do |row|
		n = 2**row
		offset[0] = (v.width - n * size) * 0.5
		((n-1)..(n-2+n)).each do |id|
			obj = @tree.node(id)
			if obj != nil
				x = offset[0] + (id - (n - 1)) * size
				y = offset[1] + row * vert
				@brush.setColor case obj.me 
				when "b" 
					@black
				when "r"
					@red
				when "o"
					@orange
				when "y"
					@yellow
				else
					@grey
				end
				v.drawPath @brush, method("g" + 1.to_s).call([x, y], size * 0.5)
			end
		end
	end
	
	
	#p, s = [22, 30], 8
	#@brush.setColor @orange
	#v.drawPath @brush, g2(p, s)
end
