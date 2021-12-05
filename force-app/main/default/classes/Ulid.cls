/**
 * ULIDを生成する
 *  - https://github.com/ulid/spec
 */
public without sharing class Ulid {

  private static final String ENCODING = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  private static final List<String> ENCODING_ARY = new List<String>{
    '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','J','K','M','N','P','Q','R','S','T','V','W','X','Y','Z'
  };
  private static final Long ENCODING_LEN = 32L; // ENCODING.length
  private static final Long TIME_MAX = 281474976710655L; // Math.pow(2, 48) - 1

  private static final Long TIME_LEN = 10L;
  private static final Long RANDOM_LEN = 16L;


  public Ulid() {}

  /**
   * ULIDを生成する
   * @param {Datetime} dt : 日時
   */
  public String generate(Datetime dt) {
    if (dt == null) {
      dt = Datetime.now();
    }

    return encodeTime(dt.getTime(), TIME_LEN) + encodeRandom(RANDOM_LEN);
  }
  public String generate() {
    return generate(Datetime.now());
  }

  /**
   * 受け取ったオブジェクトにULID keyをセットする
   */
  public SObject setKey(SObject org, String field) {
    if (org.get(field) == null) {
      org.put(field, generate());
    }
    return org;
  }


  /**
   * timestampの数値をエンコード
   *  - timestampを32進数で表現する
   *    32進数の0-31は、ENCODING で定義したものが該当する
   *    ENCODING で定義している文字列は、順序が保たれているので、32進数に変換しても順序が保たれる
   *     (timestampの数値が同じ場合は、同じ文字列に変換されるけど)
   *
   *    32 ^ 10 では、16桁の数字となりtimestampよりも3桁多いので、
   *    10桁の32進数変換で桁が溢れることは当面ない
   */
  private String encodeTime(Long dt, Long len) {
    if (dt == null || dt > TIME_MAX || dt < 0) {
      throw new InvalidException('invalid dt: ' + String.valueOf(dt));
    }

    Long mod;
    String str = '';
    for (Long l = len; len > 0; len--) {
      mod = Math.mod(dt, ENCODING_LEN);
      str = ENCODING_ARY[mod.intValue()] + str;
      dt = (dt - mod) / ENCODING_LEN;
    }
    return str;
  }


  private String encodeRandom(Long len) {
    String str = '';
    for(Long l = len; len > 0; len--) {
      str = randomChar() + str;
    }
    return str;
  }

  /**
   * ランダムな文字を生成する
   * ref) https://salesforce.stackexchange.com/questions/43823/how-do-i-generate-a-random-string
   */
  private String randomChar() {
    Long rand = Math.mod(Math.abs(Crypto.getRandomLong()), ENCODING_LEN);
    return ENCODING_ARY[rand.intValue()];
  }


  private class InvalidException extends Exception {}
}
