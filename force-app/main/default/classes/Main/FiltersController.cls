public with sharing class FiltersController {
    @AuraEnabled(cacheable=true)
    public static List<PositionsPicklistFields> getPicklistOptions() {
        try {
            return PositionsHelper.getPicklistOptions();
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

}