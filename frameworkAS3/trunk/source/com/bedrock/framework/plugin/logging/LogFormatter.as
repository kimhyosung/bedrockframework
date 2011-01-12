package com.bedrock.framework.plugin.logging
{
	import com.bedrock.framework.core.logging.LogData;
	import com.bedrock.framework.core.logging.LogLevel;
	
	import flash.utils.describeType;
	
	public class LogFormatter
	{
		public static const DYNAMIC:String = "dynamic";
		public static const STATIC:String = "static";
		public static const PRIMITIVE:String = "primitive";
		public static const DATA:String = "data";
		public static const NULL:String = "null";
		
		private var _detailDepth:uint;
		private var _data:LogData;
			
		public function LogFormatter( $detailDepth:uint )
		{
			this._detailDepth = $detailDepth;
		}
		
		public function format( $trace:*, $data:LogData ):String
		{
			this._data = $data;
			
			var baseFormat:String;
			if ( $data.category > LogLevel.STATUS ) {
				baseFormat = this._data.detailMedium + this._data.categoryLabel;
			} else {
				baseFormat = this._data.detailLow + this._data.categoryLabel;
			}
			
			if ( $trace != null ) {
				
				switch( this._getType( describeType( $trace ).@name ) ) {
					case LogFormatter.DYNAMIC :
					case LogFormatter.STATIC :
						if ( this._detailDepth > 0 ) {
							return this._getComplexFormat( $trace, this._data.detailMedium, this._data.categoryLabel, this._data.timeStamp );
						} else {
							return baseFormat + this._data.timeStamp + ": " + $trace.toString();
						}
						break;
					case LogFormatter.PRIMITIVE :
						return baseFormat + this._data.timeStamp + ": " + $trace.toString();
						break;
					case LogFormatter.DATA :
						return baseFormat + this._data.timeStamp + ": " + $trace.toXMLString();
						break;
				}
			} else {
				return baseFormat + this._data.timeStamp + " : null";
			}
			
			return new String;
		}
		
		private function _getComplexFormat( $object:*, $target:*, $category:String, $time:String ):String
		{
			var strReturn:String = new String;
			strReturn += $target + $category + $time + "\n";
			strReturn += ("------------------------------------------------" + "\n");
			switch( this._getType( describeType( $object ).@name ) ) {
				case LogFormatter.DYNAMIC :
					strReturn += this._getDynamicFormat( $object, this._detailDepth );
					break;
				case LogFormatter.STATIC :
					strReturn += this._getStaticFormat( $object, this._detailDepth );
					break;
			}
			
			return strReturn;
		}
		
		
		private function _getDynamicFormat( $object:*, $detailLevel:uint = 3, $depth:uint = 0 ):String
		{
			var numDepth:uint = $depth += 1;
			var objTrace:Object = $object;
			
			var strReturn:String = new String;
			if ( $depth <= $detailLevel ) {
				
				var xmlDescription:*;
				for (var t:String in objTrace ) {
					
					xmlDescription = describeType( objTrace[ t ] );
					
					switch( this._getType( xmlDescription.@name ) ) {
						case LogFormatter.DYNAMIC :
							strReturn += this._getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this._getDynamicFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case LogFormatter.STATIC :
							strReturn += this._getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this._getStaticFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case LogFormatter.PRIMITIVE :
						case LogFormatter.DATA :
							strReturn += this._getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth );
							break;
					}
					
				}
			}
			return strReturn;
		}
		
		private function _getStaticFormat( $object:*, $detailLevel:uint = 3, $depth:uint = 0 ):String
		{
			var numDepth:uint = $depth += 1;
			var strReturn:String = new String;
			
			if ( $depth <= $detailLevel ) {
				
				var xmlDescription:*= describeType( $object );
				for each( var xmlVariable:* in xmlDescription..variable ) {
					
					switch( this._getType( xmlVariable.@type ) ) {
						case LogFormatter.DYNAMIC :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name.toString() ], numDepth, "+") + this._getDynamicFormat( $object[ xmlVariable.@name.toString() ], $detailLevel, numDepth+1 );
							break;
						case LogFormatter.STATIC :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name.toString() ], numDepth, "+") + this._getStaticFormat( $object[ xmlVariable.@name.toString() ], $detailLevel, numDepth+1 );
							break;
						case LogFormatter.PRIMITIVE :
						case LogFormatter.DATA :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name.toString() ], numDepth );
							break;
					}
					
				}
			}
			
			
			return strReturn;
		}
		
		private function _getVariableFormat( $className:String, $variableName:String, $value:*, $depth:uint = 0, $prefix:String = "-"):String
		{
			var strValue:String;
			if ( $value is XML || $value is XMLList ) {
				strValue = $value.toXMLString();
			} else if ( $value == null ) {
				strValue = "null";
			} else {
				strValue = $value.toString();
			}
			return ( this._getTabs( $depth ) + $prefix + this._getClassNameFormat( $className ) + $variableName + " : " + strValue + "\n");
		}
		private function _getTabs( $count:uint ):String
		{
			var strTabs:String = new String();
			for (var i:int = 0 ; i < $count; i++) {
				strTabs += "   ";
			}
			return strTabs
		}
		
		private function _getClassNameFormat( $name:String ):String
		{
			if ( $name.lastIndexOf( "::" ) != -1 ) {
				return "[" + $name.substring( ( $name.lastIndexOf( "::" ) +2 ), $name.length ) + "] ";
			} else {
				return "[" + $name + "] ";
			}
		}
		/*
		Check whether argument is an object
	 	*/
		private function _getType( $name:String ):String
		{
			if ( $name == "Array" || $name == "Object" ) {
				return LogFormatter.DYNAMIC;
			} else if ( $name == "XML" || $name == "XMLList" ) {
				return LogFormatter.DATA;
			} else if ( $name == "String" || $name == "Boolean" || $name == "Number" || $name == "int" || $name == "uint" ) {
				return LogFormatter.PRIMITIVE;
			} else if ( $name == "" ) {
				return LogFormatter.NULL;
			} else {
				return LogFormatter.STATIC;
			}
		}
	}
}