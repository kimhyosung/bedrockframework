package com.bedrock.extension.delegate
{
	import adobe.utils.MMExecute;
	
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	
	dynamic public class JSFLDelegate extends Proxy
	{
		/*
		Variable Delcarations
		*/
		public var jsfl:String;
		/*
		Constructor
		*/
		public function JSFLDelegate()
		{
		}
		public function initialize( $jsfl:String ):void
		{
			this.jsfl = $jsfl;
		}
		/*
		Script Functions
	 	*/
		private function runScript($file:String, $function:String, $arguments:Array):*
		{
			var strArguments:String = this.escapeArguments( $arguments );
			var strExecute:String;
			if ( $arguments.length == 0 ) {
				strExecute = "fl.runScript( fl.configURI + '" + this.jsfl + "', '" + $function + "');";
			} else {
				strExecute = "fl.runScript( fl.configURI + '" + this.jsfl + "', '" + $function + "', '" + strArguments + "');";
			}
			var objResult:* = MMExecute(strExecute);
			return unescape( objResult );
		}
		private function escapeArguments( $arguments:Array ):String
		{
			var arrArguments:Array = $arguments;
			var numLength:int = arrArguments.length;
			for ( var i:int = 0; i < numLength; i ++ ) {
				if ( arrArguments[ i ] is XML ) {
					arrArguments[ i ] = escape( arrArguments[ i ].toXMLString() );
				} else {
					arrArguments[ i ] = escape( arrArguments[ i ].toString() );
				}
			}
			return arrArguments.join("','");
		}
		/*
		Property Definitions
		*/

		flash_proxy override function callProperty( $name: *, ...$arguments:Array ):*
		{
			return this.runScript( this.jsfl, $name.toString(), $arguments );
		}


		flash_proxy override function getProperty( $name: * ):*
		{
			return this[ $name.toString() ];
		}


		flash_proxy override function setProperty($name: *, $value: * ):void
		{
			this[ $name.toString() ] = $value;
		}


		flash_proxy override function deleteProperty( $name: * ):Boolean
		{
			delete this[ $name.toString() ];
			return true;
		}

	}
}