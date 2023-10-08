import 'package:simple_http_gen/src/annotation.dart';

abstract class QueryAnnotationTest {
  Future<dynamic> one(@Query('name') name);

  Future<dynamic> two(@Query('name') name, @Query('time') time);

  Future<dynamic> three(@Query() abc);
}

abstract class PathAnnotationTest {
  @GET(endPoint: '/api/v1/hello/{user}')
  Future<dynamic> one(@Path('user') uid);

  @GET(endPoint: '/api/v1/hello/{uid}/{name}')
  Future<dynamic> two(@Path() int uid, @Path('name') userName);
}

abstract class HeaderAnnotationTest {
  Future<dynamic> one(@Header('Authorization') token);
  Future<dynamic> two(@Header('Authorization') String token,
      @Header('Content-Type') String content_type);
}

abstract class HttpUriParseTest {
  @GET(endPoint: 'api/v1/hello')
  void one();
}

abstract class HttpsUriParseTest {
  void one();
}

abstract class InvalidUriParseTest {
  void one();
}

abstract class BodyAnnotationTest {
  void one(@Body() user);
  void two(@Body() user, @Body() chatRoom);
  void three();
}

@Base(baseUrl: 'https://example.org')
abstract class GETAnnotationTest {
  @GET(endPoint: '/api/v1/users')
  Future<dynamic> withHeader(@Header('Authorization') token, @Query() abc);
}

@Base(baseUrl: 'https://example.org')
abstract class DELETEAnnotationTest {
  @DELETE(endPoint: '/api/v1/users/{path}')
  Future<dynamic> withHeader({@Path() path, @Body() body});
}
