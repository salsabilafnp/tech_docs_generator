import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech_docs_generator/app/components/custom_app_bart.dart';
import 'package:tech_docs_generator/app/modules/controller/editor_controller.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class EditorView extends StatelessWidget {
  final ProjectBrief? brief;

  const EditorView({super.key, this.brief});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditorController(initialData: brief));
    final bool isUpdateMode = brief != null;

    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: isUpdateMode
            ? Dictionary.editProjectBrief
            : Dictionary.newProjectBrief,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              _buildExpansionTile(
                title: Dictionary.projectOverview,
                children: [
                  TextFormField(
                    controller: controller.projectTitleC,
                    decoration: InputDecoration(
                      labelText: Dictionary.projectTitle,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? Dictionary.fillAllFields
                        : null,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.docVersionC,
                          decoration: InputDecoration(
                            labelText: Dictionary.docVersion,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? Dictionary.fillAllFields
                              : null,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: controller.authorC,
                          decoration: InputDecoration(
                            labelText: Dictionary.author,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? Dictionary.fillAllFields
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildExpansionTile(
                title: Dictionary.introduction,
                children: [
                  TextFormField(
                    controller: controller.problemC,
                    decoration: InputDecoration(
                      labelText: Dictionary.problem,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: controller.visionC,
                    decoration: InputDecoration(
                      labelText: Dictionary.vision,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: controller.targetUserC,
                    decoration: InputDecoration(
                      labelText: Dictionary.targetUser,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              _buildExpansionTile(
                title: Dictionary.coreFeatures,
                children: [
                  Obx(
                    () => Column(
                      children: List.generate(controller.coreFeaturesC.length, (
                        index,
                      ) {
                        return _buildCoreFeatureInput(controller, index);
                      }),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: controller.addCoreFeature,
                      icon: Icon(Icons.add),
                      label: Text(Dictionary.addFeature),
                    ),
                  ),
                ],
              ),
              _buildExpansionTile(
                title: Dictionary.uiDesign,
                children: [
                  _buildImagePicker(
                    label: Dictionary.uploadFileOpt,
                    imagePath: controller.uiDesignImagePath,
                    onTap: () =>
                        controller.pickImage(controller.uiDesignImagePath),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: controller.uiDesignLinkC,
                    decoration: InputDecoration(
                      labelText: Dictionary.uiDesignLink,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              _buildExpansionTile(
                title: Dictionary.userScenario,
                children: [
                  Obx(
                    () => Column(
                      children: List.generate(
                        controller.userScenariosC.length,
                        (index) {
                          return _buildUserScenarioInput(controller, index);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: controller.addUserScenario,
                      icon: Icon(Icons.add),
                      label: Text(Dictionary.addUseCase),
                    ),
                  ),
                ],
              ),
              _buildExpansionTile(
                title: Dictionary.techSpec,
                children: [
                  _buildTechToolsInput(controller),
                  Divider(height: 15),
                  Text(Dictionary.techStack, style: Get.textTheme.titleMedium),
                  SizedBox(height: 10),
                  _buildImagePicker(
                    label: Dictionary.uploadFileOpt,
                    imagePath: controller.architectureImagePath,
                    onTap: () =>
                        controller.pickImage(controller.architectureImagePath),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: controller.architectureLinkC,
                    decoration: InputDecoration(
                      labelText: Dictionary.sysArcLink,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: FilledButton(
          onPressed: controller.saveBrief,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontSize: 16),
          ),
          child: Text(isUpdateMode ? Dictionary.update : Dictionary.createNew),
        ),
      ),
    );
  }

  // Helper method to build expanded section
  Widget _buildExpansionTile({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = true,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        initiallyExpanded: initiallyExpanded,
        childrenPadding: EdgeInsets.all(16.0),
        expandedAlignment: Alignment.topLeft,
        children: children,
      ),
    );
  }

  Widget _buildCoreFeatureInput(EditorController controller, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: controller.coreFeaturesC[index].name,
            onChanged: (value) => controller.coreFeaturesC[index].name = value,
            decoration: InputDecoration(
              labelText: '${Dictionary.feature} ${index + 1}',
              border: OutlineInputBorder(),
              suffixIcon: (controller.coreFeaturesC.length > 1)
                  ? IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeCoreFeature(index),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: controller.coreFeaturesC[index].description,
            onChanged: (value) =>
                controller.coreFeaturesC[index].description = value,
            decoration: InputDecoration(
              labelText: Dictionary.featureDesc,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          if (index < controller.coreFeaturesC.length - 1) Divider(height: 15),
        ],
      ),
    );
  }

  Widget _buildUserScenarioInput(EditorController controller, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: controller.userScenariosC[index].useCaseName,
            onChanged: (value) =>
                controller.userScenariosC[index].useCaseName = value,
            decoration: InputDecoration(
              labelText: '${Dictionary.useCase} ${index + 1}',
              border: OutlineInputBorder(),
              suffixIcon: (controller.userScenariosC.length > 1)
                  ? IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeUserScenario(index),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            initialValue: controller.userScenariosC[index].useCaseScenario,
            onChanged: (value) =>
                controller.userScenariosC[index].useCaseScenario = value,
            decoration: InputDecoration(
              labelText: Dictionary.useCaseScenario,
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 8),
          _buildImagePicker(
            label: Dictionary.uploadFileOpt,
            imagePath: Rxn<String>(
              controller.userScenariosC[index].diagramPath,
            ),
            onTap: () async {
              await controller.pickUserScenarioImage(index);
            },
          ),
          if (index < controller.userScenariosC.length - 1) Divider(height: 24),
        ],
      ),
    );
  }

  Widget _buildTechToolsInput(EditorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Dictionary.techStack, style: Get.textTheme.titleMedium),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.newTechToolsC,
                decoration: InputDecoration(
                  labelText: 'Cth: VS Code, Git...',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => controller.addTechTool(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.indigo, size: 30),
              onPressed: controller.addTechTool,
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: controller.techToolsC
                .map(
                  (tool) => Chip(
                    label: Text(tool),
                    onDeleted: () => controller.removeTechTool(tool),
                    deleteIcon: Icon(Icons.cancel, size: 18),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker({
    required String label,
    required Rxn<String> imagePath,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(Icons.upload_file),
          label: Text(label),
        ),
        SizedBox(height: 8),
        Obx(() {
          if (imagePath.value == null) {
            return Text(
              'Belum ada file yang dipilih.',
              style: TextStyle(color: Colors.grey),
            );
          }
          final fileName = imagePath.value!.split(Platform.pathSeparator).last;
          return Text(
            'File: $fileName',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          );
        }),
      ],
    );
  }
}
