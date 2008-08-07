
import flash.geom.Matrix;
import flash.display.BitmapData;
import flash.geom.Point;
class com.bedrockframework.plugin.gadget.DistortImage extends com.bedrockframework.core.base.StandardWidget
{
	private var _strClassName:String = "DistortImage";
	private var _mcContainer:MovieClip;
	private var _numWidth:Number;
	private var _numHeight:Number;
	// -- skew and translation matrix
	private var _objSkewMatrix:Matrix;
	private var _objTranslationMatrix:Matrix;
	private var _numMinX, _numMinY:Number;
	private var _numMaxX, _numMaxY:Number;
	private var _numSegmentH:Number;
	private var _numSegmentV:Number;
	private var _numLengthH:Number;
	private var _numLengthV:Number;
	private var _arrPoints:Array;
	private var _arrTriangles:Array;
	private var _objTextureBitmap:BitmapData;
	/* Constructor
	 *
	 * @param mc MovieClip :  the movieClip containing the distorded picture
	 * @param vseg Number : the vertical precision
	 * @param hseg Number : the horizontal precision
	 */
	public function DistortImage()
	{
	}
	public function initialize(mc:MovieClip, bitmap:BitmapData, vseg:Number, hseg:Number):Void
	{
		this._mcContainer = mc;
		//_objTextureBitmap = BitmapData.loadBitmap(symbolId);
		this.setBitmap(bitmap);
		this._numSegmentV = vseg;
		this._numSegmentH = hseg;
		//
		this._numWidth = this._objTextureBitmap.width;
		this._numHeight = this._objTextureBitmap.height;
		//
		this._arrPoints = new Array();
		this._arrTriangles = new Array();
		var ix:Number;
		var iy:Number;
		var w2:Number = this._numWidth / 2;
		var h2:Number = this._numHeight / 2;
		this._numMinX = this._numMinY = 0;
		this._numMaxX = this._numWidth;
		this._numMaxY = this._numHeight;
		this._numLengthH = this._numWidth / (_numSegmentH + 1);
		this._numLengthV = this._numHeight / (_numSegmentV + 1);
		var x:Number, y:Number;
		// -- we create the points
		for (ix = 0; ix < this._numSegmentV + 2; ix++) {
			for (iy = 0; iy < _numSegmentH + 2; iy++) {
				x = ix * this._numLengthH;
				y = iy * this._numLengthV;
				this._arrPoints.push({x:x, y:y, sx:x, sy:y});
			}
		}
		// -- we create the triangles
		for (ix = 0; ix < this._numSegmentV + 1; ix++) {
			for (iy = 0; iy < this._numSegmentH + 1; iy++) {
				this._arrTriangles.push([this._arrPoints[iy + ix * (this._numSegmentH + 2)], this._arrPoints[iy + ix * (this._numSegmentH + 2) + 1], this._arrPoints[iy + (ix + 1) * (this._numSegmentH + 2)]]);
				this._arrTriangles.push([this._arrPoints[iy + (ix + 1) * (this._numSegmentH + 2) + 1], this._arrPoints[iy + (ix + 1) * (this._numSegmentH + 2)], this._arrPoints[iy + ix * (this._numSegmentH + 2) + 1]]);
			}
		}
		this.render();
	}
	public function update($points:Array):Void
	{
		if (typeof ($points[0]) == "object") {
			this.setTransform($points[0].x,$points[0].y,$points[1].x,$points[1].y,$points[2].x,$points[2].y,$points[3].x,$points[3].y);
		} else {
			this.setTransform($points[0]._x,$points[0]._y,$points[1]._x,$points[1]._y,$points[2]._x,$points[2]._y,$points[3]._x,$points[3]._y);
		}
	}

	public function setBitmap($bitmap:BitmapData):Void
	{
		this._objTextureBitmap = $bitmap;
	}
	/* setTransform
	 *
	 * @param x0 Number the horizontal coordinate of the first point
	 * @param y0 Number the vertical coordinate of the first point
	 * @param x1 Number the horizontal coordinate of the second point
	 * @param y1 Number the vertical coordinate of the second point
	 * @param x2 Number the horizontal coordinate of the third point
	 * @param y2 Number the vertical coordinate of the third point
	 * @param x3 Number the horizontal coordinate of the fourth point
	 * @param y3 Number the vertical coordinate of the fourth point
	 *
	 * @description : Distord the bitmap to ajust it to those points.
	 */
	function setTransform(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Void
	{
		var w:Number = this._numWidth;
		var h:Number = this._numHeight;
		var dx30:Number = x3 - x0;
		var dy30:Number = y3 - y0;
		var dx21:Number = x2 - x1;
		var dy21:Number = y2 - y1;
		var l:Number = this._arrPoints.length;
		while (--l > -1)
		{
			var objPoint:Object = this._arrPoints[l];
			var gx = (objPoint.x - this._numMinX) / w;
			var gy = (objPoint.y - this._numMinY) / h;
			var bx = x0 + gy * (dx30);
			var by = y0 + gy * (dy30);
			objPoint.sx = bx + gx * ((x1 + gy * (dx21)) - bx);
			objPoint.sy = by + gx * ((y1 + gy * (dy21)) - by);
		}
		this.render();
	}
	private function render(Void):Void
	{
		var t:Number;
		var vertices:Array;
		var p0, p1, p2:Object;
		var a:Array;
		this._mcContainer.clear();
		this._objSkewMatrix = new Matrix();
		this._objTranslationMatrix = new Matrix();
		var l:Number = this._arrTriangles.length;
		while (--l > -1)
		{
			a = this._arrTriangles[l];
			p0 = a[0];
			p1 = a[1];
			p2 = a[2];
			var x0:Number = p0.sx;
			var y0:Number = p0.sy;
			var x1:Number = p1.sx;
			var y1:Number = p1.sy;
			var x2:Number = p2.sx;
			var y2:Number = p2.sy;
			var u0:Number = p0.x;
			var v0:Number = p0.y;
			var u1:Number = p1.x;
			var v1:Number = p1.y;
			var u2:Number = p2.x;
			var v2:Number = p2.y;
			this._objTranslationMatrix.tx = u0;
			this._objTranslationMatrix.ty = v0;
			this._objTranslationMatrix.a = (u1 - u0) / this._numWidth;
			this._objTranslationMatrix.b = (v1 - v0) / this._numWidth;
			this._objTranslationMatrix.c = (u2 - u0) / this._numHeight;
			this._objTranslationMatrix.d = (v2 - v0) / this._numHeight;
			this._objSkewMatrix.a = (x1 - x0) / this._numWidth;
			this._objSkewMatrix.b = (y1 - y0) / this._numWidth;
			this._objSkewMatrix.c = (x2 - x0) / this._numHeight;
			this._objSkewMatrix.d = (y2 - y0) / this._numHeight;
			this._objSkewMatrix.tx = x0;
			this._objSkewMatrix.ty = y0;
			this._objTranslationMatrix.invert();
			this._objTranslationMatrix.concat(this._objSkewMatrix);
			this._mcContainer.beginBitmapFill(this._objTextureBitmap,this._objTranslationMatrix,false,true);
			this._mcContainer.moveTo(x0,y0);
			this._mcContainer.lineTo(x1,y1);
			this._mcContainer.lineTo(x2,y2);
			this._mcContainer.endFill();
		}
	}
}