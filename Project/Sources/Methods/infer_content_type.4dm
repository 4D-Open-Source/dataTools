//%attributes = {}
/*  infer_content_type (object | collection | value{;bool{;longint}})
$1: series to infer type for
$2: true to exclude null and undefined
$3: is the number of elements of a series to evaluate  - default is 10
 Created by: Kirk as Designer, Created: 11/17/20, 13:40:12
 ------------------
 Purpose: infer the data type of the contents of $1

if $1 is a text object we analyze it to determine if the data is
all text, all numeric, a boolean, a date

if $1 is a date, number or boolean we return that type

If $1 is an object or collection we analyze the first few elements
and return the dominant data type

$2 can be passed when analyzing a collection or object to 
skip the null values in determing content type

*/

var $1;$thisValue : Variant
var $2;$skipNull : Boolean
var $3;$n : Integer
var $0;$valueType;$element_valueType : Integer
var $numLen;$len;$pos;$i;$k;$indx;$n_notUnDef : Integer
var $counts;$temp_c : Collection
var $ok : Boolean
var $key;$str : Text

If (Count parameters:C259>0)
	
	If (Count parameters:C259>1)
		$skipNull:=$2
	End if 
	
	If (Count parameters:C259>2)
		$n:=$3
	Else 
		$n:=10
	End if 
	
	$valueType:=Value type:C1509($1)
	
	Case of 
		: ($1=Null:C1517)
			$0:=Is null:K8:31
			
		: ($valueType=Is pointer:K8:14)  //  oh all right - we'll deal with pointers
			$0:=infer_content_type($1->;$skipNull;$n)
			
		: ($valueType=Is text:K8:3)
			$ok:=Match regex:C1019("^[\\d\\.,\\- ]+";$1;1;$pos;$numLen)  //  $numLen = length of number match
			
			Case of 
				: (Match regex:C1019("^\\d\\d\\d\\d-\\d\\d-\\d\\d";$1;1))
					$0:=Is date:K8:7
					
				: (Match regex:C1019("^\\d\\d?\\/\\d\\d?\\/\\d\\d(\\d\\d)?";$1;1))
					$0:=Is date:K8:7
					
				: ($numLen=Length:C16($1))  //  nothing but number chars
					$0:=Is real:K8:4
					
				: ($1="true") | ($1="false")
					$0:=Is boolean:K8:9
					
				Else 
					$0:=Is text:K8:3
			End case 
			
		: ($valueType=Is real:K8:4) | ($valueType=Is date:K8:7) | ($valueType=Is boolean:K8:9)
			$0:=$valueType
			
		: ($valueType=Is collection:K8:32) | ($valueType=Is object:K8:27)  //  collection or object
			
			$counts:=New collection:C1472()
			$counts.push(New object:C1471("kind";Is null:K8:31;"count";0))  // 255
			$counts.push(New object:C1471("kind";Is real:K8:4;"count";0))  // 1
			$counts.push(New object:C1471("kind";Is longint:K8:6;"count";0))  // 9
			$counts.push(New object:C1471("kind";Is date:K8:7;"count";0))  // 4
			$counts.push(New object:C1471("kind";Is boolean:K8:9;"count";0))  // 6
			$counts.push(New object:C1471("kind";Is text:K8:3;"count";0))  // 2
			
			$i:=0
			$k:=0  //  count of elements identified
			$n_notUnDef:=0
			
			If ($valueType=Is object:K8:27)
				$temp_c:=OB Values:C1718($1)
			Else 
				$temp_c:=$1
			End if 
			
			
			While ($i<$temp_c.length) & ($k<$n)
				
				$element_valueType:=Value type:C1509($temp_c[$i])
				
				If ($element_valueType=Is text:K8:3)
					$element_valueType:=infer_content_type($temp_c[$i])
				End if 
				
				
				Case of 
					: ($element_valueType=Is null:K8:31) & ($skipNull)
					: ($element_valueType=Is null:K8:31)
						$counts[0].count:=$counts[0].count+1
						$k:=$k+1
						
					: ($element_valueType=Is real:K8:4)
						$counts[1].count:=$counts[1].count+1
						$k:=$k+1
						
					: ($element_valueType=Is longint:K8:6)
						$counts[2].count:=$counts[2].count+1
						$k:=$k+1
						
					: ($element_valueType=Is date:K8:7)
						$counts[3].count:=$counts[3].count+1
						$k:=$k+1
						
					: ($element_valueType=Is boolean:K8:9)
						$counts[4].count:=$counts[4].count+1
						$k:=$k+1
						
					: ($element_valueType=Is text:K8:3)
						$counts[5].count:=$counts[5].count+1
						$k:=$k+1
						
					: ($skipNull)
						
					Else   //  something else we don't care about
						$n_notUnDef:=$n_notUnDef+1
						$k:=$k+1
						
				End case 
				
				$i:=$i+1
			End while 
			
/* --------------------------------------------------------
this sort puts longint above real or bool
*/
			$counts:=$counts.orderBy("count desc, kind desc")
			
			Case of 
				: ($counts[0].count>0)
					$0:=$counts[0].kind
					
				: ($n_notUnDef>0)
					$0:=Is null:K8:31
					
				Else 
					$0:=Is undefined:K8:13
					
			End case 
			
		Else 
			$0:=Is undefined:K8:13
	End case 
	
Else 
	$0:=Is undefined:K8:13
End if 

If ($0=255)  //  is null
	// TRACE
End if 