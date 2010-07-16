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

		
		
		public function TweenGroup(tweens:Vector.<ITween> = null) 
		{
			for each(var tween:ITween in tweens)
			{
				add(tween);
			}
		}

		
		
		
		public function add(tween:ITween):Boolean
		{
			if(!tweens)
			{
				tweens = new Vector.<ITween>();
			}
			else if(tweens.indexOf(tween) >= 0)
			{
				return false;
			}
			
			
			tweens.push(tween);
			
			if(_isPlaying)
			{
				startTween(tween);
			}
			
			return true;
		}
		
		
		
		public function remove(tween:ITween):Boolean
		{
			const index:int = tweens ? tweens.indexOf(tween) : -1;
			if(index == -1) return false;
			
			const lastElem:ITween = tweens.pop();
			if(lastElem != tween) tweens[index] = lastElem;
			
			if(_isPlaying && playingTweens[tween])
			{
				handleTweenComplete(tween);
			}
			
			return true;
		}
		
		
		
		public function start():Boolean
		{
			if(_isPlaying) return false;
			
			playingTweens = new Dictionary();
			
			for each(var tween:ITween in tweens)
			{
				startTween(tween);
			}
			
			for each(var key:* in playingTweens)
			{
				return true;
				key;
			}
			
			return false;
		}
		
		
		
		private function startTween(tween:ITween):void
		{
			if(tween.start())
			{
				playingTweens[tween] = true;
				tween.onComplete.add(handleTweenComplete);
			}
		}

		
		
		public function stop():Boolean
		{
			if(!_isPlaying) return false;
			
			playingTweens = null;
			
			for each(var tween:ITween in tweens)
			{
				tween.stop();
				tween.onComplete.remove(handleTweenComplete);
			}
			
			return true;
		}
		
		
		
		public function rewind():void
		{
			for each(var tween:ITween in tweens)
			{
				tween.rewind();
				
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