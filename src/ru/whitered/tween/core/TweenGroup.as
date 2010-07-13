package ru.whitered.tween.core 
{
	import flash.utils.Dictionary;
	import ru.whitered.signaller.Signaller;
	import ru.whitered.signaller.ISignal;

	/**
	 * @author whitered
	 */
	public class TweenGroup implements ITween 
	{
		private const _onComplete:Signaller = new Signaller();
		
		
		
		private var tweens:Vector.<ITween>;
		private var playingTweens:Dictionary;
		
		private var _isPlaying:Boolean = false;
		
		
		
		public function add(tween:ITween):void
		{
			if(!tweens)
			{
				tweens = new Vector.<ITween>();
			}
			else if(tweens.indexOf(tween) >= 0)
			{
				return;
			}
			
			
			tweens.push(tween);
			
			if(_isPlaying)
			{
				startTween(tween);
			}
		}
		
		
		
		public function remove(tween:ITween):void
		{
			const index:int = tweens ? tweens.indexOf(tween) : -1;
			if(index == -1) return;
			
			tweens.splice(index, 1);
			
			if(_isPlaying)
			{
				handleTweenComplete(tween);
			}
		}
		
		
		
		public function start():void
		{
			if(_isPlaying) return;
			
			playingTweens = new Dictionary();
			
			for each(var tween:ITween in tweens)
			{
				startTween(tween);
			}
			
			checkCompletion();
		}
		
		
		
		private function startTween(tween:ITween):void
		{
			tween.start();
			if(tween.isPlaying)
			{
				playingTweens[tween] = true;
				tween.onComplete.add(handleTweenComplete);
			}
		}

		
		
		public function stop():void
		{
			if(!_isPlaying) return;
			
			playingTweens = null;
			
			for each(var tween:ITween in tweens)
			{
				tween.stop();
				tween.onComplete.remove(handleTweenComplete);
			}
		}
		
		
		
		public function reset():void
		{
			for each(var tween:ITween in tweens)
			{
				tween.reset();
				
				if(_isPlaying && !tween.isPlaying)
				{
					startTween(tween);
				}
			}
		}
		
		
		
		private function handleTweenComplete(tween:ITween):void 
		{
			delete playingTweens[tween];
			checkCompletion();
		}
		
		
		
		private function checkCompletion():void
		{
			for (var key:* in playingTweens)
			{
				return;
				key;
			}
			
			stop();
			_onComplete.dispatch(this);
		}

		
		
		public function get onComplete():ISignal
		{
			return _onComplete.signal;
		}
		
		
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
	}
}