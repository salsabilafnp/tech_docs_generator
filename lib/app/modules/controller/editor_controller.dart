import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_docs_generator/app/modules/controller/project_brief_controller.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class EditorController extends GetxController {
  final formKey = GlobalKey<FormState>();
  late TextEditingController projectTitleC,
      docVersionC,
      authorC,
      problemC,
      visionC,
      targetUserC,
      uiDesignLinkC,
      newTechToolsC,
      architectureLinkC;

  // Picture
  final _picker = ImagePicker();
  var uiDesignImagePath = Rxn<String>();
  var architectureImagePath = Rxn<String>();

  // List dynamic
  var coreFeaturesC = <CoreFeature>[].obs;
  var userScenariosC = <UserScenario>[].obs;
  var techToolsC = <String>[].obs;

  // Controller
  final ProjectBriefController _briefController = Get.find();

  // For Edit Mode
  final ProjectBrief? initialData;
  EditorController({this.initialData});

  @override
  void onInit() {
    super.onInit();
    projectTitleC = TextEditingController(
      text: initialData?.projectTitle ?? '',
    );
    docVersionC = TextEditingController(text: initialData?.docVersion ?? '1.0');
    authorC = TextEditingController(text: initialData?.author ?? '');
    problemC = TextEditingController(text: initialData?.problem ?? '');
    visionC = TextEditingController(text: initialData?.vision ?? '');
    targetUserC = TextEditingController(text: initialData?.targetUser ?? '');
    uiDesignLinkC = TextEditingController(
      text: initialData?.uiDesignLink ?? '',
    );
    architectureLinkC = TextEditingController(
      text: initialData?.architectureLink ?? '',
    );
    newTechToolsC = TextEditingController();

    // Init picture paths
    uiDesignImagePath.value = initialData?.uiDesignImagePath;
    architectureImagePath.value = initialData?.architectureImagePath;

    // Init list dynamic
    if (initialData != null) {
      // Mode Edit
      coreFeaturesC.assignAll(initialData!.coreFeatures);
      userScenariosC.assignAll(initialData!.userScenario);
      techToolsC.assignAll(initialData!.techTools);
    } else {
      // Mode Create
      coreFeaturesC.add(CoreFeature(name: '', description: ''));
      userScenariosC.add(UserScenario(useCaseName: '', useCaseScenario: ''));
    }
  }

  // Manage Core Features
  void addCoreFeature() {
    coreFeaturesC.add(CoreFeature(name: '', description: ''));
  }

  void removeCoreFeature(int index) {
    if (coreFeaturesC.length > 1) {
      coreFeaturesC.removeAt(index);
    } else {
      Get.snackbar('Info', 'Minimal harus ada satu fitur utama.');
    }
  }

  // Manage User Scenario
  void addUserScenario() {
    userScenariosC.add(UserScenario(useCaseName: '', useCaseScenario: ''));
  }

  void removeUserScenario(int index) {
    if (userScenariosC.length > 1) {
      userScenariosC.removeAt(index);
    } else {
      Get.snackbar('Info', 'Minimal harus ada satu use case.');
    }
  }

  // Manage Tech Tools
  void addTechTool() {
    if (newTechToolsC.text.isNotEmpty &&
        !techToolsC.contains(newTechToolsC.text)) {
      techToolsC.add(newTechToolsC.text.trim());
      newTechToolsC.clear();
    }
  }

  void removeTechTool(String tool) {
    techToolsC.remove(tool);
  }

  // pickImage for UI Design and Architecture
  Future<void> pickImage(Rxn<String> imagePathState) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePathState.value = image.path;
    }
  }

  // Pick User Scenario Diagram
  Future<void> pickUserScenarioImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var updatedScenario = userScenariosC[index];
      updatedScenario.diagramPath = image.path;
      userScenariosC[index] = updatedScenario;

      userScenariosC.refresh();
    }
  }

  // Save Brief
  void saveBrief() {
    if (formKey.currentState!.validate()) {
      final brief = ProjectBrief(
        id: initialData?.id,
        projectTitle: projectTitleC.text,
        docVersion: docVersionC.text,
        author: authorC.text,
        problem: problemC.text,
        vision: visionC.text,
        targetUser: targetUserC.text,
        uiDesignLink: uiDesignLinkC.text,
        architectureLink: architectureLinkC.text,
        uiDesignImagePath: uiDesignImagePath.value,
        architectureImagePath: architectureImagePath.value,
        coreFeatures: coreFeaturesC.toList(),
        userScenario: userScenariosC.toList(),
        techTools: techToolsC.toList(),
      );

      if (initialData == null) {
        _briefController.addBrief(brief);
      } else {
        _briefController.updateBrief(brief);
      }
      Get.back();
    } else {
      Get.snackbar(Dictionary.error, 'Fill all required fields correctly.');
    }
  }

  @override
  void onClose() {
    projectTitleC.dispose();
    docVersionC.dispose();
    authorC.dispose();
    problemC.dispose();
    visionC.dispose();
    targetUserC.dispose();
    uiDesignLinkC.dispose();
    architectureLinkC.dispose();
    newTechToolsC.dispose();
    super.onClose();
  }
}
