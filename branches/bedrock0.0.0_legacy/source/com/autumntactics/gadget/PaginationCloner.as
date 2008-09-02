package com.builtonbedrock.gadget
{
	import com.builtonbedrock.data.ClonerData;
	import com.builtonbedrock.events.ClonerEvent;
	import com.builtonbedrock.events.PaginationEvent;
	import com.builtonbedrock.bedrock.base.DispatcherWidget;
	import com.builtonbedrock.tools.Pagination;
	import flash.display.DisplayObjectContainer;
	import com.builtonbedrock.util.ArrayUtil;
	import com.builtonbedrock.storage.ArrayBrowser;
	import com.builtonbedrock.tools.IPageable;

	public class PaginationCloner extends DispatcherWidget implements IPageable
	{
		/*
		Variable Declarations
		*/
		private var objCloner:Cloner;
		private var objClonerData:ClonerData
		private var objPagination:Pagination;
		private var arrOriginalData:Array;
		private var arrSegmentedData:Array;
		private var objArrayBrowser:ArrayBrowser;
		/*
		Constructor
		*/
		public function PaginationCloner($parent:DisplayObjectContainer,$child:Class,$useDummy:Boolean=true)
		{
			this.objArrayBrowser = new ArrayBrowser()
			this.objCloner = new Cloner($parent, $child, $useDummy);
			this.objCloner.addEventListener(ClonerEvent.CREATE, this.redispatchClonerEvent);
			this.objCloner.addEventListener(ClonerEvent.COMPLETE, this.redispatchClonerEvent);
			this.objPagination = new Pagination();
			this.objPagination.addEventListener(PaginationEvent.SELECT_PAGE, this.redispatchPaginationEvent);
			this.objPagination.addEventListener(PaginationEvent.SELECT_PAGE, this.onPageChange);
			this.objCloner.silenceLogging = true;
		}
		/*
		Setup
		*/
		public function setup($data:ClonerData):void
		{
			this.objClonerData = $data;
		}
		/*
		Initialize
		*/
		public function initialize($data:Array, $pagesize:int = 0):void
		{
			this.arrSegmentedData = new Array();
			this.arrOriginalData = $data;
			if (this.arrOriginalData.length > $pagesize) {
				this.arrSegmentedData = ArrayUtil.segment(this.arrOriginalData, $pagesize);
			}else{
				this.arrSegmentedData.push(this.arrOriginalData);
			}
			this.objArrayBrowser.data = this.arrSegmentedData;
			this.objPagination.update(this.arrOriginalData.length, $pagesize);
			this.createPage(this.objPagination.selectedPage);
		}
		public function createPage($index:int):void
		{
			this.objClonerData.total = this.getSegment($index).length;
			this.objCloner.initialize(this.objClonerData);
		}
		/*
		Get Segment Data
		*/
		private function getSegment($index:int):Array
		{
			return this.objArrayBrowser.getItemAt($index);
		}
		private function getCurrentSegment():Array
		{
			return this.getSegment(this.objPagination.selectedPage);
		}
		/*
		Next/ Previous Functionality
		*/
		public function nextPage():int
		{
			return this.objPagination.nextPage();
		}
		public function previousPage():int
		{
			return this.objPagination.previousPage();
		}
		public function selectPage($index:int):int
		{
			return this.objPagination.selectPage($index);
		}
		/*
		Page Checks
		*/
		public function hasNextPage():Boolean
		{
			return this.objPagination.hasNextPage();
		}	
		public function hasPreviousPage():Boolean
		{
			return this.objPagination.hasPreviousPage();
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
			this.createPage(this.objPagination.selectedPage);
		}		
		/*
		Property Definitions
		*/
		public function get totalItems():int
		{
			return this.objPagination.totalItems;
		}
		public function get selectedPage():int
		{
			return this.objPagination.selectedPage;
		}
		public function get totalPages():int
		{
			return this.objPagination.totalPages;
		}
		public function get currentData():Array
        {
			return this.getCurrentSegment();
        }
	}
}