package com.bedrock.framework.engine.command
{
	import com.bedrock.framework.core.command.Command;
	import com.bedrock.framework.core.command.ICommand;
	import com.bedrock.framework.core.event.GenericEvent;
	import com.bedrock.framework.engine.BedrockEngine;
	import com.bedrock.framework.engine.data.BedrockAssetGroupData;
	import com.bedrock.framework.engine.data.BedrockContentData;
	import com.bedrock.framework.engine.data.BedrockContentGroupData;
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.engine.event.BedrockEvent;

	public class PrepareInitialLoadCommand extends Command implements ICommand
	{
		public function PrepareInitialLoadCommand()
		{
			super();
		}
		
		public function execute($event:GenericEvent):void
		{
			for each( var assetGroup:BedrockAssetGroupData in BedrockEngine.assetManager.filterGroups( true, BedrockData.INITIAL_LOAD ) ) {
				BedrockEngine.loadController.appendAssets( assetGroup.assets );
			}
			
			for each( var data:BedrockContentData in BedrockEngine.contentManager.filterContents( true, BedrockData.INITIAL_LOAD ) ) {
				if ( data is BedrockContentGroupData ) {
					for each( var subData:BedrockContentData in data.contents ) {
						BedrockEngine.loadController.appendContent( subData );
					}
				} else {
					BedrockEngine.loadController.appendContent( data );
				}
			}
			
		}
		
	}
}