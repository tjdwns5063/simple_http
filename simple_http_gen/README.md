# simple_http_gen

A Simple Http Code Generator for Dart and Flutter.

## How to Use?

### 1. Add Dependency

This package automatically generates the necessary boilerplate code for using the http package. To generate the code, you need to add the build_runner package to your pubspec.yaml file.

```
dart pub add http
dart pub add build_runner
```

### 2. Create Abstract Class

Create an abstract class and add the Base annotation. This will inform simple_code_gen that the class is intended for making HTTP requests, and it will generate the code accordingly.

```
@Base(http://example.org)
abstract class ExampleService {
  ...
}
```

### 3. Create Abstract Http Method

Create an abstract method and add http method annotation(ex. GET, POST, DELETE, ...). This http method annotation has one argument named endPoint. 'simple_code_gen' uses the URL provided as an argument to @Base and the endpoint specified in the HTTP method annotation (@GET) to create a Uri. The following example generates a method for sending a GET request to http://example.org/api/v1/user.


```
@Base(endPoint: http://example.org)
abstract class ExampleService {
  @GET(endPoint: '/api/v1/user)
  Future<dynamic> getAll();
}
```

### 4. Add Proper Argument

- Path

This annotation can be applied to the method's parameters. You can specify the path using {} in the endPoint provided to the HTTP method annotation. (ex., @GET(endPoint: /api/v1/users/{id}))

```
@Base(endPoint: http://example.org)
abstract class ExampleService {
  @GET(endPoint: '/api/v1/user/{id})
  Future<dynamic> getUserById(@Path() id);
}
```

If you use the Path annotation without providing any arguments, it will substitute the parameter's value with the parameter name, matching them. However, if you provide an argument, it will replace the parameter's value with the specified argument in the path.

```
@Base(endPoint: http://example.org)
abstract class ExampleService {
  @GET(endPoint: '/api/v1/user/{id})
  Future<dynamic> getUserById(@Path('id') argument);
}
```

### 5. Generate Code

After completing the abstract class, you can generate the code. Please execute the following command in the project's root directory:

```
dart pub run build_runner build
```

This command generates the necessary code based on the abstract class you've created.


### [Example](https://github.com/tjdwns5063/simple_http_gen/blob/main/example/example.dart)






