import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

/// A custom timeline widget that displays dates and allows date selection
/// Uses the easy_date_timeline package for the core functionality
class TimeLineView extends StatelessWidget {
  /// Currently selected date in the timeline
  final DateTime selectedDate;

  /// Callback function triggered when a new date is selected
  final void Function(DateTime) onSelectedDateChange;

  const TimeLineView({
    super.key,
    required this.selectedDate,
    required this.onSelectedDateChange
  });

  @override
  Widget build(BuildContext context) {
    // Access the app's color scheme for consistent styling
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: EasyDateTimeLine(
        // Configure initial date and selection callback
        initialDate: selectedDate,
        onDateChange: onSelectedDateChange,

        // Header configuration
        headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.dropDown,
            showHeader: false,  // Hide the default header
            showSelectedDate: true  // Show currently selected date
        ),

        // Day item styling configuration
        dayProps: EasyDayProps(
          // Configure how each day is displayed
          dayStructure: DayStructure.dayNumDayStr,  // Shows day number and name

          // Styling for the selected/active day
          activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                  )
              ),
              // Text style for the day name when selected
              dayStrStyle: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
              // Text style for the day number when selected
              dayNumStyle: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              )
          ),

          // Styling for non-selected/inactive days
          inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surface,
                  border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1
                  )
              ),
              // Text style for inactive day name
              dayStrStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15
              ),
              // Text style for inactive day number
              dayNumStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 15
              )
          ),

          // Today's date highlight configuration
          todayHighlightStyle: TodayHighlightStyle.withBackground,
          todayHighlightColor: colorScheme.primaryContainer.withOpacity(0.3),
        ),

        // Timeline layout configuration
        timeLineProps: const EasyTimeLineProps(
            separatorPadding: 16  // Space between day items
        ),
      ),
    );
  }
}