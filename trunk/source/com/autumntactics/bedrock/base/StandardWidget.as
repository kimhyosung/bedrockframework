package com.autumntactics.bedrock.base
{
	import com.autumntactics.bedrock.logging.LogLevel;

	public class StandardWidget extends BasicWidget
	{
		public function StandardWidget($silenceConstruction:Boolean = true)
		{
			super();
			if ($silenceConstruction) {
				this.log(LogLevel.CONSTRUCTOR, "Constructed");
			}
		}
	}
}