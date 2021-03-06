#Rem
Copyright (c) 2011 Steve Revill and Shane Woolcock
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#End

Function LinearTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	Return diff * t / d + b
End

Function QuadTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d / 2
	If t < 1 Return diff / 2 * t * t + b
	t -= 1
	Return -diff / 2 * (t * (t - 2) - 1) + b
End

Function QuinticTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d / 2
	If (t < 1) Return diff / 2 * t * t * t * t * t + b
	t -= 2
	Return diff / 2 * (t * t * t * t * t + 2) + b
End

Function TweenCalc:Float(p1:Float, p2:Float, t:Float)
	Return p1 + t * (p2 - p1)
End

Function TweenSmooth:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	Return p1 + v * (p2 - p1)
End

Function SmoothStep:Float(x:Float, interpSmooth:Int = 1)
	For Local i:Int = 0 Until interpSmooth
		x *= x * (3 - 2 * x)
	Next

	Return x
End

Function TweenUp:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	v = Pow(v, 2) 'power of 2.
	Return p1 + v * (p2 - p1)
End

Function TweenDown:Float(p1:Float, p2:Float, t:Float)
	Local v:Float = SmoothStep(t)
	v = 1 - Pow(1 - v, 2) 'InvSquared
	Return p1 + v * (p2 - p1)
End

Function Bezier:Float(p1:Float, p2:Float, cp1:Float, cp2:Float, t:Float)
	Local v:Float = p1 * Pow( (1 - t), 3) + 3 * cp1 * Pow( (1 - t), 2) * t + 3 * cp2 * (1 - t) * Pow(t, 2) + p2 * Pow(t, 3)
	Return v
End

Function EaseInBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	Return diff - EaseOutBounceTween(d - t, 0, diff, d) + b
End

Function EaseOutBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	t /= d
	If (t < (1 / 2.75))
		Return diff * (7.5625 * t * t) + b
	ElseIf(t < (2 / 2.75))
		t -= (1.5 / 2.75)
		Return diff * (7.5625 * t * t + 0.75) + b
	ElseIf(t < (2.5 / 2.75))
		t -= (2.25 / 2.75)
		Return diff * (7.5625 * t * t + 0.9375) + b
	Else
		t -= (2.625 / 2.75)
		Return diff * (7.5625 * t * t + 0.984375) + b
	End
End

Function EaseInOutBounceTween:Float(b:Float, c:Float, t:Float, d:Float = 1)
	Local diff:Float = c - b
	If (t < d / 2)
		Return EaseInBounceTween(t * 2, 0, diff, d) * 0.5 + b
	End
	Return EaseOutBounceTween(t * 2 - d, 0, diff, d) * 0.5 + diff * 0.5 + b
End

Function BackEaseInTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	t /= d
	Return diff * t * t * ( (s + 1) * t - s) + b
End

Function BackEaseOutTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	t = t / d - 1
	Return diff * (t * t * ( (s + 1) * t + s) + 1) + b
End

Function BackEaseInOutTween:Float(b:Float, c:Float, t:Float, d:Float = 1, s:Float = 2)
	Local diff:Float = c - b
	Local s2:Float = s
	t /= d / 2
	s2 *= 1.525
	If t < 1
		Return diff / 2 * (t * t * ( (s2 + 1) * t - s2)) + b
	End
	t -= 2
	Return diff / 2 * (t * t * ( (s2 + 1) * t + s2) + 2) + b
End