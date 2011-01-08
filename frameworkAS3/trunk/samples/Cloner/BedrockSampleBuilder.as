package
{
	import com.bedrock.framework.plugin.storage.HashMap;
	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	
	public class BedrockSampleBuilder extends MovieClip
	{
		/*
		Variable Declarations
		*/
		private var _testHash:HashMap;
		private var _selectedID:String;
		/*
		Constructor
		*/
		public function BedrockSampleBulider()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this._testHash = new HashMap;
			this.loaderInfo.addEventListener( Event.COMPLETE, this._onInit );
		}
		
		public function initializeComplete():void
		{
			this.selectTestItem( this._selectedID );
		}
		
		public function addTestItem( $id:String, $target:MovieClip ):void
		{
			if ( this._testHash.size == 0 ) this._selectedID = $id;
			this.addChild( $target );
			this._testHash.saveValue( $id, $target );
		}
		
		public function selectTestItem( $id:String ):void
		{
			this._selectedID = $id;
			for each( var key:String in this._testHash.getKeys() ) {
				this._getTestItem( key ).visible = false;
			}
			this._getTestItem( this._selectedID ).visible = true;
		}
		
		public function callSelectedTestItem( $function:String, $data:Object ):void
		{
			this._getTestItem( this._selectedID )[ $function ]( $data );
		}
		
		private function _getTestItem( $id:String ):MovieClip
		{
			return this._testHash.getValue( $id );
		}
		
		private function _onInit( $event:Event ):void
		{
			this[ "initialize" ]();
		}
	}
}
