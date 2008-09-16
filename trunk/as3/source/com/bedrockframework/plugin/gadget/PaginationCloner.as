package com.bedrockframework.plugin.gadget
{
	import com.bedrockframework.plugin.data.ClonerData;
	import com.bedrockframework.plugin.event.ClonerEvent;
	import com.bedrockframework.plugin.event.PaginationEvent;
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.tools.Pagination;
	import flash.display.DisplayObjectContainer;
	import com.bedrockframework.plugin.util.ArrayUtil;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.tools.IPageable;

	public class PaginationCloner extends DispatcherWidget implements IPageable
	{
		/*
		Variable Declarations
		*/
		private var _objCloner:Cloner;
		private var _objClonerData:ClonerData
		private var _objPagination:Pagination;
		private var _arrOriginalData:Array;
		private var _arrSegmentedData:Array;
		private var _objArrayBrowser:ArrayBrowser;
		/*
		Constructor
		*/
		public function PaginationCloner($parent:DisplayObjectContainer,$child:Class,$useDummy:Boolean=true)
		{
			this._objArrayBrowser = new ArrayBrowser()
			this._objCloner = new Cloner($child, $parent, $useDummy);
			this._objCloner.addEventListener(ClonerEvent.CREATE, this.redispatchClonerEvent);
			this._objCloner.addEventListener(ClonerEvent.COMPLETE, this.redispatchClonerEvent);
			this._objPagination = new Pagination();
			this._objPagination.addEventListener(PaginationEvent.SELECT_PAGE, this.redispatchPaginationEvent);
			this._objPagination.addEventListener(PaginationEvent.SELECT_PAGE, this.onPageChange);
			this._objCloner.silenceLogging = true;
		}
		/*
		Setup
		*/
		public function setup($data:ClonerData):void
		{
			this._objClonerData = $data;
		}
		/*
		Initialize
		*/
		public function initialize($data:Array, $pagesize:int = 0):void
		{
			this._arrSegmentedData = new Array();
			this._arrOriginalData = $data;
			if (this._arrOriginalData.length > $pagesize) {
				this._arrSegmentedData = ArrayUtil.segment(this._arrOriginalData, $pagesize);
			}else{
				this._arrSegmentedData.push(this._arrOriginalData);
			}
			this._objArrayBrowser.data = this._arrSegmentedData;
			this._objPagination.update(this._arrOriginalData.length, $pagesize);
			this.createPage(this._objPagination.selectedPage);
		}
		public function createPage($index:int):void
		{
			this._objClonerData.total = this.getSegment($index).length;
			this._objCloner.initialize(this._objClonerData);
		}
		/*
		Get Segment Data
		*/
		private function getSegment($index:int):Array
		{
			return this._objArrayBrowser.getItemAt($index);
		}
		private function getCurrentSegment():Array
		{
			return this.getSegment(this._objPagination.selectedPage);
		}
		/*
		Next/ Previous Functionality
		*/
		public function nextPage():int
		{
			return this._objPagination.nextPage();
		}
		public function previousPage():int
		{
			return this._objPagination.previousPage();
		}
		public function selectPage($index:int):int
		{
			return this._objPagination.selectPage($index);
		}
		/*
		Page Checks
		*/
		public function hasNextPage():Boolean
		{
			return this._objPagination.hasNextPage();
		}	
		public function hasPreviousPage():Boolean
		{
			return this._objPagination.hasPreviousPage();
		}	
		/*
		Rebroadcast Functions
		*/
		private function redispatchClonerEvent($event:ClonerEvent):void
		{
			this.dispatchEvent(new ClonerEvent($event.type, $event.origin, $event.details));
		}
		private function redispatchPaginationEvent($event:PaginationEvent):void
		{
			this.dispatchEvent(new PaginationEvent($event.type, $event.origin, $event.details));
		}
		/*
		Event Handlers
		*/
		private function onPageChange($event:PaginationEvent):void
		{
			this.createPage(this._objPagination.selectedPage);
		}		
		/*
		Property Definitions
		*/
		public function get totalItems():int
		{
			return this._objPagination.totalItems;
		}
		public function get selectedPage():int
		{
			return this._objPagination.selectedPage;
		}
		public function get totalPages():int
		{
			return this._objPagination.totalPages;
		}
		public function get currentData():Array
        {
			return this.getCurrentSegment();
        }
	}
}