package com.bedrock.framework.engine.view
{
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockDeeplinkData;
	import com.bedrock.framework.engine.data.BedrockModuleData;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.loading.core.LoaderItem;
	import com.greensock.loading.display.ContentDisplay;

	public class BedrockModuleDisplay extends ContentDisplay implements IView
	{
		public function BedrockModuleDisplay( loader:LoaderItem )
		{
			super(loader);
		}
		
		public function initialize($data:Object=null):void
		{
			try {
				Object( this.rawContent ).initialize( $data );
			} catch( $error:Error ) {
				trace( $error.getStackTrace() );
			}
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
		
		public function get hasInitialized():Boolean
		{
			return Object( this.rawContent ).hasInitialized;
		}
		
		public function set details( $details:BedrockModuleData ):void
		{
			Object( this.rawContent ).details = $details;
		}
		public function get details():BedrockModuleData
		{
			return Object( this.rawContent ).details;
		}
		public function set deeplink( $details:BedrockDeeplinkData ):void
		{
			Object( this.rawContent ).deeplink = $details;
		}
		public function get deeplink():BedrockDeeplinkData
		{
			return Object( this.rawContent ).deeplink;
		}
		
		public function set assets( $assets:BedrockAssetGroupData ):void
		{
			Object( this.rawContent ).assets = $assets;
		}
		public function get assets():BedrockAssetGroupData
		{
			return Object( this.rawContent ).assets;
		}
		
		public function set bundle( $bundle:* ):void
		{
			Object( this.rawContent ).bundle = $bundle;
		}
		public function get bundle():*
		{
			return Object( this.rawContent ).bundle;
		}
	}
}