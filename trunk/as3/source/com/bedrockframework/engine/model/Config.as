/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine.model
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.api.IConfig;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.plugin.util.StringUtil;
	import com.bedrockframework.plugin.util.VariableUtil;
	import com.bedrockframework.plugin.util.XMLUtil;
	
	import flash.system.Capabilities;
	
	public class Config extends StandardWidget implements IConfig
	{
		/*
		Variable Declarations
		*/	
		private var _xmlConfig:XML;
		private var _xmlParamValues:XML;
		
		private var _xmlSettingValues:XML;
		private var _xmlPathValues:XML;
		private var _xmlVariableValues:XML;
		
		private var _xmlPageValues:XML;
		private var _xmlContainerValues:XML;
		private var _xmlLocaleValues:XML;
		/*
		Constructor
		*/
		public function Config()
		{
			this._xmlParamValues = new XML( <data/> );
		}
		/*
		Initialize
		*/
		public function initialize( $data:String, $url:String ):void
		{
			this._xmlConfig = new XML($data);
			
			this.parseXML($data);
			
			this.saveSettingValue( BedrockData.URL, $url );
			this.saveSettingValue( BedrockData.MANUFACTURER, Capabilities.manufacturer );
			this.saveSettingValue( BedrockData.SYSTEM_LANGUAGE, Capabilities.language );
			this.saveSettingValue( BedrockData.OS, Capabilities.os );
			this.saveSettingValue( BedrockData.ENVIRONMENT, this.getCurrentEnvironment( $url ) );
			
			this.parseEnvironmentValues( $url );
		}

		
		private function parseXML($data:String):void
		{
			this._xmlSettingValues = this.convertToXML( this._xmlConfig.settings..setting );
			this._xmlPathValues = this.convertToXML( this._xmlConfig.settings..path );
			this._xmlVariableValues = this.convertToXML( this._xmlConfig.settings..variable );
			
			this._xmlPageValues = new XML( this._xmlConfig.pages );
			this._xmlContainerValues = new XML( this._xmlConfig.containers );
			this._xmlLocaleValues = new XML( this._xmlConfig.locales );
			
			this.saveSettingValue( BedrockData.CURRENT_LOCALE, this.getSettingValue( BedrockData.DEFAULT_LOCALE ) );
			
			this.applyCacheSettings();
		}
		/*
		Environment Functions
		*/
		private function getCurrentEnvironment( $url:String ):String
		{
			var strURL:String = $url;
			var xmlEnvironments:XMLList = this._xmlConfig.environments..environment;
			var xmlPatterns:XMLList;
			for each ( var xmlEnvironment:XML in xmlEnvironments ) {
				xmlPatterns = xmlEnvironment..pattern;
				for each( var xmlPattern:XML in xmlPatterns ) {
					if ( strURL.indexOf( xmlPattern.@value ) != -1 ) {
						return xmlEnvironment.@id;
					}
				}
			}
			return BedrockData.PRODUCTION;
		}
		
		private function parseEnvironmentValues( $url:String ):void
		{
			var xmlDefaultEnvironment:XML = this._xmlConfig.environments..environment.( @id == BedrockData.DEFAULT )[ 0 ];
			var strEnvironment:String =  this.getSettingValue( BedrockData.ENVIRONMENT );
			var xmlCurrentEnvironment:XML = this._xmlConfig.environments..environment.( @id == strEnvironment )[ 0 ];
			
			this._xmlPathValues = this.mergeXMLList( this._xmlPathValues, xmlDefaultEnvironment..path );
			this._xmlPathValues = this.mergeXMLList( this._xmlPathValues, xmlCurrentEnvironment..path );
			
			this._xmlSettingValues = this.mergeXMLList( this._xmlSettingValues, xmlDefaultEnvironment..setting );
			this._xmlSettingValues = this.mergeXMLList( this._xmlSettingValues, xmlCurrentEnvironment..setting );
			
			this._xmlVariableValues = this.mergeXMLList( this._xmlVariableValues, xmlDefaultEnvironment..variable );
			this._xmlVariableValues = this.mergeXMLList( this._xmlVariableValues, xmlCurrentEnvironment..variable );
		}
		/*
		Param Functions
		*/
		public function parseParamObject($data:Object):void
		{
			for (var d:String in $data){
				this.saveParamValue( d, VariableUtil.sanitize($data[d]) ); 
			}
		}
		public function parseParamString($values:String, $variableSeparator:String ="&", $valueSeparator:String =  "="):void
		{
			if ($values != null) {
				var strValues:String = $values;
				var strVariableSeparator:String = $variableSeparator;
				var strValueSeparator:String = $valueSeparator;
				//
				var arrValues:Array = strValues.split( strVariableSeparator );
				var numLength:int = arrValues.length;
				for (var v:int = 0; v < numLength; v++) {
					var arrVariable:Array = arrValues[v].split(strValueSeparator);
					this.saveParamValue( arrVariable[0], arrVariable[1] ); 
				}
			} else {
				this.warning("No params to parse!");
			}
		}
		public function saveParamValue( $key:String, $value:*):void
		{
			var xmlList:XMLList = new XMLList( <param id={ $key } value={ $value } /> );
			this._xmlSettingValues = this.mergeXMLList( this._xmlSettingValues, xmlList, true );
			this._xmlVariableValues = this.mergeXMLList( this._xmlVariableValues, xmlList, true );
		}
		/*
		Cache Settings
		*/
		private function applyCacheSettings():void
		{
			if ( this.getSettingValue(BedrockData.CACHE_PREVENTION_ENABLED) ) {
				this.saveSettingValue( BedrockData.CACHE_KEY, StringUtil.generateUniqueKey( 10 ) );
			} else {
				this.saveSettingValue( BedrockData.CACHE_KEY, "");
			}
		}
		/*
		Save Functions
		*/
		public function saveSettingValue($key:String, $value:*, $overrideOnly:Boolean = false ):void
		{
			var xmlResult:XML = this._xmlSettingValues.children().( @id == $key )[ 0 ];
			if ( xmlResult != null ) {
				xmlResult.children().( @id == $key )[ 0 ].@value = $value;
			} else if ( !$overrideOnly ) {
				this._xmlSettingValues.appendChild( <setting id={$key} value={$value} /> );
			}
		}
		public function saveVariableValue($key:String, $value:*, $overrideOnly:Boolean = false ):void
		{
			var xmlResult:XML = this._xmlVariableValues.children().( @id == $key )[ 0 ];
			if ( xmlResult != null ) {
				xmlResult.children().( @id == $key )[ 0 ].@value = $value;
			} else if ( !$overrideOnly ) {
				this._xmlVariableValues.appendChild( <variable id={$key} value={$value} /> );
			}
		}
		/*
		Get Functions
		*/
		public function getSettingValue($key:String):*
		{
			return VariableUtil.sanitize( this._xmlSettingValues.children().( @id == $key )[ 0 ].@value );
		}
		public function getPathValue($key:String):*
		{
			return VariableUtil.sanitize( this._xmlPathValues.children().( @id == $key )[ 0 ].@value );
		}
		public function getVariableValue($key:String):*
		{
			return VariableUtil.sanitize( this._xmlVariableValues.children().( @id == $key )[ 0 ].@value );
		}
		
		/*
		Internal Functions
		*/
		private function convertToXML( $list:XMLList ):XML
		{
			var xmlData:XML = new XML( <data/> );
			xmlData.appendChild( $list );
			return xmlData;
		}
		private function mergeXMLList( $target:XML, $source:XMLList, $overrideOnly:Boolean = false ):XML
		{
			var xmlTarget:XML = $target;
			
			var xmlSource:XML = new XML( <list/> );
			xmlSource.appendChild( $source );
			
			var xmlResult:XML;
			for each( var xmlItem:XML in xmlSource.children() ) {
				xmlResult = xmlTarget.children().( @id == xmlItem.@id )[ 0 ];
				if ( xmlResult != null ) {
					xmlResult.@value = xmlItem.@value;
				} else if ( !$overrideOnly ) {
					xmlTarget.appendChild( xmlItem );
				}
			}
			return xmlTarget;
		}
		/*
		Property Definitions
		*/
		public function get containers():XML
		{
			return this._xmlContainerValues;
		}
		public function get locales():XML
		{
			return this._xmlLocaleValues;
		}
		public function get pages():XML
		{
			return this._xmlPageValues;
		}
	}
}

