class CaseMapping {
  final Map<int, int> lowercase;
  final Map<int, int> titlecase;
  final Map<int, int> uppercase;

  const CaseMapping(
      {required this.lowercase,
      required this.titlecase,
      required this.uppercase});

  Map<String, Map<int, int>> toMap() => {
        'lowercase': lowercase,
        'titlecase': titlecase,
        'uppercase': uppercase,
      };

  static CaseMapping fromCharacters(List<Character?> characters) {
    final lc = <int, int>{};
    final tc = <int, int>{};
    final uc = <int, int>{};

    for (final character in characters.nonNulls) {
      final code = character.code;

      if (character.lowercase != null) {
        lc[code] = character.lowercase!;
      }

      if (character.titlecase != null) {
        tc[code] = character.titlecase!;
      }

      if (character.uppercase != null) {
        uc[code] = character.uppercase!;
      }
    }

    return CaseMapping(lowercase: lc, titlecase: tc, uppercase: uc);
  }
}

class Character {
  final int code;
  final List<String> data;
  final String category;

  int? uppercase;
  int? titlecase;
  int? lowercase;

  Character(this.code, this.data) : category = data[2] {
    if (data[12].isNotEmpty) {
      uppercase = int.parse(data[12], radix: 16);
    }

    if (data[13].isNotEmpty) {
      lowercase = int.parse(data[13], radix: 16);
    }

    if (data[14].isNotEmpty) {
      titlecase = int.parse(data[14], radix: 16);
    }
  }
}

enum Category {
  cn('Cn', 'notAssigned', 0),
  cc('Cc', 'control', 1),
  cf('Cf', 'format', 2),
  co('Co', 'privateUse', 3),
  cs('Cs', 'surrogate', 4),
  ll('Ll', 'lowercaseLetter', 5),
  lm('Lm', 'modifierLetter', 6),
  lo('Lo', 'otherLetter', 7),
  lt('Lt', 'titlecaseLetter', 8),
  lu('Lu', 'uppercaseLetter', 9),
  mc('Mc', 'spacingMark', 10),
  me('Me', 'encosingMark', 11),
  mn('Mn', 'nonspacingMark', 12),
  nd('Nd', 'decimalNumber', 13),
  nl('Nl', 'letterNumber', 14),
  no('No', 'otherNumber', 15),
  pc('Pc', 'connectorPunctuation', 16),
  pd('Pd', 'dashPunctuation', 17),
  pe('Pe', 'closePunctuation', 18),
  pf('Pf', 'finalPunctuation', 19),
  pi('Pi', 'initialPunctuation', 20),
  po('Po', 'otherPunctuation', 21),
  ps('Ps', 'openPunctuation', 22),
  sc('Sc', 'currencySymbol', 23),
  sk('Sk', 'modifierSymbol', 24),
  sm('Sm', 'mathSymbol', 25),
  so('So', 'otherSymbol', 26),
  zl('Zl', 'lineSeparator', 27),
  zp('Zp', 'paragraphSeparator', 28),
  zs('Zs', 'spaceSeparator', 29);

  static final Map<String, Category> abbrToCategory = <String, Category>{
    cn.abbr: cn,
    cc.abbr: cc,
    cf.abbr: cf,
    co.abbr: co,
    cs.abbr: cs,
    ll.abbr: ll,
    lm.abbr: lm,
    lo.abbr: lo,
    lt.abbr: lt,
    lu.abbr: lu,
    mc.abbr: mc,
    me.abbr: me,
    mn.abbr: mn,
    nd.abbr: nd,
    nl.abbr: nl,
    no.abbr: no,
    pc.abbr: pc,
    pd.abbr: pd,
    pe.abbr: pe,
    pf.abbr: pf,
    pi.abbr: pi,
    po.abbr: po,
    ps.abbr: ps,
    sc.abbr: sc,
    sk.abbr: sk,
    sm.abbr: sm,
    so.abbr: so,
    zl.abbr: zl,
    zp.abbr: zp,
    zs.abbr: zs,
  };

  final int id;
  final String abbr;
  final String name;

  const Category(this.abbr, this.name, this.id);

  @override
  String toString() => name;
}
