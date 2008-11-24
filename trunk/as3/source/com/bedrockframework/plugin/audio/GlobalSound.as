package com.bedrockframework.plugin.audio
{
	/**
	* Manages the global sound within the flash application.
	*
	* @author Alex Toledo
	* @version 1.0.0
	* @created Sat Apr 3 2008 19:16:40 GMT-0400 (EDT)
	*/
	import com.bedrockframework.core.base.StandardWidget;
	
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class GlobalSound extends StandardWidget
	{
		/*
		Variable Declarations
		*/
		private var _objTransformBoard:TransformBoard
		private var _objSoundTransform:SoundTransform;
		private var _numVolume:Number;
		/*
		Constructor
		*/
		public function GlobalSound()
		{
			this._objTransformBoard = new TransformBoard;
		}
		
		public function mute():void
		{
			this._objTransformBoard.mute();
			SoundMixer.soundTransform = this._objTransformBoard.transform;
		}
		public function unmute():void
		{
			this._objTransformBoard.unmute();
			SoundMixer.soundTransform = this._objTransformBoard.transform;
		}
		public function toggleMute():Boolean
		{
			var bolMute:Boolean = this._objTransformBoard.toggleMute();
			SoundMixer.soundTransform = this._objTransformBoard.transform;
			return bolMute;			
		}
		
		
		/**
		* Change the global sound volume of the application.
		* @param value The volume, ranging from 0 (silent) to 1 (full volume). 
	 	*/
		public function set volume($value:Number):void
		{
			this._objTransformBoard.volume = $value;
			SoundMixer.soundTransform = this._objTransformBoard.transform;
		}
		
		public function get volume():Number
		{
			return this._objTransformBoard.volume;
		}
		/**
		* Change the global sound panning of the application.
		* @param value The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right). A value of 0 represents no panning (center). 
	 	*/
		
		public function set panning($value:Number):void
		{
			this._objTransformBoard.panning = $value;
			SoundMixer.soundTransform = this._objTransformBoard.transform;
		}
		
		public function get panning():Number
		{
			return this._objTransformBoard.panning;
		}
	}
}