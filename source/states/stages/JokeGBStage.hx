package states.stages;

import cutscenes.DialogueBoxPsych;

class JokeGBStage extends BaseStage
{
    override public function create():Void
    {
        var bg:BGSprite = new BGSprite(null, -100, -100, 0, 0);
        bg.makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF313338);
        add(bg);

        if (!ClientPrefs.data.lowQuality)
        {
            var techniktil:BGSprite = new BGSprite('techniktil', -200, 200, 0.9, 0.9);
            techniktil.setGraphicSize(techniktil.width * 1.5);
            techniktil.updateHitbox();
            add(techniktil);

            var crushernotdrip:BGSprite = new BGSprite('CrusherNotDrip', -100, 500, 0.9, 0.9);
            crushernotdrip.setGraphicSize(crushernotdrip.width * 1.5);
            crushernotdrip.updateHitbox();
            add(crushernotdrip);

            var shadE64:BGSprite = new BGSprite('shadE64', 700, 500, 0.9, 0.9);
            shadE64.setGraphicSize(shadE64.width * 1.5);
            shadE64.updateHitbox();
            add(shadE64);

            var pozo:BGSprite = new BGSprite('pozo', 100, 300, 0.9, 0.9);
            pozo.setGraphicSize(pozo.width * 1.5);
            pozo.updateHitbox();
            add(pozo);

            var shopcart:BGSprite = new BGSprite('shopcart', 1000, 300, 0.9, 0.9);
            shopcart.setGraphicSize(shopcart.width * 1.5);
            shopcart.updateHitbox();
            add(shopcart);
        }

        var bar:BGSprite = new BGSprite('bar', -400, 811);
        bar.setGraphicSize(bar.width * 1.5);
        bar.updateHitbox();
        add(bar);
    }

    override public function createPost():Void
    {
        if (songName == 'spitting-facts' && !seenCutscene)
        {
            setStartCallback(function () {
                game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(Paths.formatToSongPath(PlayState.SONG.song) + '/dialogue')));
            });
        }
    }
}