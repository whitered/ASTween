package ru.whitered.tween.core 
{
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public interface ITween 
	{
		function start():Boolean;
		function stop():Boolean;
		function rewind():void;
		
		function get isPlaying():Boolean;
		
		function get onComplete():ISignal;
	}
}
