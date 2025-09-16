import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech_docs_generator/app/components/custom_app_bart.dart';
import 'package:tech_docs_generator/app/modules/controller/project_brief_controller.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';
import 'package:tech_docs_generator/app/modules/views/project%20brief/editor_view.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class ProjectBriefListPage extends GetView<ProjectBriefController> {
  const ProjectBriefListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProjectBriefController());

    return Scaffold(
      appBar: CustomAppBar(pageTitle: Dictionary.manageProjectBrief),
      body: Obx(() {
        // Load indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty Data
        if (controller.briefList.isEmpty) {
          return const Center(
            child: Text(
              'No data.\nPress (+) button to create new brief.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // Brief List View
        return ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: controller.briefList.length,
          itemBuilder: (context, index) {
            final brief = controller.briefList[index];
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                title: Text(
                  brief.projectTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text('Ver. ${brief.docVersion} by ${brief.author}'),
                ),
                // Duplicate & delete button
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: 'More Options',
                  onPressed: () {
                    _showActionsBottomSheet(context, brief);
                  },
                ),
                // Edit data
                onTap: () {
                  Get.to(() => EditorView(brief: brief));
                },
              ),
            );
          },
        );
      }),
      // create new brief
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => EditorView());
        },

        icon: const Icon(Icons.add),
        label: const Text(Dictionary.createNew),
        tooltip: 'Create New Project Brief',
      ),
    );
  }

  // Bottom sheet for more actions (duplicate, delete)
  void _showActionsBottomSheet(BuildContext context, ProjectBrief brief) {
    Get.bottomSheet(
      Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.only(top: 10, bottom: 15),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf_outlined),
              title: Text(Dictionary.generate),
              onTap: () {
                Get.back();
                controller.generatePdf(brief);
              },
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text(Dictionary.duplicate),
              onTap: () {
                Get.back();
                controller.duplicateBrief(brief.id!);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(
                Dictionary.delete,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                _showDeleteConfirmationDialog(brief.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method - confirm before delete
  void _showDeleteConfirmationDialog(int id) {
    Get.defaultDialog(
      title: Dictionary.confirmDelete,
      middleText: "Are you sure you want to delete this project brief?",
      textConfirm: Dictionary.yes,
      textCancel: Dictionary.no,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteBrief(id);
      },
      onCancel: () {},
    );
  }
}
