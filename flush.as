/* ====================================================================== //// = Copyright © 2009 James Finley// = ==================================================================== //// = The dollar sign! OMGROTFLOLcopter!// = This is, of course, the initializer of Flush objects// ====================================================================== */var $ = function (object) {	return new Flush(object);};/* ====================================================================== //// = Flush Core Object and Core Methods// ====================================================================== */var Flush = function (object) {	this.init(object);};Flush.fn = Flush.prototype = {	_isFlush: true,	_type: 'movieclip',	object: null,	init: function (object) {		if (typeof object == 'movieclip' || typeof object == 'object') {			var type    = object instanceof TextField ? 'text' : 'movieclip';			this.object = object;			this._type  = object._flushObjectType ? object._flushObjectType : type;		}		else if (object) {			this.object = eval(object);		}		return this;	},	extend: function (obj, target) {		target = target ? target : this.constructor.prototype;		for (var i in obj) {			target[i] = obj[i];		}		return target;	},	type: function (type) {		if (type) {			this._type                   = type;			this.object._flushObjectType = type;			return this;		}		return this._type;	},	get: function () {		return this.object;	},	parent: function () {		return $(!this.object._parent ? _root : this.object._parent);	},	find: function (mcName) {		return this.object[mcName] ? $(this.object[mcName]) : false;	},	clone: function (mcName, depth) {		var clone = this.object.duplicateMovieClip(mcName, depth);		for (var i in this.object) {			if (typeof this.object[i] != 'movieclip') {				clone[i] = this.object[i];			}		}				return $(clone);	},	remove: function () {		this.object.removeMovieClip();		delete this.object;	},	each: function (item, fn) {		if (item instanceof Array) {			for (var i=0; i<item.length; i++) {				fn(i, item[i]);			}		}		else {			for (var i in item) {				fn(i, item[i]);			}		}		return this;	}};/* ====================================================================== //// = Timeline Methods// ====================================================================== */Flush.fn.extend({	frame: function (frameNum, stop) {		if (stop) {			this.object.gotoAndStop(frameNum);		}		else {			this.object.gotoAndPlay(frameNum);		}		return this;	}});/* ====================================================================== //// = Property Methods// = note: Though property and prop do the same thing, prop is used// = internally and eventually I want to phase out property all together.// ====================================================================== */Flush.fn.extend({	variable: function (name, value) {		if (typeof name == 'object') {			for (var i in name) {				this.object[i] = name[i];			}		}		else {			if (typeof value != 'undefined') {				this.object[name] = value;			}			else {				return this.object[name];			}		}		return this;	},	property: function (name, value) {		return this.variable(name, value);	},	prop: function (name, value) {		return this.variable(name, value);	},	width: function (value) {		if (this.object == _depth0 && !value) {			return Stage.width;		}		else {			return this.prop('_width',value);		}	},	height: function (value) {		if (this.object == _depth0 && !value) {			return Stage.height;		}		else {			return this.prop('_height',value);		}	},	x: function (value) {		return this.prop('_x',value);	},	y: function (value) {		return this.prop('_y',value);	},	alpha: function (value) {		return this.prop('_alpha',value);	}});/* ====================================================================== //// = Event Methods// = note: this needs to eventually move over to use event listeners// ====================================================================== */Flush.fn.extend({	event: function (event, func) {		if (func != null) {			this.object[event] = func;		}		else {			delete this.object[event];		}		return this;	},	enterFrame: function (func) {		return this.event('onEnterFrame', func);	},	rollOver: function (func) {		return this.event('onRollOver', func);	},	rollOut: function (func) {		return this.event('onRollOut', func);	},	release: function (func) {		return this.event('onRelease', func);	},	releaseOutside: function (func) {		return this.event('onReleaseOutside', func);	},	press: function (func) {		return this.event('onPress', func);	},	keyUp: function (func) {		return this.event('onKeyUp', func);	},	focus: function (func) {		return this.event('onFocus', func);	},	blur: function (func) {		return this.event('onBlur', func);	}});/* ====================================================================== //// = Manipulation Methods// ====================================================================== */Flush.fn.extend({	align: function (x, y, object) {		//get object width and height		var objectWidth      = this.width();		var objectHeight     = this.height();				var parentWidth, parentHeight, newX, newY;		switch (object) {			case 'object':				parentWidth  = arguments[3]._width;				parentHeight = arguments[3]._height;				break;			case 'coords':				parentWidth  = arguments[3]				parentHeight = arguments[4];				break;			default:				parentWidth  = this.parent().width();				parentHeight = this.parent().height();				break;		}				switch (x) {			case 'left':				newX         = 0;				break;			case 'right':				newX         = parentWidth-objectWidth;				break;			default:				newX         = (parentWidth-objectWidth) / 2;				break;		}				switch (y) {			case 'top':				newY         = 0;				break;			case 'bottom':				newY         = parentHeight-objectHeight;;				break;			default:				newY         = (parentHeight-objectHeight) / 2;				break;		}				//set new x and y		this.x(newX).y(newY);				return this;	},	center: function (object) {		this.align('center','center',object,arguments[1],arguments[2]);		return this;	},	createEmpty: function (mcName, depth) {		var empty = $(this.object.createEmptyMovieClip(mcName, depth));		empty.type('movieclip');		return empty;	},	mask: function (mask, cacheBitmap) {		if (cacheBitmap) {			this.object.cacheAsBitmap = true;			mask.cacheAsBitmap        = true;		}		this.object.setMask(mask._isFlush ? mask.get() : mask);				return this;	},	filter: function (name, settings) {		//get filters		import flash.filters.*;				switch (name) {			case 'blur':				var blurX    = settings.blurX ? settings.blurX : settings.blur ? settings.blur : 5;				var blurY    = settings.blurY ? settings.blurY : settings.blur ? settings.blur : 5;				var quality  = settings.quality ? settings.quality : 1;								var blur     = new BlurFilter();				blur.blurX   = blurX;				blur.blurY   = blurY;				blur.quality = quality;								this.object.filters = [blur];								break;			case 'shadow':				var angle    = typeof settings.angle == 'number' ? settings.angle : 45;				var blurX    = settings.blurX ? settings.blurX : typeof settings.blur == 'number' ? settings.blur : 5;				var blurY    = settings.blurY ? settings.blurY : typeof settings.blur == 'number' ? settings.blur : 5;				var color    = settings.color ? settings.color : 0x000000;				var distance = typeof settings.distance == 'number' ? settings.distance : 10;				var hideObj  = settings.hideObject ? settings.hideObject : false;				var inner    = settings.inner ? settings.inner : false;				var knockout = settings.knockout ? setting.knockout : false;				var quality  = settings.quality ? settings.quality : 1;				var strength = settings.strength ? settings.strength : 1;								var dropShadow = new DropShadowFilter();				dropShadow.angle      = angle;				dropShadow.blurX      = blurX;				dropShadow.blurY      = blurY;				dropShadow.distance   = distance;				dropShadow.color      = color;				dropShadow.hideObject = hideObj;				dropShadow.inner      = inner;				dropShadow.knockout   = knockout;				dropShadow.quality    = quality;				dropShadow.strength   = strength;								this.object.filters   = [dropShadow];								break;		}				return this;	},	depth: function (depth) {		if (typeof depth == 'number') {			this.object.swapDepths(depth);			return this;		}		else {			return this.object.getDepth();		}	},	blend: function (value) {		var modes = ['', 'normal', 'layer', 'multiply', 'screen', 'lighten', 'darken', 'difference', 'add', 'subtract', 'invert', 'alpha', 'erase', 'overlay', 'hardlight'];		if (!value) {			var blendMode = this.prop('blendMode');			blendMode     = modes[blendMode];						return blendMode;		}		else {			var obj = this;			this.each(modes, function (i, mode) {				if (value == mode) {					obj.property('blendMode', i);				}			});			return this;		}	}});/* ====================================================================== //// = Animation Methods// ====================================================================== */Flush.fn.extend({	animate: function () {		//get vars		if (typeof arguments[0] == 'object') {			var easeClass  = arguments[0].easeClass;			var easeMethod = arguments[0].easeMethod;			var duration   = arguments[0].duration ? arguments[0].duration : .5;			var callback   = arguments[0].callback;						//delete vars from object			delete arguments[0].easeClass;			delete arguments[0].easeMethod;			delete arguments[0].duration;			delete arguments[0].callback;						if (arguments[0].property) {				var property   = arguments[0].property;				var value      = arguments[0].relValue ? arguments[0].relValue+this.prop(property) : arguments[0].value;			}			else {				var anims      = [];				for (var i in arguments[0]) {					anims.push({						property: i,						value: arguments[0][i]					});				}				for (var i=0; i<anims.length; i++) {					this.animate(anims[i].property, anims[i].value, easeClass, easeMethod, duration, anims.length-1 == i ? callback : null);				}				return this;			}		}		else {			var property   = arguments[0];			var value      = arguments[1];			var easeClass  = arguments[2];			var easeMethod = arguments[3];			var duration   = arguments[4] ? arguments[4] : .5;			var callback   = arguments[5];		}				if (property) {			//run expressions for value			if (typeof value == 'string') {				value          = value.replace('_width',this.width());				value          = value.replace('_height',this.height());				value          = value.replace('_alpha',this.prop('_alpha'));				value          = value.replace('_rotation',this.prop('_rotation'));								//do the math				value          = value.split('*').length > 1 ? parseInt(value.split('*')[0])*parseInt(value.split('*')[1]) : value;				value          = value.split('+').length > 1 ? parseInt(value.split('+')[0])+parseInt(value.split('+')[1]) : value;			}						if (property && value != null) {				//get easeType				var easeType;								switch (easeClass) {					case 'back':						if (easeMethod == 'out') easeType = mx.transitions.easing.Back.easeOut;						else if (easeMethod == 'in') easeType = mx.transitions.easing.Back.easeIn;						else if (easeMethod == 'both') easeType = mx.transitions.easing.Back.easeInOut;						else easeType = mx.transitions.easing.Back.easeOut;						break;					case 'bounce':						if (easeMethod == 'out') easeType = mx.transitions.easing.Bounce.easeOut;						else if (easeMethod == 'in') easeType = mx.transitions.easing.Bounce.easeIn;						else if (easeMethod == 'both') easeType = mx.transitions.easing.Bounce.easeInOut;						else easeType = mx.transitions.easing.Bounce.easeOut;						break;					case 'elastic':						if (easeMethod == 'out') easeType = mx.transitions.easing.Elastic.easeOut;						else if (easeMethod == 'in') easeType = mx.transitions.easing.Elastic.easeIn;						else if (easeMethod == 'both') easeType = mx.transitions.easing.Elastic.easeInOut;						else easeType = mx.transitions.easing.Elastic.easeOut;						break;					case 'regular':						if (easeMethod == 'out') easeType = mx.transitions.easing.Regular.easeOut;						else if (easeMethod == 'in') easeType = mx.transitions.easing.Regular.easeIn;						else if (easeMethod == 'both') easeType = mx.transitions.easing.Regular.easeInOut;						else easeType = mx.transitions.easing.Regular.easeOut;						break;					case 'strong':						if (easeMethod == 'out') easeType = mx.transitions.easing.Strong.easeOut;						else if (easeMethod == 'in') easeType = mx.transitions.easing.Strong.easeIn;						else if (easeMethod == 'both') easeType = mx.transitions.easing.Strong.easeInOut;						else easeType = mx.transitions.easing.Strong.easeOut;						break;					default:						easeType = null;						break;				}							//import libraries				import mx.transitions.Tween;				import mx.transitions.easing.*;								if (!_root.__tweens) {					_root.__tweens = [];				}								motionTween = new mx.transitions.Tween(this.object, property, easeType, this.prop(property), value, duration, true);								motionTween.FlushObject = this;				motionTween.callback    = callback;				motionTween.onMotionFinished = function () {					this.callback(this.FlushObject);				};								_root.__tweens.push(motionTween);			}		}		return this;	},	endAnimations: function () {		for (var i=0; i<_root.__tweens.length; i++) {			_root.__tweens[i].stop();		}	},	hide: function (effect, d) {		if (effect == 'fade') {			this.animate({				property: '_alpha',				value: 0/*,				duration: d ? d : .5*/			});		}		else {			this.prop('_alpha',0);		}		return this;	},	show: function (effect, d) {		if (effect == 'fade') {			this.animate({				property: '_alpha',				value: 100/*,				duration: d ? d : .5*/			});		}		else {			this.prop('_alpha',100);		}		return this;	}});/* ====================================================================== //// = Draw Methods// ====================================================================== */Flush.fn.extend({	draw: function (type,mcName,depth,alignment) {		switch (type) {			case 'shape':				var coords      = arguments[4];				var fillColor   = arguments[5];				var borderSize  = arguments[6];				var borderColor = arguments[7];								break;			case 'line':				var coords      = arguments[4];				var borderSize  = arguments[5];				var borderColor = arguments[6];								break;			case 'rectangle':				var coords      = [];					coords.push([0,0],[arguments[4],0],[arguments[4],arguments[5]],[0,arguments[5]]);				var fillColor   = arguments[6];				var borderSize  = arguments[7];				var borderColor = arguments[8];								break;			case 'circle':				var radius      = arguments[4]/2;				var x           = 0+radius;				var y           = 0+radius;				var coords      = [];					coords.push([radius+x, y],[radius+x, Math.tan(Math.PI/8)*radius+y, Math.sin(Math.PI/4)*radius+x, Math.sin(Math.PI/4)*radius+y],[Math.tan(Math.PI/8)*radius+x, radius+y, x, radius+y],[-Math.tan(Math.PI/8)*radius+x, radius+y, -Math.sin(Math.PI/4)*radius+x, Math.sin(Math.PI/4)*radius+y],[-radius+x, Math.tan(Math.PI/8)*radius+y, -radius+x, y],[-radius+x, -Math.tan(Math.PI/8)*radius+y, -Math.sin(Math.PI/4)*radius+x, -Math.sin(Math.PI/4)*radius+y],[-Math.tan(Math.PI/8)*radius+x, -radius+y, x, -radius+y],[Math.tan(Math.PI/8)*radius+x, -radius+y, Math.sin(Math.PI/4)*radius+x, -Math.sin(Math.PI/4)*radius+y],[radius+x, -Math.tan(Math.PI/8)*radius+y, radius+x, y]);				var fillColor   = arguments[5];				var borderSize  = arguments[6];				var borderColor = arguments[7];								break;			case 'donut':				var radius      = arguments[4]/2;				var innerRadius = arguments[5]/2;				var x           = 0+radius;				var y           = 0+radius;				var coords      = [];					coords.push([radius+x, y],[radius+x, Math.tan(Math.PI/8)*radius+y, Math.sin(Math.PI/4)*radius+x, Math.sin(Math.PI/4)*radius+y],[Math.tan(Math.PI/8)*radius+x, radius+y, x, radius+y],[-Math.tan(Math.PI/8)*radius+x, radius+y, -Math.sin(Math.PI/4)*radius+x, Math.sin(Math.PI/4)*radius+y],[-radius+x, Math.tan(Math.PI/8)*radius+y, -radius+x, y],[-radius+x, -Math.tan(Math.PI/8)*radius+y, -Math.sin(Math.PI/4)*radius+x, -Math.sin(Math.PI/4)*radius+y],[-Math.tan(Math.PI/8)*radius+x, -radius+y, x, -radius+y],[Math.tan(Math.PI/8)*radius+x, -radius+y, Math.sin(Math.PI/4)*radius+x, -Math.sin(Math.PI/4)*radius+y],[radius+x, -Math.tan(Math.PI/8)*radius+y, radius+x, y]);					coords.push(						[innerRadius+x, y, true],						[innerRadius+x, Math.tan(Math.PI/8)*innerRadius+y, Math.sin(Math.PI/4)*innerRadius+x, Math.sin(Math.PI/4)*innerRadius+y],						[Math.tan(Math.PI/8)*innerRadius+x, innerRadius+y, x, innerRadius+y],						[-Math.tan(Math.PI/8)*innerRadius+x, innerRadius+y, -Math.sin(Math.PI/4)*innerRadius+x, Math.sin(Math.PI/4)*innerRadius+y],						[-innerRadius+x, Math.tan(Math.PI/8)*innerRadius+y, -innerRadius+x, y],						[-innerRadius+x, -Math.tan(Math.PI/8)*innerRadius+y, -Math.sin(Math.PI/4)*innerRadius+x, -Math.sin(Math.PI/4)*innerRadius+y],						[-Math.tan(Math.PI/8)*innerRadius+x, -innerRadius+y, x, -innerRadius+y],						[Math.tan(Math.PI/8)*innerRadius+x, -innerRadius+y, Math.sin(Math.PI/4)*innerRadius+x, -Math.sin(Math.PI/4)*innerRadius+y],						[innerRadius+x, -Math.tan(Math.PI/8)*innerRadius+y, innerRadius+x, y]);				var fillColor   = arguments[6];				var borderSize  = arguments[7];				var borderColor = arguments[8];								break;			case 'roundRectangle':				var width       = arguments[4];				var height      = arguments[5];				var radius      = arguments[6];				var coords      = [];					coords.push([radius, 0],[width - radius, 0],[width, 0, width, radius],[width, radius],[width, height - radius],[width, height, width - radius, height],[width - radius, height],[radius, height],[0, height, 0, height - radius],[0, height - radius],[0, radius],[0, 0, radius, 0],[radius, 0]);				var fillColor   = arguments[7];				var borderSize  = arguments[8];				var borderColor = arguments[9];								break;		}		var empty = this.createEmpty(mcName, depth);		empty.type('shape');		with (empty.get()) {			if (borderSize && borderColor) {				lineStyle(borderSize, borderColor, 100);			}							//get width and height			var maxX       = 0;			var maxY       = 0;			var minX       = 0;			var minY       = 0;			for (var i=0; i<coords.length; i++) {				if (coords[i].length == 2) {					if (coords[i][0] > maxX) maxX = coords[i][0];					if (coords[i][1] > maxY) maxY = coords[i][1];					if (coords[i][0] < minX) minX = coords[i][0];					if (coords[i][1] < minY) minY = coords[i][1];				}			}			var width      = maxX-minX;			var height     = maxY-minY;						//reset coords per alignment			if (alignment) {				if (alignment[0] == 'center') {					for (var i=0; i<coords.length; i++) {						if (coords[i].length == 2) {							coords[i][0] = coords[i][0]-(width/2);						}					}					maxX   = maxX-(width/2);					minX   = minX-(width/2);				}				else if (alignment[0] == 'right') {					for (var i=0; i<coords.length; i++) {						if (coords[i].length == 2) {							coords[i][0] = coords[i][0]-width;						}					}					maxX   = maxX-width;					minX   = 0;				}				if (alignment[1] == 'center') {					for (var i=0; i<coords.length; i++) {						if (coords[i].length == 2) {							coords[i][1] = coords[i][1]-(height/2);						}					}					maxY   = maxY-(height/2);					minY   = minY-(height/2);				}				else if (alignment[1] == 'bottom') {					for (var i=0; i<coords.length; i++) {						if (coords[i].length == 2) {							coords[i][1] = coords[i][1]-height;						}					}					maxY   = maxY-height;					minY   = 0;				}			}						//check to see if gradient is needed			if (fillColor == undefined) {						}			else if (typeof fillColor != 'number') {				var startColor = fillColor[0];				var endColor   = fillColor[1];				var radians    = (fillColor[2] ? fillColor[2] : 0)*Math.PI/180;								beginGradientFill('linear', [startColor,endColor], [100,100], [0,255],{					matrixType: 'box',					x: minX,					y: minY,					w: width,					h: height,					r: radians				});			}			else if (typeof fillColor == 'number') {				beginFill(fillColor, 100);			}							//check that last coordinate			if (coords[coords.length-1] != coords[0] && type != 'line') {				coords.push(coords[0]);			}						moveTo(coords[0][0],coords[0][1]);						for (var i=0; i<coords.length; i++) {				if (coords[i].length == 2) {					lineTo(coords[i][0],coords[i][1]);				}				else if (coords[i].length == 3 && coords[i][2] == true) {					moveTo(coords[i][0],coords[i][1]);				}				else if (coords[i].length == 4) {					curveTo(coords[i][0],coords[i][1],coords[i][2],coords[i][3]);				}			}			endFill();		}				return empty;	}});/* ====================================================================== //// = Load Method// = supports loading of images, sound, and video// ====================================================================== */Flush.fn.extend({	load: function (type, fileName, mcName, depth, callbackFunc, progressFunc) {		if (type == 'image') {			//create empty			var empty      = this.createEmpty(mcName,depth);			empty.type('image');						//create container in empty			var container  = empty.createEmpty('container',0);						//store callback			empty.variable({				callback: callbackFunc,				progress: progressFunc			});						//set-up loader			empty.enterFrame(function () {				if (this.container.getBytesLoaded()/this.container.getBytesTotal() == 1 && this.callback) {					this.loadingProgress = this.container.getBytesLoaded()/this.container.getBytesTotal();					this.progress(this.loadingProgress,this.container.getBytesLoaded(),this.container.getBytesTotal());					this.callback(this);					this.callback = null;				}				else if (this.progress) {					this.loadingProgress = this.container.getBytesLoaded()/this.container.getBytesTotal()*100;					this.progress(this.loadingProgress,this.container.getBytesLoaded(),this.container.getBytesTotal());					if (this.container.getBytesLoaded()/this.container.getBytesTotal() == 1) {						this.progress = null;					}				}			});						//load			container.get().loadMovie(fileName);						return empty;		}		else if (type == 'sound') {			//create empty			var empty     = this.createEmpty(mcName,depth);			empty.type('sound');						//create sound			empty.variable({				sound: new Sound(),				__paused: 0,				play: function (point) {					this.sound.start(typeof point == 'number'?point:this.__paused?this.__paused/1000:0);				},				pause: function () {					this.__paused = this.position();					this.stop();				},				stop: function () {					this.sound.stop();				},				position: function () {					return this.sound.position;				},				volume: function (value) {					if (typeof value != 'undefined') {						this.sound.setVolume(value);					}					return value ? this : this.sound.getVolume();				},				complete: function (fn) {					if (fn) {						this.sound.onSoundComplete = fn;					}					else {						delete this.sound.onSoundComplete;					}					return this;				}			});						//store callback			empty.variable({				callback: callbackFunc,				progress: progressFunc			});						//set-up loader			empty.enterFrame(function () {				if (this.sound.getBytesLoaded()/this.sound.getBytesTotal() == 1 && this.callback) {					this.loadingProgress = this.sound.getBytesLoaded()/this.sound.getBytesTotal();					this.progress(this.loadingProgress,this.sound.getBytesLoaded(),this.sound.getBytesTotal());					this.callback(this);					this.callback = null;				}				else if (this.progress) {					this.loadingProgress = this.sound.getBytesLoaded()/this.sound.getBytesTotal()*100;					this.progress(this.loadingProgress,this.sound.getBytesLoaded(),this.sound.getBytesTotal());					if (this.loadingProgress == 100) {						this.progress = null;					}				}			});						//load			empty.variable('sound').loadSound(fileName);						return empty;		}		else if (type == 'video') {					}	}});/* ====================================================================== //// = Sound & Video Methods// ====================================================================== */Flush.fn.extend({	play: function (point) {		if (this.type() == 'sound') {			if (this.object.sound && this.object.play) {				this.object.play(point);			}		}		return this;	},	pause: function () {		if (this.type() == 'sound') {			if (this.object.sound && this.object.pause) {				this.object.pause();			}		}		return this;	},	stop: function () {		if (this.type() == 'sound') {			if (this.object.sound && this.object.stop) {				this.object.stop();			}		}		return this;	},	volume: function (value) {		if (this.type() == 'sound') {			if (this.object.sound && this.object.volume) {				return value ? this.object.volume(value) ? this : this : this.object.volume();			}		}		return this;	},	position: function () {		if (this.type() == 'sound') {			if (this.object.sound && this.object.position) {				return this.object.position();			}		}		return this;	},	duration: function () {		if (this.type() == 'sound') {			if (this.object.sound && this.object.sound.duration) {				return this.object.sound.duration;			}		}		return this;	},	complete: function (fn) {		if (this.type() == 'sound') {			if (this.object.sound && this.object.complete) {				this.object.complete(fn);				return this;			}		}		return this;	}});/* ====================================================================== //// = Text Methods// ====================================================================== */Flush.fn.extend({	createText: function (fieldName, depth, width, height) {		var empty = $(this.object.createTextField(fieldName, depth, 0, 0, width, height));		empty.type('text');		return empty;	},	val: function (value, html) {		if (this.type() != 'text') return this;		if (value != null) {			if (html) {				this.prop('html',true);				this.prop('htmlText',value);			}			else {				this.prop('text',value);			}			return this;		}		else {			return this.prop('text');		}	},	format: function (format) {		if (this.type() != 'text') return this;		var newFormat = new TextFormat();		for (var i in format) {			newFormat[i] = format[i];		}		this.object.setTextFormat(newFormat);				return this;	},	style: function (style) {		if (this.type() != 'text') return this;		if (style) {			import TextField.StyleSheet;						var newStyle = new StyleSheet();			newStyle.parseCSS(style);						this.prop('styleSheet', newStyle);		}		else {			return this.prop('styleSheet');		}		return this;	}});/* ====================================================================== //// = XML Methods// ====================================================================== */Flush.fn.extend({	xmlCache: {},	xml: function (fileName, callback, process, noCache) {		if (typeof fileName == 'string') {			if (flush.xmlCache[fileName] && !noCache) {				if (process) {					callback(this.xml(flush.xmlCache[fileName]));				}				else {					callback(flush.xmlCache[fileName]);				}			}			else {				var XMLDoc      = new XML();				XMLDoc.callback = callback;				XMLDoc.fileName = (fileName);				XMLDoc.process  = process;				XMLDoc.onLoad   = function (success) {					if (success) {						flush.xmlCache[this.fileName] = this;						if (this.process) {							this.callback($().xml(this));						}						else {							this.callback(this);						}					}				}				XMLDoc.ignoreWhite = true;				XMLDoc.load(fileName);			}						return this;		}		else if (typeof arguments[0] == 'object' && fileName.nodeType) {			var obj = {};			this.processXMLNode(obj, arguments[0].firstChild);						return obj;		}	},	processXMLNode: function (obj, node) {		if (node.nodeType == 1) {			//create holder for node			if (obj[node.nodeName]) {				if (typeof obj[node.nodeName] == 'object' && !obj[node.nodeName].length) {					var _node = obj[node.nodeName];					obj[node.nodeName]    = Array();					obj[node.nodeName][0] = _node;										var holder = obj[node.nodeName][1] = {};				}				else {					var holder = obj[node.nodeName][obj[node.nodeName].length] = {};				}			}			else {				var holder = obj[node.nodeName] = {};			}						//store name			holder.nodeName = node.nodeName;						//store node			holder.node     = node;					//get attributes			for (var i in node.attributes) {				holder['_'+i] = node.attributes[i];			}						//get innerXML			if (node.childNodes) {				holder['__inner__'] = node.childNodes;			}						//get innerXML			if (node.childNodes) {				holder['__content__'] = node.firstChild.nodeValue;			}						//process children			for (var i=0; i<node.childNodes.length; i++) {				this.processXMLNode(holder,node.childNodes[i]);			}		}	}});/* ====================================================================== //// = Accessibility Methods// ====================================================================== */Flush.fn.extend({	access: function (obj, update) {		if (this.object._accProps == undefined) {			this.object._accProps        = new Object();		}		if (obj.silent) 			this.object_accProps.silent      = obj.silent;		if (obj.forceSimple)			this.object_accProps.forceSimple = obj.forceSimple;		if (obj.name)			this.object_accProps.name        = obj.name;		if (obj.description)			this.object_accProps.description = obj.description;		if (obj.shortcut)			this.object_accProps.shortcut    = obj.shortcut;					if (update) {			Accessibility.updateProperties();		}					return this;	}});/* ====================================================================== //// = External Interface Methods// ====================================================================== */Flush.fn.extend({	externalInterface: {		activate: function () {			import flash.external.*;						//add in functionality of FlushJS			this.addCallback('variable',function () {				_root[arguments[0]] = arguments[1];			});			this.addCallback('action',function (fn) {				eval(fn)(arguments);			});			_root.flush.extend({				cookie: function () {					if (arguments.length>1) {						ExternalInterface.call('flushJS.cookie',arguments[0],arguments[1]);					}					else {						return ExternalInterface.call('flushJS.cookie',arguments[0]);					}				}			});		},		addCallback: function (fnname, fn) {			ExternalInterface.addCallback(fnname,_root,fn);		}	}});/* ====================================================================== //// = Utilities// ====================================================================== */function btrace (message) {	getURL('javascript:window.console.log("'+message+'")');}String.prototype.replace = function (str, replacement) {	if (this.split(str).length > 1) {		var text = this.split(str)[0]+replacement+this.split(str)[1];	}	return text ? text : this;};