package com.bedrockframework.plugin.tools
{
	import com.bedrockframework.core.base.DispatcherWidget;
	import com.bedrockframework.plugin.event.PaginationEvent;
	import com.bedrockframework.plugin.util.MathUtil;

	public class Pagination extends DispatcherWidget implements IPageable
	{
		/*
		Variable Decarations
		*/
		private var _numTotalItems:int;
		private var _numTotalPages:int;
		private var _numPageSize:int;
		private var _numSelectedPage:int;
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
			this._numTotalItems =  $total;
			this._numPageSize = $pagesize;
			this._numTotalPages = Math.ceil(this._numTotalItems / this._numPageSize) || 0;
			this.status("Total Records - " + this._numTotalItems);
			this.status("Total Pages - " + this._numTotalPages);
			this.checkBounds();
			this.dispatchEvent(new PaginationEvent(PaginationEvent.UPDATE, this, {total:this._numTotalPages, selected:this._numSelectedPage}));
		}
		public function reset():void
		{
			this._numTotalItems = 0;
			this._numPageSize = 0;
			this._numTotalPages = 0;
			this._numSelectedPage = 0;
			this.dispatchEvent(new PaginationEvent(PaginationEvent.RESET, this));
		}
		/*
		Page Selection Functions
		*/
		public function selectPage($index:int):int
		{
			if ($index > (this._numTotalPages-1)) {
				this._numSelectedPage = this._numTotalPages;
			} else if ($index < 0) {
				this._numSelectedPage = 0;
			} else {
				this._numSelectedPage = $index;
				this.status("Selected Page - " + this._numSelectedPage);
				this.dispatchEvent(new PaginationEvent(PaginationEvent.SELECT_PAGE, this, {selected:this._numSelectedPage, total:this._numTotalPages}));
			}
			return this._numSelectedPage;
		}
		 /* 
		Check Bounds 
		*/ 
		private function checkBounds():void 
		{ 
			if (this._numSelectedPage > (this._numTotalPages-1)) { 
				this.selectPage(this._numTotalPages-1); 
			}
		}
		/*
		Navigate Pages
		*/
		public function nextPage():int
		{
			return this.selectPage(this._numSelectedPage + 1);
		}
		public function previousPage():int
		{
			return this.selectPage(this._numSelectedPage - 1);
		}
		/*
		Has Pages
		*/
		public function hasNextPage():Boolean
		{
			return ((this._numSelectedPage + 1) < (this._numTotalPages));
		}
		public function hasPreviousPage():Boolean
		{
			return ((this._numSelectedPage - 1) >= 0);
		}
		/*
		Property Definitions
		*/
		public function get totalItems():int
		{
			return this._numTotalItems;
		}
		public function get selectedPage():int
		{
			return this._numSelectedPage;
		}
		public function get totalPages():int
		{
			return this._numTotalPages;
		}
	}
}