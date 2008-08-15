package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.util.DeepLinkUtil;

	public class SectionManager extends StaticWidget
	{
		
		public static function setupSectionLoad($section:Object):void
		{
			var objSection:Object = $section;
			if (objSection.files != null) {
				var numLength:Number=objSection.files.length;
				for (var i:Number=0; i < numLength; i++) {
					LoadManager.addToQueue(objSection.files[i]);
				}
			} else {
				Logger.status(SectionManager, "No additional files to load!");
			}
			var strPath:String;
			if (objSection.url != null) {
				strPath = objSection.url;
			} else {
				strPath = Config.getValue(BedrockData.SWF_PATH) + objSection.alias + ".swf";
			}						
			LoadManager.addToQueue(strPath,ContainerManager.getContainer(BedrockData.SECTION_CONTAINER));
			TransitionManager.sectionLoader = ContainerManager.getContainer(BedrockData.SECTION_CONTAINER) as VisualLoader;
		}
		
		
		public static function getDefaultSection($details:Object = null):String
		{
			var strDefaultAlias:String;
			try {
				strDefaultAlias=$details.alias;
				Logger.status(SectionManager, "Pulling from Event - " + strDefaultAlias);
			} catch ($e:Error) {
				if (Config.getSetting(BedrockData.DEEP_LINKING_ENABLED)){
					strDefaultAlias = DeepLinkUtil.getPathNames()[0];
					Logger.status(SectionManager, "Pulling from URL - " + strDefaultAlias);
				}
			} finally {
				if (strDefaultAlias == null) {
					if (Params.getValue(BedrockData.DEFAULT_SECTION) != null) {
						strDefaultAlias=Params.getValue(BedrockData.DEFAULT_SECTION);
						Logger.status(SectionManager, "Pulling from Params - " + strDefaultAlias);
					} else {
						strDefaultAlias=Config.getSetting(BedrockData.DEFAULT_SECTION);
						Logger.status(SectionManager, "Pulling from Config - " + strDefaultAlias);
					}
				}
							
			}
			return strDefaultAlias;
		}
		
		
	}
}