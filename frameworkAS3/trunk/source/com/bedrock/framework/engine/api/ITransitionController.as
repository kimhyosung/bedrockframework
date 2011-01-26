package com.bedrock.framework.engine.api
{
	public interface ITransitionController
	{
		function initialize( $shellView:* ):void;
		function transition( $details:* = null ):void;
		function prepareInitialLoad():void;
		function prepareInitialTransition( $details:Object ):void;
		function prepareStandardTransition( $details:Object ):void;
		function prepareDeeplinkTransition( $details:Object ):void;
		function runShellTransition():void;
		function runTransition():void;
	}
}