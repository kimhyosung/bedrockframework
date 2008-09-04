package 
{
	import flash.display.MovieClip;
	import com.autumntactics.gadget.IClonable;
	public class ClonedClip extends MovieClip implements IClonable
	{
		private var numID:int;
		private var numRow:int;
		private var numColumn:int;
		/*
		Property Definitions
		*/
		public function set id($id:int):void
		{
			this.numID = $id;
		}
		public function get id():int
		{
			return this.numID;
		}
		public function set row($row:int):void
		{
			this.numRow = $row;
		}
		public function get row():int
		{
			return this.numRow;
		}
		public function set column($column:int):void
		{
			this.numColumn = $column;
		}
		public function get column():int
		{
			return this.numColumn;
		}


	}
}