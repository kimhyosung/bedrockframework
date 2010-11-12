package com.bedrock.framework.plugin.delegate
{
	import com.bedrock.framework.core.base.BasicWidget;
	
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