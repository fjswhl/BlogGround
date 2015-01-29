int main() {
	int foo;
	void (^block)(int) = ^(int arg){
		arg++;
	};
	block(foo);
	return 0;
}