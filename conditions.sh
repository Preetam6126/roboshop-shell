number=$1
string=$2

if ["${number}" -eq 5]; then #then can go in next line, also semi colan is also fine in the same line
echo number is 5 
fi

if ["${string" == abc]; then 
    echo string is abc
else 
    echo string is not abc
fi

### it is always a good practiceto quote the variables in expressions