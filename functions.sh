#Declare a Function

xyz() {
    
    echo hello function
    echo first argument - $1
    echo second argument- $2
    echo all arguments  - $*
    echo total arguemtns- $#
    echo value of a=$a
    b=200
}

#call a function ,calling a fuction just like var

a=120
xyz 123 456
echo value of b is $b


