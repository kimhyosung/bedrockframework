package com.bedrockframework.plugin.loader
{
	import com.bedrockframework.core.base.DispatcherWidget;
	
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class MultiLoader extends DispatcherWidget
	{
		/*
		Variable Declarations
		*/
		public static const NEW_DOMAIN:uint = 1;
		public static const REUSE_DOMAIN:uint = 2;
		
		public var applicationDomain:ApplicationDomain;
		public var securityDomain:SecurityDomain;
		
		public var loaderContext:LoaderContext;
		
		public var checkPolicyFile:Boolean;
		public var addWhileRunning:Boolean;
		
		private var _numApplicationDomainUsage:uint;
		/*
		Constructor
		*/
		
		public function MultiLoader()
		{
			this.checkPolicyFile = false;
			this.addWhileRunning = false;
			this.applicationDomainUsage = MultiLoader.NEW_DOMAIN;			
		}
		/*
		Create Context
		*/
		protected function generateLoaderContext():LoaderContext
		{
			if (this.loaderContext != null) {
				return this.loaderContext;
			} else {
				switch (this._numApplicationDomainUsage) {
					case 1 :
						return new LoaderContext(this.checkPolicyFile, new ApplicationDomain(this.applicationDomain), this.securityDomain);
						break;
					case 2 :
						return new LoaderContext(this.checkPolicyFile, this.applicationDomain, this.securityDomain);
						break;
				}
			}
		}
		
		public function set applicationDomainUsage($id:uint):void
		{
			this._numApplicationDomainUsage = $id;
		}
		
		public function get applicationDomainUsage():uint
		{
			return this._numApplicationDomainUsage;
		}
	}
}