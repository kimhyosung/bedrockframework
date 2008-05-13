package com.icg.madagascar.base
{
	import com.icg.madagascar.output.OutputManager;
	import com.icg.util.ClassUtil;

	public class BasicWidget
	{
		private var strClassName:String;
		private var bolOutputSilenced:Boolean;

		public function BasicWidget()
		{
			this.bolOutputSilenced=false;
			this.strClassName=ClassUtil.getDisplayClassName(this);
		}
		public function output($trace:*,$category:*=0)
		{
			if (!this.bolOutputSilenced) {
				OutputManager.send($trace,$category,this);
			}
		}
		public function get outputSilenced():Boolean
		{
			return this.bolOutputSilenced;
		}
		public function set outputSilenced($status:Boolean):void
		{
			this.bolOutputSilenced=$status;
		}
		/*
		*/
		public function toString():String
		{
			return this.strClassName;
		}
	}
}