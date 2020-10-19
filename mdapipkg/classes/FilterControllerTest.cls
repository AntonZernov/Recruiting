@isTest
private class FilterControllerTest {
    @isTest
    static void getPicklistOptionsTest() {
        List<PositionsPicklistFields> fields = new List<PositionsPicklistFields>();
        Test.startTest();
            fields = FiltersController.getPicklistOptions();
        Test.stopTest();
        System.assertEquals(3, fields.size());
    }

}