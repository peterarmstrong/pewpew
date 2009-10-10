package com.mikechambers.pewpew.ui
{
	import com.mikechambers.pewpew.utils.NumberUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.system.System;
	
	public class FPSView extends GameUIComponent
	{
		private static const TIMER_INTERVAL:Number = 1000;
		
		private static const AVG_FRAME_COUNT:uint = 10;
		
		//instantiated within FLA
		public var fpsField:TextField;
		public var afpsField:TextField;
		public var memField:TextField;
		public var maxMemField:TextField;
		
		private var timer:Timer;
		
		private var frameCount:uint = 0;
		private var timerCount:uint = 0;
		
		private var totalFrames:uint = 0;
		
		private var frameTimes:Vector.<uint>;
		private var maxMemory:uint = 0;
		
		public function FPSView()
		{
			super();
			
			frameTimes = new Vector.<uint>(AVG_FRAME_COUNT);
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, true);
		}
		
		private function onStageAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			timer = new Timer(TIMER_INTERVAL);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
		}		
		
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}
		
		private function onEnterFrame(e:Event):void
		{
			frameCount++;
		}
		
		private function onTimer(e:TimerEvent):void
		{
			timerCount++;
			fpsField.text = String(frameCount);
			
			frameTimes.shift();
			frameTimes.push(frameCount);
			
			var aSum:uint = 0;
			
			for each(var n:uint in frameTimes)
			{
				aSum += n;
			}
			frameCount = 0;
			
			var afps:Number = Math.round(aSum / AVG_FRAME_COUNT * 1000) / 1000;
			afpsField.text = String(afps);
			
			var mem:Number = Math.abs(System.totalMemory);

			if(mem > maxMemory)
			{
				maxMemory = mem;
				maxMemField.text = NumberUtil.formatNumber(maxMemory / 1024) + " kb";
			}
			
			memField.text = NumberUtil.formatNumber(mem / 1024) + " kb";			
			
			if(totalFrames < AVG_FRAME_COUNT)
			{
				totalFrames++;
				return;
			}
		}
		
	}

}

