/**
 *
 */
@isTest
private class UnitTest_Ulid {

  //-------------------------------------------------------------
  // Fixture
  //-------------------------------------------------------------



  //-------------------------------------------------------------
  // Test
  //-------------------------------------------------------------
  /**
   *
   */
  @isTest
  static void test_01() {

    Ulid u = new Ulid();


    Test.startTest();

    // 1000回実行
    Integer num = 1000;

    List<String> keys = new List<String>();

    Long st = Datetime.now().getTime();
    for (Integer i = 0; i < num; i++) {
      keys.add(u.generate());
    }
    Long en = Datetime.now().getTime();

    System.debug('----------- time: ' + String.valueOf(en - st));

    Test.stopTest();


    String chkData = keys[0];
    System.assertEquals(26, chkData.length());
    System.assert(chkData.isAlphanumeric());


    Set<String> chkKeySet = new Set<String>(keys);
    System.assertEquals(keys.size(), chkKeySet.size());

    for (Integer i = 1; i < num; i++) {
      String s0 = keys.get(i - 1);
      String s1 = keys.get(i);

      System.assert(s0 < s1);
    }
  }

  /**
   *
   */
  @isTest
  static void test_02() {

    Ulid u = new Ulid();


    Test.startTest();

    Datetime dt1 = Datetime.newInstance(2021, 2, 1, 13, 00, 00);
    String s1 = u.generate(dt1);

    Datetime dt2 = Datetime.newInstance(2021, 1, 2, 0, 0, 0);
    String s2 = u.generate(dt2);

    Test.stopTest();


    System.assert(String.isNotBlank(s1));
    System.assert(String.isNotBlank(s2));
    System.assert(s1 > s2);

  }

}
