package ru.whitered.tween.pulse 
{
	import flash.utils.Dictionary;

	/**
	 * @author whitered
	 */
	public class PulseGenerator 
	{
		private static const pulses:Dictionary = new Dictionary(true);
		
		
		
		public static function get enterFrame():IPulse
		{
			for (var p:* in pulses)
			{
				if(pulses[p] == -1) return IPulse(p);
			}
			
			const pulse:IPulse = new EnterFramePulse();
			pulses[pulse] = -1;
			return pulse;
		}

		
		
		public static function getTimer(interval:uint):IPulse
		{
			for (var p:* in pulses)
			{
				if(pulses[p] == interval) return IPulse(p);
			}
			
			const pulse:IPulse = new TimerPulse(interval);
			pulses[pulse] = interval;
			return pulse;
		}

		
		
		public function PulseGenerator() 
		{
			throw new Error("do not");
		}
	}
}
