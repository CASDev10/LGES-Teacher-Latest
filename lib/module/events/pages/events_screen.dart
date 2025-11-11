import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/repo/auth_repository.dart';
import '../cubits/get_events/get_events_cubit.dart';
import '../cubits/get_events/get_events_state.dart';
import '../models/get_events_input.dart';
import '../repo/event_card.dart';
import 'add_event_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetEventsCubit(sl()),
      child: const EventsScreenView(),
    );
  }
}

class EventsScreenView extends StatefulWidget {
  const EventsScreenView({super.key});

  @override
  State<EventsScreenView> createState() => _EventsScreenViewState();
}

class _EventsScreenViewState extends State<EventsScreenView> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  AuthRepository authRepository = sl<AuthRepository>();

  final List<String> _monthNames = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    final input = GetEventsInput(
      ucLoginUserId: authRepository.user.userId,
      ucEntityId: authRepository.user.entityId,
      month: _selectedMonth,
      year: _selectedYear,
      schoolIdFk: authRepository.user.schoolId,
    );
    context.read<GetEventsCubit>().fetchEvents(input);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      hMargin: 0,
      backgroundColor: AppColors.primaryDark,
      appBar: CustomAppbar("Events Calendar", centerTitle: true),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            // Month & Year Filter Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _monthNames[_selectedMonth - 1],
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primaryDark,
                        ),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                        items: _monthNames
                            .map(
                              (month) => DropdownMenuItem<String>(
                                value: month,
                                child: Text(month),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final monthIndex = _monthNames.indexOf(val) + 1;
                            setState(() => _selectedMonth = monthIndex);
                            _fetchEvents();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedYear,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primaryDark,
                        ),
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w500,
                        ),
                        // ✅ Years from 2000 to current year
                        items:
                            List.generate(
                                  DateTime.now().year - 1999,
                                  (index) => 2000 + index,
                                )
                                .map(
                                  (year) => DropdownMenuItem<int>(
                                    value: year,
                                    child: Text(year.toString()),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedYear = val);
                            _fetchEvents();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Events List
            Expanded(
              child: BlocBuilder<GetEventsCubit, GetEventsState>(
                builder: (context, state) {
                  if (state.status == GetEventsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == GetEventsStatus.failure) {
                    return Center(
                      child: Text(
                        state.failure.message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  } else if (state.status == GetEventsStatus.success &&
                      state.events.isNotEmpty) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: state.events.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        return EventCard(event: event);
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No Events Found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Add Event Button
            CustomButton(
              title: "Add Event",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEventScreen()),
                );
                if (result == true) _fetchEvents();
              },
            ),
          ],
        ),
      ),
    );
  }
}
