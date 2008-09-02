package com.builtonbedrock.bedrock.base
{
	import com.builtonbedrock.bedrock.logging.LogLevel;

	public class StandardWidget extends BasicWidget
	{
		public function StandardWidget($silenceConstruction:Boolean = false)
		{
			super();
			if (!$silenceConstruction) {
				this.log(LogLevel.CONSTRUCTOR, "Constructed");
			}
		}
	}
}