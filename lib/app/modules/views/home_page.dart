import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech_docs_generator/app/components/custom_app_bart.dart';
import 'package:tech_docs_generator/app/modules/views/project%20brief/project_brief_list_page.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageTitle: Dictionary.home),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildDocumentMenuCard(
                context: context,
                icon: Icons.edit_document,
                title: Dictionary.projectBrief,
                subtitle: Dictionary.projectBriefDesc,
                onTap: () {
                  // Navigate to Project Brief
                  Get.to(() => ProjectBriefListPage());
                },
              ),
              _buildDocumentMenuCard(
                context: context,
                icon: Icons.work_outline_outlined,
                title: Dictionary.srs,
                subtitle: Dictionary.srsDesc,
                onTap: () {
                  // Navigate to SRS
                  Get.snackbar('Info', 'SRS module is under development.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Document menu card builder
  Widget _buildDocumentMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.blueAccent),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
