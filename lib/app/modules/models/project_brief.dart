// core feature
import 'dart:convert';

class CoreFeature {
  String name;
  String description;

  CoreFeature({required this.name, this.description = ''});

  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description};
  }

  factory CoreFeature.fromMap(Map<String, dynamic> map) {
    return CoreFeature(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

// user scenario
class UserScenario {
  String useCaseName;
  String useCaseScenario;
  String? diagramPath;

  UserScenario({
    required this.useCaseName,
    required this.useCaseScenario,
    this.diagramPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'useCaseName': useCaseName,
      'useCaseScenario': useCaseScenario,
      'diagramPath': diagramPath,
    };
  }

  factory UserScenario.fromMap(Map<String, dynamic> map) {
    return UserScenario(
      useCaseName: map['useCaseName'] ?? '',
      useCaseScenario: map['useCaseScenario'] ?? '',
      diagramPath: map['diagramPath'],
    );
  }
}

// project brief
class ProjectBrief {
  final int? id;
  final String projectTitle;
  final String docVersion;
  final String author;
  final String problem;
  final String vision;
  final String targetUser;
  final List<CoreFeature> coreFeatures;
  final List<UserScenario> userScenario;
  final String? uiDesignImagePath;
  final String? uiDesignLink;
  final List<String> techTools;
  final String? architectureImagePath;
  final String? architectureLink;

  ProjectBrief({
    this.id,
    required this.projectTitle,
    required this.docVersion,
    required this.author,
    required this.problem,
    required this.vision,
    required this.targetUser,
    required this.coreFeatures,
    required this.userScenario,
    this.uiDesignImagePath,
    this.uiDesignLink,
    required this.techTools,
    this.architectureImagePath,
    this.architectureLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectTitle': projectTitle,
      'docVersion': docVersion,
      'author': author,
      'problem': problem,
      'vision': vision,
      'targetUser': targetUser,
      'coreFeatures': jsonEncode(coreFeatures.map((e) => e.toMap()).toList()),
      'userScenario': jsonEncode(userScenario.map((e) => e.toMap()).toList()),
      'uiDesignImagePath': uiDesignImagePath,
      'uiDesignLink': uiDesignLink,
      'techTools': jsonEncode(techTools),
      'architectureImagePath': architectureImagePath,
      'architectureLink': architectureLink,
    };
  }

  factory ProjectBrief.fromMap(Map<String, dynamic> map) {
    return ProjectBrief(
      id: map['id'] as int?,
      projectTitle: map['projectTitle'] as String,
      docVersion: map['docVersion'] as String,
      author: map['author'] as String,
      problem: map['problem'] as String,
      vision: map['vision'] as String,
      targetUser: map['targetUser'] as String,
      coreFeatures: (jsonDecode(map['coreFeatures']) as List<dynamic>)
          .map((e) => CoreFeature.fromMap(e as Map<String, dynamic>))
          .toList(),
      userScenario: (jsonDecode(map['userScenario']) as List<dynamic>)
          .map((e) => UserScenario.fromMap(e as Map<String, dynamic>))
          .toList(),
      uiDesignImagePath: map['uiDesignImagePath'] as String?,
      uiDesignLink: map['uiDesignLink'] as String,
      techTools: List<String>.from(jsonDecode(map['techTools'])),
      architectureImagePath: map['architectureImagePath'] as String?,
      architectureLink: map['architectureLink'] as String,
    );
  }

  /// Helper method to update some fields of the ProjectBrief
  ProjectBrief copyWith({
    int? id,
    String? projectTitle,
    String? docVersion,
    String? author,
    String? problem,
    String? vision,
    String? targetUser,
    List<CoreFeature>? coreFeatures,
    List<UserScenario>? userScenario,
    String? uiDesignImagePath,
    String? uiDesignLink,
    List<String>? techTools,
    String? architectureImagePath,
    String? architectureLink,
  }) {
    return ProjectBrief(
      id: id ?? this.id,
      projectTitle: projectTitle ?? this.projectTitle,
      docVersion: docVersion ?? this.docVersion,
      author: author ?? this.author,
      problem: problem ?? this.problem,
      vision: vision ?? this.vision,
      targetUser: targetUser ?? this.targetUser,
      coreFeatures: coreFeatures ?? this.coreFeatures,
      userScenario: userScenario ?? this.userScenario,
      uiDesignImagePath: uiDesignImagePath ?? this.uiDesignImagePath,
      uiDesignLink: uiDesignLink ?? this.uiDesignLink,
      techTools: techTools ?? this.techTools,
      architectureImagePath:
          architectureImagePath ?? this.architectureImagePath,
      architectureLink: architectureLink ?? this.architectureLink,
    );
  }
}
