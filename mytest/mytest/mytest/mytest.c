#include<stdio.h>
int c=1;
int func1(int b){
	c=b;
	return b;
}
void main(){
	char a[10];
	scanf("%s",a);
	if(a[0]=='a')
	{
		printf("%s\n","ok" );
	}else{
		printf("%s\n", "fail");
	}
	func1(2);
	printf("a=%d\n",c );
}