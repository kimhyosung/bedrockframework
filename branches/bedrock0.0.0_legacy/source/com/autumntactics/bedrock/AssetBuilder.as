package com.autumntactics.bedrock
{
	import com.autumntactics.bedrock.base.MovieClipWidget;
	import com.autumntactics.bedrock.factory.AssetFactory;
	
	public class AssetBuilder extends MovieClipWidget
	{
		public function AssetBuilder()
		{
			AssetFactory.initialize();
			this.initialize();
		}
		public function initialize():void
		{

		}
		protected function addView($name:String, $class:Class):void
		{
			AssetFactory.addView($name, $class);
		}
		protected function addPreloader($name:String, $class:Class):void
		{
			AssetFactory.addPreloader($name, $class);
		}
		protected function addBitmap($name:String, $class:Class):void
		{
			AssetFactory.addBitmap($name, $class);
		}
		protected function addSound($name:String, $class:Class):void
		{
			AssetFactory.addSound($name, $class);
		}
	}
}