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

  @override
  void initState() {
    super.initState();
    remainingPoints = widget.points;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B003B),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void showTierInfo(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B003B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Points and Tiers Information ',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.info_outline, color: Colors.purpleAccent, size: 30),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 8),
            Text('For reference; AED1 spent per toll trip = 100 points',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            Text(''),
            Text('Your reward tier is based on your total accumulated points:',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            SizedBox(height: 16),
            BulletPoint(text: 'Bronze: 0 to 500 points'),
            BulletPoint(text: 'Silver: 501 to 1,000 points'),
            BulletPoint(text: 'Gold: 1,001 to 5,000 points'),
            BulletPoint(text: 'Platinum: 5,001 to 10,000 points'),
            BulletPoint(text: 'Diamond: 10,001+ points'),
            SizedBox(height: 20),
            Text('Earn more points to move to higher tiers and unlock better rewards!',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void showCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B003B),
        title: const Text('Your Cart', style: TextStyle(color: Colors.white)),
        content: cart.isEmpty
            ? const Text('No items added.', style: TextStyle(color: Colors.white70))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: cart.map((item) {
                  return ListTile(
                    title: Text(item['title'], style: const TextStyle(color: Colors.white)),
                    trailing: Text('${item['cost']} pts', style: const TextStyle(color: Colors.white54)),
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
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1B003B),
                    title: const Text('Confirm Redemption', style: TextStyle(color: Colors.white)),
                    content: const Text('Are you sure you want to redeem all items in your cart?', style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => cart.clear());
                          Navigator.pop(context);
                        },
                        child: const Text('Redeem', style: TextStyle(color: Colors.greenAccent)),
                      )
                    ],
                  ),
                );
              },
              child: const Text('Redeem All', style: TextStyle(color: Colors.greenAccent)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.deepPurpleAccent)),
          )
        ],
      ),
    );
  }

  Widget rewardCard(String title, int cost, String level, IconData icon) {
    bool canRedeem = remainingPoints >= cost;
    bool isInCart = cart.any((item) => item['title'] == title);

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      ),
      child: GestureDetector(
        onTap: () {
          if (!canRedeem && !isInCart) return;
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
        child: Container(
          decoration: BoxDecoration(
            color: isInCart ? Colors.green.shade700 : const Color(0xFF5A189A),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(2, 3)),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text('$cost pts', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 4),
              Text('Level: $level', style: const TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  isInCart ? 'Remove' : 'Add to Cart',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String tier = 'Bronze';
    Color tierColor = Colors.brown;
    if (remainingPoints >= 200) {
      tier = 'Platinum';
      tierColor = Colors.blueGrey;
    } else if (remainingPoints >= 100) {
      tier = 'Gold';
      tierColor = Colors.amber;
    } else if (remainingPoints >= 50) {
      tier = 'Silver';
      tierColor = Colors.grey;
    }
    double progress = (remainingPoints % 50) / 50;

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome, ${widget.firstName} ${widget.lastName}! 👋',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      onPressed: () => showCart(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: showLogoutConfirmation,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amberAccent, size: 20),
                        const SizedBox(width: 6),
                        const Text('Total Points', style: TextStyle(fontSize: 20, color: Colors.white70)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => showTierInfo(context),
                          child: const Icon(Icons.info_outline, color: Colors.white54, size: 20),
                        )
                      ]),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.purpleAccent,
                        child: Text(
                          '$remainingPoints',
                          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.verified_user, size: 20, color: Colors.white),
                        const SizedBox(width: 6),
                        Text('Tier: $tier', style: TextStyle(color: tierColor, fontSize: 18, fontWeight: FontWeight.w500)),
                      ]),
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
                      Text('${(progress * 50).round()}/50 pts to next tier', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Redeem Rewards', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      rewardCard('Water Bottle', 10, 'Bronze', Icons.local_drink),
                      rewardCard('Coffee', 30, 'Silver', Icons.coffee),
                      rewardCard('Car Wash', 70, 'Silver', Icons.local_car_wash),
                      rewardCard('AED 20 Fuel', 100, 'Gold', Icons.local_gas_station),
                      rewardCard('Gift Voucher', 150, 'Gold', Icons.card_giftcard),
                      rewardCard('AED 50 Fuel', 200, 'Platinum', Icons.ev_station),
                    ],
                  ),
                )
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
          const Text('• ', style: TextStyle(color: Colors.white70, fontSize: 16)),
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
