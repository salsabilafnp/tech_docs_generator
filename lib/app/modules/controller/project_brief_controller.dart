import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';
import 'package:tech_docs_generator/app/modules/repositories/project_brief_repository.dart';
import 'package:tech_docs_generator/services/pdf_service.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class ProjectBriefController extends GetxController {
  final ProjectBriefRepository _repository = ProjectBriefRepository.instance;

  var isLoading = true.obs;
  var briefList = <ProjectBrief>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBriefs();
  }

  // fetch all project briefs from database
  void fetchAllBriefs() async {
    try {
      isLoading(true);
      // use dummy data for now
      // await Future.delayed(const Duration(seconds: 1));
      // briefList.assignAll(dummyBriefs);

      // use data from database
      var briefs = await _repository.fetchAll();
      briefList.assignAll(briefs);
    } catch (e) {
      Get.snackbar(Dictionary.error, 'Failed to load: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // create a project brief
  Future<void> addBrief(ProjectBrief brief) async {
    try {
      final newBrief = await _repository.create(brief);
      briefList.insert(0, newBrief);

      Get.snackbar(Dictionary.success, Dictionary.sucCreated);
    } catch (e) {
      Get.snackbar(
        Dictionary.error,
        '${Dictionary.failCreated}: ${e.toString()}',
      );
    }
  }

  // update a project brief
  Future<void> updateBrief(ProjectBrief brief) async {
    try {
      await _repository.update(brief);
      final index = briefList.indexWhere((element) => element.id == brief.id);

      if (index != -1) {
        briefList[index] = brief;
      }

      Get.snackbar(Dictionary.success, Dictionary.sucUpdated);
    } catch (e) {
      Get.snackbar(
        Dictionary.error,
        '${Dictionary.failUpdated}: ${e.toString()}',
      );
    }
  }

  // delete a project brief by id
  void deleteBrief(int id) async {
    try {
      await _repository.delete(id);
      briefList.removeWhere((brief) => brief.id == id);
      Get.snackbar(Dictionary.success, Dictionary.sucDeleted);
    } catch (e) {
      Get.snackbar(
        Dictionary.error,
        '${Dictionary.sucDeleted}: ${e.toString()}',
      );
    }
  }

  // duplicate a project brief by id
  void duplicateBrief(int id) async {
    try {
      final newBrief = await _repository.duplicate(id);

      briefList.insert(0, newBrief);

      Get.snackbar(Dictionary.success, Dictionary.sucDuplicated);
    } catch (e) {
      Get.snackbar(
        Dictionary.error,
        '${Dictionary.failDuplicated}: ${e.toString()}',
      );
    }
  }

  // generate PDF for a project brief
  void generatePdf(ProjectBrief brief) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await PdfService.generateBriefPdf(brief);

      Get.back();
    } catch (e) {
      Get.snackbar(Dictionary.error, 'Failed to generate PDF: ${e.toString()}');
    }
  }
}
