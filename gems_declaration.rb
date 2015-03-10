module Gems
	def g1 pos, size
		pos[1] -= size * 0.1
		points = []
		0.upto(2) do |i|
			pa = move_at_angle(pos, -90 + i * 120, size * 0.91)
			points << pa
		end
	
		obj = GraphicsPath.new
		obj.addClosedCurve points, 0.75
		return obj
	end

	def g2 pos, size
		points = []
		0.upto(2) do |i|
			pa = move_at_angle(pos, -90 + i * 120, size)
			points << pa
		end
		pa = move_at_angle(pos, 90, size * 0.35)
		points.insert 2, pa
		
		obj = GraphicsPath.new
		obj.addClosedCurve points, 0.6
		return obj
	end

	def g3 pos, size
		pos[1] -= size * 0.2
		points = []
		0.upto(3) do |i|
			pa = move_at_angle(pos, -45 + i * 90, size)
			points << pa
		end
		
		obj = GraphicsPath.new
		obj.addClosedCurve points, 0.2
		return obj
	end

	def g4 pos, size
		pos[1] -= size * 0.2
		points = []
		0.upto(3) do |i|
			pa = move_at_angle(pos, -45 + i * 90, size)
			points << pa
		end
		points[0][1] -= size * 0.07
		pa = points[0].clone
		pa[0] -= size * 0.15
		pb = points[-1].clone
		pb[0] += size * 0.1
	
		obj = GraphicsPath.new
		obj.addCurve [points[-1], pb, move_at_angle(pos, -90, size * 0.25), pa, points[0]], 0.5
		obj.addCurve points, 0.2
		return obj
	end

	def radians(angle)
		return angle * (Math::PI/180)
	end
	
	def move_at_angle(p, a, d)
		return p[0] + Math.cos(radians(a)) * d, p[1] + Math.sin(radians(a)) * d
	end
end
