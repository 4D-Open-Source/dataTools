# dataTools
 Some useful methods for working with various data types.
 
## infer_data_type
This method accepts a number of 4D objects and attempts to determine what type the content of the object is. 

It is particularly useful working with imported data. Let's say you have parsed a text file to a 2D text array and now need to determine what kind of 
	data is in each column. In this example we have a price list that looks like: 
	
```
ARRAY TEXT($aText;0;0)
priceList_array(->$aText)

// we know these arrays are text but what about the values in them?
var $values_c;$temp_c : Collection

$values_c:=New collection()

$temp_c:=New collection()
ARRAY TO COLLECTION($temp_c;$aText{1})
$values_c.push(infer_content_type($temp_c))

ARRAY TO COLLECTION($temp_c;$aText{2})
$values_c.push(infer_content_type($temp_c))

ARRAY TO COLLECTION($temp_c;$aText{3})
$values_c.push(infer_content_type($temp_c))
//  $values_c [ 2, 2, 1 ] or [ Is text, Is text, Is real ]

//  this will also work for individual values

var $value : Variant

$value:="1234568.000"
$this_type:=infer_content_type($value)  //  $this_type = 1

$value:=False
$this_type:=infer_content_type($value)  //  $this_type = 6

$value:=Current date
$this_type:=infer_content_type($value)  //  $this_type = 4

$value:=String($value)
$this_type:=infer_content_type($value)  //  $this_type = 4
```
Notice the last instance where `$value` is a text string of the **Current date**. Why is it still indicated as a date type? Because we are infering the **_content of `$value`_** instead of `$value` itself. 

Take a look at `infer_content_type_unitTests` for a more complete set of examples. 

## nvl
**nvl** is useful for testing individual variables on the fly. 
You pass a variable to **nvl** with the expected data type. 
- If the variable matches the expected type it returns $1 unchanged. 
- If the variable doesn't match it returns **Null** _or_ a default value you specify.
**nvl** also maps `Is undefined` to **Null**. So if you don't specifically need to know the difference between undefined and Null you can make that test in a single call. 

The ability to specify the value returned on Null can be very helpful. It's particularly useful for dealing with methods and functions that recieve **Variant** parameters. For example, let's say you have a method that recieves a **variant parameter** which you expect to be either an object or a collection. There are further actions you want to take but only if the parameter is not empty. Normally you need to do two tests: 
```
var $var : Variant

Case of 
	: (Value type($var)=Is collection)
		If ($var.length>0)
			// do this
		Else 
			// do something esle
		End if 
		
	: (Value type($var)=Is object)
		If (OB Is empty($var))
			// do something esle
		Else 
			// do this
		End if 
		
  Else
  //  whatever
End case 
```
Using **nvl** you can do this: 
```
Case of 
	: (nvl($var;Is collection;New collection).length>0)
		//  do this
		
	: (OB Keys(nvl($var;Is object;New object)).length>0)
		//  do this
		
	Else 
		// whatever
		
End case 
```
In both cases I specify an empty instance of the expected value as the null return value. This way I can do both tests in one call. 

Specifying the null return also helps when I want a `zero value` instead of **Null**. For example
```
$newValue:=nvl($var;Is real;0)
```
If `$var` is null `$newValue` will be zero. But perhpas I want to know which values are null but also want the values to all be real so I'm going to use -1 as my null value: 
```
$newValue:=nvl($var;Is real;-1)
```

**nvl** also does some simple transformations. 
```
$var:="123.45"  //  text var
$newValue:=nvl($var;Is real;-1) //  $newValue = 123.45  real value
```

Take a look at the `nvl_unit_tests` for more examples. 

This database is written in v18R4. It may work in prior versions but I haven't tested it there. 
