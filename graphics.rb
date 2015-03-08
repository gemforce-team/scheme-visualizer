def init
	@black = Color.new 255, 30, 28, 26
	@grade = 1
end

def draw v
	p, s = [10, 30], 9
	method("g" + @grade.to_s).call v, p, s
	p, s = [30, 30], 9
	g2 v, p, s
	p, s = [50, 30], 9
	g3 v, p, s
end

def g1 v, pos, size
	pos[1] -= size * 0.1
	points = []
	0.upto(2) do |i|
		pa = move_at_angle(pos, -90 + i * 120, size * 0.91)
		points << pa
	end
	p = Pen.new @black, 0.25
	b = Brush.new @black
	v.drawClosedCurve b, points, 0.75
end

def g2 v, pos, size
	points = []
	0.upto(2) do |i|
		pa = move_at_angle(pos, -90 + i * 120, size)
		points << pa
	end
	pa = move_at_angle(pos, 90, size * 0.35)
	points.insert 2, pa
	p = Pen.new @black, 0.25
	b = Brush.new @black
	v.drawClosedCurve b, points, 0.6
end

def g3 v, pos, size
	pos[1] -= size * 0.2
	points = []
	0.upto(3) do |i|
		pa = move_at_angle(pos, -45 + i * 90, size)
		points << pa
	end
	p = Pen.new @black, 0.25
	b = Brush.new @black
	v.drawClosedCurve b, points, 0.2
end

def radians(angle)
	return angle * (Math::PI/180)
end
	
def move_at_angle(p, a, d)
	return p[0] + Math.cos(radians(a)) * d, p[1] + Math.sin(radians(a)) * d
end
