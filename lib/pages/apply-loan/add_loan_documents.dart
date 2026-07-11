import 'package:app_anansi_mobile/pages/apply-loan/contracts_payslips.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLoanDocuments extends StatefulWidget {
  final String appId;
  final String productId;
  const AddLoanDocuments({
    super.key,
    required this.appId,
    required this.productId,
  });

  @override
  State<AddLoanDocuments> createState() => _AddLoanDocumentsState();
}

class _AddLoanDocumentsState extends State<AddLoanDocuments> {
  // Direct list of maps instead of a custom object model
  final List<Map<String, dynamic>> _uploadedFiles = [];

  // Unified list of supported document types
  final List<Map<String, String>> _documentTypes = [
    {"code": "mpesa_statement", "label": "M-Pesa Statement"},
    {"code": "bank_statement", "label": "Bank Statement"},
    {"code": "payslip", "label": "Payslip"},
    {"code": "national_id", "label": "National ID / Passport"},
    {"code": "employment_contract", "label": "Employment Contract"},
  ];

  Future<void> _handlePickAndUpload() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      if (!mounted) return;
      _showDocumentDetailsSheet(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Loan Documentation",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AnansiColors.darkBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload all supporting documents required for this loan profile verification.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildUploadTrigger(
                    label: "Upload Document",
                    color: AnansiColors.darkBlue,
                    icon: CupertinoIcons.cloud_upload_fill,
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ATTACHED DOCUMENTS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        "${_uploadedFiles.length} Files",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AnansiColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  if (_uploadedFiles.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _uploadedFiles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildFileItem(_uploadedFiles[index], index),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _uploadedFiles.isNotEmpty
          ? _buildSubmitButton()
          : null,
    );
  }

  Widget _buildUploadTrigger({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: _handlePickAndUpload,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Supports PDF, PNG, or JPG (one at a time)",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.add_circled, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    // Look up human-readable label from map values
    final String friendlyLabel = _documentTypes.firstWhere(
      (element) => element['code'] == file['doc_type'],
      orElse: () => {"label": "Unknown Document"},
    )['label']!;

    final int sizeInBytes = file['file_size'] ?? 0;
    final String displayNotes = file['notes'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.doc_text_fill,
            color: AnansiColors.darkBlue,
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['file_name'] ?? 'Unknown File',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${(sizeInBytes / 1024).toStringAsFixed(1)} KB",
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        friendlyLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                if (displayNotes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Note: $displayNotes",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _uploadedFiles.removeAt(index)),
            icon: const Icon(
              CupertinoIcons.trash,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(CupertinoIcons.doc_on_doc, size: 48, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            "No documentation attached yet",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AnansiColors.darkBlue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            // _uploadedFiles is already fully formatted JSON payload maps!
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContractsPayslips(),
              ),
            );
          },
          child: const Text(
            "Continue Application",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF1F5F9).withValues(alpha: 0.9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Loan Application",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "DOCUMENTATION DESK",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
      leading: Center(
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              CupertinoIcons.back,
              size: 18,
              color: AnansiColors.darkBlue,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  CupertinoIcons.question_circle,
                  size: 18,
                  color: AnansiColors.darkBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpSupport(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDocumentDetailsSheet(PlatformFile file) {
    final TextEditingController notesController = TextEditingController();
    String selectedDocType = _documentTypes.first['code']!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            left: 24,
            right: 24,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Icon(CupertinoIcons.doc_person, color: AnansiColors.darkBlue),
                  SizedBox(width: 12),
                  Text(
                    "Configure Document",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AnansiColors.darkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "File: ${file.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "DOCUMENT TYPE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDocType,
                    isExpanded: true,
                    icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                    items: _documentTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type['code'],
                        child: Text(
                          type['label']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => selectedDocType = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "ADDITIONAL NOTES (OPTIONAL)",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                keyboardType: TextInputType.text,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "e.g., Pages 2-4 contain bank layout data...",
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnansiColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      // Appending directly as a map with the exact schema requested
                      _uploadedFiles.add({
                        "doc_type": selectedDocType,
                        "file_name": file.name,
                        "file_size": file.size,
                        "file_url": "https://cdn.example.com/docs/${file.name}",
                        "notes": notesController.text.trim(),
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Confirm & Attach",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
