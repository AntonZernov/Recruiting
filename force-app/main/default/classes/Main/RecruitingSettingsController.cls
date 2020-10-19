public with sharing class RecruitingSettingsController {
    public testtest123__Recruiting_Settings__mdt recruitingMetadata {get; set;}
    public List<SelectOption> candidateFieldSetOptions {get; set;}
    public List<SelectOption> positionsCardsFieldSetOptions {get; set;}
    public List<SelectOption> positionFilterFieldSetOptions {get; set;}
    public List<SelectOption> positionDetailFieldSetOptions {get; set;}
    public Boolean showInaccessibleFields {get; set;}
    public static final String SUCCESS_MESSAGE = System.Label.Successfully_updated;
    public static final String ERROR_MESSAGE = System.Label.Some_error;

    public RecruitingSettingsController() {
        recruitingMetadata = SettingsHelper.getRecruitingMetadata();
        candidateFieldSetOptions = CandidateHelper.getFieldSetSelectOptions();
        positionsCardsFieldSetOptions = PositionsHelper.getPositionsFieldSetSelectOptions();
        positionFilterFieldSetOptions = PositionsHelper.getPositionsFieldSetSelectOptions();
        positionDetailFieldSetOptions = PositionsHelper.getPositionsFieldSetSelectOptions();
        showInaccessibleFields = false;
    }

    public void save() {
        try {
            SettingsHelper.updateRecruitingMetadata(recruitingMetadata);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, SUCCESS_MESSAGE));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
    }
    public List<PositionsFieldsWrapper> getCandidateFieldsList() {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        try {
            fields = CandidateHelper.getFieldLabels(recruitingMetadata.testtest123__Candidate_fieldset__c, 
                !this.showInaccessibleFields);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
        return fields;
    }
    public List<PositionsFieldsWrapper> getPositionsCardsFieldsList() {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        try {
            fields = PositionsHelper.getPositionsFieldLabels(recruitingMetadata.testtest123__Position_fieldset__c, 
                !this.showInaccessibleFields);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
        return fields;
    }
    public List<PositionsFieldsWrapper> getPositionFilterFieldsList() {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        try {
            fields = PositionsHelper.getPositionsFieldLabels(recruitingMetadata.testtest123__Position_filter_fieldset__c,
                !this.showInaccessibleFields);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
        return fields;
    }
    public List<PositionsFieldsWrapper> getPositionDetailFieldsList() {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        try {
            fields = PositionsHelper.getPositionsFieldLabels(recruitingMetadata.testtest123__Position_detail_fields__c,
                !this.showInaccessibleFields);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, ERROR_MESSAGE));
            System.debug(e.getTypeName());
            System.debug(e.getMessage());
        }
        return fields;
    }
}