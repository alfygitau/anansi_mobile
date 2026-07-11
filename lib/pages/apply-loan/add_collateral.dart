import 'dart:io';
import 'package:app_anansi_mobile/pages/apply-loan/collaterals.dart';
import 'package:app_anansi_mobile/pages/help&support/help_support.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/loan_application_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';

class AddCollateral extends StatefulWidget {
  final String appId;
  final String productId;
  const AddCollateral({
    super.key,
    required this.appId,
    required this.productId,
  });

  @override
  State<AddCollateral> createState() => _AddCollateralState();
}

class _AddCollateralState extends State<AddCollateral> {
  final List<File> _chattelImages = [];
  final List<PlatformFile> _assetDocs = [];
  final ImagePicker _picker = ImagePicker();

  Map<String, String?> formErrors = {
    'name': null,
    'value': null,
    'category': null,
    'attachments': null,
  };

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _valueFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  bool isAdding = false;
  String category = "";

  final List<Map<String, dynamic>> _categories = [
    {
      "id": "VEHICLE",
      "title": "Motor Vehicle",
      "icon": Icons.directions_car_filled_rounded,
    },
    {"id": "LAND", "title": "Land", "icon": Icons.landscape_rounded},
    {"id": "HOUSEHOLDS", "title": "Households", "icon": Icons.chair_rounded},
    {
      "id": "ELECTRONICS",
      "title": "Electronics",
      "icon": Icons.analytics_rounded,
    },
  ];

  void _validateField(String key, String value) {
    setState(() {
      if (value.trim().isEmpty) {
        formErrors[key] = "This field is required";
      } else {
        formErrors[key] = null;
      }
    });
  }

  bool _isFormValid() {
    bool valid = true;

    if (_nameController.text.trim().isEmpty) {
      formErrors['name'] = "Please provide a valid asset label descriptor";
      valid = false;
    }
    if (_valueController.text.trim().isEmpty) {
      formErrors['value'] = "Estimated financial valuation is required";
      valid = false;
    }
    if (category.isEmpty) {
      formErrors['category'] =
          "Please select an asset security classification option";
      valid = false;
    }
    if (_chattelImages.isEmpty) {
      formErrors['attachments'] =
          "At least one clear photo of the asset must be provided";
      valid = false;
    } else {
      formErrors['attachments'] = null;
    }

    setState(() {});
    return valid;
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _chattelImages.add(File(image.path));
        formErrors['attachments'] = null;
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg'],
      allowMultiple: true
    );
    if (result != null) {
      setState(() {
        _assetDocs.add(result.files.first);
        formErrors['attachments'] = null;
      });
    }
  }

  Future<void> addChattel() async {
    if (!_isFormValid() || isAdding) return;
    try {
      setState(() => isAdding = true);
      final (response, errors) = await LoanApplicationService().addChattel(
        applicationId: widget.appId,
        assetName: _nameController.text.trim(),
        assetValue: _valueController.text.trim(),
        assetCategory: category,
        imagePaths: _chattelImages.map((file) => file.path).toList(),
        docPaths: _assetDocs
            .map((file) => file.path)
            .whereType<String>()
            .toList(),
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Collaterals(appId: widget.appId, productId: widget.productId),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isAdding = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        _validateField('name', _nameController.text);
      }
      setState(() {});
    });
    _valueFocus.addListener(() {
      if (!_valueFocus.hasFocus) {
        _validateField('value', _valueController.text);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _valueFocus.dispose();
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    "ASSET DETAILS",
                    "Provide a detailed description of the asset you are pledging as security to help us accurately determine your enhanced loan limit.",
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: "Asset Name",
                    hint: "e.g. Samsung 55' UHD TV",
                    fieldKey: "name",
                    focusNode: _nameFocus,
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    icon: CupertinoIcons.add_circled,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Estimated Value",
                    hint: "KES 0.00",
                    keyboardType: TextInputType.number,
                    fieldKey: "value",
                    focusNode: _valueFocus,
                    controller: _valueController,
                    icon: CupertinoIcons.money_dollar,
                  ),
                  const SizedBox(height: 20),
                  categoryCard(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle(
                    "CHATTEL IMAGES",
                    "Provide clear photos of the item",
                  ),
                  const SizedBox(height: 16),
                  _buildImageGrid(),

                  const SizedBox(height: 32),
                  _buildSectionTitle(
                    "CHATTEL DOCUMENTS",
                    "Ownership proof, receipts, or logs",
                  ),
                  const SizedBox(height: 16),
                  _buildDocUploadZone(),

                  if (_assetDocs.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ..._assetDocs.map((file) => _buildFileTile(file)),
                  ],
                  if (formErrors['attachments'] != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 4),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.exclamationmark_circle,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              formErrors['attachments']!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(),
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
                "ADD CHATTEL",
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

  Widget _buildSectionTitle(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.blueGrey,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(sub, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildImageGrid() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _chattelImages.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == _chattelImages.length) {
            return _buildAddImageButton();
          }
          return _buildImagePreview(index);
        },
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () => _showImageSourceOptions(),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blueGrey.withValues(alpha: 0.1),
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(
          CupertinoIcons.camera_fill,
          color: AnansiColors.darkBlue,
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: FileImage(_chattelImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _chattelImages.removeAt(index)),
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Icon(Icons.close, size: 14, color: Colors.red),
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
          border: Border.all(color: Colors.grey.shade200),
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
            const Icon(
              Icons.file_upload_outlined,
              color: AnansiColors.darkBlue,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attach Document",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Upload Title deed, Logbook or KRA receipt",
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

  Widget _buildInputField({
    required String label,
    required String fieldKey,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required TextInputType keyboardType,
  }) {
    final String? errorText = formErrors[fieldKey];
    final bool hasError = errorText != null;
    final bool isFocused = focusNode.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: hasError
                      ? Colors.redAccent
                      : AnansiColors.darkBlue.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              if (hasError) ...[
                const SizedBox(width: 8),
                const Icon(
                  CupertinoIcons.exclamationmark_circle,
                  size: 12,
                  color: Colors.redAccent,
                ),
              ],
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent.withValues(alpha: 0.4)
                  : (isFocused
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFFE2E8F0)),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AnansiColors.darkBlue
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isFocused
                      ? Colors.white
                      : AnansiColors.darkBlue.withValues(alpha: 0.4),
                ),
              ),
              Container(
                height: 24,
                width: 1.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: const Color(0xFFE2E8F0),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  cursorColor: AnansiColors.darkBlue,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (val) {
                    if (formErrors[fieldKey] != null) {
                      setState(() => formErrors[fieldKey] = null);
                    }
                    setState(() {});
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                errorText ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileTile(PlatformFile file) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.doc_text,
            color: Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _assetDocs.remove(file)),
            child: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.grey,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: const Text("Take Photo"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: const Text("Choose from Library"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  // WIRED SUBMISSION DRIVER ACTION PANEL
  Widget _buildBottomAction() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        decoration: const BoxDecoration(color: Colors.white),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AnansiColors.darkBlue,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: isAdding
              ? null
              : addChattel, // Linked directly to execution stream
          child: isAdding
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  "Save & Continue",
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

  Widget categoryCard(BuildContext context) {
    const Color primaryColor = Color(0xFF074073);
    final bool hasCategoryError = formErrors['category'] != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "SELECT ASSET CATEGORY",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: hasCategoryError ? Colors.redAccent : Colors.blueGrey,
                letterSpacing: 1.1,
              ),
            ),
            if (hasCategoryError) ...[
              const SizedBox(width: 6),
              const Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 12,
                color: Colors.redAccent,
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                2, // Shifted to 2 for optimal title text sizing boundaries
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final item = _categories[index];
            final isSelected = category == item["id"];

            return InkWell(
              onTap: () {
                setState(() {
                  category = item["id"];
                  formErrors['category'] = null;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.04)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (hasCategoryError
                              ? Colors.redAccent.withValues(alpha: 0.3)
                              : const Color(0xFFEAECEF)),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    if (isSelected)
                      const Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: primaryColor,
                          size: 16,
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          item["icon"] as IconData,
                          color: isSelected ? primaryColor : Colors.grey[500],
                          size: 56,
                        ),
                        Text(
                          item["title"],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? primaryColor : Colors.black87,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            height: hasCategoryError ? null : 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 8),
              child: Text(
                formErrors['category'] ?? "",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
