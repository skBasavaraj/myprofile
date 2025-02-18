// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basavaraj SK - Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFF0A192F),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  int _selectedIndex = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isScrolling) {
      double currentScroll = _scrollController.offset;
      for (int i = _sectionKeys.length - 1; i >= 0; i--) {
        final sectionKey = _sectionKeys[i];
        final sectionContext = sectionKey.currentContext;
        if (sectionContext != null) {
          final RenderBox box = sectionContext.findRenderObject() as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          if (position.dy <= MediaQuery.of(context).size.height / 3) {
            if (_selectedIndex != i) {
              setState(() => _selectedIndex = i);
            }
            break;
          }
        }
      }
    }
  }

  void _scrollToSection(int index) {
    setState(() {
      _selectedIndex = index;
      _isScrolling = true;
    });

    final sectionKey = _sectionKeys[index];
    if (sectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        sectionKey.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      ).then((_) {
        setState(() => _isScrolling = false);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              if (MediaQuery.of(context).size.width > 768)
                _buildSidebar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _buildSection(_buildHero(), 0),
                        _buildSection(_buildAbout(), 1),
                        _buildSection(_buildExperience(), 2),
                        _buildSection(_buildProjects(), 3),
                        _buildSection(_buildSkills(), 4),
                        _buildSection(_buildContact2(context), 5),
                      ].animate(interval: 200.ms).fadeIn().slideX(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (MediaQuery.of(context).size.width <= 768)
            _buildMobileNav(),
        ],
      ),
    );
  }

  Widget _buildSection(Widget child, int index) {
    return Container(
      key: _sectionKeys[index],
      child: child,
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 100,
      color: const Color(0xFF172A45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.person, 'About', 1),
          _buildNavItem(Icons.work, 'Experience', 2),
          _buildNavItem(Icons.code, 'Projects', 3),
          _buildNavItem(Icons.psychology, 'Skills', 4),
          _buildNavItem(Icons.email, 'Contact', 5),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: () => _scrollToSection(index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMobileNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF172A45),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.person, 'About', 1),
            _buildNavItem(Icons.work, 'Experience', 2),
            _buildNavItem(Icons.code, 'Projects', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, my name is',
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Basavaraj SK',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Mobile Application Developer',
                textStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 42,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 600,
            child: Text(
              'I specialize in building exceptional mobile applications using Flutter and Android Compose. Currently focused on creating accessible, human-centered products.',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, String playStoreLink, List<String> technologies) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF172A45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: technologies.map((tech) => Chip(
                label: Text(tech,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF172A45),
                ),),
                backgroundColor: Colors.blue.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.white),
              )).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => launchUrl(Uri.parse(playStoreLink)),
              icon: const Icon(Icons.play_arrow,
              color:Colors.blueAccent,),
              label:   Text('View on Play Store',
              style: GoogleFonts.poppins(
                color: Colors.white
              ),),
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor:  const Color(0xFF172A45),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(String company, String role, String duration, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF172A45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              role,
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            Text(
              duration,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(String category, List<String> skills) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF172A45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => Chip(
                label: Text(skill,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF172A45),
                    )),
                backgroundColor: Colors.blue.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.white),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About Me'),
        Text(
          'I am a mobile application developer with expertise in Flutter and Android Compose. With over 4 years of experience, I have worked on various projects ranging from education management systems to e-commerce applications.',
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Experience'),
        _buildExperienceCard(
          'OneDollarCRM, Bengaluru',
          'Mobile Application Developer',
          'JULY 2024 - PRESENT',
          'Working on OneDollarCRM, SayTreesAPP',
        ),
        _buildExperienceCard(
          'Vaps Tech, Bengaluru',
          'Mobile Application Developer',
          'JULY 2023 - JULY 2024',
          'Working on VMS App, M College, and Mskool App using Flutter.\nImplementing state management with GetX, handling API integration, and Firebase notifications.',
        ),
        _buildExperienceCard(
          'Verzat Tech, Bengaluru',
          'Mobile Application Developer',
          'SEPT 2022 - JULY 2023',
          'Developed B2C applications using Flutter and created backend APIs using phpMyAdmin.',
        ),
       _buildExperienceCard(  'Synclovis, Bengaluru',
          'Android Developer',
         'APRIL 2022 - SEPT 2022',
         'Android native Kotlin development and UI design collaboration',),
        _buildExperienceCard(
          'Lufick, Gurugram',
          'Android Developer',
          'OCT 2021 - MAR 2022',
          'Android native Kotlin development and UI design collaboration',),
        _buildExperienceCard(
          'Innovatum Sol, Gulbarga',
          'Android Developer',
          'OCT 2020 - JULY 2021',
          'Android native Kotlin development and UI design collaboration',),
      ],
    );
  }

  Widget _buildProjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Projects'),
        _buildProjectCard(
          'OneDollarCRM',
          'One Dollar CRM is the Easiest CRM you will find for Lead Management and Sales Pipeline Management. It is built to suit small and medium businesses.',
          'https://play.google.com/store/apps/details?id=co.pipecycle&hl=en&gl=in',
          ['Flutter', 'KML', 'Local DB Sync', 'Offline Support'],
        ),
        _buildProjectCard(
          'SayTrees',
          'Environmental app featuring KML integration, local database synchronization, and\noffline-online data management capabilities.',
          'https://play.google.com/store/apps/details?id=com.spl.saytrees',
          ['Flutter', 'KML', 'Local DB Sync', 'Offline Support'],
        ),
        _buildProjectCard(
          'VMS App (Vaps Management System)',
          'Enterprise management system using GetX for state management, Dio for networking, and Firebase Push Notifications. Focused on UI design, API integration, and bug resolution.',
           'https://play.google.com/store/apps/details?id=com.app.vmss',
           ['Flutter', 'GetX', 'Dio', 'Firebase'],
        ),
        _buildProjectCard(
           'M College (ERP Education App)',
           'Educational ERP system featuring multiple dashboards (Principal, Chairman, Staff) with GetX state management and comprehensive API integration.',
           'https://play.google.com/store/apps/details?id=com.app.mcollege',
          ['Flutter', 'GetX', 'Firebase', 'Educational ERP'],
        ),
        _buildProjectCard(
          'M Skool (ERP Education App)',
          'Advanced educational management system with multiple user roles and comprehensive dashboard functionality.',
           'https://play.google.com/store/apps/details?id=com.app.mskool',
           ['Flutter', 'API Integration', 'Firebase'],
        ),
        _buildProjectCard(
         'Best Al-Yousifi (Ecommerce App)',
           'E-commerce platform built with Kotlin featuring MVVM architecture, biometric authentication, QR scanning, and multi-language support.',
          'https://play.google.com/store/apps/details?id=com.best.alyousifi',
           ['Kotlin', 'MVVM', 'Retrofit', 'Biometric Auth'],
        ),
        _buildProjectCard(
          'File Manager',
           'File system management app enabling P2P file sharing via WiFi between nearby devices.',
            'https://play.google.com/store/apps/details?id=com.cvinfo.filemanager',
          ['Java', 'P2P WiFi', 'File System API'],
        ),

      ],
    );
  }

  Widget _buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Skills'),
        _buildSkillCard(
          'Mobile Development',
          ['Flutter', 'Android Compose', 'Java', 'Kotlin', 'Dart'],
        ),
        _buildSkillCard(
          'Tools & Technologies',
          ['Firebase', 'REST API', 'GetX', 'MVVM', 'Git'],
        ),
      ],
    );
  }

  Widget _buildContact(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contact'),
        Center(
          child: Column(
            children: [
              Text(
                'Get In Touch',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 600,
                child: Text(
                  'I\'m currently looking for new opportunities. Whether you have a question or just want to say hi, I\'ll try my best to get back to you!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildContact2(context)
            ],
          ),
        ),
      ],
    );
  }
}
// Add this new class to handle form data
class ContactFormData {
  String name = '';
  String email = '';
  String subject = '';
  String message = '';
}

// Add these widgets to the existing PortfolioHome class

Widget _buildContact2(BuildContext context) {
  final formData = ContactFormData();
  final formKey = GlobalKey<FormState>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionTitle('Contact'),
      Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                'Get In Touch',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'I\'m currently looking for new opportunities. Feel free to reach out!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              _buildContactForm(formKey, formData,context),
              const SizedBox(height: 48),
              _buildSocialLinks(),
              const SizedBox(height: 32),
              _buildContactInfo(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildContactForm(GlobalKey<FormState> formKey, ContactFormData formData,BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: const Color(0xFF172A45),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Name',
                  onSaved: (value) => formData.name = value ?? '',
                  validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter your name' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Email',
                  onSaved: (value) => formData.email = value ?? '',
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter your email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Subject',
            onSaved: (value) => formData.subject = value ?? '',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter a subject' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Message',
            onSaved: (value) => formData.message = value ?? '',
            validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter your message' : null,
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                // Here you would typically send the form data
                // For now, we'll just print it
                print('Form submitted: ${formData.name}, ${formData.email}');

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message sent successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor:const Color(0xFF172A45),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Send Message',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white
            ),),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTextField({
  required String label,
  required Function(String?) onSaved,
  required String? Function(String?) validator,
  int maxLines = 1,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      filled: true,
      fillColor: const Color(0xFF0A192F),
    ),
    style: const TextStyle(color: Colors.white),
    maxLines: maxLines,
    onSaved: onSaved,
    validator: validator,
  );
}

Widget _buildSocialLinks() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildSocialButton(
        icon: Icons.link,
        label: 'LinkedIn',
        onPressed: () => launchUrl(Uri.parse("https://www.linkedin.com/in/basavaraj-k-4b808924b?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app")),
      ),
      const SizedBox(width: 16),
      _buildSocialButton(
        icon: Icons.code,
        label: 'GitHub',
        onPressed: () => launchUrl(Uri.parse('https://github.com/skBasavaraj')),
      ),
      const SizedBox(width: 16),
      _buildSocialButton(
        icon: Icons.phone,
        label: 'WhatsApp',
        onPressed: () => launchUrl(Uri.parse('https://wa.me/916361174126')),
      ),
    ],
  );
}

Widget _buildSocialButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF172A45),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget _buildContactInfo() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: const Color(0xFF172A45),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        _buildContactInfoItem(
          icon: Icons.email,
          label: 'Email',
          value: 'basavask963@gmail.com',
          onTap: () => launchUrl(Uri.parse('mailto:basavask963@gmail.com')),
        ),
        const Divider(color: Colors.grey, height: 32),
        _buildContactInfoItem(
          icon: Icons.phone,
          label: 'Phone',
          value: '+91 6361174126                       ',
          onTap: () => launchUrl(Uri.parse('tel:+916361174126')),
        ),
        const Divider(color: Colors.grey, height: 32),
        _buildContactInfoItem(
          icon: Icons.location_on,
          label: 'Location',
          value: 'Bengaluru  Karnataka India ',
          onTap: () {},
        ),
      ],
    ),
  );
}

Widget _buildContactInfoItem({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Divider(
            color: Colors.blue,
            thickness: 1,
          ),
        ),
      ],
    ),
  );
}

class Project {
  final String name;
  final String description;
  final String playStoreUrl;
  final List<String> technologies;

  Project({
    required this.name,
    required this.description,
    required this.playStoreUrl,
    required this.technologies,
  });
}

// Add these widgets to the existing PortfolioHome class

final List<Project> projects = [
  Project(
    name: 'VMS App (Vaps Management System)',
    description: 'Enterprise management system using GetX for state management, Dio for networking, and Firebase Push Notifications. Focused on UI design, API integration, and bug resolution.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.app.vmss',
    technologies: ['Flutter', 'GetX', 'Dio', 'Firebase'],
  ),
  Project(
    name: 'M College (ERP Education App)',
    description: 'Educational ERP system featuring multiple dashboards (Principal, Chairman, Staff) with GetX state management and comprehensive API integration.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.app.mcollege',
    technologies: ['Flutter', 'GetX', 'Firebase', 'Educational ERP'],
  ),
  Project(
    name: 'M Skool (ERP Education App)',
    description: 'Advanced educational management system with multiple user roles and comprehensive dashboard functionality.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.app.mskool',
    technologies: ['Flutter', 'API Integration', 'Firebase'],
  ),
  Project(
    name: 'Best Al-Yousifi (Ecommerce App)',
    description: 'E-commerce platform built with Kotlin featuring MVVM architecture, biometric authentication, QR scanning, and multi-language support.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.best.alyousifi',
    technologies: ['Kotlin', 'MVVM', 'Retrofit', 'Biometric Auth'],
  ),
  Project(
    name: 'File Manager',
    description: 'File system management app enabling P2P file sharing via WiFi between nearby devices.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.cvinfo.filemanager',
    technologies: ['Java', 'P2P WiFi', 'File System API'],
  ),
  Project(
    name: 'SayTrees',
    description: 'Environmental app featuring KML integration, local database synchronization, and offline-online data management capabilities.',
    playStoreUrl: 'https://play.google.com/store/apps/details?id=com.spl.saytrees',
    technologies: ['Flutter', 'KML', 'Local DB Sync', 'Offline Support'],
  ),
];
