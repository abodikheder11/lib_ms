class AuthUser {
  final int? id;
  final String? name;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? location;
  final bool isAuthor;

  const AuthUser({
    this.id,
    this.name,
    this.firstname,
    this.lastname,
    this.email,
    this.location,
    this.isAuthor = false,
  });
  AuthUser copyWith({
    int? id,
    String? email,
    String? name,
    bool? isAuthor,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isAuthor: isAuthor ?? this.isAuthor,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}'),
      name: json['name']?.toString(),
      firstname: json['firstname']?.toString(),
      lastname: json['lastname']?.toString(),
      email: json['email']?.toString(),
      location: json['location']?.toString(),
    );
  }
}