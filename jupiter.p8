pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- jupiter
-- by aquova

height = 128
width = 128

jrad = width/4

europa = {}
europa.r = width/12
europa.shadow = 5

io = {}
io.r = width/30
io.shadow = 7

timer = 0

function frontorback(t)
	if (sin(t) > sin(t-0.01) and sin(t/3) > sin(t/3-0.01)) then
		return 0
	elseif (sin(t) > sin(t-0.01) and sin(t/3) < sin(t/3-0.01)) then
		return 1
	elseif (sin(t) < sin(t-0.01) and sin(t/3) > sin(t/3-0.01)) then
  return 2
 else
  return 3
	end
end

function drawjupiter()
 -- draw the planet
 circfill(width/2,height/2,jrad,4)
 -- draw stripes
 circfill(50,45,2,9)
 circfill(80,45,2,9)
 rectfill(50,43,80,47,9)

 circfill(40,55,2,10)
 circfill(75,55,2,10)
 rectfill(40,53,75,57,10)

 circfill(50,65,2,9)
 circfill(90,65,2,9)
 rectfill(50,63,90,67,9)

 circfill(40,75,2,10)
 circfill(80,75,2,10)
 rectfill(40,73,80,77,10)
 -- great red spot
	spr(7,width*2/5,height*6.5/10)
	spr(8,width*2/5+8,height*6.5/10)
end

function _update()
	europa.x = width/2+(width*5/12)*sin(timer)
	europa.y = height/2-(height/12)*sin(timer)

	io.x = width/2+(width*5/12)*sin(timer/3)
	io.y = height/2-(height/12)*sin(timer/3)
	timer += 0.005
end

function _draw()
	cls()
	map(0,0,0,0,16,16)
	if frontorback(timer) == 0 then
		circfill(europa.x-europa.shadow,europa.y+europa.shadow,europa.r,0)
		circfill(europa.x,europa.y,europa.r,6)
		circfill(io.x-io.shadow,io.y+io.shadow,io.r,0)
		circfill(io.x,io.y,io.r,6)
  drawjupiter()
	elseif frontorback(timer) == 1 then
		circfill(europa.x-europa.shadow,europa.y+europa.shadow,europa.r,0)
		circfill(europa.x,europa.y,europa.r,6)
  drawjupiter()
		circfill(io.x-io.shadow,io.y+io.shadow,io.r,0)
		circfill(io.x,io.y,io.r,6)
	elseif frontorback(timer) == 2 then
		circfill(io.x-io.shadow,io.y+io.shadow,io.r,0)
		circfill(io.x,io.y,io.r,6)
  drawjupiter()
		circfill(europa.x-europa.shadow,europa.y+europa.shadow,europa.r,0)
		circfill(europa.x,europa.y,europa.r,6)
	else
  drawjupiter()
		circfill(europa.x-europa.shadow,europa.y+europa.shadow,europa.r,0)
		circfill(europa.x,europa.y,europa.r,6)
		circfill(io.x-io.shadow,io.y+io.shadow,io.r,0)
		circfill(io.x,io.y,io.r,6)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000700000077700000770000077777000000000000000000000088888880000000000000000000000000000000000000000000000000000000000000
00000000007770000777770007777000077777000007000000000000000888888888000000000000000000000000000000000000000000000000000000000000
00070000000700000077700007777000077777000000000000000000000888888888000000000000000000000000000000000000000000000000000000000000
00000000000000000007000000770000007770000000000000000000000088888880000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000005000000000000000600000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000005000001000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000050000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
