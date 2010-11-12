package com.bedrock.framework.engine.api
{
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	public interface ILoadManager extends IEventDispatcher
	{
		function initialize( $applicationDomain:ApplicationDomain ):void;
		function load():void
		
		function appendLoader( $loader:* ):void;
		function appendContent( $page:Object ):void;
		function appendAsset( $asset:Object ):void;
		/*
		Getters
		*/
		function getLoader( $nameOrURL:String ):*;
		function getContent( $nameOrURL:String ):*
		/*
		Property Definitions
		*/
		function set checkPolicyFile( $status:Boolean ):void;
		function get checkPolicyFile():Boolean;
		
		function set maxConnections( $count:uint ):void;
		function get maxConnections():uint;
		
		function set applicationDomain( $applicationDomain:ApplicationDomain ):void;
		function get applicationDomain():ApplicationDomain;
		
	}
}