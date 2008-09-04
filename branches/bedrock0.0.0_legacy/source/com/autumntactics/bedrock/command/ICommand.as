package com.autumntactics.bedrock.command
{
	import com.autumntactics.bedrock.events.GenericEvent;

	public interface ICommand
	{
		function execute($event:GenericEvent):void;
	}
}