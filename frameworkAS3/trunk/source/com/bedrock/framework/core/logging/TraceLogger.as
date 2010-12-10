package com.bedrock.framework.core.logging
{
	import com.bedrock.framework.plugin.trigger.Trigger;
	
	import flash.utils.describeType;
	
	public class TraceLogger implements ILogger
	{
		/*
		Variable Delcarations
		*/
		public static const DYNAMIC:String = "dynamic";
		public static const STATIC:String = "static";
		public static const PRIMITIVE:String = "primitive";
		public static const DATA:String = "data";
		public static const NULL:String = "null";
		
		private var _detailDepth:uint;
		private var _trigger:Trigger;
		/*
		Constructor
		*/
		public function TraceLogger( $detailDepth:uint = 10 )
		{
			this._detailDepth = $detailDepth;
			
			this._trigger = new Trigger;
			this._trigger.silenceLogging = true;
			this._trigger.startStopwatch( 0.01 );
		}
		/*
		Creation Functions
		*/
		public function log( $trace:*, $target:*, $category:int ):String
		{
			var strTrace:String = this._format( $trace, $target, $category );
			trace( strTrace );
			return strTrace;
		}
		
		
		
		private function _format( $trace:*, $target:*, $category:int ):String
		{
			var strTarget:String = ( $target != null ) ? this._getClassNameFormat( describeType( $target ).@name ) : "[Global] ";
			var strCategory:String = this.getCategoryFormat( $category );
			var strTime:String = this._getTimeStamp();
			
			if ( $trace != null ) {
				switch( this.getType( describeType( $trace ).@name ) ) {
					case TraceLogger.DYNAMIC :
					case TraceLogger.STATIC :
						if ( this._detailDepth > 0 ) {
							return this._getComplexFormat( $trace, strTarget, strCategory, strTime );
						} else {
							return strTarget + strCategory + strTime + ": " + $trace.toString();
						}
						break;
					case TraceLogger.PRIMITIVE :
						return strTarget + strCategory + strTime + ": " + $trace.toString();
						break;
					case TraceLogger.DATA :
						return strTarget + strCategory + strTime + ": " + $trace.toXMLString();
						break;
				}
			} else {
				return strTarget + strTime + strCategory + " : null";
			}
			
			return new String;
		}
		
		private function _getTimeStamp():String
		{
			var time:Object = this._trigger.elapsed;
			return "[" + time.displayMinutes + ":" + time.displaySeconds + ":" + time.displayMilliseconds + "] ";
		}
		
		private function _getComplexFormat( $object:*, $target:*, $category:String, $time:String ):String
		{
			var strReturn:String = new String;
			strReturn += $target + $category + $time + "\n";
			strReturn += ("------------------------------------------------" + "\n");
			switch( this.getType( describeType( $object ).@name ) ) {
				case TraceLogger.DYNAMIC :
					strReturn += this._getDynamicFormat( $object, this._detailDepth );
					break;
				case TraceLogger.STATIC :
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
					
					switch( this.getType( xmlDescription.@name ) ) {
						case TraceLogger.DYNAMIC :
							strReturn += this._getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this._getDynamicFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.STATIC :
							strReturn += this._getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this._getStaticFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.PRIMITIVE :
						case TraceLogger.DATA :
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
					
					switch( this.getType( xmlVariable.@type ) ) {
						case TraceLogger.DYNAMIC :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth, "+") + this._getDynamicFormat( $object[ xmlVariable.@name ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.STATIC :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth, "+") + this._getStaticFormat( $object[ xmlVariable.@name ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.PRIMITIVE :
						case TraceLogger.DATA :
							strReturn += this._getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth );
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
		
		private function getCategoryFormat($category:int):String
		{
			return "[" + Logger.getCategoryLabel( $category ) + "] ";
		}
		/*
		Check whether argument is an object
	 	*/
		private function getType( $name:String ):String
		{
			if ( $name == "Array" || $name == "Object" ) {
				return TraceLogger.DYNAMIC;
			} else if ( $name == "XML" || $name == "XMLList" ) {
				return TraceLogger.DATA;
			} else if ( $name == "String" || $name == "Boolean" || $name == "Number" || $name == "int" || $name == "uint" ) {
				return TraceLogger.PRIMITIVE;
			} else if ( $name == "" ) {
				return TraceLogger.NULL;
			} else {
				return TraceLogger.STATIC;
			}
		}
		
		
	}
}