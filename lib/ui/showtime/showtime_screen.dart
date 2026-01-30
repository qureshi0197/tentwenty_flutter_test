import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';

class ShowtimeScreen extends StatefulWidget {
  final String movieTitle;
  final String releaseDate;

  const ShowtimeScreen({super.key, required this.movieTitle, required this.releaseDate});

  @override
  State<ShowtimeScreen> createState() => _ShowtimeScreenState();
}

class _ShowtimeScreenState extends State<ShowtimeScreen> {
  int _selectedHallIndex = 0;
  int _selectedDateIndex = 0;
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, y').format(DateTime.parse(widget.releaseDate));

    final dates = List.generate(10, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('dd MMM').format(date);
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: Column(
          children: [
            Text(widget.movieTitle, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            Text('In Theaters $formattedDate', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),

            // DATE HEADING
            const Text('Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            // DATE LIST
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: index == _selectedDateIndex ? AppColors.accentBlue : AppColors.divider,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        dates[index],
                        style: TextStyle(
                          color: index == _selectedDateIndex ? AppColors.background : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // HALL LIST
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,

                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedHallIndex;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hall info
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '10:30  ',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                              ),

                              TextSpan(
                                text: 'Cinetech + Hall 1',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Seat image placeholder
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedHallIndex = index;
                            });
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors
                                          .accentBlue // selected
                                    : AppColors.divider, // unselected
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text('Seat Layout Image', style: TextStyle(color: Colors.black54)),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Price
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'From ',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.secondaryText),
                              ),
                              TextSpan(
                                text: '50\$ ',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                              TextSpan(
                                text: 'or ',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.secondaryText),
                              ),
                              TextSpan(
                                text: '2500 bonus',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // BOTTOM BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: const Text('Select Seats', style: TextStyle(fontSize: 16, color: AppColors.background)),
          ),
        ),
      ),
    );
  }
}
