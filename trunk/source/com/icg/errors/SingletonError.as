package com.icg.errors
{
	public class SingletonError extends Error
	{
		public function SingletonError($target:Object)
		{
			super($target + " : Only one singleton instance can be instantiated!", 1);
		}
	}
}