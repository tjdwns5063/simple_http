import 'package:simple_http_annotation/simple_http_annotation.dart';

import 'example.g.dart';

class Dto {
  String id;
  String content;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }

  Dto(this.id, this.content);
}

@Base(baseUrl: 'http://example.org')
abstract class TempService {
  @GET(endPoint: '/api/v1/hello')
  Future<dynamic> getAll();

  @DELETE(endPoint: '/api/v1/hello/{name}')
  Future<dynamic> delete(
      @Path('name') name, @Header('Authorization') token, @Body() dto);

  @POST(endPoint: '/api/v1/dto')
  Future<dynamic> post(@Header('Authorization') token, @Body() dto);

  @PUT(endPoint: '/api/v1/dto/{id}')
  Future<dynamic> put(@Header('Authorization') token,
      {@Body() dto, @Path('id') id});

  @PATCH(endPoint: '/api/v1/dto/{id}')
  Future<dynamic> patch(int a, int b, [int c = 1, int d = 2]);
}

Future<void> main() async {
  TempService service = TempServiceImpl();

  print(await service.getAll());
}
