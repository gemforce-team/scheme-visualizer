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
	@deepest = 0
	@nodelist = []
	@zoom = 1.0
	@offset = [0.0, 0.0]
	@buttons = [[],[]]
	redraw
end

def event i, v
	if i == "source"
		@tree = Fork.new 0,0,true
		@tree.me = v
		@tree.value = @tree.calc
		@deepest = @tree.last
		@nodelist = @tree.flatten
		@nodelist.flatten!
		watch @deepest
		redraw
	end
end

def draw v
	@brush.setColor @background
	v.drawRectangle @brush, [0, 0, v.width, v.height]
	return if @tree == nil or @nodelist.length == 0
	return if @tree.me == ""
	
	radius = 5 * @zoom
	center = v.width * 0.5 + @offset[0]
	height = radius * 3
	line_width = radius * 0.125
	@nodelist.each do |node|
		interval = 2**(@deepest - node.layer + 1)
		offset = 0
		if node.layer == 0
			interval = 0
			offset = 0
		else
			1.upto(node.layer) do |n|
				offset += 2**(@deepest - n)
			end
			offset *= radius * -1
		end

		node.x, node.y = center + offset + node.id * (interval * radius), @offset[1] + radius + 0.125 + node.layer * height
		
		if node.from != nil
			dx = node.from.x - node.x
			dy = node.from.y - node.y
			angle = Math.atan2(dy, dx)
			x1, y1 = node.x + Math.cos(angle) * radius, node.y + Math.sin(angle) * radius
			dx = node.x - node.from.x
			dy = node.y - node.from.y
			angle = Math.atan2(dy, dx)
			x2, y2 = node.from.x + Math.cos(angle) * radius, node.from.y + Math.sin(angle) * radius
			
			pen = Pen.new @grey, line_width
			pen.setStartCap "roundanchor"
			pen.setEndCap "round"
			pen.setLineJoin "round"
			#v.drawLine pen, [x2, y2], [x1, y1]
			v.drawLine pen, [node.x, node.y - radius * 1.25], [x2, y2]
		end
			
		p = method("g" + node.value.to_s).call([node.x, node.y], [0.1875, radius].max)
		
		@brush.setColor case node.me
			when "b"
				@black
			when "o", "m"
				@orange
			when "r"
				@red
			when "y", "k"
				@yellow
			else
				@grey
			end
		v.drawPath @brush, p
	end
end

def distance a, b
	dx = b[0] - a[0]
	dy = b[1] - a[1]
	return Math.sqrt(dx**2 + dy**2)
end

def isInMousePoint x, y
	true
end

def mouseLDouble
	@offset[0, 1] = 0.0, 0.0
	redraw
end

def mouseRDouble
	@zoom = 1
	redraw
end

def mouseLDown x, y
	@buttons[0][0] = true
	@buttons[0][1, 2] = x, y
	captureMouse
end

def mouseRDown x, y
	@buttons[1][0] = true
	@buttons[1][1] = y
	captureMouse
end

def mouseMoveCaptured x, y
	if @buttons[1][0]
		@zoom += ((y - @buttons[1][1]) * 0.05) * @zoom
		@buttons[1][1] = y
		redraw
	elsif @buttons[0][0]
		@offset[0] += (x - @buttons[0][1]) * 0.95
		@offset[1] += (y - @buttons[0][2]) * 0.95
		@buttons[0][1, 2] = x, y
		redraw
	end
end

def mouseLUp x, y
	@buttons[0][0] = false
	releaseMouse
end

def mouseRUp x, y
	@buttons[1][0] = false
	releaseMouse
end
