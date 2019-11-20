#include<stdio.h>
int c=1;
int func1(int b){
	c=b;
	return b;
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
	func1(2);
	printf("a=%d\n",c );
}