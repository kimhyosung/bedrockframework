import com.bedrockframework.core.event.GenericEvent;
import com.bedrockframework.core.command.ICommand;

class com.TestCommand implements ICommand
{
	/*
	Variable Decarations
	*/
	private static var __arrCommandCollection:Array;
	private static var __bolInitialized:Boolean;
	
	/*
	Initialize the FrontController
	*/
	public function TestCommand()
	{
		trace("[TestCommand] : Constructed");
	}

	public function execute($event:GenericEvent):Void
	{
		trace("[TestCommand] : Executed");
	}
	
}