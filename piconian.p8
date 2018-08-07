pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- piconian
-- by aquova

-- todo
-- bullets/particles vanish if wrap around
-- particles can get color from hud
-- moving sfx?
-- bullets destroy bullets
-- opening/closing base vunerabilities?
-- high scores

function _init()
 frames=0
 screen=128
 mapsize=4*screen
 shipaccel=0.1
 maxshipspd=2
 moving=false
 bulletspeed=5
 -- states:
 -- 0 - title screen
 -- 1 - main
 -- 2 - paused
 -- 3 - game over
 state=0
 score=0
 startx,starty=(mapsize/2),(mapsize/2)
 cam={x=0,y=0}
 camera(cam.x,cam.y)
 bullets={}
 enemybullets={}
 bulletlimit=2
 enemies={}
 lives=3
 blinkspeed=5
 countdown=false
	dying=false
	transition=false
 titleparticles={}
 explparticles={}
 particlenum=50
 for _=0,particlenum do
  local p=newparticle()
  p:initial()
 	add(titleparticles,p)
 end
 nextlevel()
 music(0)
end

function _update()
 frames+=1
 if state==0 then
  update_title()
 elseif state==2 then
  update_pause()
 elseif state==3 then
  update_gameover()
 else
  update_main()
 end
end

function _draw()
 if state==0 then
  titlescreen()
 elseif state==2 then
 	rectfill(cam.x,cam.y+49,cam.x+screen,cam.y+59,13)
 	fancytext("paused",cam.x+57,cam.y+52,10,8)
 elseif state==3 then
		draw_gameover()
 else
		draw_main()
 end
end

-->8
-- main functions

function update_main()
	-- first level musical intro
	if countdown then
		if (frames-startframe) > 150 then
			countdown=false
		end
		return
	end

	-- check for particles first
	for p in all(explparticles) do
		p:update()
		if p.age > p.maxage then
			del(explparticles,p)
		end
	end

	-- dying animation
 if dying then
		if (frames-deathframe) < 25 then
			if ship.direc==0 then ship.x-=ship.spd
 		elseif ship.direc==1 then ship.x+=ship.spd
 		elseif ship.direc==2 then ship.y-=ship.spd
 		elseif ship.direc==3 then ship.y+=ship.spd end
 	else
 		ship.x, ship.y=startx, starty
 		ship.spd=0
 		dying=false
 		moving=false
 		if lives==0 then
 			state=3
 		end
 	end
 	return
 end

	-- transitioning between levels
	if transition then
		moving=false
		ship.spd=0
		bullets={}
		enemybullets={}
		if btnp(4) or btnp(5) then
			transition=false
			nextlevel()		
		end
		return
	end
 
 if btn(0) then
  ship.direc=0
  moving=true
 elseif btn(1) then
  ship.direc=1
 	moving=true
 elseif btn(2) then
  ship.direc=2
  moving=true
 elseif btn(3) then
  ship.direc=3
  moving=true
 end

	if moving then
		ship.spd=mid(0,ship.spd+shipaccel,maxshipspd)
 end
 if ship.direc==0 then
  ship.x-=ship.spd
  ship.sprt=2
  ship.flp=true
 elseif ship.direc==1 then
  ship.x+=ship.spd
  ship.sprt=2
  ship.flp=false
 elseif ship.direc==2 then
  ship.y-=ship.spd
  ship.sprt=1
  ship.flp=false
 else
  ship.y+=ship.spd
  ship.sprt=1
  ship.flp=true
 end

 if btnp(4) then
  state=2
 end

 if btnp(5) then
  if count(bullets)<bulletlimit then
   add(bullets,newbullet())
   local b=newbullet()
   b.direc=1
   add(bullets,b)
   sfx(1)
  end
 end

 if ship.x < 0 then
  ship.x=mapsize
 elseif ship.x > mapsize then
  ship.x=0
 end

 if ship.y < 0 then
  ship.y=mapsize
 elseif ship.y > mapsize then
  ship.y=0
 end

 if shipcollision() then
  death()
 end

 for e in all(enemies) do
  if not(e.bullet) then
   local mapx=8*e.x
   local mapy=8*e.y
   if (cam.x <= mapx and (mapx+24) <= (cam.x+screen)) and (cam.y <= mapy and (mapy+24) <= (cam.y+screen)) then
    e.bullet=true
    add(enemybullets,enemybullet(mapx+12,mapy+12,e))
				sfx(5)
   end
  end
 end

 for eb in all(enemybullets) do
  eb:update()
  eb:collide()
 end

 for bullet in all(bullets) do
  bullet:update()
  bullet:collide()
 end

 if #enemies==0 then
  transition=true
  clearbullets()
 end
 cam.x=ship.x-(screen/2)
 cam.y=ship.y-(screen/2)
 camera(cam.x,cam.y)
end

function update_title()
	for _=0,particlenum-#titleparticles do
		add(titleparticles,newparticle())
	end
	
	for p in all(titleparticles) do
		p:update()
	end
	
 if btnp(5) then
 	flashframe=0
 	blinkspeed=1
 	countdown=true
 	sfx(2)
 end
 
 if countdown then
		flashframe+=1
		if flashframe>=30 then
			state=1
			music(1)
			startframe=frames
			cam.x=ship.x-(screen/2)
 		cam.y=ship.y-(screen/2)
 		camera(cam.x,cam.y)
		end 	
 end
end

function update_pause()
 if btnp(4) then
  state=1
 end
end

function update_gameover()
 if btnp(4) or btnp(5) then
  _init()
 end
end

function draw_gameover()
	rectfill(cam.x,cam.y+(screen/3),cam.x+screen,cam.y+(2*screen/3),1)
 fancytext("game over",cam.x+centertext("game over"),cam.y+50,7,5)
 local score="final score: "..score
 fancytext(score,cam.x+centertext(score),cam.y+62,7,5)
 fancytext("press ❎ or 🅾️ to continue",cam.x+centertext("press ❎ or 🅾️ to continue"),cam.y+74,7,5)
end

function draw_main()
 cls()
 drawmap()
	if transition then
		rectfill(cam.x,cam.y+(screen/3),cam.x+screen,cam.y+(2*screen/3),1)
		fancytext("level complete!",cam.x+centertext("level complete!"),cam.y+(screen/2),7,5)
	elseif not dying and not countdown then
 	spr(ship.sprt, ship.x, ship.y, 1, 1, ship.flp, ship.flp)
	elseif dying then
		spr(17,ship.x,ship.y)
	end

 for bullet in all(bullets) do
  bullet:draw()
 end

 for eb in all(enemybullets) do
  eb:draw()
 end
 
 for p in all(explparticles) do
 	p:draw()
 end
 
 drawbar()
 minimap()
end
-->8
-- enemy functions

function findenemy(x,y)
 --(x,y) are sprite coords
 for e in all(enemies) do
  if (e.x <= x and (e.x+2) >= x) and (e.y <= y and (e.y+2) >= y) then
   return e
  end
 end
 return nil
end

function deleteenemy(_x,_y)
 --x and y are for top left sprite
 --create explosion effect
 
 for i=0,23 do
 	for j=0,23 do
			--pget needs the on-screen coords
 		local col=pget(8*_x+i,8*_y+j)
 		add(explparticles,explparticle(8*_x+i,8*_y+j,col))
 	end
 end
 
 for i=0,2 do
  for j=0,2 do
   mset(_x+i,_y+j,0)
  end
 end

	sfx(0)
 score+=500
end

function destroymodule(_x,_y,_n)
	for i=0,7 do
 	for j=0,7 do
 		local col=pget(8*_x+i,8*_y+j)
 		add(explparticles,explparticle(8*_x+i,8*_y+j,col))
 	end
 end
	sfx(4)
 mset(_x,_y,_n+6)
 score+=100
end

function deleteobstacle(_x,_y)
	for i=0,7 do
 	for j=0,7 do
 		local col=pget(8*_x+i,8*_y+j)
 		add(explparticles,explparticle(8*_x+i,8*_y+j,col))
 	end
 end
	sfx(3)  
 mset(_x,_y,0)
 score+=50
end

function enemybullet(_x,_y,_e)
 local b={}
 b.x=_x
 b.y=_y
 b.angle=atan2((ship.x-_x),(ship.y-_y))
 b.update=function(this)
 	-- enemy bullets should be slightly slower than players
  b.x+=(bulletspeed-2)*cos(b.angle)
  b.y+=(bulletspeed-2)*sin(b.angle)
  if b.y < cam.y or b.y > (cam.y+screen) then
   _e.bullet=false
   del(enemybullets,b)
  elseif b.x < cam.x or b.x > (cam.x+screen) then
   _e.bullet=false
   del(enemybullets,b)
  end
 end
 b.draw=function(this)
  circfill(b.x,b.y,1,8)
 end
 b.collide=function(this)
  if (ship.x <= b.x and b.x <= (ship.x+8)) and (ship.y <= b.y and b.y <= (ship.y+8)) then
   _e.bullet=false
   del(enemybullets,b)
   death()
  end
 end
 return b
end

-->8
-- player functions

function death()
 lives-=1
 sfx(0)
 dying=true
 deathframe=frames
	clearbullets()
	for i=0,7 do
 	for j=0,7 do
 		local col=pget(ship.x+i,ship.y+j)
 		add(explparticles,explparticle(ship.x+i,ship.y+j,col))
 	end
 end
end

function shipcollision()
 local sprite=mget(flr(ship.x/8),flr(ship.y/8))
 for i=0,3 do
  if fget(sprite,i) then
   return true
  end
 end

 local sprite=mget(ceil(ship.x/8),flr(ship.y/8))
 for i=0,3 do
  if fget(sprite,i) then
   return true
  end
 end

 local sprite=mget(flr(ship.x/8),ceil(ship.y/8))
 for i=0,3 do
  if fget(sprite,i) then
   return true
  end
 end

 local sprite=mget(ceil(ship.x/8),ceil(ship.y/8))
 for i=0,3 do
  if fget(sprite,i) then
   return true
  end
 end
end

function newbullet()
 local b={}
 --offset by 4 to center bullet
 b.x=ship.x+4
 b.y=ship.y+4
 b.orien=ship.sprt
 b.direc=0
 b.draw=function(this)
  circfill(b.x,b.y,1,9)
 end
 b.update=function(this)
  if b.orien==1 then
   if b.direc==0 then
    b.y-=bulletspeed
   else
    b.y+=bulletspeed
   end
   -- destroy bullets if they go 5px off screen
   if b.y < (cam.y-5) or b.y > (cam.y+screen+5) then
    del(bullets,b)
   end
  else
   if b.direc==0 then
    b.x-=bulletspeed
   else
    b.x+=bulletspeed
   end
   if b.x < (cam.x-5) or b.x > (cam.x+screen+5) then
    del(bullets,b)
   end
  end
 end
 b.collide=function(this)
  local sprx=flr((b.x%mapsize)/8)
  local spry=flr((b.y%mapsize)/8)
  local sprn=mget(sprx,spry)
  local e=findenemy(sprx,spry)
  if fget(sprn,0) then
   del(bullets,b)
   if e.h > 1 then
   	e.h-=1
   	destroymodule(sprx,spry,sprn)
   else
    deleteenemy(e.x,e.y)
    del(enemies,e)
   end
  elseif fget(sprn,1) then
   del(bullets,b)
   if e~= nil then
    deleteenemy(e.x,e.y)
    del(enemies,e)
   end
  elseif fget(sprn,2) then
   del(bullets,b)
  elseif fget(sprn,3) then
   deleteobstacle(sprx,spry)
   del(bullets,b)
  end
 end
 return b
end

-->8
-- drawing functions

function centertext(t)
 return (screen/2)-#t*2
end

function fancytext(_t,_x,_y,_c1,_c2)
	print(_t,_x-1,_y-1,_c2)
	print(_t,_x,_y-1,_c2)
	print(_t,_x+1,_y-1,_c2)
	print(_t,_x-1,_y,_c2)
	print(_t,_x+1,_y,_c2)
	print(_t,_x-1,_y+1,_c2)
	print(_t,_x,_y+1,_c2)
	print(_t,_x+1,_y+1,_c2)

	print(_t,_x,_y,_c1)
end

function blinktext(_t,_x,_y,_c1,_c2,_c3)
	if frames%(4*blinkspeed) < blinkspeed then
		print(_t,_x,_y,_c1)
	elseif frames%(4*blinkspeed) < (2*blinkspeed) then
		print(_t,_x,_y,_c2)
	elseif frames%(4*blinkspeed) < (3*blinkspeed) then
		print(_t,_x,_y,_c3)
	else
		print(_t,_x,_y,_c2)
	end
end

function titlescreen()
 cls()
 -- must break up title sprite
 -- due to map/sprite limitations
	for p in all(titleparticles) do
		p:draw()
	end
 spr(64,0,18,5,4)
 spr(53,40,10,4,5)
 spr(73,72,18,7,4)
 spr(50,48,50,3,1)
 spr(32,16,50,2,2)
 fancytext("by aquova",centertext("by aquova"),100,11,1)
 spr(2,60+2*cos(t()/3),72,1,1,true,false)
	blinktext("press ❎ to start",centertext("press ❎ to start"),screen-16,6,12,13)
end

function minimap()
 local minix=cam.x+(screen-40)
 local miniy=cam.y+(screen-40)
 for e in all(enemies) do
  local localx=e.x*320/mapsize
  local localy=e.y*320/mapsize
  rectfill(minix+localx,miniy+localy,minix+localx+1,miniy+localy+1,8)
 end
 local shipx=ship.x*40/mapsize
 local shipy=ship.y*40/mapsize
 rectfill(minix+shipx,miniy+shipy,minix+shipx+1,miniy+shipy+1,11)
end

function drawmap()
 local topx=flr(cam.x/128)*128
 local topy=flr(cam.y/128)*128
 local colx=topx/8
 local coly=topy/8
 if colx < 0 then
  colx=48
 end
 if coly < 0 then
  coly=48
 end

 map(colx,coly,topx,topy,16,16)
 map((colx+16)%64,coly,topx+screen,topy,16,16)
 map(colx,(coly+16)%64,topx,topy+screen,16,16)
 map((colx+16)%64,(coly+16)%64,topx+screen,topy+screen,16,16)
end

function drawbar()
 spr(1,cam.x+4,cam.y)
 fancytext("x"..lives,cam.x+14,cam.y+2,12,1)
 fancytext("score: "..score,cam.x+45,cam.y+2,14,2)
 spr(21,cam.x+110,cam.y)
 fancytext("x"..#enemies,cam.x+120,cam.y+2,8,2)
end

function explparticle(_x,_y,_col)
	local p={}
	p.x=_x
	p.y=_y
	p.age=0
	p.maxage=flr(rnd(20))+20
	p.vx=rnd(2)-1
	p.vy=rnd(2)-1
	p.col=_col
	p.update=function(this)
		p.age+=1
		p.x+=p.vx
		p.y+=p.vy
	end
	p.draw=function(this)
		pset(p.x,p.y,p.col)
	end
	return p
end

function newparticle()
	local p={}
	p.x=0
	p.y=flr(rnd(screen))
	p.spd=rnd(3)+2
	p.initial=function(this)
		p.x=flr(rnd(screen))
	end
	p.update=function(this)
		p.x+=p.spd
		if p.x > screen then
			del(titleparticles,p)
		end
	end
	p.draw=function(this)
		pset(p.x,p.y,5)
	end
	return p
end
-->8
-- level loading functions

function nextlevel()
 --resets map
 reload()
 setobstacles()
 setenemies()
 clearbullets()
 ship={x=startx,y=starty,spd=0,direc=2,sprt=1,flp=false}
end

function clearbullets()
	bullets={}
	for e in all(enemies) do
 	e.bullet=false
 end
	enemybullets={}
	explparticles={}
end

function setobstacles()
 for _=0,50 do
  local ax=rnd(mapsize/8)
  local ay=rnd(mapsize/8)
  if (ax<(startx/8-1) or ax>(startx/8+1)) and (ay<(starty/8-1) or ay>(starty/8+1)) then
   mset(ax,ay,3)
  end

  local bx=rnd(mapsize/8)
  local by=rnd(mapsize/8)
  if (bx<(startx/8-1) or bx>(startx/8+1)) and (by<(starty/8-1) or by>(starty/8+1)) then
   mset(bx,by,16)
  end
 end
end

function setenemies()
 local enemynum=flr(rnd(5))+3
 for i=0,enemynum do
  local e={}
		-- ensure enemy isn't drawn on player
  -- lua has no continue keyword, use a goto
		::retry::
 	e.x=flr(rnd((mapsize/8)-2))
 	e.y=flr(rnd((mapsize/8)-2))
  	
 	-- check distances, ensure new enemies are
 	-- far enough away from player and other enemies
 	local playerdist=sqrt((8*e.x-startx)^2 + (8*e.y-starty)^2)
		if playerdist<(3*screen/4) then
			goto retry
		end
			
		for n in all(enemies) do
			local dist=sqrt((e.x-n.x)^2 + (e.y-n.y)^2)
			if dist<3 then
				goto retry
			end
		end
  
  e.h=6
  e.bullet=false
  add(enemies,e)

  local offset=(flr(rnd(2))%2)==0 and 4 or 7
  for a=0,2 do
   for b=0,2 do
    mset(e.x+a,e.y+b,(b*16)+a+offset)
   end
  end
 end
end

__gfx__
00000000000880000666680000044ff00000000000bbbb000000000000000b2b00000000b2b00000000000000000000000000000000000000000000000000000
00000000000660000066000000f4444f000000000bb22bb0000000000000bb2bb000000bb2bb0000000000000900000000000000000000000000000000000000
0070070080066008066660000444444400000000bb2bb2bb00000000000bb2b2bb0000bb2b2bb00000000000b890000000000000000990090900000000098000
0007700060666606966c66680f444f4400bbbb0322bbbb2233bbbb00000b2bbb2b0000b2bbb2b000000000032890000933bb890000088998980000000998b000
00077000666cc666966c6668f444ff440bb22bb3bb2bb2bb3bb22bb0000b2bbb2b0000b2bbb2b00000000983bb8999883bb28900000b288b8b0000999882b000
00700700666666660666600044444440bb2bb2bb0bb22bb0bb2bb2bb000bb2b2bb0000bb2b2bb000000098bb0bb888b0bb289000000bb2b2bb0000888b2bb000
0000000060666606006600000f44440022bbbb2200bbbb0022bbbb220003bb2bb000000bb2bb300000098b2200bbbb0022b890000003bb2bb000000bb2bb3000
00000000000990000666680000ff4400bb2bb2bb00033000bb2bb2bb00033b2b33000033b2b33000000982bb00033000bb2b890000033b2b33000033b2b33000
000660000088880000000000000000000bb22bb330bbbb033bb22bb000b2b00033b00b33000b2b0000982bb330bbbb033bb890000009800033b00b33000b8900
0601106008899880000070000000000000bbbb033bb22bb330bbbb000bb2bb000bb88bb000bb2bb00098bb033bb22bb330bb890000008b000bb88bb000bb8900
00111100889aa988000000000000000000000000bb2222bb00000000bb2b2bb0bb2ee2bb0bb2b2bb00000000bb2222bb00000000000098b0bb2ee2bb0bb89000
6116611689a77a9800700000000700000000000008e77e8000000000b2bbb2b3b227722b3b2bbb2b0000000008e77e8000000000000098b3b227722b3b289000
6116611689a77a9800000000000000000000000008e77e8000000000b2bbb2b3b227722b3b2bbb2b0000000008e77e8000000000000098b3b227722b3b289000
00111100889aa988000070000000000000000000bb2222bb00000000bb2b2bb0bb2ee2bb0bb2b2bb00000000bb2222bb0000000000998bb0bb2ee2bb0bb28900
0601106008899880000000000000000000bbbb033bb22bb330bbbb000bb2bb000bb88bb000bb2bb00098bb033bb22bb3308900000988bb000bb88bb000bb2890
000660000088880000000000000000000bb22bb330bbbb033bb22bb000b2b00033b00b33000b2b0000098bb330bbbb033b89000000b2b00033b00b33000b2800
00027299927200000000000000000000bb2bb2bb00033000bb2bb2bb00033b2b33000033b2b33000000098bb00033000bb89000000033b2b33000033b2b33000
0002729927200000000000000000000022bbbb2200bbbb0022bbbb220000bb2bb000000bb2bb30000000982200bbbb0022b8900000008b2bb000000bb2bb3000
00027292772000000000000000000000bb2bb2bb0bb22bb0bb2bb2bb000bb2b2bb0000bb2b2bb000000098bb0bb22bb0bb289000000098b2bb0000bb888bb000
000272927200000000000000000000000bb22bb3bb2bb2bb3bb22bb0000b2bbb2b0000b2bbb2b00000098bb3bb2888bb3bb28900000009882b0000b899988000
0002722722000000000000000000000000bbbb3322bbbb2233bbbb00000b2bbb2b0000b2bbb2b00000098b332289998833bbb800000000998800008900099000
0002722720000000000000000000000000000000bb2bb2bb00000000000bb2b2bb0000bb2b2bb000000000008890009900000000000000009900009000000000
00027272200000000000000000000000000000000bb22bb0000000000000bb2bb000000bb2bb0000000000000900000000000000000000000000000000000000
000272720000000000000000000000000000000000bbbb000000000000000b2b00000000b2b00000000000000000000000000000000000000000000000000000
00027722000000002772999999999277220000000000000000000022222000000000000000000000000000000000000000000000000000000000000000000000
00027720000000000277229999992772000000000000000000000277777200000000000000000000000000000000000000000000000000000000000000000000
00027200000000000022772222227220000000000000000000022721112722000000000000000000000000000000000000000000000000000000000000000000
00027200000000000000227777772000000000000000000002277211111277220000000000000000000000000000000000000000000000000000000000000000
00027200000000000000002222220000000000000000000027721111111112772000000000000000000000000000000000000000000000000000000000000000
00022000000000000000000000000000000000000000002272211112221111227220000000000000000000000000000000000000000000000000000000000000
00022000000000000000000000000000000000000000027721111227772211112772200000000000000000000000000000000000000000000000000000000000
00022000000000000000000000000000000000000002272211112772227721111227720000000000000000000000000000000000000000000000000000000000
00002222222222222222222222222222222222222227721111227221112277211112272222222222222222222222222222222222222222222222222222220000
00000227777777777777777777777777777777777772211122772111111122722111127777777777777777777777777777777777777777777777777772200000
00000027cccccccccccccccccccccccccccccccc7221111277221111111112277211127ccccccccccccccccccccccccccccccccccccccccccccccccc72000000
000000027cccccccccccccccccccccccccccccc72211112722111122222111122721127cccccccccccccccccccccccccccccccccccccccccccccccc720000000
0000000027cccccccccccccccccccccccccccc721111277211112277777221111277227ccccccccccccccccccccccccccccccccccccccccccccccc7200000000
00000000027cccc77777777777777777777777711122721111127711111772211112777777777777777777777777777777777777777777777cccc72000000000
00000000027cccc71111777777777711777777711127211112771111111117721111277771117777777777111177111177711177777711117cccc72000000000
000000000027cccc711172222222227172222271112721112771111111111177221127227777222272222711172271117227772222271117cccc720000000000
0000000000277ccc7111721111111127721112711127211271111bb111bb1111721127211277111271112711721127117211272111271117ccc7720000000000
2222222222227cccc71172111222111272111271112721127111b2b111b2b11172112721112211127111271721111271721112211127117cccc7222222222222
02777777777777ccc71172111277211272111271112721127111bbb111bbb11172112721111211127111277221111127721112211127117ccc77777777777720
00227cccccccc7cccc71721112772112721112711127211271113131113131117211272111111112711127721122112772111121112717cccc7cccccccc72200
000227cccccccc7ccc7172222272222272222272222722227113111b8b1113117222272222222222722227222222222272222222222717ccc7cccccccc722000
0000027ccccccc7ccc71722222222227722222722227222271bbb1bbebb1bbb17222272222222222722227222227222272222222222717ccc7ccccccc7200000
0000027ccccc1117ccc7722222222227722222722227222271b2b3bb7bb3b2b1722227222222222272222722227722227222222222277ccc7111ccccc7200000
00000027cccc7117ccc7722222222771722222722227222271bbb1bbebb1bbb1722227222227222272222722227722227222272222277ccc7117cccc72000000
000000227cccc717cccc72222227711172222272222722227113111b8b11131172222722222722227222272222222222722227222227cccc717cccc722000000
0000000277ccc711cccc7222227111117222227222272222711131311131311172222722222722227222272222222222722227222227cccc117ccc7720000000
0000000027cccc71cccc72222271111172222272222722227111bbb111bbb11172222722222722227222272222222222722227222227cccc17cccc7200000000
0000000002ccccc7177772222271111172222272222722227111b2b111b2b11172222722222722227222272222222222722227222227777117ccc72000000000
00000000027cccc71111722222711111722222722227222271111bb111bb11117222272222272222722227222277222272222722222711117cccc72000000000
000000000027ccc71111722222711111722222722227222227111111111111172222272222272222722227222277222272222722222711117cccc72000000000
000000000027ccc71111722222711111722222722227222222771111111111722222272222272222722227222277222272222722222711117ccc720000000000
000000000027ccc71111722222711111722222722222722222227711111172222222272222272222722227222277222272222722222711117ccc720000000000
0000000000027ccc711172444271111172222272444227724444227111772444422772222227222272222722227722227222272222271117ccc7200000000000
0000000000027ccc711172444271111172444272244442272444422777224444277242244427244272442724427724427244272444271117ccc7200000000000
0000000000027ccc777772444277777777777777724444227724444222444422722442777777777777777777777777777777777777777777ccc7200000000000
00000000000027ccccccc29992ccccccccccc7222722999922729999999992772999927ccccccccccccccccccccccccccccccccccccccccccc72200000000000
00000000000027ccccccc29992cccccccccc72000277229999277229999277229992277ccccccccccccccccccccccccccccccccccccccccccc72000000000000
00000000000027ccccccc29992ccccccccc722000022772999922772222722999927777ccccccccccccccccccccccccccccccccccccccccccc72000000000000
00000000000027777777729992777777777220000000227229999227777299992272227777777777777777777777777777777777777777777772000000000000
00000000000022222222729992722222222200000000002772299992222999227720002222222222222222222222222222222222222222222222000000000000
00000000000000000000000000000000000000000031000000000000000031000000000031000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000031000000000031000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000310000310000310000000000000031000000000000000000000000003100000000310000310000000000000031000000000031003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000031000000000000000000000031000031000000000000310000000000310000000000000000000000000000310000000000003100000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000310000003100000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31003100000000000000003100003100000000000000000031000000000000310000000000000031000000000000310000003100000031000000310000003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31000000310000000000000000000000000000000000000000000000000000000031000000000000000000000000003131000000000000310000000000313100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000000031000000000031000000000031000000000031000000000000003100000000003100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003100000000000000000000003100000000000000000000000000000000003100003100000000000000003100000000000000000031000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000031003100000000313100000000310000000000310000000000000000003100003100000000000000003100000000003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000003100000000000000000000000000000000000031003100000000000000000000000000000000000031000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000310000000000000000000000310000000000000031000000000000000000000000003100000031000000310000000000000000003100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000031000000000000003100000000000000000000000031000000000000000000000031000000000000000000000000000000000031000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000310000000000000000000000003100003100000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003100000000003100000000000000000000003100000000000000000000000000000000003100000031000000310000003100000000310000310000003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003100000000000000310000000000000000000000003100000000000000000000000000000000000000000000000000310000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000310000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000310000000000000000000000000000000031000000000000310000000000000000003100000031000000000000310000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000000000003100310031000000000000310000000000000000003100000031000000000000003100000031000000000000003100003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003100000000003100000000000000000000000000000000000031000000000000000000000000310000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000003100003100310000003100000000000000000000000000000000000000000000310000000031000031000031003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00310000000000000000000031000000000000000000000000000000000000000000310000000031000000310000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000003100000000000000000000000000000000000000310000000000000000000000000000000000310000003100000000000000003100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000003100003100003100003100000000000000000000000000310000000031000000000000000000000000310000000000003100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000310000000000000000000000000000000000000000000000000000003100000000000000000000310000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000310000000000000000000000000000003100003100310000003100000031000000000000000000003100003100000031000000310000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31000000000000000000000000000000000000003100000000000000000000000000003100000000000000003100000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000310000003100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000031000000000000000000310000000031000000000000000000003100000000000000003100000031000031000000003100000000000000000000000031
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000031000000000000000000000000000031000000000000000000310000000000000000000000000000000000003100000031000000000000
__gff__
0000000801010101000104040404000408000000000200010201000000040004000000000101010100010404040400040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000130000000000000000000000000000000000000000000000000000000013000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013000000000000000000130000130000000013000000130000000000130000000000000000001300001300000000000000130000130000001300001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000130000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000001300000013000000001300000000000000001300001300000000130000000013000000130000000000000000130013001300001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000130000000013000000000000000000001300000013000000000000130000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1300001300000000000000000000000000001300000000000000000000130000000000000000000000000000130000000000130000000000000013001300001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000130000000013000000000000130000000013000000000000130000000013000000130000000000000000000000130000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1300000000000013000000000000000000130000000000000000000000001300130013000000000000000000130000000000130000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013000000000000000000000000000013000000000000000000000000000000000000000000000000000000000000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000130000000000130000000000000000130000000000000000000000001300000013000000130000000000001300000000130000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000013000000000013000000130000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000000000013000000000000000000000000130000000000000000000000000000130000000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000130000130000001300000000001300000000000013000000000000130000000013000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000130000000000130000000000000000000000000000001300000000000000000000000000000000000000000000000000130013000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000013000000000000000013000000000000000000130000000013000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000130000000000130000130000000000001300000000000000001300000000000000000000000000000000130000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013000000000000000000000000000000000000000000001300000000000000000013000000000000000000000000000013000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001300000013000013000000000000000000000000001300000000000000001300000000000000001300000000000000000000130000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000001300001300000013000000000000000000000000000000001300000000000000000000130000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000130000130000000000000000000013000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000001300000000130000130000000000000000000000000013000000000000000000001300000000000000000013000000130000000000000013000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000130000000000000013000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000013000000130000001300001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1300000000000000130000000000000013000000001300000000001300000000000000000000000000001300001300000013000000000000001300000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000000000000001300000000000013000000000000000000000000000000000000001300000000000000000000000000001300000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0013000000000000000000000000000000000000000000001300000013001300000013000000000000000000000000000000000000000000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000013000000000013000000000013000000000000000000000000000000000000000000000013000000000000001300000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000130000000000001300000013000000130000000000000000000013000000000000000000130013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000130000000000000000130000000013000000000000000000130000000000000000000000000000000000000013000000000000130000000000001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000013000000000000000000001300000000000000000000000000001300000000001300130000130000000000000000000000130000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000300003862034620316202e6202a62027620246201f6201c6201962014620116200e6200b620086200662005620056200562005620056200562005620056200562005620056200100001000010000100001000
000200003a0503a05035050310502d05027050230501f0501b05017050120500f0500a05004050010500d0000a000080000500002000010002470023700237002370000000000000000000000000000000000000
000200001d0501d0501d0501d050240502405024050240502105021050210501e0501e0501e0501e0502c0502c0502c0502c0502c0502c0502c05025000220002200022000220002e0002e0002e0002e00000000
000200001a75018750157501475012750107500f7500c7500b750087500675006750017000e1000d1000d10000000000000000000000000002f6002f6002e6002e60000000000000000000000000000000000000
000200002f62028620216201c6201762012620106200e6200b6200962008620086200862008600016000a30006300013000000000000000000000000000000000000000000000000000000000000000000000000
000200003a2203a22035220312202d22027220232201f2201b22017220122200f2200a22004220022200d0000a000080000500002000010002470023700237002370000000000000000000000000000000000000
01100000197541b7441e73420725197551b7451e73422724197541b7451e73522725197541b7441e7342272525755277452a7342e72425754277452a7352e72525754277442a7342e72525755277452a7342e724
011000000c0431960019600196000c0430000000000000000c0430000000000000000c0430000000000000000c0530000000000000000c0530c00000000000000c0530000000000000000c053000000000000000
010c00002d0502f0502b0502d050290502b050280502905026050280502405026050230502405021050230501f050210501d0501f0501c0501d0501a0501c050180501a050170501705018050180501a0501a050
010a00001d0501d0501d0501d05011000110001d0501d0501d0501d0551d0501d0501d0501d0551d0501d0501d0501d0501f0501f0501f0501f0501f0501f0500000000000000000000000000000000000000000
__music__
02 06074849
00 08424344
00 09424344

