package com.bedrockframework.plugin.audio
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.plugin.storage.HashMap;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundBoard extends StandardWidget implements ISoundBoard
	{
		/*
		Variable Declarations
		*/
		private var _objSoundMap:HashMap;
		/*
		Constructor
		*/
		public function SoundBoard()
		{
			this._objSoundMap = new HashMap();
		}
		/*
		Add a new sound
		*/
		public function add($alias:String, $sound:Sound):void
		{
			var objSoundData:SoundData = new SoundData();
			objSoundData.sound = $sound;
			this._objSoundMap.saveValue($alias, objSoundData);
		}
		public function load($alias:String, $url:String, $completeHandler:Function):void
		{
		
		}
		/*
		Pull SoundData Object
		*/
		private function getSoundData($alias:String):SoundData
		{
			return this._objSoundMap.getValue($alias);
		}
		
		public function getSound($alias:String):Sound
		{
			return this.getSoundData($alias).sound;
		}
		public function getChannel($alias:String):SoundChannel
		{
			return this.getSoundData($alias).channel;
		}
		/*
		Transform Functions
		*/
		private function createTransform($volume:Number, $panning:Number):SoundTransform
		{
			return new SoundTransform($volume, $panning);
		}
		public function setTransform($alias:String, $transform:SoundTransform):void
		{
			var objChannel:SoundChannel = this.getChannel($alias);
			objChannel.soundTransform = $transform;
		}
									
		public function getTransform($alias:String):SoundTransform
		{
			return this.getChannel($alias).soundTransform;
		}
		
		/*
		Yay
		*/
		public function play($alias:String, $startTime:Number = 0, $loops:int = 0, $volume:Number = 1, $panning:Number = 0):SoundChannel
		{
			var objSoundData:SoundData = this.getSoundData($alias)
			var objSound:Sound = objSoundData.sound;
			var objTransform:SoundTransform = this.createTransform($volume, $panning);
			objSoundData.channel = objSound.play($startTime, $loops, objTransform);
			this.setTransform($alias, objTransform);
			return objSoundData.channel;
		}
		public function close($alias:String):void
		{
			var objSound:Sound =  this.getSound($alias);
			objSound.close();
		}
		public function stop($alias:String):void
		{
			var objChannel:SoundChannel = this.getChannel($alias);
			objChannel.stop();			
		}
		/*
		Volume Functions
		*/
		public function setVolume($alias:String, $value:Number):void
		{
			this.setTransform($alias, this.createTransform($value, this.getPanning($alias)));
		}
		public function getVolume($alias:String):Number
		{
			return this.getTransform($alias).volume;
		}
		/*
		Pan Functions
		*/
		public function setPanning($alias:String, $value:Number):void
		{
			this.setTransform($alias, this.createTransform(this.getVolume($alias), $value));
		}
		
		public function getPanning($alias:String):Number
		{
			return this.getTransform($alias).pan;
		}
	}
}
import flash.media.Sound;
import flash.media.SoundChannel;
	
class SoundData {
	
	public var sound:Sound;
	public var channel:SoundChannel;
		
}