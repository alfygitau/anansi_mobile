import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class KycStatus extends StatefulWidget {
  const KycStatus({super.key});

  @override
  State<KycStatus> createState() => _KycStatusState();
}

class _KycStatusState extends State<KycStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildMinimalProgress(),
              const SizedBox(height: 16),
              _buildSectionHeader("PERSONAL IDENTITY"),
              _buildDetailedKycCard(
                title: "National ID (Front)",
                description: "High-resolution photo of the ID front side.",
                status: "Verified",
                statusMessage: "Document matches profile details.",
                icon: LucideIcons.image,
                color: Colors.green,
                metaData: "IMG_882.jpg • 2.4 MB",
              ),
              _buildDetailedKycCard(
                title: "National ID (Back)",
                description: "High-resolution photo of the ID back side.",
                status: "Rejected",
                statusMessage: "Image is too blurry. Please retake.",
                icon: LucideIcons.image,
                color: Colors.redAccent,
                isActionable: true,
                metaData: "Retry required",
              ),
              _buildDetailedKycCard(
                title: "Liveness Selfie",
                description: "Real-time face scan for identity match.",
                status: "Pending",
                statusMessage: "Reviewing biometric consistency.",
                icon: LucideIcons.camera,
                color: Colors.orange,
                metaData: "Submitted: Today, 10:45 AM",
              ),

              const SizedBox(height: 24),
              _buildSectionHeader("TAX & LEGAL"),
              _buildDetailedKycCard(
                title: "KRA PIN Certificate",
                description: "Valid certificate in PDF format.",
                status: "Not Uploaded",
                statusMessage: "Required for KES 1M+ transactions.",
                icon: LucideIcons.fileDigit,
                color: Colors.grey,
                isActionable: true,
                metaData: "PDF Format only",
              ),
              _buildDetailedKycCard(
                title: "Terms & Conditions",
                description: "Anansi SACCO membership agreement.",
                status: "Accepted",
                statusMessage: "Version 2.4 signed digitally.",
                icon: LucideIcons.fileCheck,
                color: Colors.green,
                metaData: "Agreed on: 28/04/2026",
              ),

              const SizedBox(height: 20),
              _buildInfoFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedKycCard({
    required String title,
    required String description,
    required String status,
    required String statusMessage,
    required IconData icon,
    required Color color,
    required String metaData,
    bool isActionable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActionable
              ? color.withOpacity(0.4)
              : const Color(0xFFF1F5F9),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: isActionable ? () {} : null,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.blueGrey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status, color),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: Color(0xFFE2E8F0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(LucideIcons.info, size: 14, color: color),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            statusMessage,
                            style: TextStyle(
                              fontSize: 12,
                              color: color.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    metaData,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueGrey.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Helper UI methods from previous context (Progress, Header, Footer)
  Widget _buildMinimalProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Complete your profile to unlock all sacco benefits and features.",
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildInfoFooter() {
    return Center(
      child: Column(
        children: [
          Icon(LucideIcons.shieldCheck, color: Colors.grey.shade300, size: 28),
          const SizedBox(height: 8),
          Text(
            "Securely encrypted by Anansi Systems",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
