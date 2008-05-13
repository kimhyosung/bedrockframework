package com.icg.madagascar.base
{
	import com.icg.util.ClassUtil;
	import com.icg.madagascar.base.BasicWidget;
	public class StaticWidget extends BasicWidget
	{
		public function StaticWidget()
		{
			this.output("Cannot Instantiate static class!", "error");
		}
	}
}