package com.icg.tools
{
	import com.icg.madagascar.base.DispatcherWidget;
	import com.icg.events.PaginationEvent;
	import com.icg.util.MathUtil;

	public class Pagination extends DispatcherWidget implements IPageable
	{
		/*
		Variable Decarations
		*/
		private var numTotalItems:int;
		private var numTotalPages:int;
		private var numPageSize:int;
		private var numSelectedPage:int;
		/*
		Constructor
		*/
		public function Pagination($total:int = 0, $pagesize:int = 0)
		{
			this.reset();
			this.update($total, $pagesize);
		}
		/*
		Public Functions
		*/
		public function update($total:int = 0, $pagesize:int = 0):void
		{
			this.numTotalItems =  $total;
			this.numPageSize = $pagesize;
			this.numTotalPages = Math.ceil(this.numTotalItems / this.numPageSize) || 0;
			output("Total Records - " + this.numTotalItems);
			output("Total Pages - " + this.numTotalPages);
			this.checkBounds();
			this.dispatchEvent(new PaginationEvent(PaginationEvent.UPDATE, this, {total:this.numTotalPages, selected:this.numSelectedPage}));
		}
		public function reset():void
		{
			this.numTotalItems = 0;
			this.numPageSize = 0;
			this.numTotalPages = 0;
			this.numSelectedPage = 0;
			this.dispatchEvent(new PaginationEvent(PaginationEvent.RESET, this));
		}
		/*
		Page Selection Functions
		*/
		public function selectPage($index:int):int
		{
			if ($index > (this.numTotalPages-1)) {
				this.numSelectedPage = this.numTotalPages;
			} else if ($index < 0) {
				this.numSelectedPage = 0;
			} else {
				this.numSelectedPage = $index;
				output("Selected Page - " + this.numSelectedPage);
				this.dispatchEvent(new PaginationEvent(PaginationEvent.SELECT_PAGE, this, {selected:this.numSelectedPage, total:this.numTotalPages}));
			}
			return this.numSelectedPage;
		}
		 /* 
		Check Bounds 
		*/ 
		private function checkBounds():void 
		{ 
			if (this.numSelectedPage > (this.numTotalPages-1)) { 
				this.selectPage(this.numTotalPages-1); 
			}
		}
		/*
		Navigate Pages
		*/
		public function nextPage():int
		{
			return this.selectPage(this.numSelectedPage + 1);
		}
		public function previousPage():int
		{
			return this.selectPage(this.numSelectedPage - 1);
		}
		/*
		Has Pages
		*/
		public function hasNextPage():Boolean
		{
			return ((this.numSelectedPage + 1) < (this.numTotalPages));
		}
		public function hasPreviousPage():Boolean
		{
			return ((this.numSelectedPage - 1) >= 0);
		}
		/*
		Property Definitions
		*/
		public function get totalItems():int
		{
			return this.numTotalItems;
		}
		public function get selectedPage():int
		{
			return this.numSelectedPage;
		}
		public function get totalPages():int
		{
			return this.numTotalPages;
		}
	}
}