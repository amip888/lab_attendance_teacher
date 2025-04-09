import 'package:bloc/bloc.dart';
import 'package:lab_attendance_mobile_teacher/modules/schedule/model/schedule_model/schedule_model.dart';
import 'package:lab_attendance_mobile_teacher/services/api/api_service.dart';
import 'package:lab_attendance_mobile_teacher/services/api/batch_api.dart';
import 'package:lab_attendance_mobile_teacher/services/response_data/response_data.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BatchApi _api;

  ScheduleBloc({BatchApi? api})
      : _api = api ?? BatchApi(),
        super(ScheduleInitial()) {
    on<GetScheduleEvent>(_onGetSchedule);
  }

  void _onGetSchedule(
      GetScheduleEvent event, Emitter<ScheduleState> emit) async {
    emit(GetScheduleLoadingState());
    try {
      final data = await _api.getSchedules();
      ResponseData responseData = ResponseData.fromJson(data.data);
      ScheduleModel scheduleModel = ScheduleModel.fromJson(responseData.data);
      if (scheduleModel.schedules!.isNotEmpty) {
        emit(GetScheduleLoadedState(scheduleModel));
      } else {
        emit(GetScheduleEmptyState(data.statusMessage!));
      }
    } catch (error) {
      if (ApiService.connectionInternet == 'Disconnect') {
        emit(NoInternetConnectionState());
      } else {
        emit(GetScheduleErrorState(error.toString()));
      }
    }
  }
}
