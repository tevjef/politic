import 'package:politic/ui/home/home_view.dart';
import 'package:politic/ui/util/lib.dart';

import 'location_services.dart';

abstract class VoterInformationFlow {
  void onVoterInformationComplete(BuildContext context);
  void onVoterInformationNotFound(BuildContext context);
}

class CreateVoterInformationFlow extends VoterInformationFlow {
  @override
  void onVoterInformationComplete(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }

  @override
  void onVoterInformationNotFound(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationServicesPage(),
      ),
    );
  }
}

class UpdateVoterInformationFlow extends VoterInformationFlow {
  @override
  void onVoterInformationComplete(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }

  @override
  void onVoterInformationNotFound(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PoliticHomePage(),
      ),
    );
  }
}
