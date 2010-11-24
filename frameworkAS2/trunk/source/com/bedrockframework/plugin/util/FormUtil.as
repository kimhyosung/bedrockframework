class com.bedrockframework.plugin.util.FormUtil extends com.bedrockframework.core.base.StaticWidget {
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "FormUtil";
	/*
	Clear and set default value of textfield on focus
	*/
	static function setFocusDefault($field:TextField, $defaultString:String) {
		$field.onSetFocus = function() {
			if ($field.text == $defaultString) {
				$field.text = "";
			}
		};
		$field.onKillFocus = function() {
			if ($field.text == "") {
				$field.text = $defaultString;
			}
		};
		$field.text = $defaultString;
	}
}
