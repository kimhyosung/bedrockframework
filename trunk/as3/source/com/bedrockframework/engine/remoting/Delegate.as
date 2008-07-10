package com.bedrockframework.engine.remoting
{
	import com.bedrockframework.core.base.BasicWidget;
	
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