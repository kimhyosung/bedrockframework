package com.builtonbedrock.bedrock.base
{
	import com.builtonbedrock.util.ClassUtil;
	import com.builtonbedrock.bedrock.base.BasicWidget;
	import com.builtonbedrock.bedrock.logging.Logger;
	import com.builtonbedrock.bedrock.logging.LogLevel;
	
	public class StaticWidget extends BasicWidget
	{
		public function StaticWidget()
		{
			Logger.log(this, LogLevel.ERROR, "Cannot Instantiate static class!");
		}
	}
}