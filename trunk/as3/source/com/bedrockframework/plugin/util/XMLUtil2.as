package com.bedrockframework.plugin.util
{
	import com.bedrockframework.core.base.StaticWidget;
	
	public class XMLUtil2 extends StaticWidget
	{
		
		public static function getAsObject( $data:* ):Object
		{
			return VariableUtil.combineObjects(  XMLUtil2.getAttributesAsObject( $data ), XMLUtil2.getNodesAsObject( $data ) );
		}
		
		public static function getNodesAsObject( $data:* ):Object
		{
			var xmlData:XML = XMLUtil2.getAsXML( $data );
			var objConversion:Object = new Object;
			
			if ( xmlData.hasComplexContent() ) {
				var numLength:Number = xmlData.children().length();
				for (var i:int = 0; i  < numLength; i++) {
					objConversion[ xmlData.child( i ).name() ] = VariableUtil.sanitize( xmlData.child( i ) );
				}
			}
			return objConversion;
		}
		public static function getAttributesAsObject( $node:* ):Object
		{
			var objResult:Object = new Object();
			
			var xmlTemp:XMLList = new XMLList($node);
			var xmlAttributes:XMLList = xmlTemp.attributes();
			
			var numLength:int = xmlAttributes.length();		
			for (var i:int = 0; i < numLength; i ++) {
				objResult[ xmlAttributes[ i ].name().toString() ] = VariableUtil.sanitize( xmlAttributes[ i ] );
			}	
				
			return objResult;
		}

		public static function getAsXML( $data:* ):XML
		{
			if ( $data is XML ) {
				return $data;
			} else if ( XMLList( $data ).length() == 1 ) {
				return new XML( $data );
			} else {
				var xmlData:XML = new XML( <data/> );
				xmlData.appendChild( $data );
				return xmlData;
			}
		}
		
		public static function filterByAttribute( $data:XML, $attribute:String, $value:String):XML
		{
			return XMLUtil2.getAsXML( $data.children().(attribute($attribute) == $value ) );
		}
		public static function filterByNode( $data:XML, $name:String, $value:String):XML
		{
			var xmlList:XMLList = $data.children().(child($name) == $value);
			return XMLUtil2.getAsXML( xmlList );
		}
		
		
	}
}