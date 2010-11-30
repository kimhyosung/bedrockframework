package com.bedrock.extension.model
{
	import com.bedrock.extension.delegate.JSFLDelegate;
	import com.bedrock.framework.core.base.StandardBase;
	import com.bedrock.framework.plugin.util.ArrayUtil;
	import com.bedrock.framework.plugin.util.XMLUtil2;
	
	public class NamingConventionModel extends StandardBase
	{
		/*
		Variable Delcarations
		*/
		[Bindable]
		private var _conventionsXML:XML;
		[Bindable]
		public var options:Array;
		[Bindable]
		public var groups:Array;
		
		public var delegate:JSFLDelegate;
		/*
		Constructor
		*/
		public function NamingConventionModel()
		{
			
		}
		
		public function initialize( $delegate:JSFLDelegate ):void
		{
			this.delegate = $delegate;
			
			this._parseConventions( this.delegate.openRelativeFile( "naming_conventions.bedrock" ) );
		}
		
		private function _parseConventions( $data:String ):void
		{
			this._conventionsXML = new XML( $data );
			this.options = new Array;
			for each( var optionXML:XML in this._conventionsXML.options..option ) {
				this.options.push( XMLUtil2.getAttributesAsObject( optionXML ) );
			}
			
			this.groups = new Array;
			var groupObj:Object = new Object;
			for each( var groupXML:XML in this._conventionsXML.groups..group ) {
				groupObj = XMLUtil2.getAttributesAsObject( groupXML );
				groupObj.types = new Array;
				for each( var typeXML:XML in groupXML..type ) {
					groupObj.types.push( XMLUtil2.getAsObject( typeXML ) );
				}
				this.groups.push( groupObj );
			}
		}
		
		public function getOptionByID( $id:String ):Object
		{
			return ArrayUtil.findItem( this.options, $id, "id" );
		}
		
	}
}