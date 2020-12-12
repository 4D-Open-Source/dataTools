//%attributes = {}
/*  nvl_examples ()

*/



/*  let's say we want to do something with $var if it's a collection that has some content
 and do something else with it if it's an object with some content. 

That might look something like: 
*/
var $var : Variant

Case of 
	: (Value type:C1509($var)=Is collection:K8:32)
		If ($var.length>0)
			// do this
		Else 
			// do something esle
		End if 
		
	: (Value type:C1509($var)=Is object:K8:27)
		If (OB Is empty:C1297($var))
			// do something esle
		Else 
			// do this
		End if 
		
End case 

//  using nvl you can do 
Case of 
	: (nvl($var;Is collection:K8:32;New collection:C1472).length>0)
		//  do this
		
	: (OB Keys:C1719(nvl($var;Is object:K8:27;New object:C1471)).length>0)
		//  do this
		
	Else 
		// whatever
		
End case 