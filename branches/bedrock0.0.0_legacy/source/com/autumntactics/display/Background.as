package com.builtonbedrock.display
{
	import com.builtonbedrock.bedrock.base.SpriteWidget;
	import com.builtonbedrock.data.BackgroundData;
	import com.builtonbedrock.util.MathUtil;
	
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

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
			this.objData.rectangle = (this.objData.rectangle != null) ? this.objData.rectangle : new Rectangle(0, 0, this.objData.width, this.objData.height);
			this.objData.matrix =  (this.objData.rotation != 0 && objData.matrix == null) ? this.getMatrix() : objData.matrix;
			
			if (this.objData.matchStageSize) {
				this.stage.addEventListener(Event.RESIZE, this.onResize);
				this.draw(this.getStageRectangle());
			} else  {
				this.draw(this.objData.rectangle);
			}
		}
		public function clear():void
		{
			this.stage.removeEventListener(Event.RESIZE, this.onResize);
		}
		private function getMatrix():Matrix
		{
			var objMatrix:Matrix = new Matrix();
			objMatrix.createGradientBox(this.objData.rectangle.width, this.objData.height, MathUtil.degreesToRadians(this.objData.rotation));
			return objMatrix;
		}
		/*
		Draw the Shape
		*/
		public function draw($rectangle:Rectangle):void
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
			this.graphics.drawRect($rectangle.x, $rectangle.y, $rectangle.width, $rectangle.height);
			this.graphics.endFill();
		}
		/*
		Get Stage rectangle
	 	*/
	 	private function getStageRectangle():Rectangle
		{
			return new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		}
		/*
		Property Definitions
		*/
		public function set data($data:BackgroundData):void
		{
			this.initialize($data);
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
			this.draw(this.getStageRectangle());
		}
	}
}