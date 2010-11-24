/**

Cloner

*/
import com.bedrockframework.plugin.data.ClonerData;
import com.bedrockframework.plugin.event.ClonerEvent;
class com.bedrockframework.plugin.gadget.Cloner extends com.bedrockframework.core.base.DispatcherWidget
{
	/*
	Variable Decarations
	*/
	public var data:ClonerData;
	
	private var _strClassName:String = "Cloner";
	private var _mcContainer:MovieClip;
	private var _mcCurrentClone:MovieClip;
	private var _strLinkage:String;
	
	private var _numXposition:Number;
	private var _numYposition:Number;
	
	private var _numWrap:Number;
	
	private var _numColumn:Number;
	private var _numRow:Number;
	
	private var _mcDummy:MovieClip;
	private var _numWrapIndex:Number;

	private var numCurrentIndex:Number;
	/*
	Constructor
	*/
	public function Cloner()
	{
	}
	public function setup($container:MovieClip, $linkage:String):Void
	{
		this._mcContainer = $container;
			
		this._mcDummy = this._mcContainer.createEmptyMovieClip("_mcDummy", 1);
		this._strLinkage = $linkage;
	}
	public function initialize($data:ClonerData):Void
	{
		if ($data) {
			this.data = $data;
			
			this._numXposition = 0;
			this._numYposition = 0;
			//
			this._numColumn = 0;
			this._numRow = 0;
			this._numWrapIndex = 1;
			this.numCurrentIndex = 0;
			this.setDirection(this.data.direction.toLowerCase());
			this.setPattern(this.data.pattern.toLowerCase());
			this.setPositionProperties(this.data);
			this.duplicate(this.data);
		}
	}
	/*
	Clone Functions
	*/
	public function create():MovieClip
	{
		this._mcCurrentClone = this._mcDummy.attachMovie(this._strLinkage, this._strLinkage + this.numCurrentIndex, this.numCurrentIndex, this.getProperties());
		this.dispatchEvent(new ClonerEvent(ClonerEvent.CREATE, this, {id:this.numCurrentIndex, child:this._mcCurrentClone}));
		this.numCurrentIndex++;
		return this._mcCurrentClone;
	}
	private function getProperties():Object
	{
		if (this.numCurrentIndex != 0) {
			this._numWrapIndex++;
			switch (this.data.pattern) {
				case ClonerData.GRID :
					switch (this.data.direction) {
						case ClonerData.HORIZONTAL :
							this._numXposition += this.data.spaceX;
							if (this._numWrapIndex > this.data.wrap) {
								this._numXposition = 0;
								this._numYposition += this.data.spaceY;
								this._numWrapIndex = 1;
								this._numRow += 1;
							}
							this._numColumn = this._numWrapIndex;
							break;
						case ClonerData.VERTICAL :
							this._numYposition += this.data.spaceY;
							if (this._numWrapIndex > this.data.wrap) {
								this._numYposition = 0;
								this._numXposition += this.data.spaceX;
								this._numWrapIndex = 1;
								this._numColumn += 1;
							}
							this._numRow = this._numWrapIndex;
							break;
					}
					return {_x:this._numXposition, _y:this._numYposition, _column:this._numColumn, _row:this._numRow, _id:this.numCurrentIndex};
					break;
				case ClonerData.LINEAR :
					switch (this.data.direction) {
						case ClonerData.HORIZONTAL :
							this._numXposition += this.data.spaceX;
							break;
						case ClonerData.VERTICAL :
							this._numYposition += this.data.spaceY;
							break;
					}
					return {_x:this._numXposition, _y:this._numYposition, _id:this.numCurrentIndex};
					break;
				case ClonerData.RANDOM :
					return {_x:random(this.data.rangeX), _y:random(this.data.rangeY), _id:this.numCurrentIndex};
					break;
			}
		} else if (this.data.pattern == ClonerData.GRID) {
			return {_x:this._numXposition, _y:this._numYposition, _column:this._numColumn, _row:this._numRow, _id:this.numCurrentIndex};
		} else if (this.data.pattern == ClonerData.LINEAR) {
			return {_x:this._numXposition, _y:this._numYposition, _id:this.numCurrentIndex};
		} else if (this.data.pattern == ClonerData.RANDOM) {
			return {_x:random(this.data.rangeX), _y:random(this.data.rangeY), _id:this.numCurrentIndex};
		}
	}
	public function remove($id:Number):Void
	{
		this._mcContainer.removeMovieClip([this._strLinkage + $id]);
		this.dispatchEvent(new ClonerEvent(ClonerEvent.REMOVE, this, {id:$id}));
	}
	/*
	Chamber Functions Definitions
	*/
	public function duplicate($data:Object):Array
	{
		this.clear();
		output("Duplicate");
		var arrCloneClips:Array = new Array();
		for (var i = 0; i < $data.total; i++) {
			arrCloneClips.push(this.create());
		}
		this.dispatchEvent(new ClonerEvent(ClonerEvent.COMPLETE, this, {total:$data.total, clips:arrCloneClips}));
		return arrCloneClips;		
	}
	public function clear($resetPosition:Boolean, $resetIndex:Boolean):Void
	{
		output("Cleared");
		this._numColumn = 1;
		this._numRow = 1;
		this._mcDummy = this._mcContainer.createEmptyMovieClip("_mcDummy", 1);
		if ($resetPosition || $resetPosition == undefined) {
			this._numXposition = 0;
			this._numYposition = 0;
		}
		if ($resetIndex || $resetIndex == undefined) {
			this.numCurrentIndex = 0;
		}
		this.dispatchEvent(new ClonerEvent(ClonerEvent.CLEAR, this));
	}
	/*
	Property Definitions
	*/
	public function setPositionProperties($data:Object):Void
	{
		if (this.data.pattern != ClonerData.RANDOM) {
			this.setOffset($data.offsetX,$data.offsetY);
		}
	}

	public function setOffset($offsetX:Number, $offsetY:Number):Void
	{
		this._numXposition = $offsetX || 0;
		this._numYposition = $offsetY || 0;
	}
	public function setWrap($wrap:Number):Void
	{
		this.data.wrap = $wrap;
	}
	public function setDirection($direction:String):Void
	{
		if ($direction != ClonerData.HORIZONTAL && $direction != ClonerData.VERTICAL && $direction != ClonerData.RANDOM) {
			output("Invalid direction value!","warning");
		} else {
			this.data.direction = $direction;
			if (this.data.direction == ClonerData.RANDOM) {
				this.data.pattern = ClonerData.RANDOM;
			}
		}
	}
	public function setPattern($pattern:String):Void
	{
		if (this.data.direction != ClonerData.RANDOM) {
			if ($pattern != ClonerData.LINEAR && $pattern != ClonerData.GRID && $pattern != ClonerData.RANDOM) {
				output("Invalid pattern value!","warning");
			} else {
				this.data.pattern = $pattern;
			}
		} else {
			this.data.pattern = ClonerData.RANDOM;
		}
	}

	/*
	Returns the current index of the movieclip being cloned.
	*/
	public function get currentIndex():Number
	{
		return this.numCurrentIndex;
	}
	/*
	Returns the instance of the movieclip being cloned.
	*/
	public function get currentClone():MovieClip
	{
		return this._mcCurrentClone;
	}
	public function set direction($direction:String)
	{
		this.setDirection($direction);
	}
	public function get direction():String
	{
		return this.data.direction;
	}
	public function set pattern($pattern:String)
	{
		this.setPattern($pattern);
	}
	public function get pattern():String
	{
		return this.data.pattern;
	}
}