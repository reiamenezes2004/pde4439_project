import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toll_smart_rewards/main.dart'; // for LoginScreen

class Dashboard extends StatefulWidget {
  final String username;
  final int points;
  final String firstName;
  final String lastName;

  const Dashboard({
    super.key,
    required this.username,
    required this.points,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<Map<String, dynamic>> cart = [];
  late int remainingPoints;
  String selectedTier = 'All';
  List<Map<String, dynamic>> allRewards = [];

  @override
  void initState() {
    super.initState();
    remainingPoints = widget.points;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    allRewards = [
      {
        'title': 'Water Bottle',
        'cost': 10,
        'level': 'Bronze',
        'icon': Icons.local_drink,
      },
      {'title': 'Coffee', 'cost': 30, 'level': 'Silver', 'icon': Icons.coffee},
      {
        'title': 'Car Wash',
        'cost': 70,
        'level': 'Silver',
        'icon': Icons.local_car_wash,
      },
      {
        'title': 'AED 20 Fuel',
        'cost': 100,
        'level': 'Gold',
        'icon': Icons.local_gas_station,
      },
      {
        'title': 'Gift Voucher',
        'cost': 150,
        'level': 'Gold',
        'icon': Icons.card_giftcard,
      },
      {
        'title': 'AED 50 Fuel',
        'cost': 200,
        'level': 'Platinum',
        'icon': Icons.ev_station,
      },
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1B003B),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }

  void showTierInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1B003B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Points and Tiers Information ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.info_outline, color: Colors.purpleAccent, size: 30),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                Text(
                  'For reference; AED1 spent per toll trip = 100 points',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(''),
                Text(
                  'Your reward tier is based on your total accumulated points:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 16),
                BulletPoint(text: 'Bronze: 0 to 500 points'),
                BulletPoint(text: 'Silver: 501 to 1,000 points'),
                BulletPoint(text: 'Gold: 1,001 to 5,000 points'),
                BulletPoint(text: 'Platinum: 5,001 to 10,000 points'),
                BulletPoint(text: 'Diamond: 10,001+ points'),
                SizedBox(height: 20),
                Text(
                  'Earn more points to move to higher tiers and unlock better rewards!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void showCart(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1B003B),
            title: const Text(
              'Your Cart',
              style: TextStyle(color: Colors.white),
            ),
            content:
                cart.isEmpty
                    ? const Text(
                      'No items added.',
                      style: TextStyle(color: Colors.white70),
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          cart.map((item) {
                            return ListTile(
                              title: Text(
                                item['title'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                '${item['cost']} pts',
                                style: const TextStyle(color: Colors.white54),
                              ),
                            );
                          }).toList(),
                    ),
            actions: [
              if (cart.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: const Color(0xFF1B003B),
                            title: const Text(
                              'Confirm Redemption',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to redeem all items in your cart?',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => cart.clear());
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Redeem',
                                  style: TextStyle(color: Colors.greenAccent),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  child: const Text(
                    'Redeem All',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ],
          ),
    );
  }

  String getTier(int points) {
    if (points >= 10000) return 'Diamond';
    if (points >= 5001) return 'Platinum';
    if (points >= 1001) return 'Gold';
    if (points >= 501) return 'Silver';
    return 'Bronze';
  }

  int tierLevelToInt(String tier) {
    switch (tier) {
      case 'Bronze':
        return 1;
      case 'Silver':
        return 2;
      case 'Gold':
        return 3;
      case 'Platinum':
        return 4;
      case 'Diamond':
        return 5;
      default:
        return 0;
    }
  }

  List<Map<String, dynamic>> getFilteredRewards() {
    if (selectedTier == 'All') return allRewards;
    return allRewards
        .where((reward) => reward['level'] == selectedTier)
        .toList();
  }

  Widget rewardCard(Map<String, dynamic> reward) {
    String title = reward['title'];
    int cost = reward['cost'];
    String level = reward['level'];
    IconData icon = reward['icon'];
    bool canRedeem = remainingPoints >= cost;
    bool isInCart = cart.any((item) => item['title'] == title);
    bool isUnlocked =
        tierLevelToInt(getTier(widget.points)) >= tierLevelToInt(level);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      ),
      child: GestureDetector(
        onTap: () {
          if (!canRedeem || !isUnlocked) return;
          setState(() {
            if (isInCart) {
              cart.removeWhere((item) => item['title'] == title);
              remainingPoints += cost;
            } else {
              cart.add({'title': title, 'cost': cost});
              remainingPoints -= cost;
            }
          });
        },
        child: Opacity(
          opacity: isUnlocked ? 1.0 : 0.4,
          child: Container(
            decoration: BoxDecoration(
              color: isInCart ? Colors.green.shade700 : const Color(0xFF5A189A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$cost pts',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level: $level',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isInCart ? 'Remove' : 'Add to Cart',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getNextTierMessage(int points) {
    final tiers = [
      {'tier': 'Silver', 'min': 501},
      {'tier': 'Gold', 'min': 1001},
      {'tier': 'Platinum', 'min': 5001},
      {'tier': 'Diamond', 'min': 10001},
    ];

    for (var t in tiers) {
      final min = t['min'] as int;
      final tierName = t['tier'] as String;
      if (points < min) {
        final needed = min - points;
        return 'You need $needed points to reach $tierName Tier';
      }
    }
    return 'You are in the highest tier: Diamond';
  }

  @override
  Widget build(BuildContext context) {
    String tier = getTier(widget.points);
    Color tierColor =
        {
          'Bronze': Colors.brown,
          'Silver': Colors.grey,
          'Gold': Colors.amber,
          'Platinum': Colors.blueGrey,
          'Diamond': Colors.purple,
        }[tier]!;
    double progress = (remainingPoints % 500) / 500;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF240046), Color(0xFF3C096C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Welcome, ${widget.firstName} ${widget.lastName}! 👋',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () => showCart(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: showLogoutConfirmation,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5F33A7), Color(0xFF3F0071)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amberAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Total Points',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => showTierInfo(context),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white54,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.purpleAccent,
                        child: Text(
                          '$remainingPoints',
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Tier: $tier',
                            style: TextStyle(
                              color: tierColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          color: tierColor,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$remainingPoints/500 pts to next tier',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Filter:',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      dropdownColor: const Color(0xFF3C096C),
                      value: selectedTier,
                      style: const TextStyle(color: Colors.white),
                      items:
                          ['All', 'Bronze', 'Silver', 'Gold', 'Platinum']
                              .map(
                                (tier) => DropdownMenuItem(
                                  value: tier,
                                  child: Text(tier),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => selectedTier = value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children:
                        getFilteredRewards()
                            .map((reward) => rewardCard(reward))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
