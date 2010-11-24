class com.bedrockframework.plugin.util.ButtonUtil extends com.bedrockframework.core.base.StaticWidget {
	/*
	Variable Declarations
	*/
	private var _strClassName:String = "ButtonUtil";
	/*
	Disables all button events in specified buttons in the array.
	Accept one exception which will be enabled.
	*/
	public static function disableButtons($buttons:Array, $exception:Object):Void {
		var numLength:Number = $buttons.length;
		for (var a:Number = 0; a < numLength; a++) {
			var objButton:Object = $buttons[a];
			if (objButton != $exception) {
				objButton.enabled = false;
				objButton.onRollOver();
			} else {
				objButton.enabled = true;
				objButton.onRollOut();
			}
		}
	}
	/*	
	Enables all button events in specified buttons in the array.
	Accept one exception which will be disabled.
	*/
	public static function enableButtons($buttons:Array, $exception:Object):Void {
		var numLength:Number = $buttons.length;
		for (var a:Number = 0; a < numLength; a++) {
			var objButton:Object = $buttons[a];
			objButton.enabled = (objButton != $exception) ? true : false;
			if (objButton != $exception) {
				objButton.enabled = true;
				objButton.onRollOut();
			} else {
				objButton.enabled = false;
				objButton.onRollOver();
			}
		}
	}
}
