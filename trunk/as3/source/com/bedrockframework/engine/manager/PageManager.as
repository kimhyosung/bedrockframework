package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.util.DeepLinkUtil;

	public class PageManager extends StaticWidget
	{
		
		public static function setupPageLoad($page:Object):void
		{
			var objPage:Object = $page;
			if (objPage.files != null) {
				var numLength:Number=objPage.files.length;
				for (var i:Number=0; i < numLength; i++) {
					LoadManager.addToQueue(objPage.files[i]);
				}
			} else {
				Logger.status(PageManager, "No additional files to load!");
			}
			var strPath:String;
			if (objPage.url != null) {
				strPath = objPage.url;
			} else {
				strPath = Config.getValue(BedrockData.SWF_PATH) + objPage.alias + ".swf";
			}						
			LoadManager.addToQueue(strPath,ContainerManager.getContainer(BedrockData.PAGE_CONTAINER));
			TransitionManager.pageLoader = ContainerManager.getContainer(BedrockData.PAGE_CONTAINER) as VisualLoader;
		}
		
		
		public static function getDefaultPage($details:Object = null):String
		{
			var strDefaultAlias:String;
			try {
				strDefaultAlias=$details.alias;
				Logger.status(PageManager, "Pulling from Event - " + strDefaultAlias);
			} catch ($e:Error) {
				if (Config.getSetting(BedrockData.DEEP_LINKING_ENABLED)){
					strDefaultAlias = DeepLinkUtil.getPathNames()[0];
					Logger.status(PageManager, "Pulling from URL - " + strDefaultAlias);
				}
			} finally {
				if (strDefaultAlias == null) {
					if (Params.getValue(BedrockData.DEFAULT_PAGE) != null) {
						strDefaultAlias=Params.getValue(BedrockData.DEFAULT_PAGE);
						Logger.status(PageManager, "Pulling from Params - " + strDefaultAlias);
					} else {
						strDefaultAlias=Config.getSetting(BedrockData.DEFAULT_PAGE);
						Logger.status(PageManager, "Pulling from Config - " + strDefaultAlias);
					}
				}
							
			}
			return strDefaultAlias;
		}
		
		
	}
}