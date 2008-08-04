/**
*/
import com.bedrockframework.core.event.GenericEvent;
import com.bedrockframework.core.util.Delegate;
import com.bedrockframework.plugin.util.ArrayUtil;

class com.bedrockframework.core.dispatcher.EventDispatcher extends com.bedrockframework.core.base.StaticWidget
{
	private var _strClassName:String = "EventDispatcher";
	/*
	Initialize as EventDispatcher
	*/
	public static function initialize($target:Object)
	{
		EventDispatcher.setupListenerFunctions($target);
		EventDispatcher.setupAddRemoveFunctions($target);
		EventDispatcher.setupDispatchFunction($target);
		EventDispatcher.setupDefaults($target);
	}
	/*
	Declare Defaults
	*/
	public static function setupDefaults($target:Object)
	{
		$target.bolOutputEvents = false;
		$target.bolIgnoreWarnings = false;
		$target.objListeners = new Object();
	}

	/*
	Listener Functions
	*/
	public static function setupListenerFunctions($target:Object):Void
	{
		$target.getListeners = function($type:String):Array 
		{
			if (this.objListeners[$type] == undefined) {
				this.objListeners[$type] = new Array();
			}
			return this.objListeners[$type];
		};
		$target.clearListeners = function($type:String):Void 
		{
			if ($type != undefined) {
				this.objListeners[$type] = new Array();
			} else {
				for (var e in this.objListeners) {
					this.objListeners[e] = new Array();
				}
			}
		};
	}

	/*
	Add/ Remove Listeners
	*/
	public static function setupAddRemoveFunctions($target:Object):Void
	{
		$target.addEventListener = function($type:String, $object:Object, $handler:Function)
		{
			var arrQueue:Array = this.getListeners($type);
			
			if ($handler != undefined) {
				var fnDelegate:Function = Delegate.createHandler($object, ($handler));
				this.objListeners[$type].unshift({scope:$object, handler:$handler, delegate:fnDelegate});
			} else {
				throw new Error("Undefined Handler!");
			}

		};
		$target.removeEventListener = function($type:String, $object:Object, $handler:Function)
		{
			var arrQueue:Array = this.getListeners($type, $object);
			var numLength:Number = arrQueue.length;
			for (var i:Number = numLength; i > -1; i--) {
				if (arrQueue[i].handler == $handler) {
					arrQueue.splice(i, 1);					
				}
			}			
		};
	}
	/*
	Dispatch Events
	*/
	public static function setupDispatchFunction($target:Object):Void
	{
		$target.dispatchEvent = function($type:GenericEvent)
		{
			var arrQueue:Array = this.getListeners($type.type, $type.target);
			for (var t in arrQueue) {
				arrQueue[t].delegate($type);
			}
		};
	}
}