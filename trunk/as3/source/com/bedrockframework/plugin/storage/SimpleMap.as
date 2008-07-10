package com.bedrockframework.plugin.storage
{

	public dynamic class SimpleMap
	{
		public function SimpleMap()
		{
		}
		public function saveValue($name:String, $item:*):void
		{
			this[$name] = $item;
		}
		public function getValue($name:String):*
		{
			return this[$name];
		}
		public function pullValue($name:String):*
		{
			var tmpResult:* = this.getItem($name);
			this.removeValue($name);
			return tmpResult;
		}
		public function removeValue($name:String):void
		{
			delete this[$name];
		}
		
		public function clear():void{
			for (var p:String in this){
				this.removeValue(p);
			}
		}

	}

}