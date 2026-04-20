import 'package:app_anansi_mobile/pages/profile/edit_address.dart';
import 'package:app_anansi_mobile/pages/profile/edit_financial_details.dart';
import 'package:app_anansi_mobile/pages/profile/edit_personal_information.dart';
import 'package:app_anansi_mobile/pages/profile/edit_profile_image.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Map<String, dynamic> staticCustomer = {
    "id": "user_88291",
    "public_id": "ANS-99201-KE",
    "firstname": "Alfred",
    "lastname": "Kariuki Gitau",
    "email": "alfred@anansi.co.ke",
    "mobileno": "+254 712 345 678",
    "dob": "1994-05-12T00:00:00Z",
    "gender": "Male",
    "country_of_residence": "Kenya",
    "identification_type": "National ID",
    "identification": "32098411",
    "profile_photo":
        "https://ui-avatars.com/api/?name=Alfred+Kariuki&background=0A2351&color=fff",
    "occupation": "Senior Full-Stack Developer",
    "employment_type": "Permanent / Full-time",
    "income_range": "200,000 - 400,000",
    "kraPin": "A001234567Z",

    // Nested Address List (matches your React logic: address?.[0])
    "addresses": [
      {
        "county": "Nairobi",
        "subcounty": "Westlands",
        "physical_address": "Delta Towers, 4th Floor",
        "postal_code": "00100",
      },
    ],

    // Nested Next of Kin List (matches your React logic: nextOfKins?.[0])
    "nextOfKins": [
      {
        "name": "Jane Wambui Kariuki",
        "relationship": "Spouse",
        "phoneNumber": "+254 722 000 111",
        "location": "Nairobi, Kilimani",
      },
    ],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
              child: Column(
                children: [
                  _buildTopIdentitySection(),
                  const SizedBox(height: 20),
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 20),
                  _buildGridSections(),
                  const SizedBox(height: 24),
                  _buildExitPolicySection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIdentitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: ThemeColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 4,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://ui-avatars.com/api/?name=Alfred+Kariuki&background=random",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfilePicturePage(customer: staticCustomer),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: ThemeColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.camera_fill,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Alfred Kariuki Gitau",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "alfred@anansi.co.ke",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              "ID: ANS-99201-KE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. PERSONAL INFO CARD ---
  Widget _buildPersonalInfoCard() {
    return _InfoCardTemplate(
      title: "Personal Information",
      icon: CupertinoIcons.person_fill,
      onEdit: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditPersonalInformation(customer: staticCustomer),
          ),
        );
      },
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _DataField(label: "First Name", value: "Alfred"),
          _DataField(label: "Last Name", value: "Kariuki"),
          _DataField(label: "Phone Number", value: "+254 712 345 678"),
          _DataField(label: "Date of Birth", value: "12 May 1994"),
          _DataField(label: "Gender", value: "Male"),
          _DataField(label: "ID Type", value: "National ID"),
        ],
      ),
    );
  }

  // --- 3. GRID SECTIONS (Residential, Financial, Kin) ---
  Widget _buildGridSections() {
    return Column(
      children: [
        _InfoCardTemplate(
          title: "Residential Address",
          icon: CupertinoIcons.map_pin_ellipse,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAddressPage(customer: staticCustomer),
              ),
            );
          },
          child: Column(
            children: [
              _DataField(label: "Country", value: "Kenya", isFullWidth: true),
              const SizedBox(height: 12),
              _DataField(label: "County", value: "Nairobi", isFullWidth: true),
              const SizedBox(height: 12),
              _DataField(
                label: "Sub County",
                value: "Langata",
                isFullWidth: true,
              ),
              const SizedBox(height: 12),
              _DataField(
                label: "Physical Address",
                value: "Westlands, Delta Towers, 4th Floor",
                isFullWidth: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _InfoCardTemplate(
          title: "Employment & Financials",
          icon: CupertinoIcons.briefcase_fill,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditFinancialsPage(customer: staticCustomer),
              ),
            );
          },
          child: Column(
            children: [
              _DataField(
                label: "Job Title",
                value: "Senior Full-Stack Developer",
                isFullWidth: true,
              ),
              const SizedBox(height: 16),
              _DataField(
                label: "Income Range",
                value: "KES 200,000 - 400,000",
                isFullWidth: true,
              ),
              const SizedBox(height: 16),
              _DataField(
                label: "KRA Pin",
                value: "A123456789Q",
                isFullWidth: true,
              ),
              const SizedBox(height: 16),
              _DataField(
                label: "Job Type",
                value: "Employed",
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ],
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
            "MEMBER INFORMATION",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 7,
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

  // --- 4. SACCO EXIT POLICY (The "Critical" Section) ---
  Widget _buildExitPolicySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeColors.rose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  CupertinoIcons.person_badge_minus_fill,
                  color: ThemeColors.rose,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SACCO EXIT POLICY",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "Membership Termination",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: ThemeColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Membership withdrawal is permanent. Ensure all active loans are cleared and no guarantorship obligations remain.",
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 24),
          _buildPolicyRequirement(
            "No Active Loans",
            "Account balance must be KES 0.00",
          ),
          const SizedBox(height: 12),
          _buildPolicyRequirement(
            "No Guarantorship",
            "You must not be guaranteeing any loan",
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.rose,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Apply for Membership Exit",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRequirement(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.checkmark_circle_fill,
            size: 18,
            color: Colors.amber,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: ThemeColors.primary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE SUB-COMPONENTS ---

class _InfoCardTemplate extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback onEdit;

  const _InfoCardTemplate({
    required this.title,
    required this.icon,
    required this.child,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: ThemeColors.secondary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: ThemeColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  CupertinoIcons.pencil_circle,
                  size: 22,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _DataField extends StatelessWidget {
  final String label;
  final String value;
  final bool isFullWidth;

  const _DataField({
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade400,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ThemeColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
