class Base {
  final String baseUrl;

  const Base({required this.baseUrl});
}

class Path {
  final String? name;

  const Path([this.name]);
}

class Query {
  final String? name;

  const Query([this.name]);
}

class Header {
  final String name;

  const Header(this.name);
}

class Body {
  const Body();
}

class GET {
  final String endPoint;

  const GET({required this.endPoint});
}

class DELETE {
  final String endPoint;

  const DELETE({required this.endPoint});
}

class POST {
  final String endPoint;

  const POST({required this.endPoint});
}

class PUT {
  final String endPoint;

  const PUT({required this.endPoint});
}

class PATCH {
  final String endPoint;

  const PATCH({required this.endPoint});
}
