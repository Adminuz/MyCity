import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'uz'; // По умолчанию узбекский

  final List<Map<String, dynamic>> languages = [
    {
      'code': 'uz',
      'name': 'O\'zbekcha',
      'flag': '🇺🇿',
      'subtitle': 'Asosiy til',
    },
    {
      'code': 'ru',
      'name': 'Русский',
      'flag': '🇷🇺',
      'subtitle': 'Основной язык',
    },
    {
      'code': 'en',
      'name': 'English',
      'flag': '🇺🇸',
      'subtitle': 'Primary language',
    },
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷', 'subtitle': 'Ana dil'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 5,
        title: const Text(
          '🌐 Til / Language',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.teal.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ilova tili',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ilovaning barcha matnlari tanlangan tilda ko\'rsatiladi.',
                    style: TextStyle(fontSize: 14, color: Colors.teal.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Mavjud tillar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),

            // Languages list
            Expanded(
              child: ListView.separated(
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = selectedLanguage == language['code'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = language['code'];
                      });

                      // Показываем подтверждение
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Til o\'zgartirildi: ${language['name']}',
                          ),
                          backgroundColor: Colors.teal,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.teal
                              : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Flag
                          Text(
                            language['flag'],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 16),

                          // Language info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.teal.shade700
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  language['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.teal.shade600
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Selected indicator
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          else
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Apply button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Применяем изменения
                  final selectedLang = languages.firstWhere(
                    (lang) => lang['code'] == selectedLanguage,
                  );

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Til o\'zgartirildi'),
                        content: Text(
                          'Ilova tili ${selectedLang['name']} ga o\'zgartirildi. O\'zgarishlar keyingi ishga tushirishda ko\'rinadi.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Qo\'llash',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
