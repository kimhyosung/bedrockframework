﻿package com.bedrockframework.plugin.timer{	/*	imports	*/	import com.bedrockframework.core.base.DispatcherWidget;	import com.bedrockframework.plugin.event.IntervalTriggerEvent;		import flash.utils.*;	/*	class	*/	public class IntervalTrigger extends DispatcherWidget	{		/*		Variables		*/		private var _numMilliseconds:Number;		private var _numSeconds:Number;		private var _numID:uint;		private var _bolRunning:Boolean;		private var _numLoops:int;		private var _numIndex:Number;		/*		Constructor		*/		public function IntervalTrigger($time:Number = 0.5):void		{			this._numSeconds = $time;			this._bolRunning = false;			this._numLoops = -1;		}		/*		public functions		*/		public function start($time:Number = -1 , $loops:int = -1):void		{			if (!this._bolRunning) {				this.status("Start");				this._numSeconds = ($time != -1) ? $time : this._numSeconds;				this._numMilliseconds = this._numSeconds * 1000;				this._numID = setInterval(this.trigger, this._numMilliseconds);				this._numLoops = $loops;				this._numIndex = 0;				this._bolRunning = true;				this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.START, this, {seconds:this._numSeconds, milliseconds:this._numMilliseconds, loops:this._numLoops}));			}		}		public function stop():void		{			if (this._bolRunning) {				this.status("Stop");				this._numIndex = 0;				this._bolRunning = false;				clearInterval(this._numID);				this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.STOP, this,{seconds:this._numSeconds, milliseconds:this._numMilliseconds, loops:this._numLoops}));			}					}		public function trigger():void		{			this.dispatchEvent(new IntervalTriggerEvent(IntervalTriggerEvent.TRIGGER, this,{index:this._numIndex, loops:this._numLoops}));			this._numIndex++;			if (this._numLoops > 0) {				if (this._numIndex >= this._numLoops) {					this.stop();				}			}		}		/*		Property Definitions		*/		public function get seconds():Number		{			return this._numSeconds;		}		public function get milliseconds():Number		{			return this._numMilliseconds / 1000;		}		public function get loops():Number		{			return this._numLoops;		}		public function get running():Boolean		{			return this._bolRunning;		}		public function get elapsed():Number		{			return this._numIndex * this._numMilliseconds / 1000;		}	}}