import 'package:flutter/material.dart';

class CustomerFormPage extends StatefulWidget {

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  bool showAdditionalInfo = true; // For the toggle switch
  bool showAddressSection = true; // Toggle for Add Address section
  String customerType = 'Customer Type'; // Dropdown value
  String additionalInfoType = 'AS Supplier'; // Additional Info Dropdown value
  String addressType = 'Enter Address Type';
  String country = 'Select Country';
  String state = 'Select State';
  String district = 'Select District';
  String thana = 'Select Thana';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isNameClearIconVisible = false;
  bool isPhoneClearIconVisible = false;
  bool isEmailClearIconVisible = false;
  bool isWebsiteClearIconVisible = false;
  bool isOpeningClearIconVisible = false;
  bool isAddressClearIconVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No shadow for a clean look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button action
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, size: 35, color: Colors.grey),
                      onPressed: () {
                        // Handle image upload
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add Photo',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Full Name Field
            buildTextField(
              'Name',
              icon: Icons.person_outline,
              controller: nameController,
              isCloseIconVisible: isNameClearIconVisible,
              onChanged: (value){
                setState(() {
                  isNameClearIconVisible = value.isNotEmpty ? true : false;
                });
              },
            ),
            SizedBox(height: 10),

            // Phone Field
            buildTextField('Phone',
                keyboardType: TextInputType.phone,
                icon:  Icons.phone_outlined,
                controller: phoneController,
                isCloseIconVisible: isPhoneClearIconVisible,
                onChanged: (value){
                  setState(() {
                    isPhoneClearIconVisible = value.isNotEmpty ? true : false;
                  });
                }
            ),
            SizedBox(height: 10),

            // Email Field
            buildTextField('Email',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.mail_outline,
                isCloseIconVisible: isEmailClearIconVisible,
                onChanged: (value){
                  setState(() {
                    isEmailClearIconVisible = value.isNotEmpty ? true : false;
                  });
                },
                controller: emailController),

            SizedBox(height: 20),

            // Customer Type Dropdown
            buildDropdown(
              'Customer Type',
              customerType,
              ['Customer Type', 'Retail', 'Wholesale'],
                  (String? newValue) {
                setState(() {
                  customerType = newValue!;
                });
              },
            ),

            SizedBox(height: 20),

            // Additional Info Toggle with background
            buildToggleSectionWithBackground(
              'Additional Info',
              showAdditionalInfo,
              Icons.account_box,
                  (value) {
                setState(() {
                  showAdditionalInfo = value;
                });
              },
              content: showAdditionalInfo
                  ? Column(
                children: [
                  const SizedBox(height: 10),
                  buildDropdown(
                    'AS Supplier',
                    additionalInfoType,
                    ['AS Supplier', 'AS Customer'],
                        (String? newValue) {
                      setState(() {
                        additionalInfoType = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                      'Website',
                      icon: Icons.language,
                      keyboardType: TextInputType.url,
                      controller: websiteController,
                      isCloseIconVisible: isWebsiteClearIconVisible,
                      onChanged: (value){
                        setState(() {
                          isWebsiteClearIconVisible = value.isNotEmpty ? true : false;
                        });
                      }
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                      'Opening Balance',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      controller: openingBalanceController,
                      isCloseIconVisible: isOpeningClearIconVisible,
                      onChanged: (value){
                        setState(() {
                          isOpeningClearIconVisible = value.isNotEmpty ? true : false;
                        });
                      }
                  ),
                ],
              )
                  : null,
            ),

            SizedBox(height: 20),

            // Add Address Section with same style as Additional Info
            buildToggleSectionWithBackground(
                'Add Address',
                showAddressSection,
                Icons.location_on,
                    (value) {
                  setState(() {
                    showAddressSection = value;
                  });
                },
                content: showAddressSection ?
                // Add Address Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showAddressBottomSheet(context); // Show the bottom dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Add Address', style: TextStyle(fontSize: 16)),
                  ),
                ) : null
            ),

            SizedBox(height: 20),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: Text('SAVE', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Helper method to build a text field with optional icon
  Widget buildTextField(
      String label, {
        TextInputType keyboardType = TextInputType.text,
        IconData? icon,
        required TextEditingController controller,
        required void Function(String) onChanged,
        bool isCloseIconVisible = false
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: Visibility(
          visible: isCloseIconVisible, // Simplify visibility check
          child: IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: icon != null ? Icon(icon, size: 18, color: Colors.blue) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  // Helper method to build dropdown fields
  Widget buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              // Address Type Dropdown
              buildDropdown(
                'Address Type',
                addressType,
                ['Enter Address Type', 'Home', 'Work', 'Other'],
                    (String? newValue) {
                  setState(() {
                    addressType = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),

              // Address Field
              buildTextField('Address',
                  controller: addressController,
                  icon: Icons.home_outlined,
                  isCloseIconVisible: isAddressClearIconVisible,
                  onChanged: (value){
                    setState(() {
                      isAddressClearIconVisible = value.isNotEmpty ? true : false;

                    });
                  }
              ),

              // Country, State, District, and Thana Fields
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      'Country',
                      country,
                      ['Select Country', 'Country 1', 'Country 2'],
                          (String? newValue) {
                        setState(() {
                          country = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildDropdown(
                      'State/Division',
                      state,
                      ['Select State', 'State 1', 'State 2'],
                          (String? newValue) {
                        setState(() {
                          state = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: buildDropdown(
                      'District',
                      district,
                      ['Select District', 'District 1', 'District 2'],
                          (String? newValue) {
                        setState(() {
                          district = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: buildDropdown(
                      'Thana',
                      thana,
                      ['Select Thana', 'Thana 1', 'Thana 2'],
                          (String? newValue) {
                        setState(() {
                          thana = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Save Address Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close bottom sheet after saving
                },
                child: Text('Save Address'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build toggle sections with background color
  Widget buildToggleSectionWithBackground(
      String title,
      bool value,
      IconData icon,
      ValueChanged<bool> onChanged, {
        Widget? content
      }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, // Background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.white24,
              ),
            ],
          ),
          if (content != null) content,
        ],
      ),
    );
  }
}
