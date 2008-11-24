﻿package com.bedrockframework.engine.command
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
			super();
		}
		
		public function execute($event:GenericEvent):void
		{
			 switch ($event.type) {
				case BedrockEvent.ADD_SOUND :
					var objSound:Sound = $event.details.sound || BedrockEngine.assetManager.getSound($event.details.alias);
					BedrockEngine.soundManager.addSound($event.details.alias, objSound);
					break;
				case BedrockEvent.PLAY_SOUND :
					BedrockEngine.soundManager.playSound($event.details.alias, $event.details.startTime, $event.details.loops, $event.details.transform);
					break;
				case BedrockEvent.STOP_SOUND :
					BedrockEngine.soundManager.stopSound($event.details.alias);
					break;
				case BedrockEvent.ADJUST_SOUND_VOLUME :
					BedrockEngine.soundManager.setSoundVolume($event.details.alias, $event.details.volume);
					break;
				case BedrockEvent.ADJUST_SOUND_PAN :
					BedrockEngine.soundManager.setSoundPanning($event.details.alias, $event.details.panning);
					break;
				case BedrockEvent.MUTE :
					BedrockEngine.soundManager.muteGlobal();
					break;
				case BedrockEvent.UNMUTE :
					BedrockEngine.soundManager.unmuteGlobal();
					break;
				case BedrockEvent.ADJUST_GLOBAL_PAN :
					BedrockEngine.soundManager.setGlobalPanning($event.details.panning);
					break;
				case BedrockEvent.ADJUST_GLOBAL_VOLUME :
					BedrockEngine.soundManager.setGlobalVolume($event.details.volume);
					break;
			}
		}
		
	}
}