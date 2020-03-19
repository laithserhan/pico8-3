pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- prelude
-- by aquova

function _init()
	frame=0
	music(0)
	fade={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}
end

function ctxt(_t)
	return 64-(#_t*2)
end

function fadein(_num)
	-- _num is number of 'fadings' for each color
	pal()
	for i=1,15 do
		local currcol=i
		for _=1,_num do
			currcol=fade[currcol]
			pal(i, currcol)
		end
	end
end

function _draw()
	cls()
	print("final fantasy",ctxt("final fantasy"),24,6)
	spr(1,46,36,4,7)
	print("prelude",ctxt("prelude"),100,6)
	print("aquova",105,123,1)
end

function _update()
	frame+=1
	print(t())
	if frame < 10 then
		fadein(3)
	elseif frame < 20 then
		fadein(2)
	elseif frame < 30 then
		fadein(1)
	else
		pal()
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000cc7700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000000000000000ccc7770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000000000000000cc5c7677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000ccccc7667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000cccc5c7666770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000ccccc5c7667677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000c5c5c55c7666777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000c5c5c555c7666677770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000c5c5c5555c7666767677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000c5c5c5555ccc766677767700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000c5c5c5555cc5cc76677776770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000c5c555555cc556cc7676777677000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000c555c5555cc55676cc767676766700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c55555555cc5566676cc76767667700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001cc55555cc55665cc676c767667c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111cc55cc556555ccc676c7667cc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000011100ccc55655550ccc67cc77ccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111100c5555555000ccc6cc6cccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c5555555000cccccc6ccc6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110100c555555000cc0cccc6cc6c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c55555000cc00cccc6c6c6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c555500ccc0000ccc6cc6c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110100c1511055510001cc56ccc6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c1515511100011cc56cc66600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c15511100000155c56c66c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110000c15110000005515c5666c6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c15100000151105c56666c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110100c1c11c00111000555666c6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c1c1c00111001155566c6c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000110100c1cc1111010115555666cc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111000c5155111000115551ccccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001111005c1155100011555516cccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000011110515c11151011555c1c56ccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000111151015c111511555c1ccc56cc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001115100115cc111555c1ccccc566600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000011510010015ccc55cc1cc55ccc56600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000551100010115ccccc1cc5155cccc600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000110001010015ccc1cc511155ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000111000001015c1cc51115555c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000100000000115cc51151155c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000010100010011c51511155c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000001010001011c1511155c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000100000101c511155c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000010001001c11151c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000001010001c5111c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000101001c115c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000010101c15c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001011c5c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000111cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000011c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011800000c0500e0501005013050180501a0501c0501f0502405026050280502b050300503205034050370503c050370503405032050300502b0502805026050240501f0501c0501a0501805013050100500e050
01180000000500205004050070500c0500e0501005013050180501a0501c0501f0502405026050280502b050300502b0502805026050240501f0501c0501a0501805013050100500e0500c050070500405002050
01180000090500b0500c050100501505017050180501c050210502305024050280502d0502f0503005034050300502f0502d050280502405023050210501c050180501705015050100500c0500b0500905004050
011800001505017050180501c050210502305024050280502d0502f0503005034050390503b0503c050340503c0503b0503905034050300502f0502d050280502405023050210501c05018050170501505010050
01180000090500c050110501305015050180501d0501f0502105024050290502b0502d050300503505037050390503705035050300502d0502b0502905024050210501f0501d050180501505013050110500c050
0118000009000000500505007050090500c050110501305015050180501d0501f0502105024050290502b0502d0502b0502905024050210501f0501d050180501505013050110500c05009050070500505000050
011800000b0500e0501305015050170501a0501f0502105023050260502b0502d0502f0503205037050390503b0503905037050320502f0502d0502b0502605023050210501f0501a0501705015050130500e050
011800000b0000205007050090500b0500e0501305015050170501a0501f0502105023050260502b0502d0502f0502d0502b0502605023050210501f0501a0501705015050130500e0500b050090500705002050
01180000080500c0500f0501305014050180501b0501f0502005024050270502b0502c050300503305037050380503705033050300502c0502b0502705024050200501f0501b0501805014050130500f0500c050
0118000008000000500305007050080500c0500f0501305014050180501b0501f0502005024050270502b0502c0502b0502705024050200501f0501b0501805014050130500f0500c05008050070500305000050
011800000a0500e0501105015050160501a0501d050210502205026050290502d0502e0503205035050390503a0503905035050320502e0502d050290502605022050210501d0501a0501605015050110500e050
011800000a0000205005050090500a0500e0501105015050160501a0501d050210502205026050290502d0502e0502d050290502605022050210501d0501a0501605015050110500e0500a050090500505002050
011800001c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401a5401a5401a5401a5401a5401a5401a5401a5401d5401d5401d5401d5401d5401d5401d5401d540
011800001f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5451f5401f5401f5401f5401f5401f5401f5401f5400000000000000000000000000000000000000000
011800002454024540245402454024540245402454024540245402454024540245402454024540245402454023540235402354023540235402354023540235402654026540265402654026540265402654026540
011800001c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401a5401a5401a5401a54018540185401854018540175401754017540175401a5401a5401a5401a540
011800002154021540215402154021540215402154021540215402154021540215402154021540215402154000500000000000000000000000000000000000000000000000000000000000000000000000000000
011800002454024540245402454024540245402454024540245402454024540245402454024540245402454000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800001c5401c540000000000000000000000000000000000000000000000000000000000000000000000015540155401554015540175401754017540175400c5400c5400c5400c54010540105401054010540
0118000021540215400000000000000000000000000000000000000000000000000000000000000000000000185401854018540185401a5401a5401a5401a5401c5401c5401c5401c5401f5401f5401f5401f540
011800001a5401a5401c5401c54018540185401854018540185401854018540185401854018540185401854000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800001854018540185401854018540185401854018540185401854018540185401854018540185401854015540155401554015540155401554015540155451554015540155401554015540155401554015540
011800001d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401a5401a5401a5401a5401a5401a5401a5401a5401854018540185401854018540185401854018540
01180000215402154021540215402154021540215402154021540215402154021540215402154021540215401f5401f5401f5401f5401f5401f5401f5401f5401d5401d5401d5401d5401d5401d5401d5401d540
011800001a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5451a5401a5401a5401a54000000000000000000000000000000000000000002354023540235402354023540235402354023540
011800001f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5451f5401f5401f5401f5451f5401f5401f5401f5401f5401f5401f5401f5402654026540265402654026540265402654026540
011800002354023540235402354023540235402354023540235402354023540235402454024540245402454026540265402654026540265402654026540265402b5402b5402b5402b5402b5402b5402b5402b540
0118000022540225402254022545225402254026540265401b5401b5401b5401b5401b5401b5401b5401b5401454014540145401454016540165401654016540185401854018540185401b5401b5401b5401b540
01180000265402654026540265401b5401b54000000000002054020540205402054020540205402054020540185401854018540185401a5401a5401a5401a5401b5401b5401b5401b54020540205402054020540
011800001d5401d5401d5401d54000000000000000000000185401854018540185401854018540185401854000000000000000000000000000000000000000000000000000000000000000000000000000000000
0118000022540225402254022540295402954027540275401d5401d5401d5401d5401d5401d5401d5401d5451d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d540
011800002654026540265402654000000000000000000000225402254022540225402254022540225402254522540225402254022540225402254022540225402254022540225402254022540225402254022540
011800001f5401f5401f5401f540000000000000000000001a5401a5401a5401a5401a5401a5401a5401a5451a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a540
0118000022540225402254022540295402954027540275401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5402d5402d5402d5402d5402954029540295402954026540265402654026540
011800001a5401a5401a5401a5400000000000000000000022540225402254022540225402254022540225402254022540225402254000000000000000000000000000000000000000002d5402d5402d5402d540
011800002b5402b5402b5402b540000000000000000000001a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a540000000000000000000000000000000000000000000000000000000000000
011800001c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c5401c540
011800001f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f540
011800002454024540245402454024540245402454024540245402454024540245402454024540245402454024540245402454024540245402454024540245402454024540245402454024540245402454024540
01180000205402054020540205402054020540205402054020540205402054020540205402054020540205401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5451f5401f5401f5401f540
011800001a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a5401a54018540185401854018540185401854018540185401854018540185401854518540185401854018540
011800001d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401d5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5401f5451f5401f5401f5401f540
__music__
00 00014344
00 02034344
00 00014344
00 02034344
00 04054344
00 06074344
00 08094344
00 0a0b4344
00 000c0d0e
00 020f1011
00 000c0d0e
00 02121314
00 04151617
00 0618191a
00 081b1c1d
00 0a1e1f20
00 000c0d0e
00 020f1011
00 000c0d0e
00 02121314
00 04151617
00 0618191a
00 081b1c1d
00 0a212223
00 00242526
00 48272829
