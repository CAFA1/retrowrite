#include<stdio.h>
int c=1;
int func1(int b){
	c=b;
	return b;
}
int func2(int b){
	c+=b;
	return c;
}
void main(){
	char a[10];
	scanf("%s",a);
	if(a[0]=='1')
	{
		printf("%s\n","oka" );
	}else{
		printf("%s\n", "faila");
	}
	if(a[1]=='2')
	{
		printf("%s\n","okb" );
	}else{
		printf("%s\n", "failb");
	}
	 switch (a[3]){
        case '1':func1(2);printf("Monday\n");
        case '2':func2(1);printf("Tuesday\n");
        case '3':printf("Wednesday\n");
        case '4':printf("Thursday\n");
        case '5':printf("Friday\n");
        case '6':printf("Saturday\n");
        case '7':printf("Sunday\n");
        default:printf("error\n");
    }
	
	printf("a=%d\n",c );
}