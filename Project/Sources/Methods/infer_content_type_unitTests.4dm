//%attributes = {}
/*  infer_content_type_unitTests ()
 Created by: Kirk as Designer, Created: 12/12/20, 11:09:51
 ------------------
 infer_content_type determines the data type of content of the object passed to it. 

For scalar values this will be the same as the object type: real, date, bool

For text values it looks at the content of the text to infer what's there. 
 So, "1234"  has content of Is real because it has nothing but number: 0-9 , . -
 Dates are in the form yyyy-mm-dd  or mm/dd/yy or mm/dd/yyyy in either European or US form
 Booleans are "true" or "false"
 Any thing else and the content Is text

For collections they must be scalar values.

This method doesn't deal with all the data types available in 4D. 

*/



ASSERT:C1129(infer_content_type=Is undefined:K8:13)

ASSERT:C1129(infer_content_type(1234)=Is real:K8:4)
ASSERT:C1129(infer_content_type("1234")=Is real:K8:4)

ASSERT:C1129(infer_content_type(New collection:C1472())=Is undefined:K8:13)  //  because there are no contents
ASSERT:C1129(infer_content_type(New collection:C1472(Current date:C33))=Is date:K8:7)
ASSERT:C1129(infer_content_type(New collection:C1472(String:C10(Current date:C33)))=Is date:K8:7)

ASSERT:C1129(infer_content_type(New object:C1471("a";Current date:C33))=Is date:K8:7)

ASSERT:C1129(infer_content_type(New object:C1471("a";"1/1/10"))=Is date:K8:7)
ASSERT:C1129(infer_content_type(New object:C1471("a";"31/1/2020"))=Is date:K8:7)
ASSERT:C1129(infer_content_type(New object:C1471("a";Timestamp:C1445))=Is date:K8:7)

ASSERT:C1129(infer_content_type($x)=Is null:K8:31)
/*  why not undefined? Because $x is undefined here but the 
parameter exists in the method is null.
*/

ASSERT:C1129(infer_content_type(New object:C1471())=Is undefined:K8:13)  //  because there are no contents


var $temp_c : Collection

$temp_c:=New collection:C1472()
ASSERT:C1129(infer_content_type($temp_c)=Is undefined:K8:13)

$temp_c:=New collection:C1472("1";"1.0";"2.3")
ASSERT:C1129(infer_content_type($temp_c)=Is real:K8:4)

/* in this case the collection is mostly null so we decide...  */
$temp_c:=New collection:C1472("1";"1.0";"2";Null:C1517;Null:C1517;Null:C1517;Null:C1517)
ASSERT:C1129(infer_content_type($temp_c)=Is null:K8:31)

/* but we can skip the nulls and determine the actual data are real  */
$temp_c:=New collection:C1472("1";"1.0";"2";Null:C1517;Null:C1517;Null:C1517;Null:C1517)
ASSERT:C1129(infer_content_type($temp_c;True:C214)=Is real:K8:4)

$temp_c:=New collection:C1472(Null:C1517;Null:C1517;Null:C1517;Null:C1517)
ASSERT:C1129(infer_content_type($temp_c;True:C214)=Is undefined:K8:13)  // because we filtered out all the contents

$temp_c:=New collection:C1472(\
New object:C1471("1";"1.0");\
New object:C1471("a";"2");\
Null:C1517;Null:C1517;Null:C1517;Null:C1517)

ASSERT:C1129(infer_content_type($temp_c;True:C214)=Is undefined:K8:13)
/*  Why Is undefined?
we filtered out the null values
the ones left aren't scalar values so we don't know what kind they are
*/

//-----
var $ptr : Pointer
ASSERT:C1129(infer_content_type($ptr)=Is null:K8:31)  //  because  $ptr=Null

$ptr:=->$temp_c
ASSERT:C1129(infer_content_type($ptr)=Is null:K8:31)

$x:=True:C214
$ptr:=->$x
ASSERT:C1129(infer_content_type($ptr)=Is boolean:K8:9)

// will accept arrays but always returns Is real because it's evaluating the as a longint
ARRAY LONGINT:C221($aX;4)
$ptr:=->$aX
ASSERT:C1129(infer_content_type($ptr)=Is real:K8:4)

ARRAY TEXT:C222($aText;2)
ASSERT:C1129(infer_content_type($aText)=Is real:K8:4)
// ----

var $x : Variant
$x:=Null:C1517
ASSERT:C1129(infer_content_type($x)=Is null:K8:31)

var $o : Object
// this object seems to have numeric values
$o:=New object:C1471(\
"a";"1234";\
"b";"-1,234";\
"c";"1,234.00";\
"d";"1,234";\
"e";"1,234")
ASSERT:C1129(infer_content_type($o)=Is real:K8:4)

// but this one does not
$o:=New object:C1471(\
"a";"a1234";\
"b";"b1234";\
"c";"c1234";\
"d";"d1234";\
"e";"e1234")
ASSERT:C1129(infer_content_type($o)=Is text:K8:3)

// neither does this one
$o:=New object:C1471(\
"a";"$1234";\
"b";"$1234";\
"c";"$1234";\
"d";"$1234";\
"e";"$1234")
ASSERT:C1129(infer_content_type($o)=Is text:K8:3)






// --------------------------------------------------------
ALERT:C41("Infer_content_type\r\rUnit tests done!")