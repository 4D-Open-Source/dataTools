//%attributes = {}
/*  nvl_unitTests ()
 Purpose: if no asserts test is passed
*/



var $x : Variant  //  need this to be able to compile

ASSERT:C1129(nvl(Null:C1517)=Null:C1517)
ASSERT:C1129(nvl($x)=Null:C1517)  //  map undefined to null 

ASSERT:C1129(nvl($1)=Null:C1517)  //  $1 is mapped to null - but this only works interpreted! 

//  return not-null values unchanged
ASSERT:C1129(nvl(1)=1)
ASSERT:C1129(nvl(Current date:C33)=Current date:C33)

//  an undefined var will return the 'empty' value type
ASSERT:C1129(nvl($x;Is text:K8:3)="")
ASSERT:C1129(nvl($x;Is date:K8:7)=!00-00-00!)
ASSERT:C1129(nvl($x;Is collection:K8:32).length=0)
ASSERT:C1129(OB Is empty:C1297(nvl($x;Is object:K8:27)))

// a defined var type returns itself
ASSERT:C1129(nvl(Current date:C33;Is date:K8:7)=Current date:C33)
ASSERT:C1129(nvl(1234;Is real:K8:4)=1234)

ASSERT:C1129(nvl(1234.25;Is longint:K8:6)=1234.25)  //  but all numbers are treated as reals - see Value Type
ASSERT:C1129(Value type:C1509(nvl(Current date:C33;Is longint:K8:6))=Is real:K8:4)

//  now let's define the 'fillvalue' to return instead of empty
ASSERT:C1129(nvl($x;Is text:K8:3;"xx")="xx")
ASSERT:C1129(nvl(Null:C1517;Is text:K8:3;"xx")="xx")

ASSERT:C1129(nvl(Null:C1517;Is collection:K8:32;New collection:C1472(1;2;3)).length=3)

ASSERT:C1129(Not:C34(OB Is empty:C1297(nvl($x;Is object:K8:27;New object:C1471("x";True:C214)))))

// and finally we can also get simple type conversions
ASSERT:C1129(nvl("1234";Is text:K8:3;"xx")="1234")
ASSERT:C1129(nvl("1234";Is real:K8:4)=1234)
ASSERT:C1129(nvl(1234;Is text:K8:3)="1234")
ASSERT:C1129(nvl(0;Is text:K8:3;"--")="0")
ASSERT:C1129(nvl(Null:C1517;Is text:K8:3;"--")="--")

ASSERT:C1129(nvl(1;Is boolean:K8:9)=True:C214)

// --------------------------------------------------------
ALERT:C41("nvl\r\rUnit tests done")
