class com.bedrockframework.plugin.util.TextFieldUtil extends com.bedrockframework.core.base.StaticWidget
{
	/*
	Class identifier string.
	*/
	private var _strClassName:String = "TextFieldUtil";
	/*
	Set focus functions
	*/
	public static function applyFocusDefaults($textField:TextField, $defaultText:String, $password:Boolean):Void
	{
		$textField.text = $defaultText;
		$textField.defaultText = $defaultText;
		if (!$password) {
			$textField.onSetFocus = function()
			{
				if (this.text == this.defaultText) {
					this.text = "";
				}
			};
			$textField.onKillFocus = function()
			{
				if (this.text == "") {
					this.text = this.defaultText;
				}
			};
		} else {
			$textField.onSetFocus = function()
			{
				if (this.text == this.defaultText) {
					this.text = "";
					this.password = true;
				}
			};
			$textField.onKillFocus = function()
			{
				if (this.text == "") {
					this.text = this.defaultText;
					this.password = false;
				}
			};
		}
	}
	public function applyFocusClear($textField:TextField):Void
	{
		$textField.onSetFocus = function()
		{
			this.text = "";
		};
	}
	/*
	Get text value in field by checking against the default value
	*/
	public static function getFieldValue($textField:TextField):String
	{
		if ($textField.text == $textField.defaultText) {
			return "";
		} else {
			return $textField.text;
		}
	}
}