List<int> compressGroups(List<int> groups) {
  final data = <int>[];
  var deltaStart = 0;
  var deltaEnd = 0;
  var start = 0;
  var end = 0;
  // Compression phase #1
  for (var i = 0; i < groups.length; i += 3) {
    deltaStart = groups[i] - start;
    deltaEnd = groups[i + 1] - end;
    start = start + deltaStart;
    end = end + deltaEnd;
    data.add(deltaStart);
    data.add(deltaEnd);
    data.add(groups[i + 2]);
  }

  return data;
}

List<int> compressMapping(List<int> mapping) {
  final data = <int>[];
  var deltaKey = 0;
  var deltaValue = 0;
  var key = 0;
  var value = 0;
  // Compression phase #1
  for (var i = 0; i < mapping.length; i += 2) {
    deltaKey = mapping[i] - key;
    deltaValue = mapping[i + 1] - value;
    key = key + deltaKey;
    value = value + deltaValue;
    data.add(deltaKey);
    data.add(deltaValue);
  }

  return data;
}
