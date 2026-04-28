import 'package:app_anansi_mobile/pages/settings/kyc_status.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _biometricsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _buildSectionHeader("Security & Privacy"),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSettingsTile(
                icon: CupertinoIcons.lock_shield,
                title: "Change Password",
                subtitle: "Secure your account credentials",
                onTap: () => () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.viewfinder,
                title: "Enable Biometrics",
                subtitle: "Face ID or Fingerprint",
                onTap: () {},
                toggle: CupertinoSwitch(
                  value: _biometricsEnabled,
                  activeTrackColor: const Color(0xFF042159),
                  onChanged: (val) => setState(() => _biometricsEnabled = val),
                ),
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildSectionHeader("Account Details"),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSettingsTile(
                icon: CupertinoIcons.person_crop_circle,
                title: "Edit Profile",
                subtitle: "Manage your name, email, and phone",
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.doc_plaintext,
                title: "Kyc Documents",
                subtitle: "Check your verification status",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KycStatus(),
                    ),
                  );
                },
              ),
            ]),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildSectionHeader("Support"),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSettingsTile(
                icon: CupertinoIcons.question_circle,
                title: "Help Center",
                subtitle: "FAQs and support guides",
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.chat_bubble_2,
                title: "Contact Us",
                subtitle: "Talk to our support team",
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.info_circle,
                title: "About Anansi",
                subtitle: "Learn more about our mission",
                onTap: () {},
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.shield_lefthalf_fill,
                title: "Privacy Policy",
                onTap: () {},
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          const Text(
            "Settings",
            style: TextStyle(
              color: AnansiColors.darkBlue,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          Text(
            "VIEW MY SETTINGS",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      leading: _buildCircleBackBtn(),
    );
  }

  Widget _buildCircleBackBtn() {
    return Center(
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
    );
  }

  // --- Reusable Modern Components ---

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF94A3B8),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    Widget? toggle, // For the biometrics switch
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF042159).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: const Color(0xFF042159), size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 3. Trailing Content (Toggle, Text, or Chevron)
                  if (toggle != null)
                    toggle
                  else if (trailingText != null)
                    Text(
                      trailingText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF042159),
                      ),
                    )
                  else
                    const Icon(
                      CupertinoIcons.chevron_right,
                      size: 14,
                      color: Color(0xFFCBD5E1),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
