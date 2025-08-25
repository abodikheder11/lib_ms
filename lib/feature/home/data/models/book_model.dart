
class Book {
  final int id;
  final String title;
  final String description;
  final double price;

  final String? filePath;
  final int? categoryId;
  final int? authorId;
  final String? authorName;
  final int? adminId;
  final int? quantity;
  final String? imagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Author? author;
  final Category? category;
  final AdminUser? admin;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.filePath,
    this.categoryId,
    this.authorId,
    this.authorName,
    this.adminId,
    this.quantity,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
    this.author,
    this.category,
    this.admin,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: (json['id'] as num?)?.toInt() ?? 1,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? json['Description'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      filePath: json['file_path'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      authorId: (json['author_id'] as num?)?.toInt(),
      authorName: json['author_name'] as String?,
      adminId: (json['admin_id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      imagePath: json['image_path'] as String?,
      createdAt: _tryParseDate(json['created_at']),
      updatedAt: _tryParseDate(json['updated_at']),
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      admin: json['admin'] != null ? AdminUser.fromJson(json['admin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'Description': description,
      'price': price,
      'file_path': filePath,
      'category_id': categoryId,
      'author_id': authorId,
      'author_name': authorName,
      'admin_id': adminId,
      'quantity': quantity,
      'image_path': imagePath,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'author': author?.toJson(),
      'category': category?.toJson(),
      'admin': admin?.toJson(),
    };
  }


  String get authorDisplayName {
    if (authorName != null && authorName!.trim().isNotEmpty) return authorName!;
    if (author != null) {
      final full = '${author!.firstname ?? ''} ${author!.lastname ?? ''}'.trim();
      if (full.isNotEmpty) return full;
    }
    return 'Unknown';
  }

  String get categoryName => category?.name ?? 'Unknown';

  int get publishYear => (updatedAt ?? createdAt)?.year ?? 0;

  Map<String, dynamic> toUiMap() => {
    "id": id,
    "title": title,
    "author": authorDisplayName,
    "image": imagePath ?? '',
    "description": description,
    "rating": 2.0,
    "price": price,
    "category": categoryName,
    "pages": 0,
    "publishYear": publishYear,
  };

  static DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString();
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }
}

class Author {
  final int id;
  final String? firstname;
  final String? lastname;
  final String? location;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Author({
    required this.id,
    this.firstname,
    this.lastname,
    this.location,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: (json['id'] as num).toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      createdAt: Book._tryParseDate(json['created_at']),
      updatedAt: Book._tryParseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'location': location,
    'email': email,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class Category {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '').toString(),
      createdAt: Book._tryParseDate(json['created_at']),
      updatedAt: Book._tryParseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class AdminUser {
  final int id;
  final String? firstname;
  final String? lastname;
  final String? location;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminUser({
    required this.id,
    this.firstname,
    this.lastname,
    this.location,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: (json['id'] as num).toInt(),
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      location: json['location'] as String?,
      email: json['email'] as String?,
      createdAt: Book._tryParseDate(json['created_at']),
      updatedAt: Book._tryParseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'location': location,
    'email': email,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
