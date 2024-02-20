import 'package:recase/recase.dart';

import 'models.dart';

String getCharacterSetName(Category category) => '${category.name}Characters';

String getSimpleCaseMappingName(String name) =>
    'simple_${name}_mapping'.camelCase;
