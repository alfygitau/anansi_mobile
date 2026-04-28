import 'dart:io';
import 'package:app_anansi_mobile/pages/profile/profile.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/profile_service.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePicturePage extends StatefulWidget {
  final Map<String, dynamic> customer;
  const EditProfilePicturePage({super.key, required this.customer});

  @override
  State<EditProfilePicturePage> createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  File? _image;
  String? _profilePhotoUrl;
  bool _isUploading = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profilePhotoUrl = widget.customer['profile_photo'];
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _image = File(photo.path);
          _profilePhotoUrl = null;
        });
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  Future<void> _uploadFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
          _profilePhotoUrl = null;
        });
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }

  Future<void> _saveChanges() async {
    if (_image == null) return;
    setState(() => _isUploading = true);
    try {
      final (response, errors) = await ProfileService().uploadProfilePhoto(
        file: _image ?? File(""),
        id: widget.customer['id'] ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPhotoDisplay(),
                const SizedBox(height: 32),

                _buildActionTitle("UPDATE PHOTO"),
                const SizedBox(height: 16),

                _buildUploadOption(
                  label: "Take a New Selfie",
                  description: "Use your camera for immediate update.",
                  icon: CupertinoIcons.camera,
                  onTap: _takePhoto,
                ),
                const SizedBox(height: 16),

                _buildUploadOption(
                  label: "Upload from Gallery",
                  description: "Choose a clear photo from your device.",
                  icon: CupertinoIcons.photo,
                  onTap: _uploadFromGallery,
                ),

                const SizedBox(height: 40),
                _buildDisclaimers(),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: _buildPersistentFooter(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ThemeColors.background.withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "My Profile",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "EDIT PROFILE PICTURE",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
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
            border: Border.all(color: Colors.grey.shade200),
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
          child: _buildCircleAction(CupertinoIcons.question_circle, () {}),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, VoidCallback onTap) {
    return Center(
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
          icon: Icon(icon, size: 18, color: AnansiColors.darkBlue),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildPhotoDisplay() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A2351).withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Hero(
          tag: 'profile_pic',
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.white, width: 6),
              image: _profilePhotoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_profilePhotoUrl!),
                      fit: BoxFit.cover,
                    )
                  : _image != null
                  ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (_profilePhotoUrl == null && _image == null)
                ? const Icon(
                    CupertinoIcons.person_alt_circle_fill,
                    size: 80,
                    color: Colors.grey,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Color(0xFF17C6C6),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildUploadOption({
    required String label,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F4F8), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF17C6C6).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF17C6C6)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A2351),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimers() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F4F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                CupertinoIcons.checkmark_shield_fill,
                color: Color(0xFF17C6C6),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Compliance & Verification",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A2351),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDisclaimerText(
            "Your profile photo is used for identity verification by Sacco staff.",
          ),
          _buildDisclaimerText(
            "Please ensure your face is clearly visible, centered, and well-lit.",
          ),
          _buildDisclaimerText(
            "Avoid using photos with other people, filters, or hats.",
          ),
          _buildDisclaimerText(
            "Photos must be professional and consistent with official documentation.",
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F4F8)),
          const SizedBox(height: 12),
          Text(
            "Anansi Sacco utilizes advanced facial recognition as part of our security protocols to protect your account.",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(
              radius: 2,
              backgroundColor: Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersistentFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: (_image != null && !_isUploading) ? _saveChanges : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A2351),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            disabledBackgroundColor: Colors.grey.shade100,
          ),
          child: _isUploading
              ? const CupertinoActivityIndicator(color: Colors.white)
              : const Text(
                  "Update Profile Photo",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
