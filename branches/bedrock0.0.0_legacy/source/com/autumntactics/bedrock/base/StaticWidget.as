package com.autumntactics.bedrock.base
{
	import com.autumntactics.util.ClassUtil;
	import com.autumntactics.bedrock.base.BasicWidget;
	import com.autumntactics.bedrock.logging.Logger;
	import com.autumntactics.bedrock.logging.LogLevel;
	
	public class StaticWidget extends BasicWidget
	{
		public function StaticWidget()
		{
			Logger.log(this, LogLevel.ERROR, "Cannot Instantiate static class!");
		}
	}
}