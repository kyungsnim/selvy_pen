import 'dart:ffi';

final DynamicLibrary nativeLibrary = DynamicLibrary.open('libyourlibrary.so');

typedef YourFunctionC = Int32 Function(Int32);
typedef YourFunctionDart = int Function(int);

// typedef CreateDart = int Function(String);

YourFunctionDart yourFunction = nativeLibrary
    .lookup<NativeFunction<YourFunctionC>>('your_function')
    .asFunction<YourFunctionDart>();

void main() {
  int result = yourFunction(42);
  print('Result: $result');
}