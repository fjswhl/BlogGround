###	把 Block 语法转换成 C 代码
初次接触 Block 的时候，觉得 Block 似乎是 Objective-C 的一种特殊语法。但我们知道 Objective-C 最终是被编译器编译成 C 语言的，因此 Block 也不例外。LLVM 有一个选项`-rewrite-objc`可以把 Objective-C 代码转换成人们能看懂的 C 代码。
```c++
int main() {
	int foo;
	void (^block)(int) = ^(int arg){
		arg++;
	};
	block(foo);
	return 0;
}
```
终端运行`clang -rewrite-objc block.m`，就会在当前目录下产生一个 xxx.cpp 文件。 对于这简单的8行 objc ，我这里产生了132行c++（其实只用到了c++ struct的构造函数语法，其他都是纯 C）。仔细看的话，这些代码并不复杂。  
对于原始代码中的`arg++;`，在转换后的代码中，你可以看到相同的句子：
```c++
static void __main_block_func_0(struct __main_block_impl_0 *__cself, int arg) {
  arg++;
 }
```
这说明 Block 被转换成 C 函数，函数名根据 Block 在哪定义再加一个序号自动生成，如`__main_block_func_0`大概就是指在`main`函数中的第一个 Block。 参数里的`__cself`就相当于 objc 里的 self，指这个 Block 它自身。  
先来看看 objc 中的 self 是怎么回事
###	Self In Objective-C
这是一个objc类的实例方法
```objc
- (void) method:(int)arg {
	NSLog(@"%p %d\n", self, arg); 
}
```
编译器把这个方法转成C 函数
```c++
void _I_MyObject_method_(struct MyObject *self, SEL _cmd, int arg) {
	NSLog(@"%p %d\n", self, arg); 
}
```
可以看到，self 作为第一个参数传进这个 C 函数，再来看调用者
```objc
MyObject *obj = [[MyObject alloc] init];
[obj method:10];
```
用 `clang -rewrite-objc` 编译后，得
```c++
MyObject *obj = objc_msgSend(objc_getClass("MyObject"), sel_registerName("alloc"));
obj = objc_msgSend(obj, sel_registerName("init")); 
objc_msgSend(obj, sel_registerName("method:"), 10);
```
`objc_msgSend`先通过这个对象和其方法名找到指向`_I_MyObject_method_`的函数指针，然后调用这个函数(把 obj 作为这个函数的第一个参数传进),以此实现类实例的方法调用。
### `___cself`的声明
`struct __main_block_impl_0 *__cself`, `__cself`是一个指向`struct __main_block_impl_0`的指针，在转换后的代码中可以查找到`__main_block_impl_0`的定义如下（我移除了构造函数）
```c++
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
};
```
再来看这个结构体的成员变量`impl`和`Desc`是如何定义的
```c++
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
};
```
其中reserved是一个保留字段以备将来使用（真的会用么？？），Block_size这些从变量名大概都能看出这是做什么用的
###`__main_block_impl_0`的构造函数
```c++
__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
	impl.isa = &_NSConcreteStackBlock;
	impl.Flags = flags;
	impl.FuncPtr = fp;
	Desc = desc;
}
```
这就是一个memberwise initialzie，除了`_NSConcreteStackBlock`，这个以后再讨论。我们先来看看这个构造函数是怎样被调用的:
```c++
void (*block)(int) = (void (*)(int))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA);
```
太乱了，去掉cast语法后得
```c++
void (*block)(int) = &__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA);
```
这行代码就说明了 block 在底层的具体表现形式了：**block 就是一个指向结构体`__main_block_impl_0`的指针，并且这个结构体是在栈而不是堆上创建的**  
不要吃惊这里居然能把结构体转成函数指针，后续可以看到，实际上在调用这个 block 的时候，会再把函数指针转成结构体
###`__main_block_impl_0`的初始化
初始化参数`__main_block_impl_0(__main_block_func_0, &__main_block_desc_0_DATA)`，第一个参数是从 block 转换而来的函数指针(文章开始处就已经提到)。第二个参数是一个指向结构体`__main_block_desc_0`的指针，这是一个全局静态变量(即只在当前文件中可见)，看看`__main_block_desc_0_DATA`的初始化：
```c++
static struct __main_block_desc_0
	 __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
```
就是用结构体`__main_block_impl_0`的大小初始化了而已，如果我们把`__main_block_impl_0`的定义和初始化展开，大概就是下面这个样子
```c++
//定义
struct __main_block_impl_0 {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
  size_t reserved;
  size_t Block_size;
};
//初始化
    isa = &_NSConcreteStackBlock;
    Flags = 0;
    FuncPtr = __main_block_func_0;
    reserved = 0;
    Block_size = sizeof(struct __main_block_impl_0);
```
当调用这个block 的时候：`block(foo);`,这行代码转成：
```c++
 ((void (*)(__block_impl *, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, foo);
```
可以看到它把 block 强转成`__block_impl`了，去掉强转语法得:
```c++
 (block)->FuncPtr)(block, foo);
```
这就是一个通过函数指针的普通函数调用,也可以看到它把block自身作为`__main_block_func_0(struct __main_block_impl_0 *__cself, int arg)`的__cself参数传进，这其实也跟objc 类方法的调用大同小异。



















