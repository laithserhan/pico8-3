pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- starmoo valley
-- by aquova and apple

function _init()
	screen=128
	mapsize=2*screen -- i'm not sure if i ever use this
	threshold=20
	displaying=false -- displaying any message?
	showgift=false

	cam={x=0,y=0}
	p1=createplayer()
	cows=generatecows()
	cowlist=generatecowlist()
	gift=creategift(mapsize/2-8,mapsize/2-8)

	_upd=update_title
	_drw=draw_title
end

function _update()
	_upd()
end

function _draw()
	_drw()
end
-->8
-- title screen

function update_title()
	if btnp(❎) or btnp(🅾️) then
		cam.x=p1.x-screen/2+p1.w/2
		cam.y=p1.y-screen/2+p1.h/2
		camera(cam.x,cam.y)
	
		_upd=update_main
		_drw=draw_main
	end
end

function draw_title()
	cls()
	map(32,0,0,0,16,16)
	spr(128,34,8,8,4)
	spr(136,35,40,8,3)
	--local titletext="starmoo valley"
	local infotext="talk to all the cows to win!"
	local nexttext="z/x to begin"
	local ztext="talk to cow - z"
	local xtext="pet cow - x"
	local aquotext="programming by aquova"
	local appletext="spritework by apple"
	--sprint(titletext,ctext(titletext,0,screen),35,7,0)
	if t()%8<4 then
		sprint(infotext,ctext(infotext,0,screen),75,7,0)
		sprint(ztext,ctext(ztext,0,screen),90,7,0)
		sprint(xtext,ctext(xtext,0,screen),100,7,0)
		sprint(nexttext,ctext(nexttext,0,screen),110,7,0)
	else
		sprint(aquotext,ctext(aquotext,0,screen),95,7,0)
		sprint(appletext,ctext(appletext,0,screen),105,7,0)
	end
end
-->8
-- main behavior

function update_main()
	-- check if gift should be drawn
	if not showgift then
		showgift=(#cowlist==0)
	end

	p1:update()
	
	for c in all(cows) do
		c:update()
	end
	
	if showgift then
		gift:update()
	end

	cam.x=mid(0,p1.x-screen/2+p1.w/2,mapsize-screen)
	cam.y=mid(0,p1.y-screen/2+p1.h/2,mapsize-screen)
	camera(cam.x,cam.y)
end
-->8
-- drawing functions

function draw_main()
	cls(3)
	map(0,0,0,0,32,32,1)
	palt(3,true)
	palt(0,false)
	-- draw background cows first
	for c in all(cows) do
		if c.y<p1.y then
			c:draw()
		end
	end

	if showgift and gift.y<p1.y then
		gift:draw()
	end

	-- then draw player
	p1:draw()
	-- and cows in front of player
	for c in all(cows) do
		if c.y>=p1.y then
			c:draw()
		end
	end

	if showgift and gift.x>=p1.y then
		gift:draw()
	end
	
	map(0,0,0,0,32,32,2)

	-- same loop, but i need to draw the window last
	for c in all(cows) do
		if c.display then
			c:drawphrase()
		end
	end

	--drawbar()
	palt()
end

-- draw shadow text
function sprint(t,x,y,c1,c2)
	print(t,x,y+1,c2)
	print(t,x,y,c1)
end

function ctext(t,x1,x2)
	return ((x2-x1)/2)-#t*2
end

function drawbar()
	local dx=cam.x
	local dy=cam.y
	local t="cows remaining: "..#cowlist
	local midx=ctext(t,0,screen)

	rectfill(dx,dy,dx+screen,dy+10,6)
	sprint(t,dx+midx,dy+2,5,3)
end
-->8
-- cow

function newcow(input)
	local c={
		x=input[1],
		y=input[2],
		w=16,
		h=16,
		name=input[3],
		phrases=input[4],
		phrasenum=1,
		sprnum=input[5],
		display=false,
		sound=input[5]/2
	}
	
	function c:update()
		if self.display then
			if dist(p1.x+p1.w/2,p1.y+p1.h/2,self.x+self.w/2,self.y+self.h/2)>threshold then
				self.display=false
				displaying=false
			end
		end
	end

	function c:draw()
		spr(self.sprnum,self.x,self.y,2,2)
	end

	function c:collision(x,y,w,h)
		if x+w>self.x and x<self.x+self.w then
			if y+h/2>self.y and y<self.y+self.h/2 then
				return true
			end
		end
		return false
	end

	function c:nextphrase()
		self.phrasenum=flr(rnd(#self.phrases))+1
	end

	function c:removefromlist()
		for l in all(cowlist) do
			if l==c.name then
				del(cowlist,l)
				break
			end
		end
	end

	function c:drawphrase()
		local py=3*screen/4
		local frame=3

		rectfill(cam.x,cam.y+py,cam.x+screen,cam.y+screen,4)
		rectfill(cam.x+frame,cam.y+py+frame,cam.x+screen-frame,cam.y+screen-frame,15)
		-- 28 chars per line
		sprint(self.name,cam.x+7,cam.y+py+7,5,6)
		sprint(self.phrases[self.phrasenum][1],cam.x+12,cam.y+py+15,5,6)
		sprint(self.phrases[self.phrasenum][2],cam.x+12,cam.y+py+21,5,6)
	end

	return c
end

function generatecows()
	local moos={}

	for item in all(cowdata) do
		local new=newcow(item)
		add(moos,new)
	end

	return moos
end

function generatecowlist()
	local list={}

	for c in all(cowdata) do
		add(list,c[3])
	end

	return list
end

function creategift(x,y)
	local g={
		x=x,
		y=y,
		w=16,
		h=16,
		anim=0,
		cake=false -- draw cake or gift
	}

	function g:update()
		self.anim=(self.anim+1)%24
	end

	function g:collision(x,y,w,h)
		if x+w>self.x and x<self.x+self.w then
			if y+h/2>self.y and y<self.y+self.h/2 then
				return true
			end
		end
		return false
	end

	function g:draw()
		local sprnum
		if self.cake then
			if self.anim<12 then
				sprnum=100
			else
				sprnum=102
			end
		else
			if self.anim<12 then
				sprnum=74
			else
				sprnum=72
			end
		end

		spr(sprnum,self.x,self.y,2,2)
	end

	return g
end

-->8
-- player

function createplayer()
	local p={
		x=mapsize/2-8,
		y=mapsize/2-8,
		w=16,
		h=16,
		sprnum=96,
		sprflp=false,
		anim=0,
		idle=true
	}

	function p:update()
		local startx=self.x
		local starty=self.y
		self.anim=(self.anim+1)%12

		if btn(⬅️) then
 		self.x-=1
 		self.sprflp=true
 		self.idle=false
 	elseif btn(➡️) then
 		self.x+=1
 		self.sprflp=false
 		self.idle=false
 	elseif btn(⬆️) then
 		self.y-=1
 		self.idle=false
 	elseif btn(⬇️) then
 		self.y+=1
 		self.idle=false
 	else
 		self.idle=true
 	end

 	-- stop leaving the screen
 	self.x=mid(4,self.x,mapsize-4-self.w)
 	self.y=mid(4,self.y,mapsize-2-self.h)

 	-- check cow collision
 	for c in all(cows) do
 		if c:collision(self.x,self.y,self.w,self.h) then
 			self.x=startx
 			self.y=starty
 			self.idle=true
 			break
 		end
 	end

 	-- check gift collision
 	if showgift then
 		if gift:collision(self.x,self.y,self.w,self.h) then
 			self.x=startx
 			self.y=starty
 			self.idle=true
 		end
 	end

 	if btnp(❎) then
 		p:checkforcake()
 		if displaying then
 			for c in all(cows) do
 			 if c.display then
 			 	c:nextphrase()
 			 end
 				c.display=false
 			end
 			displaying=false
 		else
 			p:checkforcows()
 		end
 	elseif btnp(🅾️) then
 		p:checkfornoise()
 	end
	end

	function p:checkforcows()
		for c in all(cows) do
			-- calculate from center of sprites
			if dist(c.x+c.w/2,c.y+c.h/2,self.x+self.w/2,self.y+self.h/2)<threshold then
				c.display=true
				displaying=true
				c:removefromlist()
				break
			end
		end
	end

	function p:checkforcake()
		if showgift then
			if dist(gift.x+gift.w/2,gift.y+gift.h/2,self.x+self.w/2,self.y+self.h/2)<threshold then
				gift.cake=true
			end
		end
	end

	-- if i was a better person, id combine these functions
	function p:checkfornoise()
		for c in all(cows) do
			-- calculate from center of sprites
			if dist(c.x+c.w/2,c.y+c.h/2,self.x+self.w/2,self.y+self.h/2)<threshold then
				sfx(c.sound)
				break
			end
		end
	end

	function p:draw()
		if self.idle then
			-- should idle at half speed to walking
			if self.anim<6 then
				self.sprnum=96
			else
				self.sprnum=98
			end
		else
			if self.anim%6<3 then
				self.sprnum=76
			else
				self.sprnum=78
			end
		end

		spr(self.sprnum,self.x,self.y,2,2,self.sprflp)
	end

	return p
end

function dist(x1,y1,x2,y2)
	-- the /10 is to help combat overflow
	return sqrt(((x2-x1)/10)^2+((y2-y1)/10)^2)*10
end
-->8
-- data goes here

cowdata={
	{10,215,"cassie",{{"hey, thanks for sticking","with me all these years"},{"oh murr",""},{"since it's a special day,","i'd cream your nipples"},{"psst, it's your birthday..","oh yeah everyone knows, shit."}},2},
	{150,70,"bee",{{"try my honey milk, it's the","tits."},{"jade you're the breast","server owner i've ever met!"},{"boob puns are always a tit","or miss"},{"you better be playing with","sound on wink wink"},{"i hope i'm not overmilking","the tit puns."},{"tit tit tit tit tit tit boob","breast double d tiddies"}},4},
	{50,50,"newit",{{"i tried baking you a cake..","but i blewit"},{"world domination? dewit.",""},{"it's your birthday!? i","knewit.."},{"happy birthday to you! happy","birthday to.. ah screwit"}},6},
 {70,240,"crumbledore",{{"life is but an illusion",""}},8},
	{9,25,"arphenion",{{"it's pronounced jif today","only"}},10},
	{100,100,"toe",{{"i'm lactoes intolerant but","u'r worth the explosive diarrhea."},{"haoiy borthday jad gope u","havr an wondrfol dzy"},{"the cow is the only marine","creature to enjoy vienna sausages"}},12},
	{130,172,"apple",{{"happy birbday!",""},{"...",""},{"u-uh? of course i'm cow.",""},{"ah--..m-moo?",""}},14},
	{87,72,"jev",{{"...",""}},32},
	{172,172,"ian",{{"ur face is a cow",""},{"moove along",""},{"orange you glad i didn't","say moo?"},{"i lost the game",""}},34},
	{20,107,"poptart",{{"happy day of the birth!",""},{"the cow say- reeeeee",""},{"licking doorknobs is illegal","on other planets"},{"the cake is not a lie",""}},36},
	{210,130,"badiyanu",{{"*white guy blinking*",""},{"*glub glub* he whispers",""},{"happy birthday, jade!",""},{"y'all have fun now.",""}},38},
	{100,20,"ary",{{"...",""}},40},
	{186,74,"zaph",{{"...",""}},42},
	{150,230,"aquova",{{"this is a chrono trigger","reference, u don't get it"}},44},
	{155,90,"danny",{{"...",""}},46},
	{200,50,"iris",{{"...",""}},70}
}
__gfx__
000000000aaaaaa03333333333333333333333333333333333300000033333333333333333333333333333333333333333333333333333333333333333333333
00000000aaaaaaaa3330303333333333333cc333cc33333330088088803333333333300000000003333333333333333333333333333333333333333333333333
00700700aa0aa0aa303000033333333333cccc3cc0c3430330888808803303033033040404444440300033033033330330303303333333333333333333333333
00077000aa0aa0aa070000703333333333cccccc0704407008808808000000000703007044477003008000330700307007003070333333333333333333333333
00077000aaaaaaaa070000703033333333cccccc07044070000888080000000007000070047777033000003307000070070000700000033333333333333c3333
00700700a0aaaa0a30d0dd000003333333ccccc000aaaa03333088800080080330444400047000333000033000100003300b0b000bb0b0033330333033333333
00000000aa0000aa30ddddddd0003333333ccc044aaaaa0333330808888888033074774440770333330033011111110330bbbbbbb00b0bb0330e0b0e03c33333
000000000aaaaaa0300d00d000000003300000000a00a003300000800800800330040040044000033000000001001003300b00b000b0b0b0330f080f03333333
333333333333333330dddd0dd0ddd030030a4a4a40aaaa0303088888808888033044440444444030030006000011110330bbbb00bb0bbb00330f000f03333003
333333333333333330fff0d0ddd0d030030a4a4a4a0fff0303088888880fff03307770444444403003006600000fff03308880bb00000000330eeeee03330e03
333333333333333330fff0ddddddd030030a4a4a4a0fff0303088888880fff03307770444774403003000600600fff03308880bbbbbbb030330e8e8e0000ee03
333333333333333333000dddddddd030030a4a4a4aa0003303088888888000333300044477744030030006000600003333000bbbbbbbb0303330eee0eeeeef03
3333333333333333333330dd000dd03d430aa000aa033333830880008803333333333044000440341300000000033333333330bb000bb03b3333000eeeee0033
3333333333333333333330000f000033330aa0f0aa033333330880f088033333333330440f044033330000f000033333333330bb080bb0333333330ef0fe0333
33333333333333333333300003000033330aa030aa033333330880308803333333333044030440333300003011033333333330bb030bb0333333330e030e0333
33333333333333333333330033300333333443334433333333300333003333333333337733377333333003330033333333333388333883333333333833383333
333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333a3333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333a333333333333333333333a33a333
333333333033330330333303333333333033330333333333333333333033330333333333303333033034330333333333aaaaaaa33033330330363603333aaa33
3333333307044070074440703003333307088070333333333300033307077070333333330708887007044070333333333aaaaa33070330700ac6c6a03333a333
3333333307044070044440700c003333070880728333333333300037070770703333333807088880070440704333333333aaa333070000700a0aa0a0333a3a33
33333330004444033444640000cc03333088862a233333333333003000677603333333300088888330444400033333333aaaaa3000eeee03307aa7000333333a
3333330777774703306666666000333330866662603333333333330666666603333333077787878330848888803333333a333a0eeeeeee03307a777770333333
300000000700700330060060000000033006006008000003300000000600600330000000070070033008008000000003300000000e11e1033007007000000003
03055dd0d07777033066660cc06660303066660828666030070bb5577066660303066578807777033088880888888030030eeeeee0eeee033077770aacccc030
03055ddd0d0fff0330fff0cc0666603030fff062a2666030070bb557760fff0303066578880fff0330fff08888888030030eeeeeee0fff0330fff06aacccc030
03055ddd0d0fff0330fff0cc0666603030fff0682666603000bbb555760fff0303066577880fff0330fff08888888030030eeeeeee0fff0330fff06aacccc030
03055dddd0d0003333000cc066666030330006666666603000bbb5555560003303066577787000333300088888888030030eeeeeeee000333300066cccccc030
73055000dd03333333333006000660353333306600066032600000005503333383066000770333333333308800088038e30ee000ee03333333333accc0ccc03c
330550f0dd033333333330660f066033333330660f066033330660f055033333330660f055033333333330880f088033330ee0f0ee0333333a3330cc0f0cc033
33055030dd033333333330660306603333333066030660333306603066033333330660307703333333333088030880333388883888833333333330cc030cc033
3334433344333333333333553335533333333322333223333335533355333333333553335533333333333377333773333338833388333333333a33aa333aa333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333003003333333333300300333333
33333333333333333333333333333333333333333333333333333333333333333388883333888833333333333333333333330770770333333333077077033333
3333333333333333333bbb3333333333333333333333333333333333303333033833338338333383338888333388883333333077f770333333333077f7703333
333333333333333333b3b333333333333333333333333333333333330803308033888888888888333833338338333383333333077f703333333333077f703333
33333333333333333b3b33bb333333333333333333333333333333330800008033999998899999333388888888888833333333077f703333333333077f703333
333333333bb33bb33b3bbbb3333ee333333dd33333333333333333300097970339aaaaa88aaaaa93339999988999993333333307777033333333330777703333
33333c33b3b3b33bb3bb3b3333eeee3333dddd3333333333333333049799990339aaaaa88aaaaa9339aaaaa88aaaaa9333333077777703333333307777770333
3333cac333bb3333b3b3b3333eeeeee33dddddd3333333333000000007009003399999988999999339aaaaa88aaaaa9333333077877803333777307787780333
3c333c33c333333333333333eeeaaeeedddaaddd33333333080999999099990339aaaaa88aaaaa9339999998899999933777330e777e03333377730e777e0333
cac3333cac33333333333333eeeaaeeedddaaddd333333330909999999077703388888888888888339aaaaa88aaaaa9333777330777033333337733077703333
3c33c333c3333333333333333eeeeee33dddddd33333333308099999b90777033888888888888883388888888888888333377307787f033333333307787f0333
333cac33333333333333333333eeee3333dddd3333333333070997779bb000b3339aaaa88aaaa933388888888888888333333077f77f033333333077f77f0333
3c33c33c333333333333333333bee333333ddb3bb33333333008900089033333339aaaa88aaaa933339aaaa88aaaa9333333077f7777f0333333077f7777f033
cac333cac333333333333bbb3b3bb333333333bb33333333330880f0880333333339aaa88aaa93333339aaa88aaa9333333300f770770033333300077077f033
3c33333c3333333333333b33bbb3b3333333b3b33b33333333088030880333333333999889993333333399988999333333333307730033333333333003770333
3333333333333333333333b33b3b3333333b3bbbb3b3333333344333443333333333333333333333333333333333333333333330033333333333333333003333
33333003003333333333300300333333333333333333333333333333333333333333333333333333333333330000000000000000000000000000000000000000
333307707703333333330770770333333e3e3393393333333333339339333e3e4433334433444444444444330000000000000000000000000000000000000000
33333077f770333333333077f77033333eee338338333e3e3e3e338338333eee9433334933499449944994330000000000000000000000000000000000000000
333333077f703333333333077f70333333e333eeee333eee3eee33eeee3333e39444444933499449944994330000000000000000000000000000000000000000
333333077f703333333333077f70333333333ee7e7e333e333e33ee7e7e333339499994933499449944994330000000000000000000000000000000000000000
33333307777033333333330777703333333336777763333333333677776333339444444933499449944994330000000000000000000000000000000000000000
333330777777033333333077777703333333eee8eeee33333333eee8eeee33339433334933444449944444330000000000000000000000000000000000000000
33333077877803333777307787780333333e7e8a8ee7e333333e7e8a8ee7e3339433334933444449944444330000000000000000000000000000000000000000
3777330e777e03333377730e777e0333393677e877e76393393677e877e763933334433333344333333443333333333300000000000000000000000000000000
33777330777033333337733077703333383677777777638338367777777763833344443333444444444444334433334400000000000000000000000000000000
33377307787f033333333307787f033338ee8eeeeee8ee8338ee8eeeeee8ee833349943333499449944994339433334900000000000000000000000000000000
33333077f77f033333333077f77f03333ee8a8e7e78a87e33ee8a8e7e78a87e33349943333499449944994339444444900000000000000000000000000000000
3333077f7777f0333333077f7777f0333e7e8e77e77877e33e7e8e77e77877e33349943333499449944994339499994900000000000000000000000000000000
333300f77777f033333300f77777f033367777777777776336777777777777633349943333499449944994339444444900000000000000000000000000000000
33333307707703333333330770770333366666666666666336666666666666633344443333499449944994339433334900000000000000000000000000000000
33333330030033333333333003003333333333333333333333333333333333333344443333499449944994339433334900000000000000000000000000000000
00004994000000000000000000000000000000000000000000004994000000000455554444444444444440777777777555040704407040704407044440000000
0000499400000000e000000000000000000000000000000000004994000000000444444444444444444440557707707777040770075040570077044440000000
000055550000005eae00000000000000000000000000000055004994000000000444444444444444444440557040040777040755577040557575044440000000
0044444444444544e444444400000000000000000444444544445555000000000444444444444444444444000444444000444000000444000000444440000000
044455544444454454444444444440440444444444444454e4444444440000000444444994444444994444444444444444444444444444444444444440000000
04455655444445444544444444444044444444444444445eae444555444000000444444999444444994444444444444444444444444444444444444440000000
044556554444445554444444444444444444444444444454e4445565544000000444444999444449994444444449944499444444444444eee444444440000000
044556554444444444444444444444444494444444444454444455655440000000444449994444499944444444499444994444444444eeeeeee4444440000000
044455544444444444444444444444444949444444444445444455655440000004444444999444999449999944499444994449999944eeaaaee4444440000000
0444444444449999444444444444444444944444444444445444455544440000444444449994449944499999444994449944999999455eaaae55444440000000
04444444449999999944449944444444444444444944444445444444444400004444444499994999449944499449944499499944994535eee555444440000000
044444444499944499444499444444444444444444444444445444444444000044444444499999944499444994499444994994499444535e5354444440000000
0444444449999444994999999994444444444444444444444e4544444444000044449444499999944499999994499444994994994444535e3554444440000000
044444444999944444449999994444444449999944494444eae45444444400004449494444999944449999999449944499499994499445353544444440000000
0e44444444999944444444994449999944999999944444444e445444444400004444944444499944449944499499949999449999999444335444494440000000
eae44444444499994444449944499999449944999444444444445444444400004444444444499444449944499499949999444999994444554444444444000000
5e444444444449999444449944994449949944499444494444445444444400004444444444444444444444444444444444444444444444554444444444000000
54444444444444999944449944994449949994499444444444445554444000000444444444444444444444444444444444444444454445554449444444000000
54444444499444499944449944999999949999994444444444454555444000000444444444444444444444444444444444444444455555544944444444000000
54444444499944999944449944999999949999999444444444554555444000000044444444404444444444444444444444444444445555444444444440000000
54444444499999999444449944994449949944999944444455454444444000000044444444404404444444444444444444444444444444444444440000000000
05444444449999994444449944994449949944449944444544454444444000000000000000000000000000000000000000000000000000000000000000000000
05444444444444444444444444444444444444444444445444454444444000000000000000000000000000000000000000000000000000000000000000000000
0544e444444444444444444444444444444444444444445444445444544000000000000000000000000000000000000000000000000000000000000000000000
005eae44444444444444444000444444000444444444445444444555444000000000000000000000000000000000000000000000000000000000000000000000
0045e444444444444444440777044440555044444444444544444444440000000000000000000000000000000000000000000000000000000000000000000000
00445444445444444444440777704405555044444444444444444444440000000000000000000000000000000000000000000000000000000000000000000000
00444554444544444444440557770075555044444444444444444444440000000000000000000000000000000000000000000000000000000000000000000000
00444454444544444444440555777777555044000000444000000444440000000000000000000000000000000000000000000000000000000000000000000000
00455445545544444444440555777777777040557777040755755044440000000000000000000000000000000000000000000000000000000000000000000000
00545445454444444444440557777577777040550077040750055044440000000000000000000000000000000000000000000000000000000000000000000000
00544454444444444444440777577777555040704407040704407044440000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010100000000000000000000010101010101000000000000000000000000000000000000010101000000000000000000000000000102020200000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
696868686868686868686868686868686868686868686868686868686868686a6968686868686868686868686868686a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454540454545454545454545454545434545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454550514545454545454545454552534545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454541424545454545454545454545454045454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545455051454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578784545454545454545454545454545780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578797b7b7b7b7b7b7b7b7b7b7b7b7b7b7a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454541424545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454445454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545455455454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454142454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545404545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545505145454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545434545454545454545454545454541424545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454552534545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7845454545454545454545454545454545454545454545454545454545454578000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
797b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000000037050340502d0502a05026050220501f0501b0501705013050100500c0500b050080500705006050000000505005050000000405004050040500505006050070500705000000000000000000000
