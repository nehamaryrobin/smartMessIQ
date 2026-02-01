import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'admin.dart';
import 'preorder_screen.dart';
import 'orders_screen.dart'; // IMPORT THIS!

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MessApp());
}

// ... (MessMenu Data omitted for brevity, it's the same as before)
const Map<String, Map<String, String>> messMenu = {
  "Monday": {
    "Breakfast": "Kal Dosai...",
    "Lunch": "White Rice...",
    "Snacks": "Sambar vadai...",
    "Dinner": "Chapathi...",
  },
  "Tuesday": {
    "Breakfast": "Idly...",
    "Lunch": "White Rice...",
    "Snacks": "Boiled Corn...",
    "Dinner": "Parotta...",
  },
  "Wednesday": {
    "Breakfast": "Pongal...",
    "Lunch": "White Rice...",
    "Snacks": "Samosa...",
    "Dinner": "Kal Dosai...",
  },
  "Thursday": {
    "Breakfast": "Idly...",
    "Lunch": "Brinji Rice...",
    "Snacks": "Boiled Ground nut...",
    "Dinner": "Chapathi...",
  },
  "Friday": {
    "Breakfast": "Rava Uppuma...",
    "Lunch": "White Rice...",
    "Snacks": "Onion Pakoda...",
    "Dinner": "Dosai...",
  },
  "Saturday": {
    "Breakfast": "Poori...",
    "Lunch": "Bisibelebath...",
    "Snacks": "Keera Vadi...",
    "Dinner": "Idiappam...",
  },
  "Sunday": {
    "Breakfast": "Onion Dosai...",
    "Lunch": "Chicken Briyani...",
    "Snacks": "White Channa...",
    "Dinner": "Idly...",
  },
};

class MessApp extends StatelessWidget {
  const MessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mess Mate',
      theme: ThemeData(
        primaryColor: const Color(0xFFFC8019),
        scaffoldBackgroundColor: const Color(0xFFF5F5F6),
        useMaterial3: true,
        fontFamily: 'Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFC8019),
          primary: const Color(0xFFFC8019),
          secondary: const Color(0xFF2B1E16),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool isOwnerMode = false;
  int _rewardPoints = 45;

  final List<Map<String, dynamic>> extraItems = [
    {
      "name": "Boiled Egg",
      "price": 10.0,
      "points": 50,
      "type": "BREAKFAST",
      "image":
          "https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&q=80&w=600",
      "veg": false,
      "prepHour": 7,
      "prepMin": 0,
    },
    {
      "name": "Omelette",
      "price": 25.0,
      "points": 125,
      "type": "BREAKFAST",
      "image":
          "https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&q=80&w=600",
      "veg": false,
      "prepHour": 7,
      "prepMin": 0,
    },
    {
      "name": "Chicken 65",
      "price": 80.0,
      "points": 400,
      "type": "LUNCH",
      "image":
          "https://images.unsplash.com/photo-1626074353765-517a681e40be?auto=format&fit=crop&q=80&w=600",
      "veg": false,
      "prepHour": 11,
      "prepMin": 30,
    },
    {
      "name": "Samosa (2pcs)",
      "price": 20.0,
      "points": 100,
      "type": "SNACKS",
      "image":
          "https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&q=80&w=600",
      "veg": true,
      "prepHour": 16,
      "prepMin": 0,
    },
    {
      "name": "Chicken Gravy",
      "price": 90.0,
      "points": 450,
      "type": "DINNER",
      "image":
          "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?auto=format&fit=crop&q=80&w=600",
      "veg": false,
      "prepHour": 19,
      "prepMin": 30,
    },
  ];

  void _addPoints(int points) => setState(() => _rewardPoints += points);
  void _deductPoints(int points) => setState(() => _rewardPoints -= points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isOwnerMode ? const OwnerDashboard() : _buildStudentDashboard(),
      ),
      floatingActionButton: isOwnerMode ? null : _buildFab(),
    );
  }

  Widget _buildFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => MessCancellationDialog(
                onPointsEarned: (points) {
                  _addPoints(points);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Cancellation Successful! You earned $points Reward Points.",
                      ),
                      backgroundColor: Colors.purple,
                    ),
                  );
                },
              ),
            );
          },
          backgroundColor: const Color(0xFFFC8019),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            "Mess Leave\nRequest",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOwnerMode ? Icons.admin_panel_settings : Icons.navigation,
                color: const Color(0xFFFC8019),
                size: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                "Shiv Nadar University",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          Text(
            isOwnerMode ? "Administrator View" : "Hostel Block 2, Room 304",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      actions: [
        if (!isOwnerMode) ...[
          // NEW: MY ORDERS BUTTON
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
            icon: const Icon(Icons.receipt_long, color: Colors.black87),
            tooltip: "My Orders",
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 8),
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
                  "$_rewardPoints",
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
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              setState(() => isOwnerMode = !isOwnerMode);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isOwnerMode ? "Welcome, Mess Owner" : "Welcome, Student",
                  ),
                  backgroundColor: const Color(0xFF2B1E16),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOwnerMode ? const Color(0xFF2B1E16) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Switch to",
                        style: TextStyle(fontSize: 8, color: Colors.grey[600]),
                      ),
                      Text(
                        isOwnerMode ? "Student" : "Mess Owner",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isOwnerMode
                              ? Colors.white
                              : const Color(0xFFFC8019),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isOwnerMode ? Icons.person : Icons.swap_horiz,
                    size: 18,
                    color: isOwnerMode ? Colors.white : const Color(0xFFFC8019),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDashboard() {
    return SingleChildScrollView(
      key: const ValueKey("StudentDashboard"),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMessBanner(),
          const SizedBox(height: 16),
          _buildPreorderSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // NOTE: Copy _buildMessBanner, _buildFilterButton, _buildCheckboxTile, _showFilterBottomSheet from previous responses here.
  // They have not changed.
  // ...

  Widget _buildMessBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF171A29),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Opacity(
                opacity: 0.8,
                child: Image.network(
                  "https://images.unsplash.com/photo-1559339352-11d035aa65de?auto=format&fit=crop&q=80&w=800",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF171A29),
                  Color(0xFF171A29),
                  Colors.transparent,
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "NEXT MEAL",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        DateFormat(
                          'd MMM y',
                        ).format(DateTime.now()).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "7:30 DINNER",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  width: 220,
                  child: Text(
                    "DOSA, chutney, sambar, milk, tea, salad, boiled egg",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.tune, size: 16, color: Colors.black),
            SizedBox(width: 8),
            Text(
              "Filters",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildPreorderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "ADD EXTRA ITEM TO YOUR PLATE",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: extraItems.length,
            itemBuilder: (context, index) {
              final item = extraItems[index];
              return Row(
                children: [
                  _buildExtraItemCard(item),
                  const SizedBox(width: 16),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExtraItemCard(Map<String, dynamic> item) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item['image'],
                  height: 120,
                  width: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['type'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹ ${item['price'].toInt()}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.stars_rounded,
                      size: 14,
                      color: Colors.purple,
                    ),
                    Text(
                      " ${item['points']}",
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreorderScreen(
                          userPoints: _rewardPoints,
                          onPointsRedeemed: _deductPoints,
                          args: PreorderArguments(
                            mealName: item['name'],
                            mealType: item['type'],
                            imageUrl: item['image'],
                            pricePerUnit: item['price'],
                            pointsPricePerUnit: item['points'],
                            mealStartTime: TimeOfDay(
                              hour: item['prepHour'],
                              minute: item['prepMin'],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFC8019),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Add +",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessCancellationDialog extends StatefulWidget {
  final Function(int) onPointsEarned;
  const MessCancellationDialog({super.key, required this.onPointsEarned});

  @override
  State<MessCancellationDialog> createState() => _MessCancellationDialogState();
}

class _MessCancellationDialogState extends State<MessCancellationDialog> {
  int _selectedMode = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  final Map<String, bool> _mealSelection = {
    "Breakfast": false,
    "Lunch": false,
    "Snacks": false,
    "Dinner": false,
  };
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Mess Cancellation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildModeButton("One Day", 0),
                  _buildModeButton("Bulk Leave", 1),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: _selectedMode == 0
                    ? _buildOneDayView()
                    : _buildBulkView(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      int points = 0;
                      if (_selectedMode == 0) {
                        points =
                            _mealSelection.values.where((e) => e).length * 5;
                      } else if (_selectedDateRange != null) {
                        points = (_selectedDateRange!.duration.inDays + 1) * 20;
                      }
                      widget.onPointsEarned(points);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC8019),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String title, int index) {
    bool isActive = _selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? const Color(0xFFFC8019) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOneDayView() {
    String dayName = DateFormat('EEEE').format(_selectedDate);
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFFFC8019),
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEE, MMM d, y').format(_selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dayName,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Color(0xFFFC8019),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Select Meals to Cancel (+5 pts each):",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 12),
        ..._mealSelection.keys.map((meal) {
          bool isSelected = _mealSelection[meal]!;
          return GestureDetector(
            onTap: () => setState(() => _mealSelection[meal] = !isSelected),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFF0E6) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFC8019)
                      : Colors.grey[200]!,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFFC8019)
                          : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? const Color(0xFFFC8019)
                        : Colors.grey[300],
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBulkView() {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now().add(const Duration(days: 1)),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Color(0xFFFC8019)),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDateRange = picked);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Icon(Icons.date_range, size: 30, color: Color(0xFFFC8019)),
            const SizedBox(height: 8),
            Text(
              _selectedDateRange == null
                  ? "Select Date Range"
                  : "${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
