//%attributes = {}
/*  nvl (variant{; long[:fill value}) -> variant
$1: some variable, null or undefined var
$2: data type
$3: fill value
$0: 
 Created by: Kirk Brooks
 ------------------
fillValue = the empty value of $2 or $3

If the value type of $1 = $2:  return $1 unchanged

if $1 is null and $2 is defined return the fillValue

if $1 is not null and $2 is defined return the $2 value of $1
     eg.  $1= "123" and $2= is real: $0=123
*/

var $1;$3;$fillValue;$0 : Variant
var $2;$valueType : Integer

$valueType:=Value type:C1509($1)

Case of 
	: (($valueType=Is null:K8:31) | ($valueType=Is undefined:K8:13)) & (Count parameters:C259=1)
		$0:=Null:C1517  //  maps undfined to null
		
	: (Count parameters:C259=1)  //  return the not-null value
		$0:=$1
		
	: ($valueType=$2)  //       just return the value
		$0:=$1
		
	Else   //  we have a value type mismatch
		
		Case of 
			: (Count parameters:C259=3)
				$fillValue:=$3
			: ($2=Is collection:K8:32)
				$fillValue:=New collection:C1472()
				
			: ($2=Is object:K8:27)
				$fillValue:=New object:C1471()
				
			: ($2=Is real:K8:4) | ($2=Is longint:K8:6) | ($2=Is integer:K8:5)
				$fillValue:=0
				
			: ($2=Is date:K8:7)
				$fillValue:=!00-00-00!
				
			: ($2=Is text:K8:3)
				$fillValue:=""
				
			: ($2=Is boolean:K8:9)
				$fillValue:=False:C215
				
			: ($2=Is time:K8:8)
				$fillValue:=?00:00:00?
			Else 
				$fillValue:=Null:C1517
		End case 
		// --------------------------------------------------------
		
		Case of 
			: (($valueType=Is null:K8:31) | ($valueType=Is undefined:K8:13))
				$0:=$fillValue
				
			: ($2=Is real:K8:4) | ($2=Is longint:K8:6) | ($2=Is integer:K8:5)  // but Value type only recognizes real
				$0:=Num:C11(String:C10($1))
				
			: ($2=Is date:K8:7)
				$0:=Date:C102(String:C10($1))  //  this could be better
				
			: ($2=Is text:K8:3)
				$0:=String:C10($1)
				
			: ($2=Is boolean:K8:9)
				$0:=Bool:C1537($1)  //  this could be improved
				
			: ($2=Is time:K8:8)
				$0:=Time:C179($1)
			Else 
				$0:=$fillValue
		End case 
		
End case 


