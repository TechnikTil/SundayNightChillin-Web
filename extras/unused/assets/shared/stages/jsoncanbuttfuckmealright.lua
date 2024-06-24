function onCreate()
	makeLuaSprite("bg", 'old2/BG', -1700, -700)
	scaleObject("bg", 2.5, 2, true)

	makeLuaSprite("sun", 'old2/Sun', 1600, -200)
	scaleObject("sun", 1.2, 1.2, true)

	makeLuaSprite("clouds", 'old2/Clouds', 900, 0)
	scaleObject("clouds", 1.4, 1.4, true)
	setProperty("clouds.velocity.x", -10, false)

	makeLuaSprite("mountain", 'old2/Mountain', -1500, 100)
	scaleObject("mountain", 2.5, 2.5, true)

	makeLuaSprite("grass", 'old2/Grass', -1600, 600)
	scaleObject("grass", 3.7, 3.7, true)

	makeLuaSprite("tree", 'old2/Tree', -350, 350)
	scaleObject("tree", 1.9, 1.9, true)

	makeLuaSprite("sign", 'old2/Sign', 1200, 700)
	scaleObject("sign", 2.2, 2.2, true)

	addLuaSprite('bg', false)
	addLuaSprite('sun', false)
	addLuaSprite('clouds', false)
	addLuaSprite('mountain', false)
	addLuaSprite('grass', false)
	addLuaSprite('tree', false)
	addLuaSprite('sign', false)
end