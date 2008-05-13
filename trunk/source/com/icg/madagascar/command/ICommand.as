package com.icg.madagascar.command
{
	import com.icg.madagascar.events.GenericEvent;

	public interface ICommand
	{
		function execute($event:GenericEvent):void;
	}
}