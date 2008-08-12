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
	
	private var strClassName:String = "Cloner";
	private var mcContainer:MovieClip;
	private var mcCurrentClone:MovieClip;
	private var strLinkage:String;
	
	private var numXposition:Number;
	private var numYposition:Number;
	
	private var numWrap:Number;
	
	private var numColumn:Number;
	private var numRow:Number;
	
	private var mcDummy:MovieClip;
	private var numWrapIndex:Number;

	private var numCurrentIndex:Number;
	/*
	Constructor
	*/
	public function Cloner()
	{
	}
	public function setup($container:MovieClip, $linkage:String):Void
	{
		this.mcContainer = $container;
			
		this.mcDummy = this.mcContainer.createEmptyMovieClip("mcDummy", 1);
		this.strLinkage = $linkage;
	}
	public function initialize($data:ClonerData):Void
	{
		if ($data) {
			this.data = $data;
			
			this.numXposition = 0;
			this.numYposition = 0;
			//
			this.numColumn = 0;
			this.numRow = 0;
			this.numWrapIndex = 1;
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
		this.mcCurrentClone = this.mcDummy.attachMovie(this.strLinkage, this.strLinkage + this.numCurrentIndex, this.numCurrentIndex, this.getProperties());
		this.dispatchEvent(new ClonerEvent(ClonerEvent.CREATE, this, {id:this.numCurrentIndex, child:this.mcCurrentClone}));
		this.numCurrentIndex++;
		return this.mcCurrentClone;
	}
	private function getProperties():Object
	{
		if (this.numCurrentIndex != 0) {
			this.numWrapIndex++;
			switch (this.data.pattern) {
				case ClonerData.GRID :
					switch (this.data.direction) {
						case ClonerData.HORIZONTAL :
							this.numXposition += this.data.spaceX;
							if (this.numWrapIndex > this.data.wrap) {
								this.numXposition = 0;
								this.numYposition += this.data.spaceY;
								this.numWrapIndex = 1;
								this.numRow += 1;
							}
							this.numColumn = this.numWrapIndex;
							break;
						case ClonerData.VERTICAL :
							this.numYposition += this.data.spaceY;
							if (this.numWrapIndex > this.data.wrap) {
								this.numYposition = 0;
								this.numXposition += this.data.spaceX;
								this.numWrapIndex = 1;
								this.numColumn += 1;
							}
							this.numRow = this.numWrapIndex;
							break;
					}
					return {_x:this.numXposition, _y:this.numYposition, _column:this.numColumn, _row:this.numRow, _id:this.numCurrentIndex};
					break;
				case ClonerData.LINEAR :
					switch (this.data.direction) {
						case ClonerData.HORIZONTAL :
							this.numXposition += this.data.spaceX;
							break;
						case ClonerData.VERTICAL :
							this.numYposition += this.data.spaceY;
							break;
					}
					return {_x:this.numXposition, _y:this.numYposition, _id:this.numCurrentIndex};
					break;
				case ClonerData.RANDOM :
					return {_x:random(this.data.rangeX), _y:random(this.data.rangeY), _id:this.numCurrentIndex};
					break;
			}
		} else if (this.data.pattern == ClonerData.GRID) {
			return {_x:this.numXposition, _y:this.numYposition, _column:this.numColumn, _row:this.numRow, _id:this.numCurrentIndex};
		} else if (this.data.pattern == ClonerData.LINEAR) {
			return {_x:this.numXposition, _y:this.numYposition, _id:this.numCurrentIndex};
		} else if (this.data.pattern == ClonerData.RANDOM) {
			return {_x:random(this.data.rangeX), _y:random(this.data.rangeY), _id:this.numCurrentIndex};
		}
	}
	public function remove($id:Number):Void
	{
		this.mcContainer.removeMovieClip([this.strLinkage + $id]);
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
		this.numColumn = 1;
		this.numRow = 1;
		this.mcDummy = this.mcContainer.createEmptyMovieClip("mcDummy", 1);
		if ($resetPosition || $resetPosition == undefined) {
			this.numXposition = 0;
			this.numYposition = 0;
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
		this.numXposition = $offsetX || 0;
		this.numYposition = $offsetY || 0;
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
		return this.mcCurrentClone;
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