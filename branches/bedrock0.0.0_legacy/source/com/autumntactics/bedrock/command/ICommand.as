package com.builtonbedrock.bedrock.command
{
	import com.builtonbedrock.bedrock.events.GenericEvent;

	public interface ICommand
	{
		function execute($event:GenericEvent):void;
	}
}