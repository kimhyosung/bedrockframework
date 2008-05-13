package com.icg.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Bitmap9Slice extends Bitmap
	{
		/*
		Variable Declarations
		*/
		private var bmpOriginal:BitmapData;
		private var recScaleGrid:Rectangle = null;
		private var bolSmoothing:Boolean;
		/*
		Constructor
		*/		
		public function Bitmap9Slice($bitmapData:BitmapData=null, $pixelSnapping:String="auto", $smoothing:Boolean=true)
		{
			super($bitmapData, $pixelSnapping, $smoothing);
			this.bmpOriginal = $bitmapData.clone();
			this.bolSmoothing = $smoothing;
		}
		/*
		Set Size of the bitmap
		*/		
		public function setSize($width:Number, $height:Number):void
		{
			if (this.recScaleGrid == null) {
				super.width = $width;
				super.height = $height;
			} else {
				var numWidth:Number = Math.max($width, this.bmpOriginal.width - this.recScaleGrid.width);
				var numHeight:Number = Math.max($height, this.bmpOriginal.height - this.recScaleGrid.height);
				this.resizeBitmap(numWidth, numHeight);
			}
		}
		private function resizeBitmap($width:Number, $height:Number):void
		{

			var bmpData:BitmapData = new BitmapData($width, $height, true, 0x00000000);

			var arrRows:Array = [0, this.recScaleGrid.top, this.recScaleGrid.bottom, this.bmpOriginal.height];
			var arrCols:Array = [0, this.recScaleGrid.left, this.recScaleGrid.right, this.bmpOriginal.width];

			var arrDisRows:Array = [0, this.recScaleGrid.top, $height - (this.bmpOriginal.height - this.recScaleGrid.bottom), $height];
			var arrDisCols:Array = [0, this.recScaleGrid.left, $width - (this.bmpOriginal.width - this.recScaleGrid.right), $width];

			var recOrigin:Rectangle;
			var recDraw:Rectangle;
			var matDistortion:Matrix = new Matrix();


			for (var cx:int = 0; cx < 3; cx++) {
				for (var cy:int = 0; cy < 3; cy++) {
					recOrigin = new Rectangle(arrCols[cx], arrRows[cy], arrCols[cx + 1] - arrCols[cx], arrRows[cy + 1] - arrRows[cy]);
					recDraw = new Rectangle(arrDisCols[cx], arrDisRows[cy], arrDisCols[cx + 1] - arrDisCols[cx], arrDisRows[cy + 1] - arrDisRows[cy]);
					matDistortion.identity();
					matDistortion.a = recDraw.width / recOrigin.width;
					matDistortion.d = recDraw.height / recOrigin.height;
					matDistortion.tx = recDraw.x - recOrigin.x * matDistortion.a;
					matDistortion.ty = recDraw.y - recOrigin.y * matDistortion.d;
					bmpData.draw(this.bmpOriginal, matDistortion, null, null, recDraw, this.bolSmoothing);
				}
			}
			this.assignBitmapData(bmpData);
		}
		/*
		Update the effective bitmapData
		*/
		private function assignBitmapData($bitmap:BitmapData):void
		{
			super.bitmapData.dispose();
			super.bitmapData = null;
			super.bitmapData = $bitmap;
		}
		/*
		Validate Grid Size
		*/
		private function isValidGrid($rectangle:Rectangle):Boolean
		{
			return $rectangle.right <= this.bmpOriginal.width && $rectangle.bottom <= this.bmpOriginal.height;
		}
		/*
		Property Definitions
		*/

		override public function set bitmapData(bmpData:BitmapData):void
		{
			this.bmpOriginal = bmpData.clone();
			if (this.recScaleGrid != null) {
				if (!this.isValidGrid(this.recScaleGrid)) {
					this.recScaleGrid = null;
				}
				this.setSize(bmpData.width, bmpData.height);
			} else {
				this.assignBitmapData(this.bmpOriginal.clone());
			}
		}


		override public function set width($value:Number):void
		{
			if ($value != this.width) {
				this.setSize($value, this.height);
			}
		}

		override public function set height($value:Number):void
		{
			if ($value != this.height) {
				this.setSize(this.width, $value);
			}
		}
		override public function set scale9Grid($rect:Rectangle):void
		{
			// Check if the given grid is different from the current one
			if ((this.recScaleGrid == null && $rect != null) || (this.recScaleGrid != null && !this.recScaleGrid.equals($rect))) {
				if ($rect == null) {
					// If deleting scalee9Grid, restore the original bitmap
					// then resize it (streched) to the previously set dimensions
					this.recScaleGrid = null;
					this.assignBitmapData(this.bmpOriginal.clone());
					this.setSize(this.width, this.height);
				} else {
					if (!this.isValidGrid($rect)) {
						throw new Error("#001 - The recScaleGrid does not match the original BitmapData");
						return;
					}
					this.recScaleGrid = $rect.clone();
					this.resizeBitmap(this.width, this.height);
				}
			}
		}	
		override public function get scale9Grid():Rectangle
		{
			return this.recScaleGrid;
		}
	}
}