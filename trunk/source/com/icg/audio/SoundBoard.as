package com.icg.audio
{
	import com.icg.madagascar.base.StandardWidget;
	import com.icg.storage.HashMap;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundBoard extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private var objSoundMap:HashMap;
		/*
		Constructor
		*/
		public function SoundBoard()
		{
			this.objSoundMap = new HashMap();
		}
		/*
		Add a new sound
		*/
		public function add($name:String, $sound:Sound):void
		{
			var objSoundData:SoundData = new SoundData();
			objSoundData.sound = $sound;
			this.objSoundMap.saveValue($name, objSoundData);
		}
		public function load($name:String, $url:String, $completeHandler:Function):void
		{
		
		}
		/*
		Pull SoundData Object
		*/
		private function getSoundData($name:String):SoundData
		{
			return this.objSoundMap.getValue($name);
		}
		
		public function getSound($name:String):Sound
		{
			return this.getSoundData($name).sound;
		}
		public function getChannel($name:String):SoundChannel
		{
			return this.getSoundData($name).channel;
		}
		/*
		Transform Functions
		*/
		public function setTransform($name:String, $transform:SoundTransform):void
		{
			var objChannel:SoundChannel = this.getChannel($name);
			objChannel.soundTransform = $transform;
		}
									
		public function getTransform($name:String):SoundTransform
		{
			return this.getChannel($name).soundTransform;
		}
		
		/*
		Yay
		*/
		public function play($name:String, $startTime:Number = 0, $loops:int = 0, $transform:SoundTransform = null):SoundChannel
		{
			var objSoundData:SoundData = this.getSoundData($name)
			var objSound:Sound = objSoundData.sound;
			objSoundData.channel = objSound.play($startTime, $loops, $transform); 
			return objSoundData.channel;
		}
		public function close($name:String):void
		{
			var objSound:Sound =  this.getSound($name);
			objSound.close();
		}
		public function stop($name:String):void
		{
			var objChannel:SoundChannel = this.getChannel($name);
			objChannel.stop();			
		}
		/*
		Volume Functions
		*/
		public function setVolume($name:String, $value:Number):void
		{
			var objTransform:SoundTransform = new SoundTransform($value, this.getPan($name));
			this.setTransform($name, objTransform);
		}
		public function getVolume($name:String):Number
		{
			return this.getTransform($name).volume;
		}
		/*
		Pan Functions
		*/
		public function setPan($name:String, $value:Number):void
		{
			var objTransform:SoundTransform = new SoundTransform(this.getVolume($name), $value);
			this.setTransform($name, objTransform);
		}
		
		public function getPan($name:String):Number
		{
			return this.getTransform($name).pan;
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;
	
class SoundData {
	
	public var sound:Sound;
	public var channel:SoundChannel;
		
}