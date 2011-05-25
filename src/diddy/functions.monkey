Import "native/diddy.${TARGET}.${LANG}"
Import mojo
Import assert

Extern

	#If LANG="cpp" Then
		Function RealMillisecs:Int() = "diddy::systemMillisecs"
		Function FlushKeys:Void() = "diddy::flushKeys"
		Function HideMouse:Void() = "diddy::hideMouse"
		Function ShowMouse:Void() = "diddy::showMouse"
		Function GetUpdateRate:Int() = "diddy::getUpdateRate"
	#Else
		Function RealMillisecs:Int() = "diddy.systemMillisecs"
		Function FlushKeys:Void() = "diddy.flushKeys"
		Function HideMouse:Void() = "diddy.hideMouse"
		Function ShowMouse:Void() = "diddy.showMouse"
		Function GetUpdateRate:Int() = "diddy.getUpdateRate"
	#End
	
Public

Function ExitApp:Void()
	Error ""
End

Function RectsOverlap:Int(x0:Float, y0:Float, w0:Float, h0:Float, x2:Float, y2:Float, w2:Float, h2:Float)
	If x0 > (x2 + w2) Or (x0 + w0) < x2 Then Return False
	If y0 > (y2 + h2) Or (y0 + h0) < y2 Then Return False
	Return True
End

Function DrawRectOutline:Void(x:Int, y:Int, w:Int, h:Int)
	w -= 1
	h -= 1
	DrawLine(x,y,x+w,y)
	DrawLine(x+w,y,x+w,y+h)
	DrawLine(x+w,y+h,x,y+h)
	DrawLine(x,y+h,x,y)	
End

Function LoadBitmap:Image(path$, flags%=0)
	Local pointer:Image = LoadImage(path, 1, flags)

	AssertNotNull(pointer, "Error loading bitmap "+path)
	
   	Return pointer
End

Function LoadAnimBitmap:Image(path$, w%, h%, count%, tmpImage:Image)
	'tmpImage = loadBitmap(path) <-- This creates another image, decided to just copy the code here
	tmpImage = LoadImage(path)
	
	AssertNotNull(tmpImage, "Error loading bitmap "+path)

	local pointer:Image = tmpImage.GrabImage( 0, 0, w, h, count, Image.MidHandle)
	
   	Return pointer
End

Function LoadSoundSample:Sound(path$)
	local pointer:Sound = LoadSound(path)
	AssertNotNull(pointer, "Error loading sound "+path)
	Return pointer
End

Function FormatNumeric:String(value:Float)
	Local i:Int,s:String,ns:String,k:Int
	Local os:String
	s=String(value)
	os=s
	Local pos:Int=s.Length()
	If s.Find(".")>0 pos=s.Find(".") Else os=""
	For i=pos To 1 Step -1
		If k>2 ns+="." k=0
		k+=1
		ns=ns+Mid(s,i,1)
	Next
	s=""
	For i= ns.Length() To 1 Step -1
		s+=Mid(ns,i,1)
	Next
	If os<>"" s=s+","+os[pos+1..]
	Return s
End

Function Left$( str$,n:Int )
	If n>str.Length() n=str.Length()
	Return str[..n]
End

Function Right$( str$,n:Int )
	If n>str.Length() n=str.Length()
	Return str[str.Length()-n..]
End

Function LSet$( str$,n:Int,char:String=" " )
	Local rep:String
	For Local i:Int=1 To n
		rep=rep+char
	Next
	str=str+rep
	Return str[..n]
End

Function RSet$( str$,n:Int,char:String=" " )
	Local rep:String
	For Local i:Int=1 To n
		rep=rep+char
	Next
	str=rep+str
	Return str[str.Length()-n..]
End

Function Mid$( str$,pos:Int,size:Int=-1 )
	If pos>str.Length() Return ""
	pos-=1
	If( size<0 ) Return str[pos..]
	If pos<0 size=size+pos pos=0
	If pos+size>str.Length() size=str.Length()-pos
	Return str[pos..pos+size]
End

Function StripDir$( path$ )
	Local i:=path.FindLast( "/" )
	If i<>-1 Return path[i+1..]
	Return path
End

Function StripExt$( path$ )
	Local i:=path.FindLast( "." )
	If i<>-1 And path.Find( "/",i+1 )=-1 Return path[..i]
	Return path
End

Function StripAll$( path$ )
	Return StripDir( StripExt( path ) )
End

Function Round%(flot#)
	Return Floor(flot+0.5)
End

Function PointInSpot:Int(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float)
	Local dx:Float = x2 - x1
	Local dy:Float = y2 - y1
	Return dx * dx + dy * dy <= radius * radius
End

Function AnyInputPressed:Bool()
	For Local i:Int = 0 To 511
		If KeyHit(i) Then Return True
	Next
	Return False
End

Function FormatNumber:String(number:Float, decimal:Int=4, comma:Int=0, padleft:Int=0 )
	Assert(decimal > -1 And comma > -1 And padleft > -1, "Negative numbers not allowed in FormatNumber()")

	Local str:String = number
	Local dl:Int = str.Find(".")
	If decimal = 0 Then decimal = -1
	str = str[..dl+decimal+1]
	
	If comma
		While dl>comma
			str = str[..dl-comma] + "," + str[dl-comma..]
			dl -= comma
		Wend
	End
	
	If padleft
		Local paddedLength:Int = padleft+decimal+1
		If paddedLength < str.Length Then str = "Error"
		str = RSet(str,paddedLength)
	End
	Return str
End

Function IsWhitespace:Bool(str:String)
	Return str = "~t" Or str = "~n" Or str = "~r" Or str = " "
End

Function IsWhitespace:Bool(val:Int)
	Return val = ASC_TAB Or val = ASC_LF Or val = ASC_CR Or val = ASC_SPACE
End

' control characters
Const ASC_NUL:Int = 0       ' Null character
Const ASC_SOH:Int = 1       ' Start of Heading
Const ASC_STX:Int = 2       ' Start of Text
Const ASC_ETX:Int = 3       ' End of Text
Const ASC_EOT:Int = 4       ' End of Transmission
Const ASC_ENQ:Int = 5       ' Enquiry
Const ASC_ACK:Int = 6       ' Acknowledgment
Const ASC_BEL:Int = 7       ' Bell
Const ASC_BACKSPACE:Int = 8 ' Backspace
Const ASC_TAB:Int = 9       ' Horizontal tab
Const ASC_LF:Int = 10       ' Linefeed
Const ASC_VTAB:Int = 11     ' Vertical tab
Const ASC_FF:Int = 12       ' Form feed
Const ASC_CR:Int = 13       ' Carriage return
Const ASC_SO:Int = 14       ' Shift Out
Const ASC_SI:Int = 15       ' Shift In
Const ASC_DLE:Int = 16      ' Data Line Escape
Const ASC_DC1:Int = 17      ' Device Control 1
Const ASC_DC2:Int = 18      ' Device Control 2
Const ASC_DC3:Int = 19      ' Device Control 3
Const ASC_DC4:Int = 20      ' Device Control 4
Const ASC_NAK:Int = 21      ' Negative Acknowledgment
Const ASC_SYN:Int = 22      ' Synchronous Idle
Const ASC_ETB:Int = 23      ' End of Transmit Block
Const ASC_CAN:Int = 24      ' Cancel
Const ASC_EM:Int = 25       ' End of Medium
Const ASC_SUB:Int = 26      ' Substitute
Const ASC_ESCAPE:Int = 27   ' Escape
Const ASC_FS:Int = 28       ' File separator
Const ASC_GS:Int = 29       ' Group separator
Const ASC_RS:Int = 30       ' Record separator
Const ASC_US:Int = 31       ' Unit separator

' visible characters
Const ASC_SPACE:Int = 32                ' '
Const ASC_EXCLAMATION:Int = 33          '!'
Const ASC_DOUBLE_QUOTE:Int = 34         '"'
Const ASC_HASH:Int = 35                 '#'
Const ASC_DOLLAR:Int = 36               '$'
Const ASC_PERCENT:Int = 37              '%'
Const ASC_AMPERSAND:Int = 38            '&'
Const ASC_SINGLE_QUOTE:Int = 39         '''
Const ASC_OPEN_PARENTHESIS:Int = 40     '('
Const ASC_CLOSE_PARENTHESIS:Int = 41    ')'
Const ASC_ASTERISK:Int = 42             '*'
Const ASC_PLUS:Int = 43                 '+'
Const ASC_COMMA:Int = 44                ','
Const ASC_HYPHEN:Int = 45               '-'
Const ASC_PERIOD:Int = 46               '.'
Const ASC_SLASH:Int = 47                '/'
Const ASC_0:Int = 48
Const ASC_1:Int = 49
Const ASC_2:Int = 50
Const ASC_3:Int = 51
Const ASC_4:Int = 52
Const ASC_5:Int = 53
Const ASC_6:Int = 54
Const ASC_7:Int = 55
Const ASC_8:Int = 56
Const ASC_9:Int = 57
Const ASC_COLON:Int = 58        ':'
Const ASC_SEMICOLON:Int = 59    ';'
Const ASC_LESS_THAN:Int = 60    '<'
Const ASC_EQUALS:Int = 61       '='
Const ASC_GREATER_THAN:Int = 62 '>'
Const ASC_QUESTION:Int = 63     '?'
Const ASC_AT:Int = 64           '@'
Const ASC_UPPER_A:Int = 65
Const ASC_UPPER_B:Int = 66
Const ASC_UPPER_C:Int = 67
Const ASC_UPPER_D:Int = 68
Const ASC_UPPER_E:Int = 69
Const ASC_UPPER_F:Int = 70
Const ASC_UPPER_G:Int = 71
Const ASC_UPPER_H:Int = 72
Const ASC_UPPER_I:Int = 73
Const ASC_UPPER_J:Int = 74
Const ASC_UPPER_K:Int = 75
Const ASC_UPPER_L:Int = 76
Const ASC_UPPER_M:Int = 77
Const ASC_UPPER_N:Int = 78
Const ASC_UPPER_O:Int = 79
Const ASC_UPPER_P:Int = 80
Const ASC_UPPER_Q:Int = 81
Const ASC_UPPER_R:Int = 82
Const ASC_UPPER_S:Int = 83
Const ASC_UPPER_T:Int = 84
Const ASC_UPPER_U:Int = 85
Const ASC_UPPER_V:Int = 86
Const ASC_UPPER_W:Int = 87
Const ASC_UPPER_X:Int = 88
Const ASC_UPPER_Y:Int = 89
Const ASC_UPPER_Z:Int = 90
Const ASC_OPEN_BRACKET:Int = 91     '['
Const ASC_BACKSLASH:Int = 92        '\'
Const ASC_CLOSE_BRACKET:Int = 93    ']'
Const ASC_CIRCUMFLEX:Int = 94       '^'
Const ASC_UNDERSCORE:Int = 95       '_'
Const ASC_BACKTICK:Int = 96         '`'
Const ASC_LOWER_A:Int = 97
Const ASC_LOWER_B:Int = 98
Const ASC_LOWER_C:Int = 99
Const ASC_LOWER_D:Int = 100
Const ASC_LOWER_E:Int = 101
Const ASC_LOWER_F:Int = 102
Const ASC_LOWER_G:Int = 103
Const ASC_LOWER_H:Int = 104
Const ASC_LOWER_I:Int = 105
Const ASC_LOWER_J:Int = 106
Const ASC_LOWER_K:Int = 107
Const ASC_LOWER_L:Int = 108
Const ASC_LOWER_M:Int = 109
Const ASC_LOWER_N:Int = 110
Const ASC_LOWER_O:Int = 111
Const ASC_LOWER_P:Int = 112
Const ASC_LOWER_Q:Int = 113
Const ASC_LOWER_R:Int = 114
Const ASC_LOWER_S:Int = 115
Const ASC_LOWER_T:Int = 116
Const ASC_LOWER_U:Int = 117
Const ASC_LOWER_V:Int = 118
Const ASC_LOWER_W:Int = 119
Const ASC_LOWER_X:Int = 120
Const ASC_LOWER_Y:Int = 121
Const ASC_LOWER_Z:Int = 122
Const ASC_OPEN_BRACE:Int = 123  '{'
Const ASC_PIPE:Int = 124        '|'
Const ASC_CLOSE_BRACE:Int = 125 '}'
Const ASC_TILDE:Int = 126       '~'
Const ASC_DELETE:Int = 127

