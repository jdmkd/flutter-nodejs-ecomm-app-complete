class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Object? json,
    T Function(Object? json)? fromJsonT,
  ) {
    final Map<String, dynamic> jsonMap = json as Map<String, dynamic>;
    return ApiResponse<T>(
      success: jsonMap['success'] as bool,
      message: jsonMap['message'] as String,
      data: jsonMap['data'] != null && fromJsonT != null
          ? fromJsonT(jsonMap['data'])
          : null,
    );
  }
}
