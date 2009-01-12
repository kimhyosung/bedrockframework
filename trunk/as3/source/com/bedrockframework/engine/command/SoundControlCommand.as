package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.Command;
	import com.bedrockframework.core.command.ICommand;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.event.BedrockEvent;
	
	import flash.media.Sound;
	public class SoundControlCommand extends Command implements ICommand
	{
		
		public function SoundControlCommand()
		{
			
		}
				
		public function execute($event:GenericEvent):void
		{
			var objDetails:Object = $event.details;
			 switch ($event.type) {
				case BedrockEvent.ADD_SOUND :
					var objSound:Sound = objDetails.sound || BedrockEngine.assetManager.getSound($event.details.alias);
					BedrockEngine.soundManager.addSound(objDetails.alias, objSound, objDetails.allowMultiple);
					break;
				case BedrockEvent.PLAY_SOUND :
					BedrockEngine.soundManager.playSound(objDetails.alias, objDetails.startTime, objDetails.delay, objDetails.loops, objDetails.volume, objDetails.panning);
					break;
				case BedrockEvent.STOP_SOUND :
					BedrockEngine.soundManager.stopSound(objDetails.alias);
					break;
				case BedrockEvent.ADJUST_SOUND_VOLUME :
					BedrockEngine.soundManager.setSoundVolume(objDetails.alias, objDetails.volume);
					break;
				case BedrockEvent.ADJUST_SOUND_PAN :
					BedrockEngine.soundManager.setSoundPanning(objDetails.alias, objDetails.panning);
					break;
				case BedrockEvent.MUTE :
					BedrockEngine.soundManager.muteGlobal();
					break;
				case BedrockEvent.UNMUTE :
					BedrockEngine.soundManager.unmuteGlobal();
					break;
				case BedrockEvent.ADJUST_GLOBAL_PAN :
					BedrockEngine.soundManager.setGlobalPanning(objDetails.panning);
					break;
				case BedrockEvent.ADJUST_GLOBAL_VOLUME :
					BedrockEngine.soundManager.setGlobalVolume(objDetails.volume);
					break;
				case BedrockEvent.FADE_IN_SOUND:
					BedrockEngine.soundManager.fadeInSound(objDetails.alias, objDetails.time)
					break;
				case BedrockEvent.FADE_OUT_SOUND:
					BedrockEngine.soundManager.fadeOutSound(objDetails.alias, objDetails.time)
					break;
			}
		}
	}
}