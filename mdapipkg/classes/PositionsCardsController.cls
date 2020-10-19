public with sharing class PositionsCardsController {

    @AuraEnabled(cacheable=true)
    public static List<PositionsFieldsWrapper> getPositions(List<String> status, List<String> location, 
            List<String> skills, Integer positionsPerPage, Integer currentPage, String order, 
            String searchString, String searchMode) {
        try {
            return PositionsHelper.getPositionsFiltered(status, location, skills, positionsPerPage, 
                currentPage, order, searchString, searchMode);
        } catch(Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getPositionsCount (List<String> status, List<String> location, 
            List<String> skills) {
        try {
            return PositionsHelper.getPositionsCount(status, location, skills);
        } catch (Exception e) {
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
            throw new AuraHandledException(e.getTypeName() + ' ' + e.getMessage());
        }
    }
}