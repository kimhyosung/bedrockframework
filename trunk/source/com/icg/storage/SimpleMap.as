package com.icg.storage
{
	import com.icg.madagascar.base.BasicWidget;
	public dynamic class SimpleMap extends BasicWidget
	{
		public function SimpleMap()
		{
		}
		public function set($name:String, $item:*):void
		{
			this[$name] = $item;
		}
		public function get($name:String):*
		{
			return this[$name];
		}
		public function pull($name:String):*
		{
			var tmpResult:* = this.getItem($name);
			this.remove($name);
			return tmpResult;
		}
		public function remove($name:String):void
		{
			delete this[$name];
		}
		public function clear():void{
			for (var p:String in this){
				this.remove(p);
			}
		}

	}

}