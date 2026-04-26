import 'package:app_anansi_mobile/pages/onboarding/income.dart';
import 'package:app_anansi_mobile/services/error_service.dart';
import 'package:app_anansi_mobile/services/onboarding_service.dart';
import 'package:app_anansi_mobile/shimmers/onboarding/verify_email_shimmer.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:app_anansi_mobile/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  String? selectedCountry = 'Kenya';
  String? selectedCounty = 'Select county';
  String? selectedSubCounty = 'Select subcounty';
  String? selectedState;

  final TextEditingController _physicalAddressController =
      TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  Map<String, String?> formErrors = {
    'address': null,
    'address_one': null,
    'address_two': null,
    'city': null,
    'zip_code': null,
    'county': null,
    'sub-county': null,
    'country': null,
    'state': null,
  };
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _addressOneFocus = FocusNode();
  final FocusNode _addressTwoFocus = FocusNode();
  final FocusNode _zipCodeFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();

  bool _isLoading = false;
  bool _loading = false;
  List<String> _counties = [];
  List<String> _subCounties = [];
  List<String> _states = [];
  List<Map<String, dynamic>> _allCounties = [];

  void _validateField(String key, String value) {
    String? error;

    switch (key) {
      case 'address':
      case 'address_one':
        if (value.trim().isEmpty) {
          error = "Please enter your street address";
        } else if (value.trim().length < 3) {
          error = "Address is too short";
        }
        break;

      case 'city':
        if (value.trim().isEmpty) {
          error = "City/Town is required";
        }
        break;

      case 'zip_code':
        if (value.trim().isEmpty) {
          error = "Zip/Postal code is required";
        } else if (value.trim().length < 4) {
          error = "Enter a valid postal code";
        }
        break;

      case 'country':
        if (value.isEmpty || value == 'Select country') {
          error = "Please select your country";
        }
        break;

      case 'county':
        if (value.isEmpty || value == 'Select county') {
          error = "Please select your county";
        }
        break;

      case 'sub-county':
        if (value.isEmpty || value == 'Select subcounty') {
          error = "Please select your sub-county";
        }
        break;

      default:
        error = null;
    }

    setState(() {
      formErrors[key] = error;
    });
  }

  bool get isFormValid {
    // 1. Check Kenya Requirements
    if (selectedCountry == 'Kenya') {
      return _physicalAddressController.text.trim().isNotEmpty &&
          (selectedCounty != null &&
              !selectedCounty!.toLowerCase().contains('select')) &&
          (selectedSubCounty != null &&
              !selectedSubCounty!.toLowerCase().contains('select'));
    }

    // 2. Check US Requirements
    if (selectedCountry == 'United States') {
      return _addressOneController.text.trim().isNotEmpty &&
          _addressTwoController.text.trim().isNotEmpty &&
          _cityController.text.trim().isNotEmpty &&
          _zipCodeController.text.trim().isNotEmpty &&
          (selectedState != null &&
              selectedState!.isNotEmpty &&
              !selectedState!.toLowerCase().contains('select'));
    }

    // 3. Fallback (Button remains disabled if no country matches)
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchCounties();
    fetchStates();

    // Physical Address / General Address
    _addressFocus.addListener(() {
      if (!_addressFocus.hasFocus) {
        _validateField('address', _physicalAddressController.text);
      }
    });

    // Address Line 1
    _addressOneFocus.addListener(() {
      if (!_addressOneFocus.hasFocus) {
        _validateField('address_one', _addressOneController.text);
      }
    });

    // Address Line 2 (Usually optional, but good to have the listener)
    _addressTwoFocus.addListener(() {
      if (!_addressTwoFocus.hasFocus) {
        _validateField('address_two', _addressTwoController.text);
      }
    });

    // City
    _cityFocus.addListener(() {
      if (!_cityFocus.hasFocus) {
        _validateField('city', _cityController.text);
      }
    });

    // Zip Code
    _zipCodeFocus.addListener(() {
      if (!_zipCodeFocus.hasFocus) {
        _validateField('zip_code', _zipCodeController.text);
      }
    });
  }

  Future<void> fetchCounties() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final (response, errors) = await OnboardingService().getCounties();
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        final myCounties = List<Map<String, dynamic>>.from(
          response.data['data'] ?? [],
        );
        setState(() {
          _allCounties = myCounties;
          _counties = myCounties
              .where((county) => county['county'] != null)
              .map((county) => county['county'].toString())
              .toList();
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> fetchStates() async {
    final (response, errors) = await OnboardingService().getStates();
    if (errors != null) {
      ErrorService.showActionableError(
        context,
        title: errors[0],
        message: errors[1],
      );
    } else if (response != null) {
      final myStates = List<Map<String, dynamic>>.from(
        response.data['data'] ?? [],
      );
      setState(() {
        _states = myStates
            .where((state) => state['name'] != null)
            .map<String>((state) => state['name'].toString())
            .toList();
      });
    }
  }

  void _changeCounty(String? value) {
    if (value == null) return;
    setState(() {
      selectedCounty = value;
      final selected = _allCounties.firstWhere((c) => c['county'] == value);
      _subCounties = List<String>.from(selected['sub_counties'] ?? []);
      selectedSubCounty = _subCounties.isNotEmpty
          ? _subCounties.first
          : 'Select subcounty';
    });
    _validateField('state', value);
  }

  @override
  void dispose() {
    // Dispose Controllers
    _physicalAddressController.dispose();
    _addressOneController.dispose();
    _addressTwoController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();

    // Dispose FocusNodes
    _addressFocus.dispose();
    _addressOneFocus.dispose();
    _addressTwoFocus.dispose();
    _cityFocus.dispose();
    _zipCodeFocus.dispose();

    super.dispose();
  }

  Future<void> createAddress() async {
    setState(() {
      _loading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final (response, errors) = await OnboardingService().createAddress(
        id: authProvider.user?['id'] ?? "",
        county: selectedCounty?.trim() ?? "",
        subcounty: selectedSubCounty?.trim() ?? "",
        physicalAddress: _physicalAddressController.text.trim(),
        zipcode: _zipCodeController.text.trim(),
        city: _cityController.text.trim(),
        state: selectedState?.trim() ?? "",
      );
      if (errors != null) {
        ErrorService.showActionableError(
          context,
          title: errors[0],
          message: errors[1],
        );
      } else if (response != null) {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IncomeInformation()),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? VerifyEmailShimmer()
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _buildStepHeader(),
                          const SizedBox(height: 32),
                          _buildSectionLabel("RESIDENCY DETAILS"),
                          const SizedBox(height: 16),
                          _buildDropdownField(
                            label: "Country of Residence",
                            value: selectedCountry,
                            items: ['Kenya', 'United States'],
                            icon: CupertinoIcons.globe,
                            onChanged: (val) {
                              setState(() => selectedCountry = val);
                              _validateField('country', val ?? '');
                            },
                          ),

                          const SizedBox(height: 24),
                          _buildSectionLabel("LOCATION DETAILS"),
                          const SizedBox(height: 16),

                          if (selectedCountry == 'Kenya') ...[
                            _buildDropdownField(
                              label: "County",
                              value: selectedCounty,
                              items: _counties,
                              icon: CupertinoIcons.map_pin_ellipse,
                              onChanged: _changeCounty,
                            ),
                            const SizedBox(height: 20),
                            _buildDropdownField(
                              label: "Sub-County",
                              value: selectedSubCounty,
                              items: _subCounties,
                              icon: Icons.location_city,
                              onChanged: (val) {
                                setState(() => selectedSubCounty = val);
                                _validateField('sub-county', val ?? '');
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: "Physical Address",
                              controller: _physicalAddressController,
                              hint: "e.g Apartment, House No, Street",
                              icon: CupertinoIcons.house,
                              focusNode: _addressFocus,
                              fieldKey: "address",
                              keyboardType: TextInputType.text,
                            ),
                          ] else ...[
                            _buildInputField(
                              label: "Address Line 1",
                              controller: _addressOneController,
                              hint: "Street address or P.O. Box",
                              icon: CupertinoIcons.house,
                              focusNode: _addressOneFocus,
                              fieldKey: "address_one",
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: "Address Line 2",
                              controller: _addressTwoController,
                              hint: "Apartment, suite, unit, building",
                              icon: CupertinoIcons.info_circle,
                              focusNode: _addressTwoFocus,
                              fieldKey: "address_two",
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            _buildDropdownField(
                              label: "State",
                              value: selectedState,
                              items: _states,
                              icon: CupertinoIcons.map,
                              onChanged: (val) {
                                setState(() => selectedState = val);
                                _validateField('state', val ?? '');
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: "City",
                              controller: _cityController,
                              hint: "Enter your city",
                              icon: CupertinoIcons.location,
                              focusNode: _cityFocus,
                              fieldKey: "city",
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              label: "Zip Code",
                              controller: _zipCodeController,
                              hint: "Enter your zip code",
                              icon: CupertinoIcons.location,
                              focusNode: _zipCodeFocus,
                              fieldKey: "zip_code",
                              keyboardType: TextInputType.number,
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildActionDock(),
                ],
              ),
            ),
    );
  }

  Widget _buildStepHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Information",
          style: TextStyle(
            color: AnansiColors.darkBlue,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "To ensure a secure and compliant experience, we require your current residential address. This information allows us to verify your regional eligibility for specific Anansi loan products, facilitate official legal communication, and maintain the integrity of our credit assessment process in accordance with local financial regulations.",
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 15,
            height: 1.6,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: Colors.grey.shade400,
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
                  : (isFocused ? Color(0xFFE2E8F0) : const Color(0xFFE2E8F0)),
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
                    fontSize: 16,
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
              if (controller.text.isNotEmpty && !hasError)
                const Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: Colors.teal,
                  size: 18,
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    bool hasValue = value != null && value.isNotEmpty && items.contains(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AnansiColors.darkBlue.withValues(alpha: 0.6),
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          height: 64, // Fixed height to match text inputs perfectly
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown:
                  true, // This aligns the menu width with the button width
              child: DropdownButton<String>(
                value: hasValue ? value : null,
                isExpanded: true, // Forces the content to span the Row
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(22),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 14),
                  child: Icon(
                    CupertinoIcons.chevron_down,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                // We use the hint/selectedItem to build your custom Row inside the button
                hint: _buildDropdownRow(icon, "Select $label", isHint: true),
                selectedItemBuilder: (context) {
                  return items.map((String item) {
                    return _buildDropdownRow(icon, item, isHint: false);
                  }).toList();
                },
                items: items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper to keep the Icon Anchor and Separator consistent
  Widget _buildDropdownRow(IconData icon, String text, {required bool isHint}) {
    return Row(
      children: [
        // Icon Anchor
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AnansiColors.darkBlue.withValues(alpha: 0.4),
          ),
        ),
        // Vertical Separator
        Container(
          height: 24,
          width: 1.5,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: const Color(0xFFE2E8F0),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isHint ? Colors.blueGrey.shade200 : Colors.black,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionDock() {
    final VoidCallback? action = _loading
        ? () {}
        : (isFormValid ? createAddress : null);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F4F8), width: 1)),
      ),
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: AnansiColors.darkBlue,
          foregroundColor: Colors.white,
          // The background when the form is invalid (not loading)
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade500,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: _loading
            ? const SizedBox(
                height: 24, // Increased slightly for visibility
                width: 24,
                child: CupertinoActivityIndicator(color: Colors.white),
              )
            : Text(
                "SAVE AND CONTINUE",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  // Text stays white if valid OR loading
                  color: isFormValid || _loading
                      ? Colors.white
                      : Colors.grey.shade500,
                ),
              ),
      ),
    );
  }
}
