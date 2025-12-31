class Batch {
  final String id;
  final String title;
  final String teacher;
  final int price;
  final String banner;
  final String description; // <-- यह अब यहाँ जोड़ दिया गया है
  final List<Subject> subjects;

  Batch({
    required this.id, 
    required this.title, 
    required this.teacher,
    required this.price, 
    required this.banner, 
    required this.description, // <-- यहाँ भी जोड़ दिया गया
    required this.subjects,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    // अगर मुख्य लेवल पर डेटा नहीं है, तो सब्जेक्ट्स के अंदर से निकालो (SaaS Fix)
    String extractedTitle = json['title'] ?? "";
    String extractedTeacher = json['teacher'] ?? "";

    if (extractedTitle == "" && json['subjects'] != null && (json['subjects'] as List).isNotEmpty) {
      extractedTitle = json['subjects'][0]['title'] ?? "Untitled Batch";
      extractedTeacher = json['subjects'][0]['teacher'] ?? "Mantu Sir";
    }

    return Batch(
      id: json['id'] ?? '',
      title: extractedTitle,
      teacher: extractedTeacher,
      price: int.tryParse(json['price'].toString()) ?? 0,
      banner: (json['banner'] == null || json['banner'] == "") 
          ? "https://via.placeholder.com/300x160" 
          : json['banner'],
      description: json['description'] ?? "Batch for mission30 students", // <-- यहाँ भी फिक्स
      subjects: json['subjects'] != null 
          ? (json['subjects'] as List).map((i) => Subject.fromJson(i)).toList()
          : [],
    );
  }
}

class Subject {
  final String subjectName;
  final List<Chapter> chapters;
  Subject({required this.subjectName, required this.chapters});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectName: json['subjectName'] ?? json['title'] ?? 'No Subject',
      chapters: json['chapters'] != null 
          ? (json['chapters'] as List).map((i) => Chapter.fromJson(i)).toList()
          : [],
    );
  }
}

class Chapter {
  final String chapterName;
  final List<Content> contents;
  Chapter({required this.chapterName, required this.contents});
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterName: json['chapterName'] ?? 'No Chapter',
      contents: json['contents'] != null 
          ? (json['contents'] as List).map((i) => Content.fromJson(i)).toList()
          : [],
    );
  }
}

class Content {
  final String title;
  final String type;
  final String url;
  Content({required this.title, required this.type, required this.url});
  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      title: json['title'] ?? 'Lecture',
      type: json['type'] ?? 'video',
      url: json['url'] ?? '',
    );
  }
}