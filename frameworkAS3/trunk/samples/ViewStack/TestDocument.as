package
{
	public class TestDocument extends SampleTestBed
	{
		public function TestDocument()
		{
			super();
			
			this._addTestItem( "test1", new Test1 );
			
			this._initializeComplete();
		}
		
	}
}
/* <initializingCloner> */
import com.bedrock.framework.plugin.view.ViewStack;
import com.bedrock.framework.plugin.view.ViewStackData;

import flash.display.MovieClip;

class Test1 extends MovieClip 
{
		/*
		Variable Declarations
		*/
		public var viewStack:ViewStack;
		/*
		Constructor
		*/
		public function Test1()
		{
			this.createViewStack();
		}

		public function createViewStack():void
		{
			this.viewStack = new ViewStack();
			this.addChild( this.viewStack );
		}
		
		public function initializeViewStack( $data:Object ):void
		{
			var data:ViewStackData = new ViewStackData;
			data.wrap = $data.wrap;
			data.autoStart = $data.autoStart;
			data.addToStack( new Burst1() );
			data.addToStack( new Burst2() );
			data.addToStack( new Burst3() );
			data.addToStack( new Burst4() );
			
			this.viewStack.initialize( data );
		}
		
		public function selectNextView( $data:Object ):void
		{
			this.viewStack.selectNext();
		}
		public function selectPreviousView( $data:Object ):void
		{
			this.viewStack.selectPrevious();
		}
		public function selectViewByIndex( $data:Object ):void
		{
			this.viewStack.selectByIndex( $data.index );
		}
}
/* </initializingCloner> */

