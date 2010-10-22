package com.bedrockframework.core.logging
{
	import flash.utils.Dictionary;
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
		
		private var _dicCategories:Dictionary;
		private var _numDetailDepth:uint;
		/*
		Constructor
		*/
		public function TraceLogger( $detailDepth:uint = 10 )
		{
			this._numDetailDepth = $detailDepth;
		}
		/*
		Creation Functions
		*/
		public function log( $trace:*, $target:*, $category:int ):String
		{
			var strTrace:String = this.format( $trace, $target, $category );
			trace( strTrace );
			return strTrace + "\n";
		}
		
		
		
		private function format( $trace:*, $target:*, $category:int ):String
		{
			var strTarget:String = ( $target != null ) ? this.getClassNameFormat( describeType( $target ).@name ) : "[Global] ";
			var strCategory:String = this.getCategoryFormat( $category );
			
			switch( this.getType( describeType( $trace ).@name ) ) {
				case TraceLogger.DYNAMIC :
				case TraceLogger.STATIC :
					if ( this._numDetailDepth > 0 ) {
						return this.getComplexFormat( $trace, strTarget, strCategory );
					} else {
						return strTarget + strCategory + " : " + $trace.toString();
					}
					break;
				case TraceLogger.PRIMITIVE :
					return strTarget + strCategory + " : " + $trace.toString();
					break;
				case TraceLogger.DATA :
					return strTarget + strCategory + " : " + $trace.toXMLString();
					break;
				case TraceLogger.NULL :
					return strTarget + strCategory + " : null";
					break;
			}
			return new String;
		}
		
		private function getComplexFormat( $object:*, $target:*, $category:String ):String
		{
			var strReturn:String = new String;
			strReturn += $target + ": " + $category + "\n";
			strReturn += ("---------------------------------------------------------------------------------" + "\n");
			switch( this.getType( describeType( $object ).@name ) ) {
				case TraceLogger.DYNAMIC :
					strReturn += this.getDynamicFormat( $object, this._numDetailDepth );
					break;
				case TraceLogger.STATIC :
					strReturn += this.getStaticFormat( $object, this._numDetailDepth );
					break;
			}
			
			return strReturn;
		}
		
		
		private function getDynamicFormat( $object:*, $detailLevel:uint = 3, $depth:uint = 0 ):String
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
							strReturn += this.getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this.getDynamicFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.STATIC :
							strReturn += this.getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth, "+") + this.getStaticFormat( objTrace[ t ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.PRIMITIVE :
						case TraceLogger.DATA :
							strReturn += this.getVariableFormat( xmlDescription.@name, t, objTrace[ t ], numDepth );
							break;
					}
					
				}
			}
			return strReturn;
		}
		
		private function getStaticFormat( $object:*, $detailLevel:uint = 3, $depth:uint = 0 ):String
		{
			var numDepth:uint = $depth += 1;
			var strReturn:String = new String;
			
			if ( $depth <= $detailLevel ) {
				
				var xmlDescription:*= describeType( $object );
				for each( var xmlVariable:* in xmlDescription..variable ) {
					
					switch( this.getType( xmlVariable.@type ) ) {
						case TraceLogger.DYNAMIC :
							strReturn += this.getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth, "+") + this.getDynamicFormat( $object[ xmlVariable.@name ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.STATIC :
							strReturn += this.getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth, "+") + this.getStaticFormat( $object[ xmlVariable.@name ], $detailLevel, numDepth+1 );
							break;
						case TraceLogger.PRIMITIVE :
						case TraceLogger.DATA :
							strReturn += this.getVariableFormat( xmlVariable.@type, xmlVariable.@name, $object[ xmlVariable.@name ], numDepth );
							break;
					}
					
				}
			}
			
			
			return strReturn;
		}
		
		private function getVariableFormat( $className:String, $variableName:String, $value:*, $depth:uint = 0, $prefix:String = "-"):String
		{
			var strValue:String = ( $value is XML || $value is XMLList ) ? $value.toXMLString() : $value.toString();
			return ( this.getTabs( $depth ) + $prefix + this.getClassNameFormat( $className ) + $variableName + " : " + strValue + "\n");
		}
		private function getTabs( $count:uint ):String
		{
			var strTabs:String = new String();
			for (var i:int = 0 ; i < $count; i++) {
				strTabs += "   ";
			}
			return strTabs
		}
		
		private function getClassNameFormat( $name:String ):String
		{
			if ( $name.lastIndexOf( "::" ) != -1 ) {
				return "[" + $name.substring( ( $name.lastIndexOf( "::" ) +2 ), $name.length ) + "] ";
			} else {
				return "[" + $name + "] ";
			}
		}
		
		private function getCategoryFormat($category:int):String
		{
			return "[" + Logger.getCategoryLabel( $category ) + "]";
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