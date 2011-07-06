Strict

Import xml
Import assert

Interface ISerializable
	Method Serialize:Void(serializer:Serializer)
	Method GetClassName:String()
	Method GetGenericNames:String[]()
End

Class Serializer Abstract
Private
	Field currentElement:XMLElement

Public
' Abstract
	Method CreateSerializable:ISerializable(className:String) Abstract

' Methods
	Method Write:Void(name:String, value:Int)
		Local element:XMLElement = New XMLElement("field")
		element.SetAttribute("name", name)
		element.SetAttribute("value", value)
		element.SetAttribute("type", "int")
		currentElement.AddChild(element)
	End
	
	Method Write:Void(name:String, value:Float)
		Local element:XMLElement = New XMLElement("field")
		element.SetAttribute("name", name)
		element.SetAttribute("value", value)
		element.SetAttribute("type", "float")
		currentElement.AddChild(element)
	End
	
	Method Write:Void(name:String, value:String)
		Local element:XMLElement = New XMLElement("field")
		element.SetAttribute("name", name)
		element.SetAttribute("value", value)
		element.SetAttribute("type", "string")
		currentElement.AddChild(element)
	End
	
	Method Write:Void(name:String, value:ISerializable)
		Local lastCurrent:XMLElement = currentElement
		Local fieldElement:XMLElement = New XMLElement("field")
		fieldElement.SetAttribute("name", name)
		fieldElement.SetAttribute("type", "serializable")
		currentElement.AddChild(fieldElement)
		Local objectElement:XMLElement = New XMLElement("object")
		objectElement.SetAttribute("class", value.GetClassName())
		fieldElement.AddChild(objectElement)
		' TODO: generics
		currentElement = objectElement
		value.Serialize(Self)
		currentElement = lastCurrent
	End
	
	Method ReadInt:Int(name:String)
		' find the named field
		For Local element:XMLElement = EachIn currentElement.GetChildrenByName("field")
			If element.GetAttribute("name") = name Then
				Return Int(element.GetAttribute("value", "0"))
			End
		Next
		Error("Couldn't find field" + name)
	End
	
	Method ReadFloat:Float(name:String)
		' find the named field
		For Local element:XMLElement = EachIn currentElement.GetChildrenByName("field")
			If element.GetAttribute("name") = name Then
				Return Float(element.GetAttribute("value", "0"))
			End
		Next
		Error("Couldn't find field" + name)
	End
	
	Method ReadString:String(name:String)
		' find the named field
		For Local element:XMLElement = EachIn currentElement.GetChildrenByName("field")
			If element.GetAttribute("name") = name Then
				Return element.GetAttribute("value")
			End
		Next
		Error("Couldn't find field" + name)
	End
	
	Method ReadSerializable:ISerializable(name:String)
		' find the named field
		For Local element:XMLElement = EachIn currentElement.GetChildrenByName("field")
			If element.GetAttribute("name") = name Then
				' store the last currentElement
				Local lastCurrent:XMLElement = currentElement
				
				' get the object element and assert it's not null
				For Local objectElement:XMLElement = EachIn element.GetChildrenByName("object")
					' set the current element to be our object element
					currentElement = objectElement
					
					' make that object serialize itself
					Local rv:ISerializable = CreateSerializable(objectElement.GetAttribute("class"))
					
					' reset the current element
					currentElement = lastCurrent
					
					Return rv
				Next
			End
		Next
		Error("Couldn't find field" + name)
	End
	
	Method SerializeObject:XMLElement(name:String, value:ISerializable)
		Local objectElement:XMLElement = New XMLElement("object")
		objectElement.SetAttribute("name", name)
		objectElement.SetAttribute("class", value.GetClassName())
		currentElement = objectElement
		value.Serialize(Self)
		Return objectElement
	End
	
	Method DeserializeObject:ISerializable(element:XMLElement)
		AssertEquals(element.Name, "object", "Wasn't an object element!")
		currentElement = element
		Local rv:ISerializable = CreateSerializable(element.GetAttribute("class"))
		Return rv
	End
End


