package ru.whitered.tween.core 
{
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public interface ITween 
	{
		function start():void;
		function stop():void;
		function reset():void;
		
		function get isPlaying():Boolean;
		
		function get onComplete():ISignal;
	}
}
