import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'orders_screen.dart'; // IMPORT THIS!

class PreorderArguments {
  final String mealName;
  final String mealType;
  final String imageUrl;
  final double pricePerUnit;
  final int pointsPricePerUnit;
  final TimeOfDay mealStartTime;

  PreorderArguments({
    required this.mealName,
    required this.mealType,
    required this.imageUrl,
    required this.pricePerUnit,
    required this.pointsPricePerUnit,
    required this.mealStartTime,
  });
}

class PreorderScreen extends StatefulWidget {
  final PreorderArguments args;
  final int userPoints;
  final Function(int) onPointsRedeemed;

  const PreorderScreen({
    super.key,
    required this.args,
    required this.userPoints,
    required this.onPointsRedeemed,
  });

  @override
  State<PreorderScreen> createState() => _PreorderScreenState();
}

class _PreorderScreenState extends State<PreorderScreen> {
  int _quantity = 1;
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  late DateTime _bookingDeadline;
  bool _isBookingOpen = true;

  final Color _swiggyOrange = const Color(0xFFFC8019);
  final Color _paleBlueBg = const Color(0xFFCBEFF9);

  @override
  void initState() {
    super.initState();
    _calculateBookingDeadline();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateBookingDeadline() {
    final now = DateTime.now();
    DateTime mealStart = DateTime(
      now.year,
      now.month,
      now.day,
      widget.args.mealStartTime.hour,
      widget.args.mealStartTime.minute,
    );
    _bookingDeadline = mealStart.subtract(const Duration(hours: 3));
    _updateTimeRemaining();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final difference = _bookingDeadline.difference(now);

    setState(() {
      if (difference.isNegative) {
        _timeRemaining = Duration.zero;
        _isBookingOpen = false;
        _timer?.cancel();
      } else {
        _timeRemaining = difference;
        _isBookingOpen = true;
      }
    });
  }

  String get _formattedTimerString {
    if (!_isBookingOpen) return "Booking Closed";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_timeRemaining.inHours);
    final minutes = twoDigits(_timeRemaining.inMinutes.remainder(60));
    final seconds = twoDigits(_timeRemaining.inSeconds.remainder(60));
    return "Book within $hours:$minutes:$seconds";
  }

  double get _totalPrice => _quantity * widget.args.pricePerUnit;
  int get _totalPointsCost => _quantity * widget.args.pointsPricePerUnit;

  void _incrementQuantity() {
    if (_isBookingOpen) setState(() => _quantity++);
  }

  void _decrementQuantity() {
    if (_quantity > 1 && _isBookingOpen) setState(() => _quantity--);
  }

  void _clearCart() {
    setState(() => _quantity = 0);
  }

  // HELPER TO SAVE ORDER
  void _saveOrder({required bool isPoints}) {
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString().substring(8),
      itemName: "${widget.args.mealName} x$_quantity",
      imageUrl: widget.args.imageUrl,
      price: isPoints
          ? (_quantity * widget.args.pointsPricePerUnit).toDouble()
          : (_quantity * widget.args.pricePerUnit),
      paidWithPoints: isPoints,
      orderTime: DateTime.now(),
    );
    globalOrders.add(newOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.args.mealType,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple[100]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.purple, size: 16),
                const SizedBox(width: 4),
                Text(
                  "${widget.userPoints} pts",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          Widget leftSection = _buildLeftImageSection(
            constraints.maxWidth,
            isWideScreen,
          );
          Widget rightSection = _buildRightCartSection();

          if (isWideScreen) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: leftSection),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: rightSection),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  leftSection,
                  const SizedBox(height: 24),
                  rightSection,
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLeftImageSection(double maxWidth, bool isWideScreen) {
    double imageHeight = isWideScreen ? (maxWidth * 0.4 * 1.2) : 320;
    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _paleBlueBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _paleBlueBg.withOpacity(0.3),
                BlendMode.srcOver,
              ),
              child: Image.network(
                widget.args.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: SizedBox(
              width: 200,
              child: Text(
                widget.args.mealName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: Colors.black87,
                  height: 1.1,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: _isBookingOpen ? _swiggyOrange : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formattedTimerString,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _isBookingOpen ? Colors.black87 : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightCartSection() {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    bool canPayWithPoints = widget.userPoints >= _totalPointsCost;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          const Text(
            "CUSTOMIZE YOUR PLATE",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${currencyFormat.format(widget.args.pricePerUnit)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("or", style: TextStyle(color: Colors.grey)),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.purple,
                    size: 18,
                  ),
                  Text(
                    " ${widget.args.pointsPricePerUnit}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(
                " / plate",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuantityIconButton(
                Icons.remove,
                _isBookingOpen ? _decrementQuantity : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '$_quantity',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _isBookingOpen ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              _buildQuantityIconButton(
                Icons.add,
                _isBookingOpen ? _incrementQuantity : null,
              ),
            ],
          ),
          if (!_isBookingOpen)
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "Booking has closed for this meal.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 24),
          if (_isBookingOpen && _quantity > 0) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveOrder(isPoints: false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Paid ${currencyFormat.format(_totalPrice)} via Cash. Order Saved!",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _swiggyOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Pay ${currencyFormat.format(_totalPrice)} (Cash)",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canPayWithPoints
                    ? () {
                        _saveOrder(isPoints: true);
                        widget.onPointsRedeemed(_totalPointsCost);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Redeemed $_totalPointsCost Points! Order Saved!",
                            ),
                            backgroundColor: Colors.purple,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.purple.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Pay $_totalPointsCost Points",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!canPayWithPoints)
                      const Text(
                        " (Insufficient)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantityIconButton(IconData icon, VoidCallback? onPressed) {
    bool isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled ? Colors.grey[200]! : Colors.grey[300]!,
          ),
          color: isDisabled ? Colors.grey[100] : Colors.white,
        ),
        child: Icon(icon, color: isDisabled ? Colors.grey : Colors.black),
      ),
    );
  }
}
