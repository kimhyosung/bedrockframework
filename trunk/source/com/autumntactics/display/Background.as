package com.autumntactics.display
{
	import com.autumntactics.data.BackgroundData;
	import com.autumntactics.bedrock.base.SpriteWidget;
	import com.autumntactics.util.MathUtil;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Background extends SpriteWidget
	{
		private var objData:BackgroundData;
		
		public function Background()
		{
		}
		/*
		Initialize
		*/
		public function initialize($data:BackgroundData):void
		{
			this.objData = $data;
			this.objData.matrix =  (this.objData.rotation != 0 && objData.matrix == null) ? this.getMatrix() : objData.matrix;
			this.draw(this.objData.width, this.objData.height);
			if (this.objData.matchStageSize) {
				this.stage.addEventListener(Event.RESIZE, this.onResize);
				this.draw(this.stage.stageWidth, this.stage.stageHeight);
			}			
		}
		public function clear():void
		{
			this.stage.removeEventListener(Event.RESIZE, this.onResize);
		}
		private function getMatrix():Matrix
		{
			var objMatrix:Matrix = new Matrix();
			objMatrix.createGradientBox(this.objData.width, this.objData.height, MathUtil.degreesToRadians(this.objData.rotation));
			return objMatrix;
		}
		/*
		Draw the Shape
		*/
		public function draw($width:uint, $height:uint):void
		{
			this.graphics.clear();
			
			switch (this.objData.type) {
				case BackgroundData.FILL :
					this.graphics.beginFill(this.objData.fillColor, this.objData.alpha);
					break;
				case BackgroundData.BITMAP :
					this.graphics.beginBitmapFill(this.objData.bitmapData, this.objData.matrix,this.objData.repeat, this.objData.smooth);
					break;
				case BackgroundData.GRADIENT :					
					this.graphics.beginGradientFill(this.objData.gradientType, this.objData.colors, this.objData.alphas, this.objData.ratios, this.objData.matrix, this.objData.spreadMethod, this.objData.interpolationMethod, this.objData.focalPointRatio);
					break;
			}			
			this.graphics.drawRect(0, 0, $width, $height);
			this.graphics.endFill();
		}
		/*
		Property Definitions
		*/
		public function set data($data:BackgroundData):void
		{
			this.objData = $data;
			this.objData.matrix =  (this.objData.rotation != 0 && objData.matrix == null) ? this.getMatrix() : objData.matrix;
			this.draw(this.objData.width, this.objData.height)
		}
		public function get data():BackgroundData
		{
			return this.objData;
		}
		/*
		Event Handlers
		*/
		private function onResize($event:Event):void
		{
			this.draw(this.stage.stageWidth, this.stage.stageHeight);
		}
	}
}