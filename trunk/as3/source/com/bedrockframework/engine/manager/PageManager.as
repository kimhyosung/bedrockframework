package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StandardWidget;
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.api.IPageManager;
	import com.bedrockframework.engine.bedrock;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.util.DeepLinkUtil;

	public class PageManager extends StandardWidget implements IPageManager
	{
		private var _objCurrent:Object;
		private var _objPrevious:Object;
		/*
		* Constructor
		*/
		public function PageManager()
		{
		}
		/*
		*/
		
		public function setupPageLoad($page:Object):void
		{
			var objPage:Object = $page;
			if (objPage.files != null) {
				var numLength:Number=objPage.files.length;
				for (var i:Number=0; i < numLength; i++) {
					BedrockEngine.loadManager.addToQueue(objPage.files[i]);
				}
			} else {
				this.status("No additional files to load!");
			}
			var strPath:String;
			if (objPage.url != null) {
				strPath = objPage.url;
			} else {
				strPath = BedrockEngine.config.getValue(BedrockData.SWF_PATH) + objPage.alias + ".swf";
			}						
			BedrockEngine.loadManager.addToQueue(strPath,BedrockEngine.containerManager.getContainer(BedrockData.PAGE_CONTAINER));
			BedrockEngine.bedrock::transitionManager.pageLoader = BedrockEngine.containerManager.getContainer(BedrockData.PAGE_CONTAINER) as VisualLoader;
		}
		
		
		public function getDefaultPage($details:Object = null):String
		{
			var strDefaultAlias:String;
			try {
				strDefaultAlias=$details.alias;
				this.status("Pulling from Event - " + strDefaultAlias);
			} catch ($e:Error) {
				if (BedrockEngine.config.getSetting(BedrockData.DEEP_LINKING_ENABLED)){
					strDefaultAlias = DeepLinkUtil.getPathNames()[0];
					this.status("Pulling from URL - " + strDefaultAlias);
				}
			} finally {
				if (strDefaultAlias == null) {
					if (BedrockEngine.config.getParam(BedrockData.DEFAULT_PAGE) != null) {
						strDefaultAlias = BedrockEngine.config.getParam(BedrockData.DEFAULT_PAGE);
						this.status("Pulling from Params - " + strDefaultAlias);
					} else {
						strDefaultAlias = BedrockEngine.config.getSetting(BedrockData.DEFAULT_PAGE);
						this.status("Pulling from Config - " + strDefaultAlias);
					}
				}
							
			}
			return strDefaultAlias;
		}
		
		/*
		Set Queue
		*/
		public function setQueue($page:Object):Boolean
		{
			var bolFirstRun:Boolean = (this._objCurrent == null);
			var objPage:Object = $page;
			if (objPage != null) {
				if (objPage != this._objCurrent) {
					this._objPrevious = this._objCurrent;
					this._objCurrent=objPage;
					BedrockEngine.history.addHistoryItem(objPage);
				} else {
					this.warning("Page already in queue!");
				}
			}
			return bolFirstRun;
		}
		/*
		Load Queue
		*/
		public function getQueue():Object
		{
			var objTemp:Object=this.current;
			if (objTemp == null) {
				this.warning("Queue is empty!");
			}
			return objTemp;
		}
		/*
		Clear Queue
		*/
		public function clearQueue():void
		{
			this._objCurrent=null;
			this._objPrevious=null;
		}
		/*
		Get Current Queue
		*/
		public function get current():Object
		{
			return this._objCurrent;
		}
		/*
		Get Previous Queue
		*/
		public function get previous():Object
		{
			return this._objPrevious;
		}
		
		
		
	}
}