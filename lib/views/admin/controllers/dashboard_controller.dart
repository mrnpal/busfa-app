import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt totalAlumni = 0.obs;
  RxInt verifiedAlumni = 0.obs;
  RxInt activeJobs = 0.obs;

  RxMap<String, int> jobDistribution =
      {'IT': 30, 'Finance': 20, 'Education': 15, 'Other': 10}.obs;

  RxMap<String, int> alumniPerYear =
      {'2018': 20, '2019': 25, '2020': 30, '2021': 35, '2022': 40}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() {
    // Simulasi fetch data
    totalAlumni.value = 120;
    verifiedAlumni.value = 100;
    activeJobs.value = 12;
  }
}
