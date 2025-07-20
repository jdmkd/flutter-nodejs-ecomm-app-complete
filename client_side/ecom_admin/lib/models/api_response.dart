class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    if (json == null || json is! Map<String, dynamic>) {
      return ApiResponse<T>(
        success: false,
        message: 'Invalid or null response from server',
        data: null,
      );
    }
    final Map<String, dynamic> jsonMap = json;
    return ApiResponse<T>(
      success: jsonMap['success'] as bool? ?? false,
      message: jsonMap['message'] as String? ?? 'No message',
      data: jsonMap['data'] != null && fromJsonT != null
          ? fromJsonT(jsonMap['data'])
          : null,
    );
  }
}
