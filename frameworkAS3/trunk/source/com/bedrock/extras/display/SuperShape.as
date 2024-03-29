﻿package com.bedrock.extras.display
{
	
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import com.bedrock.framework.plugin.util.MathUtil;

	public class SuperShape extends Sprite
	{
		private var _data:SuperShapeData;
		
		public function SuperShape()
		{
		}
		/*
		Initialize
		*/
		public function initialize($data:SuperShapeData):void
		{
			this._data = $data;
			this._data.rectangle = (this._data.rectangle != null) ? this._data.rectangle : new Rectangle(0, 0, this._data.width, this._data.height);
			this._data.matrix =  (this._data.rotation != 0 && this._data.matrix == null) ? this._getMatrix() : this._data.matrix;
			
			if (this._data.matchStageSize) {
				this.stage.addEventListener(Event.RESIZE, this._onResize);
				this.draw(this._getStageRectangle());
			} else  {
				this.draw(this._data.rectangle);
			}
		}
		public function clear():void
		{
			this.stage.removeEventListener(Event.RESIZE, this._onResize);
		}
		private function _getMatrix():Matrix
		{
			var objMatrix:Matrix = new Matrix();
			objMatrix.createGradientBox(this._data.rectangle.width, this._data.rectangle.height, MathUtil.degreesToRadians(this._data.rotation));
			return objMatrix;
		}
		/*
		Draw the Shape
		*/
		public function draw($rectangle:Rectangle):void
		{
			this.graphics.clear();
			
			switch (this._data.type) {
				case SuperShapeData.FILL :
					this.graphics.beginFill(this._data.fillColor, this._data.alpha);
					break;
				case SuperShapeData.BITMAP :
					this.graphics.beginBitmapFill(this._data.bitmapData, this._data.matrix,this._data.repeat, this._data.smooth);
					break;
				case SuperShapeData.GRADIENT :					
					this.graphics.beginGradientFill(this._data.gradientType, this._data.colors, this._data.alphas, this._data.ratios, this._data.matrix, this._data.spreadMethod, this._data.interpolationMethod, this._data.focalPointRatio);
					break;
			}			
			this.graphics.drawRect($rectangle.x, $rectangle.y, $rectangle.width, $rectangle.height);
			this.graphics.endFill();
		}
		/*
		Get Stage rectangle
	 	*/
	 	private function _getStageRectangle():Rectangle
		{
			return new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		}
		/*
		Property Definitions
		*/
		public function set data($data:SuperShapeData):void
		{
			this.initialize($data);
		}
		public function get data():SuperShapeData
		{
			return this._data;
		}
		
		override public function set width( $width:Number ):void
		{
			this._data.rectangle.width = $width;
			this.draw( this._data.rectangle );
		}
		override public function set height( $height:Number ):void
		{
			this._data.rectangle.height = $height;
			this.draw( this._data.rectangle );
		} 
		/*
		Event Handlers
		*/
		private function _onResize($event:Event):void
		{
			this.draw( this._getStageRectangle() );
		}
	}
}