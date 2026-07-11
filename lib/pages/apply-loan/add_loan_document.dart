import 'package:app_anansi_mobile/pages/apply-loan/loan_documents.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLoanDocument extends StatefulWidget {
  final String appId;
  final String productId;
  const AddLoanDocument({
    super.key,
    required this.appId,
    required this.productId,
  });

  @override
  State<AddLoanDocument> createState() => _AddLoanDocumentState();
}

class _AddLoanDocumentState extends State<AddLoanDocument> {
  PlatformFile? _pickedFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool isAdding = false;
  String _selectedDocType = "mpesa_statement";
  final List<Map<String, dynamic>> _documentTypes = [
    {
      "code": "mpesa_statement",
      "label": "M-Pesa Statement",
      "icon": Icons.phone_android,
    },
    {
      "code": "bank_statement",
      "label": "Bank Statement",
      "icon": Icons.account_balance,
    },
    {
      "code": "payslip",
      "label": "Payslip Data",
      "icon": Icons.payments_outlined,
    },
    {
      "code": "national_id",
      "label": "National ID",
      "icon": Icons.badge_outlined,
    },
    {
      "code": "collateral_proof",
      "label": "Title Deed / Logbook",
      "icon": Icons.gavel_outlined,
    },
    {
      "code": "other",
      "label": "Other Documents",
      "icon": Icons.receipt_long_outlined,
    },
  ];

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        if (_nameController.text.isEmpty) {
          _nameController.text = _pickedFile!.name.split('.').first;
        }
      });
    }
  }

  void _addLoanDocument() async {
    final fileToUpload = _pickedFile;
    if (fileToUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please attach a document file first.")),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please type a document name.")),
      );
      return;
    }
    try {
      setState(() {
        isAdding = true;
      });
      final (response, errors) = await LoanApplicationService().addLoanDocument(
        applicationId: widget.appId,
        documentType: _selectedDocType,
        notes: _notesController.text.trim(),
        file: fileToUpload,
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoanDocuments(
                appId: widget.appId,
                productId: widget.productId,
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => isAdding = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DOCUMENT DISPLAY NAME",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          "Enter custom file name (e.g., M-Pesa Jan 2026)",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 3. Grid Selector Cards for Document Type Mapping
                  const Text(
                    "CLASSIFY DOCUMENT TYPE",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDocTypeGrid(),
                  const SizedBox(height: 28),

                  // 1. Provided Custom Upload Target Zone
                  _buildDocUploadZone(),
                  const SizedBox(height: 28),

                  // 4. Notes Text Area Field Block
                  const Text(
                    "PROCESSING REMARKS / NOTES",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText:
                          "Add specific processing condition records or context summary details...",
                      hintStyle: const TextStyle(fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Bottom CTA Action Control
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AnansiColors.darkBlue,
                        // Keeps the button premium-looking but slightly faded when processing
                        disabledBackgroundColor: AnansiColors.darkBlue
                            .withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      // Disables tapping functionality completely while uploading
                      onPressed: isAdding ? null : _addLoanDocument,
                      child: isAdding
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Confirm & Attach Document",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
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
                "Add Loan Document",
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
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

  Widget _buildDocUploadZone() {
    return GestureDetector(
      onTap: _pickDocument,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _pickedFile != null
                ? Colors.green.withValues(alpha: 0.4)
                : Colors.grey.shade200,
            width: _pickedFile != null ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _pickedFile != null
                  ? Icons.check_circle_outline_rounded
                  : Icons.file_upload_outlined,
              color: _pickedFile != null ? Colors.green : AnansiColors.darkBlue,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pickedFile != null
                        ? "Document Selected"
                        : "Attach Document",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _pickedFile != null
                        ? "Source: ${_pickedFile!.name} (${(_pickedFile!.size / 1024).toStringAsFixed(1)} KB)"
                        : "Upload Title deed, Logbook or KRA receipt",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTypeGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _documentTypes.map((type) {
        final bool isSelected = _selectedDocType == type['code'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDocType = type['code']!;
            });
          },
          child: Container(
            width:
                (MediaQuery.of(context).size.width - 60) /
                2, // Dynamically targets clean two-column grid rows
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AnansiColors.darkBlue : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AnansiColors.darkBlue
                    : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type['icon'],
                  size: 20,
                  color: isSelected ? Colors.white : AnansiColors.darkBlue,
                ),
                const SizedBox(height: 12),
                Text(
                  type['label']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
