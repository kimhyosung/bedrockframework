package
{
	import com.bedrock.sampler.BedrockSampler;
	
	public class TestDocument extends BedrockSampler
	{
		public function TestDocument()
		{
			super();
			
			this._addTestItem( "test1", new Test1 );
			this._addTestItem( "test2", new Test2 );
			this._addTestItem( "test3", new Test3 );
			this._addTestItem( "test4", new Test3 );
			
			this._initializeComplete();
		}
		
	}
}
/* <initializingCloner> */
import flash.display.MovieClip;
import com.bedrock.extras.cloner.Cloner;
import com.bedrock.extras.cloner.ClonerData;
import com.bedrock.extras.cloner.ClonerEvent;

class Test1 extends MovieClip 
{
		/*
		Variable Declarations
		*/
		public var cloner:Cloner;
		/*
		Constructor
		*/
		public function Test1()
		{
			this.createCloner();
		}

		public function createCloner():void
		{
			this.cloner = new Cloner();
			this.addChild( this.cloner );
		}
		
		public function initializeCloner( $data:Object ):void
		{
			var data:ClonerData = new ClonerData;
			data.clone = StandardClip;
			data.total = $data.total;
			data.spaceX = $data.spaceX;
			data.spaceY = $data.spaceY;
			data.paddingX = $data.paddingX;
			data.paddingY = $data.paddingY;
			data.offsetX = $data.offsetX;
			data.offsetY = $data.offsetY;
			data.direction = $data.direction;
			data.pattern = $data.pattern;
			data.wrap = $data.wrap;
			
			this.cloner.initialize( data );
		}
		public function createClone( $data:Object ):void
		{
			this.cloner.createClone();
		}
		public function clearCloner( $data:Object ):void
		{
			this.cloner.clear();
		}
		
}
/* </initializingCloner> */

/* <customizingClones> */
import flash.display.MovieClip;
import com.bedrock.extras.cloner.Cloner;
import com.bedrock.extras.cloner.ClonerData;
import com.bedrock.extras.cloner.ClonerEvent;
import com.bedrock.framework.plugin.util.ButtonUtil;
import flash.events.MouseEvent;

class Test2 extends MovieClip 
{
		/*
		Variable Declarations
		*/
		public var cloner:Cloner;
		private var _buttonData:Array;
		/*
		Constructor
		*/
		public function Test2()
		{
			this.createCloner();
		}
		
		public function createCloner():void
		{
			this.cloner = new Cloner();
			this.cloner.addEventListener(ClonerEvent.CREATE, this._onCloneCreate);
			this.addChild( this.cloner );
		}
		public function initializeCloner( $data:Object ):void
		{
			this._buttonData = $data.buttonData;
			
			var data:ClonerData = new ClonerData;
			data.clone = MenuItem;
			data.total = this._buttonData.length;
			data.spaceX = 125;
			data.paddingX = 5;
			data.direction = ClonerData.HORIZONTAL;
			data.pattern = ClonerData.LINEAR;
			
			this.cloner.initialize( data );
		}
		private function _onCloneCreate( $event:ClonerEvent ):void
		{
			$event.details.child.name = this._buttonData[ $event.details.index ].id;
			$event.details.child.label.text = this._buttonData[ $event.details.index ].label;
			ButtonUtil.addListeners( $event.details.child, { down:this._onCloneDown } );
		}
		private function _onCloneDown( $event:MouseEvent ):void
		{
			trace( $event.target.name );
		}
		
		
}
/* </customizingClones> */

/* <usingIClonableInterface> */
import flash.display.MovieClip;
import com.bedrock.extras.cloner.Cloner;
import com.bedrock.extras.cloner.ClonerData;

class Test3 extends MovieClip 
{
		/*
		Variable Declarations
		*/
		public var cloner:Cloner;
		/*
		Constructor
		*/
		public function Test3()
		{
			this.createCloner();
		}
		
		public function createCloner():void
		{
			this.cloner = new Cloner();
			this.addChild( this.cloner );
		}
		public function initializeCloner( $data:Object ):void
		{
			var data:ClonerData = new ClonerData;
			data.clone = RedCloneableClip;
			data.spaceX = 75;
			data.spaceY = 75;
			data.paddingX = 5;
			data.paddingY = 5;
			data.total = $data.total;
			data.direction = $data.direction;
			data.pattern = $data.pattern;
			data.wrap = $data.wrap;
			
			this.cloner.initialize( data );
		}
		public function createClone( $data:Object ):void
		{
			this.cloner.createClone();
		}
		public function clearCloner( $data:Object ):void
		{
			this.cloner.clear();
		}
}
/* </usingIClonableInterface> */

