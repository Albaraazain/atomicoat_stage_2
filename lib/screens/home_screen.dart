import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/status_indicator.dart';
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(
                      'Atomicoat',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    StatusIndicator(status: 'System Idle'),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                delegate: SliverChildListDelegate([
                  _buildActionCard(context, 'System\nControl', CupertinoIcons.slider_horizontal_3, AppRoutes.systemControl),
                  _buildActionCard(context, 'Recipes', CupertinoIcons.book, AppRoutes.recipe),
                  _buildActionCard(context, 'Monitoring', CupertinoIcons.graph_square, AppRoutes.monitoring),
                  _buildActionCard(context, 'Settings', CupertinoIcons.settings, AppRoutes.settings),
                  _buildActionCard(context, 'PLC\nTroubleshooter', CupertinoIcons.wrench_fill, AppRoutes.plcTroubleshooter),
                  _buildActionCard(context, 'PLC\nDiagram', CupertinoIcons.chart_bar_fill, AppRoutes.plcImage),
                  _buildActionCard(context, 'Machine\nStatus Chat', CupertinoIcons.chat_bubble_2_fill, AppRoutes.machineStatusChat),  // Add this line
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}