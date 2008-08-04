class com.bedrockframework.core.util.Delegate
{
	/*
	This function is used to create a callback.
	It accepts 3 parameters, scope, function to be called and an array of arguments.
	*/
	public static  function createCallback($scope:Object,$function:Function,$arguments:Array):Function
	{
		return create($scope,$function,$arguments);
	}
	/*
	This function is used to create a handler.
	It accepts a variable amount of parameters, scope, function and any additional parameters separated by commas.
	It returns any parameters passed by the parent object first then any addition arguments passed by the user.
	*/
	public static  function createHandler($scope:Object,$function:Function):Function
	{
		var arrArguments:Array=arguments.slice(2,arguments.length);
		// --------------------------------------------------------------------------------------
		return create($scope,$function,arrArguments);
	}
	/*
	Internal method returning a function to call.
	*/
	private static  function create($scope:Object,$function:Function,$arguments:Array):Function
	{
		var fnResult:Function=function () {
		var arrArguments:Array = arguments.concat($arguments);
		$function.apply($scope, arrArguments);
		};
		return fnResult;
	}
}