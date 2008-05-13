/**


Outputter
Output stand in for static classes.


*/
package com.icg.madagascar.output
{
	import com.icg.util.ClassUtil;
	import com.icg.madagascar.base.BasicWidget;
	import com.icg.madagascar.output.OutputManager;
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
		override public function toString():String
		{
			return this.strClassName;
		}
	}
}