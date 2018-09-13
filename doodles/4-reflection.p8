pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _init()
	scrn=128
	water=2*scrn/3
	player={x=scrn/2,y=water,h=15,w=9,f=false}
end

function _update()
	if btn(⬅️) then
		player.x=max(player.x-1,0)
		player.f=false
	elseif btn(➡️) then
		player.x=min(player.x+1,scrn-player.w)
		player.f=true
	end
end

function _draw()
	cls()
	print("pico-8 doodle iv",35,50,7)
	line(0,water,scrn,water,6)
	--sspr(8,0,player.w,player.h,player.x,player.y-player.h,player.w,player.h,player.f,false)
	for i=0,water/2 do
		memcpy(0x7540+i*scrn/2,0x7540-i*scrn/2,scrn/2)
	end
end
__gfx__
00000000000000000000000002222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000022222220000000022222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700222222222000000022222f22200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700022222f22200000002222ff22200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770002222ff22200000002f0ff0f2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007002f0ff0f2f00000002f3ff3f2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002f3ff3f2f00000002ffffff2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002ffffff22000000002dffdd2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000002dffdd20000000000deedf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000deedf00000000000deedf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000deedf00000000000666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006666600000000000deedd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000deedd00000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000101000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000606000000000000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
