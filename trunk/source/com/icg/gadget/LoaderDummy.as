package com.icg.gadget{
	import com.icg.madagascar.base.SpriteWidget;
	import com.icg.gadget.IClonable;
	import com.icg.tools.VisualLoader;
	public class LoaderDummy extends SpriteWidget implements IClonable {
		/*
		Variable Definitions
		*/
		private var numID:int;
		private var numRow:int;
		private var numColumn:int;
		private var objLoader:VisualLoader;
		/*
		Consructor
		*/
		public function LoaderDummy() {
			this.objLoader = new VisualLoader();
			this.addChild(this.objLoader);
		}

		/*
		Property Definitions
		*/
		public function get loader():VisualLoader {
			return this.objLoader;
		}

		public function set id($id:int):void {
			this.numID = $id;
		}
		public function get id():int {
			return this.numID;
		}
		public function set row($row:int):void {
			this.numRow = $row;
		}
		public function get row():int {
			return this.numRow;
		}
		public function set column($column:int):void {
			this.numColumn = $column;
		}
		public function get column():int {
			return this.numColumn;
		}
	}
}