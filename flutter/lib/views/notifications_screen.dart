import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Настройки уведомлений
  bool pushNotifications = true;
  bool serviceUpdates = true;
  bool newServices = false;
  bool promotions = true;
  bool systemUpdates = false;
  bool emailNotifications = true;
  bool smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 5,
        title: const Text(
          '🔔 Bildirishnomalar',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bildirishnoma sozlamalari',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Qaysi bildirishnomalarni olishni xohlaysiz?',
                    style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Push уведомления
            _buildSectionTitle('Push bildirishnomalar'),
            const SizedBox(height: 12),

            _buildNotificationTile(
              title: 'Push bildirishnomalar',
              subtitle: 'Barcha push bildirishnomalarni yoqish/o\'chirish',
              value: pushNotifications,
              onChanged: (value) {
                setState(() {
                  pushNotifications = value;
                  if (!value) {
                    // Если отключаем push, отключаем все связанные
                    serviceUpdates = false;
                    newServices = false;
                    promotions = false;
                    systemUpdates = false;
                  }
                });
                _showNotificationChange('Push bildirishnomalar', value);
              },
              icon: Icons.notifications_active,
              iconColor: Colors.orange,
            ),

            AnimatedOpacity(
              opacity: pushNotifications ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildNotificationTile(
                    title: 'Xizmat yangilanishlari',
                    subtitle: 'Sevimli xizmatlaringizdagi o\'zgarishlar haqida',
                    value: serviceUpdates && pushNotifications,
                    onChanged: pushNotifications
                        ? (value) {
                            setState(() {
                              serviceUpdates = value;
                            });
                            _showNotificationChange(
                              'Xizmat yangilanishlari',
                              value,
                            );
                          }
                        : null,
                    icon: Icons.update,
                    iconColor: Colors.blue,
                    isIndented: true,
                  ),

                  const SizedBox(height: 8),
                  _buildNotificationTile(
                    title: 'Yangi xizmatlar',
                    subtitle: 'Yangi qo\'shilgan xizmatlar haqida ma\'lumot',
                    value: newServices && pushNotifications,
                    onChanged: pushNotifications
                        ? (value) {
                            setState(() {
                              newServices = value;
                            });
                            _showNotificationChange('Yangi xizmatlar', value);
                          }
                        : null,
                    icon: Icons.new_releases,
                    iconColor: Colors.green,
                    isIndented: true,
                  ),

                  const SizedBox(height: 8),
                  _buildNotificationTile(
                    title: 'Aksiyalar va chegirmalar',
                    subtitle: 'Maxsus takliflar va chegirmalar haqida',
                    value: promotions && pushNotifications,
                    onChanged: pushNotifications
                        ? (value) {
                            setState(() {
                              promotions = value;
                            });
                            _showNotificationChange('Aksiyalar', value);
                          }
                        : null,
                    icon: Icons.local_offer,
                    iconColor: Colors.red,
                    isIndented: true,
                  ),

                  const SizedBox(height: 8),
                  _buildNotificationTile(
                    title: 'Tizim yangilanishlari',
                    subtitle: 'Ilova yangilanishlari va texnik xabarlar',
                    value: systemUpdates && pushNotifications,
                    onChanged: pushNotifications
                        ? (value) {
                            setState(() {
                              systemUpdates = value;
                            });
                            _showNotificationChange(
                              'Tizim yangilanishlari',
                              value,
                            );
                          }
                        : null,
                    icon: Icons.system_update,
                    iconColor: Colors.purple,
                    isIndented: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Другие типы уведомлений
            _buildSectionTitle('Boshqa bildirishnom turlari'),
            const SizedBox(height: 12),

            _buildNotificationTile(
              title: 'Email bildirishnomalar',
              subtitle: 'Muhim xabarlarni emailga yuborish',
              value: emailNotifications,
              onChanged: (value) {
                setState(() {
                  emailNotifications = value;
                });
                _showNotificationChange('Email bildirishnomalar', value);
              },
              icon: Icons.email,
              iconColor: Colors.indigo,
            ),

            const SizedBox(height: 8),
            _buildNotificationTile(
              title: 'SMS bildirishnomalar',
              subtitle: 'Juda muhim xabarlarni SMS orqali yuborish',
              value: smsNotifications,
              onChanged: (value) {
                setState(() {
                  smsNotifications = value;
                });
                _showNotificationChange('SMS bildirishnomalar', value);
              },
              icon: Icons.sms,
              iconColor: Colors.teal,
            ),

            const SizedBox(height: 32),

            // Время доставки
            _buildSectionTitle('Yetkazib berish vaqti'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.orange),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Sokin vaqt',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '22:00 - 08:00',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bu vaqt oralig\'ida faqat juda muhim bildirishnomalar yuboriladi',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Кнопка тестирования
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showTestNotification();
                },
                icon: const Icon(Icons.notifications_outlined),
                label: const Text('Test bildirishnoma yuborish'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
    required IconData icon,
    required Color iconColor,
    bool isIndented = false,
  }) {
    return Container(
      margin: EdgeInsets.only(left: isIndented ? 16 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: onChanged == null
                        ? Colors.grey.shade400
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: onChanged == null
                        ? Colors.grey.shade300
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.teal),
        ],
      ),
    );
  }

  void _showNotificationChange(String type, bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type ${enabled ? "yoqildi" : "o\'chirildi"}'),
        backgroundColor: enabled ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showTestNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.notifications, color: Colors.teal),
              SizedBox(width: 8),
              Text('Test bildirishnoma'),
            ],
          ),
          content: const Text(
            'Bu test bildirishnomasi! Agar buni ko\'rayotgan bo\'lsangiz, bildirishnomalar to\'g\'ri ishlayapti. 🎉',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  }
}
