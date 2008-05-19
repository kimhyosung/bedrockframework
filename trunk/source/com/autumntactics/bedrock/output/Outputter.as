/**


Outputter
Output stand in for static classes.


*/
package com.autumntactics.bedrock.output
{
	import com.autumntactics.util.ClassUtil;
	import com.autumntactics.bedrock.base.BasicWidget;
	import com.autumntactics.bedrock.output.OutputManager;
	public class Outputter extends BasicWidget
	{
		/*
		Variable Definitions
		*/
		private var strClassName:String;
		/*
		Constructor
		*/
		public function Outputter($target:* = null)
		{
			this.strClassName = (typeof $target == "string") ? $target :ClassUtil.getDisplayClassName($target);
			OutputManager.send("Constructed","constructor",this);
		}
		public function toString():String
		{
			return this.strClassName;
		}
	}
}