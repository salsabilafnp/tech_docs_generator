import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tech_docs_generator/app/modules/models/project_brief.dart';
import 'package:tech_docs_generator/utils/dictionary.dart';

class PdfService {
  static Future<void> generateBriefPdf(ProjectBrief brief) async {
    final pdf = pw.Document();

    final pw.ImageProvider? uiImage = brief.uiDesignImagePath != null
        ? pw.MemoryImage(File(brief.uiDesignImagePath!).readAsBytesSync())
        : null;

    final pw.ImageProvider? archImage = brief.architectureImagePath != null
        ? pw.MemoryImage(File(brief.architectureImagePath!).readAsBytesSync())
        : null;

    // Halaman PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        // footer
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: pw.EdgeInsets.only(top: 15),
          padding: pw.EdgeInsets.only(top: 5),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(width: 0.5, color: PdfColors.grey),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${Dictionary.projectBrief} ${brief.projectTitle} ver.${brief.docVersion}',
                style: pw.TextStyle(color: PdfColors.grey),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ],
          ),
        ),

        // content
        build: (context) => [
          // Header
          _buildHeader(brief),
          pw.Divider(),
          pw.SizedBox(height: 20),
          // Project Overview
          _buildSection(Dictionary.introduction, [
            _buildKeyValue(title: Dictionary.problem, subtitle: brief.problem),
            _buildKeyValue(title: Dictionary.vision, subtitle: brief.vision),
            _buildKeyValue(
              title: Dictionary.targetUser,
              subtitle: brief.targetUser,
            ),
          ]),
          // Core Features
          _buildSection(
            Dictionary.coreFeatures,
            brief.coreFeatures.map((feature) {
              return _buildKeyValue(
                title:
                    '${brief.coreFeatures.indexOf(feature) + 1}. ${feature.name}',
                subtitle: feature.description,
              );
            }).toList(),
          ),
          // Use Cases
          _buildSection(
            Dictionary.userScenario,
            brief.userScenario.map((scenario) {
              final pw.ImageProvider? ucImage = scenario.diagramPath != null
                  ? pw.MemoryImage(
                      File(scenario.diagramPath!).readAsBytesSync(),
                    )
                  : null;

              return _buildKeyValue(
                title:
                    '${brief.userScenario.indexOf(scenario) + 1}. ${scenario.useCaseName}',
                subtitle: scenario.useCaseScenario,
                diagram: ucImage,
              );
            }).toList(),
          ),
          // UI Design
          _buildSection(Dictionary.uiDesign, [
            _buildKeyValue(title: Dictionary.uiDesignLink, subtitle: ''),
            // link UI Design
            if (brief.uiDesignLink!.isNotEmpty)
              pw.UrlLink(
                destination: brief.uiDesignLink!,
                child: pw.Text(
                  brief.uiDesignLink!,
                  style: const pw.TextStyle(
                    color: PdfColors.blue,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
              ),

            if (brief.uiDesignLink!.isNotEmpty && uiImage != null)
              pw.SizedBox(height: 15),

            // gambar UI Design
            if (uiImage != null)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'UI Design Preview:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Image(uiImage, fit: pw.BoxFit.contain, height: 250),
                ],
              ),
          ]),
          // Tech Specs
          _buildSection(Dictionary.techSpec, [
            _buildKeyValue(
              title: Dictionary.techStack,
              subtitle: brief.techTools.join(', '),
            ),
            if (brief.architectureLink != null &&
                brief.architectureLink!.isNotEmpty) ...[
              _buildKeyValue(title: Dictionary.sysArcLink, subtitle: ''),
              pw.UrlLink(
                destination: brief.architectureLink!,
                child: pw.Text(
                  brief.architectureLink!,
                  style: pw.TextStyle(
                    color: PdfColors.blue,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
              ),
            ],
            if (archImage != null)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'System Architecture Design Preview:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Image(archImage, fit: pw.BoxFit.contain, height: 250),
                ],
              ),
          ]),
        ],
      ),
    );

    // Preview PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Helper PDF
  // Header
  static pw.Widget _buildHeader(ProjectBrief brief) {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            Dictionary.projectBrief,
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            '${brief.projectTitle} ver.${brief.docVersion}',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '${Dictionary.author}: ${brief.author}',
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // Section
  static pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
        ),
        pw.SizedBox(height: 10),
        ...children,
        pw.SizedBox(height: 15),
      ],
    );
  }

  // Key-value pair Item
  static pw.Widget _buildKeyValue({
    required String title,
    required String subtitle,
    pw.ImageProvider? diagram,
  }) {
    final textContent = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        if (subtitle.isNotEmpty) ...[pw.SizedBox(height: 5), pw.Text(subtitle)],
        pw.SizedBox(height: 10),
      ],
    );

    return (diagram != null)
        ? pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 15),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                    ),
                    child: pw.Image(
                      diagram,
                      height: 200,
                      fit: pw.BoxFit.fitHeight,
                    ),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Expanded(flex: 3, child: textContent),
              ],
            ),
          )
        : textContent;
  }
}
