package com.bedrockframework.plugin.delegate
{
	import com.bedrockframework.core.base.BasicWidget;
	import com.bedrockframework.plugin.remoting.IResponder;
	
	public class Delegate extends BasicWidget
	{
		/*
		Variable Declarations
		*/
		public var responder:IResponder;
		/*
		Constructor
		*/
		public function Delegate($responder:IResponder)
		{
			this.responder = $responder;
		}
		
	}
}