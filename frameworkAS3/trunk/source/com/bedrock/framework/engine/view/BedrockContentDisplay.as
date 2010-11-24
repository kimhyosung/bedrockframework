package com.bedrock.framework.engine.view
{
	import com.bedrock.framework.plugin.storage.HashMap;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.display.ContentDisplay;
	import com.bedrock.framework.plugin.view.IView;

	public class BedrockContentDisplay extends ContentDisplay implements IView
	{
		public function BedrockContentDisplay( loader:LoaderItem )
		{
			super(loader);
		}
		
		public function initialize($data:Object=null):void
		{
			Object( this.rawContent ).initialize( $data );
		}
		
		public function intro($data:Object=null):void
		{
			Object( this.rawContent ).intro( $data );
		}
		
		public function outro($data:Object=null):void
		{
			Object( this.rawContent ).outro( $data );
		}
		
		public function clear():void
		{
			Object( this.rawContent ).clear();
		}
		
		public function get hasInitialized():Boolean
		{
			return Object( this.rawContent ).hasInitialized;
		}
		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
			if( this.rawContent != null ) Object( this.rawContent ).addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void
		{
			super.removeEventListener( type, listener, useCapture );
			if( this.rawContent != null ) Object( this.rawContent ).removeEventListener( type, listener, useCapture );
		}
		
		public function set properties( $properties:Object ):void
		{
			Object( this.rawContent ).properties = $properties;
		}
		public function set assets( $assets:HashMap ):void
		{
			Object( this.rawContent ).assets = $assets;
		}
		public function set bundle( $bundle:* ):void
		{
			Object( this.rawContent ).bundle = $bundle;
		}
	}
}