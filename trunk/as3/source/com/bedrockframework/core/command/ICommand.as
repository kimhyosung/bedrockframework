package com.bedrockframework.core.command
{
	import com.bedrockframework.core.event.GenericEvent;

	public interface ICommand
	{
		function execute($event:GenericEvent):void;
	}
}