public with sharing class PositionsPageController {
    
    public String filter {get; set;}
    public static final String SUCCESS_MESSAGE = System.Label.Successfully_updated;
    public static final String ERROR_MESSAGE = System.Label.Some_error;
    public List<SelectOption> filterList {get; set;}
    public List<Position__c> positionsList {get; set;}
    
    public PositionsPageController() {
        filter = PositionsHelper.ALL;
        changePositionsList();
        filterList = PositionsHelper.getFilterOptions();
    }

    public void changePositionsList() {
        try {
            positionsList = PositionsHelper.getPositions(filter);
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
    }

    public void save() {
        try {
            PositionsHelper.updatePositions(positionsList);
            filter = PositionsHelper.ALL;
            changePositionsList();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, SUCCESS_MESSAGE));
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
    }
}