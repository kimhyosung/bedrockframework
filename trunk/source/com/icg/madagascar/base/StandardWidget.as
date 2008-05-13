package com.icg.madagascar.base
{
	import com.icg.madagascar.base.BasicWidget;

	public class StandardWidget extends BasicWidget
	{
		public function StandardWidget($outputConstruction:Boolean = true)
		{
			super();
			if ($outputConstruction) {
				this.output("Constructed","constructor");
			}
		}
	}
}