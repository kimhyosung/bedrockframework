package com.bedrock.extension.model
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	dynamic public class ConfigSettingsProxy extends Proxy
	{
		private var _configModel:ConfigModel;
		
		public function ConfigSettingsProxy( $configModel:ConfigModel )
		{
			this._configModel = $configModel;
		}
		
		flash_proxy override function callProperty( $name:*, ...$arguments:Array ):*
		{
			return null;
		}


		flash_proxy override function getProperty( $name:* ):*
		{
			return this._configModel.getSettingValue( $name.toString() );
		}


		flash_proxy override function setProperty( $name:*, $value:* ):void
		{
			this._configModel.setSettingValue( $name.toString(), $value );
		}


		flash_proxy override function deleteProperty( $name:* ):Boolean
		{
			return false;
		}
	}
}