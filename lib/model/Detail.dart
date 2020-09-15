
class Detail {

  final String preUrl;

  final String nextUrl;

  final String detail;

  Detail(this.preUrl, this.nextUrl, this.detail);

  @override
  String toString() {
    return "preUrl: " + preUrl + "\n nextUrl: " + nextUrl + "\n detail: " + detail;
  }
}