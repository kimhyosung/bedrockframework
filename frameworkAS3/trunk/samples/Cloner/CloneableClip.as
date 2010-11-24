package 
{
	import com.bedrock.extras.cloner.IClonable;
	import com.bedrock.extras.util.MathUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class CloneableClip extends MovieClip implements IClonable
	{
		private var _index:int;
		private var _row:int;
		private var _column:int;
		
		public var label:TextField;
		
		public function CloneableClip()
		{
		}
		
		private function _updateLabel():void
		{
			this.label.text = "Col : " + this.column + "\nRow : " + this.row + "\nIndex : " + this.index;
		}
		/*
		Property Definitions
		*/
		public function set index( $value:int ):void
		{
			this._index = $value;
			this._updateLabel();
		}
		public function get index():int
		{
			return this._index;
		}
		
		public function set row( $value:int ):void
		{
			this._row = $value;
			trace( $value );
			this._updateLabel();
		}
		public function get row():int
		{
			return this._row;
		}
		
		public function set column( $value:int ):void
		{
			this._column = $value;
			trace( $value );
			this._updateLabel();
		}
		public function get column():int
		{
			return this._column;
		}


	}
}