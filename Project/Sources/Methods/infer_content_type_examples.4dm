//%attributes = {}
/*  infer_content_type_examples ()

Let's say you have parsed a text file to a 2D text array and now need to determine what kind of 
data is in each collumn
*/

ARRAY TEXT:C222($aText;0;0)

priceList_array(->$aText)

/* 
 we know these arrays are text but what about the values in them?
*/
var $values_c;$temp_c : Collection

$values_c:=New collection:C1472()

$temp_c:=New collection:C1472()
ARRAY TO COLLECTION:C1563($temp_c;$aText{1})
$values_c.push(infer_content_type($temp_c))

ARRAY TO COLLECTION:C1563($temp_c;$aText{2})
$values_c.push(infer_content_type($temp_c))

ARRAY TO COLLECTION:C1563($temp_c;$aText{3})
$values_c.push(infer_content_type($temp_c))

//  $values_c [ 2, 2, 1 ] or [ Is text, Is text, Is real ]

//  this will also work for individual values

var $value : Variant

$value:="1234568.000"
$this_type:=infer_content_type($value)  //  $this_type = 1

$value:=False:C215
$this_type:=infer_content_type($value)  //  $this_type = 6

$value:=Current date:C33
$this_type:=infer_content_type($value)  //  $this_type = 4

$value:=String:C10($value)
$this_type:=infer_content_type($value)  //  $this_type = 4
/* why is $this_type still 4 (Is date)?
because we are infering the content of $value instead of the container itself
*/

