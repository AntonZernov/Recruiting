public with sharing class NewCandidateFormController {

    @AuraEnabled(cacheable=true)
    public static List<String> getFieldNames() {
        try {
            return CandidateHelper.getFieldNames();
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}