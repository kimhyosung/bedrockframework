package com.bedrock.extension.view.misc
{
	import flash.events.Event;
	
	import mx.containers.Panel;
	import mx.controls.ComboBox;

    [ Event(name="change", type="flash.events.Event") ]

	public class ComboPanel extends Panel
	{
		public var combo:ComboBox;
		
		public function ComboPanel()
		{
			super();
			this.combo = new ComboBox();
			this.combo.addEventListener( Event.CHANGE, this.dispatchEvent );
			this.combo.includeInLayout = true;
		}
		protected override function createChildren():void
        {
            super.createChildren();
            rawChildren.addChild( this.combo );
        }
        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            this.combo.width = this.combo.measuredWidth;
            this.combo.height = this.combo.measuredHeight;
            this.setStyle( "headerHeight", this.combo.height + 10 );            
            this.combo.move( this.titleTextField.textWidth + 15, 5 );
        }

        public function set dataProvider( $data:Object ):void
        {
        	this.combo.dataProvider = $data;
        }
	}
	
}