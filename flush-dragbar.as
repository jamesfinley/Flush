/* ====================================================================== //
// = Dragbar Widget
// ====================================================================== */
_root.flush.extend({
	dragbar: function (orientation, min, max, callback, press, release) {
		var obj = this.object;
		this.event('onPress', function () {
			if (orientation == 'vertical') {
				this.startDrag(false, $(obj).x(), min, $(obj).x(), max);
			}
			else {
				this.startDrag(false, min, $(obj).y(), max, $(obj).y());
			}
			$(obj).enterFrame(function () {
				var percent = (orientation == 'vertical' ? $(this).y() - min : $(this).x() - min) / (max - min);
				if (callback) callback(percent, (orientation == 'vertical' ? $(this).y() : $(this).x()));
			});
			
			if (press) press();
		}).event('onRelease', function () {
			stopDrag();
			$(obj).event('onEnterFrame', null);
			
			var percent = (orientation == 'vertical' ? $(obj).y() - min : $(obj).x() - min) / (max - min);
			if (release) release(percent, (orientation == 'vertical' ? $(obj).y() : $(obj).x()));
		}).event('onReleaseOutside', function () {
			stopDrag();
			$(obj).event('onEnterFrame', null);
			
			var percent = (orientation == 'vertical' ? $(obj).y() - min : $(obj).x() - min) / (max - min);
			if (release) release(percent, (orientation == 'vertical' ? $(obj).y() : $(obj).x()));
		});
		
		return this;
	}
});