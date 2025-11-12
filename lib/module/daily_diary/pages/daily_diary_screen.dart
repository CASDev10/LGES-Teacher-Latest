import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/components/custom_textfield.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/delete_diary/delete_diary_state.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/diary_list_cubit/diary_list_cubit.dart';
import 'package:lges_teacher_app/module/daily_diary/pages/add_daily_diary_screen.dart';
import 'package:lges_teacher_app/module/daily_diary/pages/delete_diary_input.dart';
import 'package:lges_teacher_app/utils/custom_date_time_picker.dart';
import 'package:lges_teacher_app/utils/display/display_utils.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/loading_indicator.dart';
import '../../../constants/keys.dart';
import '../../../core/di/service_locator.dart';
import '../../home/repo/home_repo.dart';
import '../cubit/delete_diary/delete_diary_cubit.dart';
import '../cubit/diary_list_cubit/diary_list_state.dart';
import '../widgets/diary_card_widget.dart';

class DailyDiaryScreen extends StatelessWidget {
  const DailyDiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DiaryListCubit(sl())),
        BlocProvider(create: (context) => DeleteDiaryCubit(sl())),
      ],
      child: DailyDiaryScreenView(),
    );
  }
}

class DailyDiaryScreenView extends StatefulWidget {
  @override
  State<DailyDiaryScreenView> createState() => _DailyDiaryScreenViewState();
}

class _DailyDiaryScreenViewState extends State<DailyDiaryScreenView> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  AuthRepository _authRepository = sl<AuthRepository>();
  List<String> userPrivileges = [];
  HomeRepository homeRepository = sl<HomeRepository>();

  @override
  void initState() {
    super.initState();
    if (_authRepository.user.userPrivileges?.isNotEmpty == true) {
      userPrivileges = _authRepository.user.userPrivileges.toString().split(
        ',',
      );
    }
    _fetchAllDiaries();
  }

  void _gotoAddDiary() {
    if (userPrivileges.isNotEmpty) {
      bool exists = false;
      for (var i = 0; i < userPrivileges.length; i++) {
        if (userPrivileges[i].toInt() == StorageKeys.addDiaryId) {
          exists = true;
          break;
        } else {
          exists = false;
        }
      }
      if (exists) {
        NavRouter.push(context, AddDailyDiaryScreen()).then((value) {
          _fetchAllDiaries();
        });
      } else {
        Fluttertoast.showToast(msg: "You are not allowed to add diary!");
      }
    } else {
      Fluttertoast.showToast(msg: "You are not allowed to add diary!");
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Header Row
                Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_rounded,
                      color: AppColors.primaryDark,
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Filter Diary Entries",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔸 From Date
                CustomTextField(
                  hintText: 'From Date',
                  height: 50,
                  inputType: TextInputType.text,
                  fillColor: AppColors.lightGreyColor,
                  hintColor: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                  readOnly: true,
                  fontSize: 16,
                  suffixWidget: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primaryDark,
                  ),
                  onTap: () async {
                    fromDateController.text =
                        await CustomDateTimePicker.selectDiaryDate(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000, 01, 01),
                        );
                  },
                  controller: fromDateController,
                ),

                const SizedBox(height: 12),

                // 🔸 To Date
                CustomTextField(
                  hintText: 'To Date',
                  height: 50,
                  inputType: TextInputType.text,
                  fillColor: AppColors.lightGreyColor,
                  hintColor: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                  readOnly: true,
                  fontSize: 16,
                  suffixWidget: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primaryDark,
                  ),
                  onTap: () async {
                    toDateController.text =
                        await CustomDateTimePicker.selectDiaryDate(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000, 01, 01),
                        );
                  },
                  controller: toDateController,
                ),

                const SizedBox(height: 22),

                // 🔘 Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          fromDateController.clear();
                          toDateController.clear();
                          NavRouter.pop(context);
                          _fetchAllDiaries();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _applyFilter();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Show",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyFilter() {
    final fromDateString = fromDateController.text.trim();
    final toDateString = toDateController.text.trim();

    if (fromDateString.isEmpty || toDateString.isEmpty) {
      Fluttertoast.showToast(msg: "Please select both dates!");
      return;
    }
    DateTime fromDate = DateFormat("dd/MM/yyyy").parse(fromDateController.text);
    DateTime toDate = DateFormat("dd/MM/yyyy").parse(toDateController.text);
    context.read<DiaryListCubit>().fetchDiaryList(
      DateFormat("yyyy-MM-dd").format(fromDate),
      DateFormat("yyyy-MM-dd").format(toDate),
    );
  }

  void _fetchAllDiaries() {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, 1, 1);
    final toDate = DateTime(now.year, 12, 31);

    context.read<DiaryListCubit>().fetchDiaryList(
      DateFormat("yyyy-MM-dd").format(fromDate),
      DateFormat("yyyy-MM-dd").format(toDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar(
        'Diary Work',
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              _showFilterDialog(context);
            },
            child: Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Icon(
                Icons.filter_alt_outlined,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<DeleteDiaryCubit, DeleteDiaryState>(
        listener: (context, deleteState) {
          if (deleteState.deleteDiaryStatus == DeleteDiaryStatus.loading) {
            DisplayUtils.showLoader();
          }
          if (deleteState.deleteDiaryStatus == DeleteDiaryStatus.failure) {
            DisplayUtils.removeLoader();
            DisplayUtils.showSnackBar(context, deleteState.failure.message);
          }
          if (deleteState.deleteDiaryStatus == DeleteDiaryStatus.success) {
            DisplayUtils.removeLoader();
            DisplayUtils.showToast(context, 'Diary deleted successfully!');
            _fetchAllDiaries();
          }
        },
        builder: (context, deleteState) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20) +
                const EdgeInsets.symmetric(vertical: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<DiaryListCubit, DiaryListState>(
                      builder: (context, state) {
                        if (state.diaryListStatus == DiaryListStatus.loading) {
                          return Center(child: LoadingIndicator());
                        }
                        if (state.diaryListStatus == DiaryListStatus.success) {
                          return ListView.builder(
                            itemCount: state.diaryList.length,
                            itemBuilder: (context, index) {
                              return DiaryCard(
                                diary: state.diaryList[index],
                                onTap: () {
                                  NavRouter.push(
                                    context,
                                    AddDailyDiaryScreen(
                                      diary: state.diaryList[index],
                                    ),
                                  ).then((value) {
                                    _fetchAllDiaries();
                                  });
                                },
                                onDelete: () {
                                  showDeleteConfirmationDialog(
                                    context,
                                    onConfirm: () {
                                      DeleteDiaryInput input = DeleteDiaryInput(
                                        diaryId: state.diaryList[index].diaryId,
                                        ucSchoolId: _authRepository
                                            .user
                                            .schoolId
                                            .toString(),
                                        ucLoginUserId: _authRepository
                                            .user
                                            .userId
                                            .toString(),
                                      );
                                      context
                                          .read<DeleteDiaryCubit>()
                                          .deleteDiary(input);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                        if (state.diaryListStatus == DiaryListStatus.failure) {
                          return Center(child: Text(state.failure.message));
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    height: 50,
                    borderRadius: 15,
                    onPressed: () {
                      _gotoAddDiary();
                    },
                    title: 'Add Diary Work',
                    isEnabled: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: AppColors.primaryDark,
      hMargin: 0,
    );
  }
}

Future<void> showDeleteConfirmationDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🗑️ Icon
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              // 🔸 Title
              const Text(
                "Delete Diary Entry?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // 📝 Subtitle
              const Text(
                "Are you sure you want to delete this diary entry?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              // 🔘 Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
