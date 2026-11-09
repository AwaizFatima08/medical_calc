// Every working calculator, by catalog id. A catalog tool without an entry
// here shows "Coming in an update".

import 'model.dart';
import 'tools/acute.dart';
import 'tools/body.dart';
import 'tools/clots.dart';
import 'tools/dengue_ramadan.dart';
import 'tools/heart.dart';
import 'tools/kidney.dart';
import 'tools/lab.dart';
import 'tools/liver_diabetes.dart';
import 'tools/mother_child.dart';
import 'tools/public.dart';

final Map<String, CalcDefinition> kCalculators = {
  for (final c in [
    egfrCalc,
    cockcroftGaultCalc,
    mapCalc,
    cha2ds2vaCalc,
    bodySizeCalc,
    hasBledCalc,
    qtcCalc,
    wellsPercCalc,
    curb65Calc,
    qsofaCalc,
    gcsCalc,
    news2Calc,
    anionGapCalc,
    correctedCalciumCalc,
    correctedSodiumCalc,
    osmolalityCalc,
    gestationalAgeCalc,
    bishopCalc,
    hollidaySegarCalc,
    parklandCalc,
    dehydrationCalc,
    whoGrowthCalc,
    apriFib4Calc,
    a1cEagCalc,
    dripRateCalc,
    dengueCalc,
    ramadanRiskCalc,
    publicBmiCalc,
    publicDiabetesRiskCalc,
    publicBpCalc,
    publicSugarCalc,
    publicDueDateCalc,
    publicHeatCalc,
    publicDengueCalc,
    publicHeartRiskCalc,
    publicRamadanCalc,
  ])
    c.id: c,
};

/// Tools with their own screen rather than a CalcDefinition.
const Set<String> kCustomScreens = {'lab_units', 'p_units'};

bool isWorking(String id) =>
    kCalculators.containsKey(id) || kCustomScreens.contains(id);
