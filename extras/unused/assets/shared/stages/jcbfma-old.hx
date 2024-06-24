// The positions weren't finished lmao
import objects.BGSprite;

function onCreate()
{
	var bg:BGSprite = new BGSprite('old/BG', 0, 0, 1, 1);
	addBehindGF(bg);

	var sun:BGSprite = new BGSprite('old/Sun', 0, 0, 1, 1);
	addBehindGF(sun);

	var clouds:BGSprite = new BGSprite('old/Clouds', 0, 0, 1, 1);
	clouds.velocity.x = 5;
	addBehindGF(clouds);

	var mountains:BGSprite = new BGSprite('old/Mountain', 0, 0, 1, 1);
	addBehindGF(mountains);

	var grass:BGSprite = new BGSprite('old/Grass', 0, 0, 1, 1);
	addBehindGF(grass);

	var sign:BGSprite = new BGSprite('old/Sign', 0, 0, 1, 1);
	addBehindGF(sign);
}