import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

// ---------------------------------------------------------------------------
// GLOBAL DATA STORAGE (Simple List for Hackathon)
// ---------------------------------------------------------------------------
final List<OrderModel> globalOrders = [];

class OrderModel {
  final String id;
  final String itemName;
  final String imageUrl;
  final double price;
  final bool paidWithPoints;
  final DateTime orderTime;
  bool isRedeemed;

  OrderModel({
    required this.id,
    required this.itemName,
    required this.imageUrl,
    required this.price,
    required this.paidWithPoints,
    required this.orderTime,
    this.isRedeemed = false,
  });
}

// ---------------------------------------------------------------------------
// SCREEN: MY ORDERS LIST
// ---------------------------------------------------------------------------
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    // Sort orders: Newest first
    final sortedOrders = List<OrderModel>.from(globalOrders)
      ..sort((a, b) => b.orderTime.compareTo(a.orderTime));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F6),
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: sortedOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fastfood_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No active orders",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(sortedOrders[index]);
              },
            ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () async {
        // Navigate to QR Ticket Screen and wait for result (redeemed status)
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(order: order),
          ),
        );
        setState(() {}); // Refresh list upon return
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                order.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(order.orderTime),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: order.isRedeemed
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.isRedeemed ? "REDEEMED" : "ACTIVE",
                          style: TextStyle(
                            color: order.isRedeemed
                                ? Colors.green
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        order.paidWithPoints
                            ? "${order.price.toInt()} pts"
                            : "₹${order.price.toInt()}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: order.paidWithPoints
                              ? Colors.purple
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.qr_code, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SCREEN: QR TICKET DETAIL
// ---------------------------------------------------------------------------
class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // Hackathon Trick: Simulate scanning by clicking the QR code
  void _simulateScan() {
    if (widget.order.isRedeemed) return;

    setState(() {
      widget.order.isRedeemed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("QR Verified! Meal Redeemed."),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF171A29,
      ), // Dark background for ticket pop
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ORDER TICKET",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "#${widget.order.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Color(0xFFFC8019),
                    ),
                  ),
                ],
              ),
              const Divider(height: 40),

              // Item Info
              Text(
                widget.order.itemName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2B1E16),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.order.isRedeemed
                    ? "Enjoy your meal!"
                    : "Show this QR to the counter",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),

              const SizedBox(height: 32),

              // QR Code Area (Simulated)
              GestureDetector(
                onLongPress: _simulateScan, // Secret developer shortcut
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: widget.order.isRedeemed
                        ? Colors.green[50]
                        : Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: widget.order.isRedeemed
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 60,
                                color: Colors.green,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "REDEEMED",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          // Simple Mock QR visual using Icons
                          child: Icon(
                            Icons.qr_code_2,
                            size: 160,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Hackathon "Simulate Scan" Button
              if (!widget.order.isRedeemed)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _simulateScan,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text("Simulate QR Scan (Admin)"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
