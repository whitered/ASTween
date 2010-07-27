package ru.whitered.tween.displayObject 
{

	/**
	 * @author whitered
	 */
	public interface IPropertyModifier 
	{
		function init():void;
		function update(progress:Number):void;
	}
}
