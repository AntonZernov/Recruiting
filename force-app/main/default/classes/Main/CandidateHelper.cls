public inherited sharing class CandidateHelper {
    public static final String CANDIDATE_OBJECT = 'testtest123__Candidate__c';

    public static List<testtest123__Candidate__c> getCandidates() {
        return  [SELECT Name FROM testtest123__Candidate__c WITH SECURITY_ENFORCED ORDER BY CreatedDate 
            LIMIT : PositionsHelper.MAX_QUERY_LIMIT];
    }
    public static List<String> getFieldNames() {
        String fieldSetApiName = 
            SettingsHelper.getRecruitingMetadata().testtest123__Candidate_fieldset__c;
        List<String> fields = new List<String>();
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            fields.add(fieldSetMember.getSObjectField().getDescribe().getName());
        }
        return fields;
    }

    public static List<PositionsFieldsWrapper> getFieldLabels(String fieldSetApiName, Boolean onlyAccessible) {
        List<PositionsFieldsWrapper> fields = new List<PositionsFieldsWrapper>();
        Boolean fieldAccessible;
        for (FieldSetMember fieldSetMember : getFieldSetMemberList(fieldSetApiName)) {
            if (onlyAccessible) {
                fieldAccessible = isFieldAccessible(CANDIDATE_OBJECT, 
                    fieldSetMember.getSObjectField().getDescribe().getName());
                if (fieldAccessible) {
                    PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper();
                    wrapper.fieldLabel = fieldSetMember.getSObjectField().getDescribe().getLabel();
                    fields.add(wrapper);
                } else {
                    continue;
                }
            } else {
                PositionsFieldsWrapper wrapper = new PositionsFieldsWrapper();
                wrapper.fieldLabel = fieldSetMember.getSObjectField().getDescribe().getLabel();
                wrapper.fieldAccessible = isFieldAccessible(CANDIDATE_OBJECT, 
                    fieldSetMember.getSObjectField().getDescribe().getName());
                    fields.add(wrapper);
            }
        }
        return fields;
    }

    public static Boolean isFieldAccessible(String objectName, String fieldName) {
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectName).getDescribe();
        Map<String, Schema.SObjectField> fields = objectDescribe.fields.getMap();
        if (fields.get(fieldName).getDescribe().isAccessible()) {
            return true;
        } else {
            return false;
        }
    }

    
    @testVisible
    private static List<Schema.FieldSetMember> getFieldSetMemberList(String fieldSetApiName) {
        List<Schema.FieldSetMember> fieldSetMembersList = new List<Schema.FieldSetMember>();
        Schema.DescribeSObjectResult objectDescribe = testtest123__Candidate__c.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();
        fieldSetMembersList = fieldSetMap.get(fieldSetApiName).getFields();
        return fieldSetMembersList;
    }

    public static List<SelectOption> getFieldSetSelectOptions() {
        Schema.DescribeSObjectResult objectDescribe = testtest123__Candidate__c.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> candidateFieldSetMap =  objectDescribe.fieldSets.getMap();
        List<SelectOption> optionsList = new List<SelectOption>();
        for (String fieldSet : candidateFieldSetMap.keySet()) {
            if (String.isEmpty(candidateFieldSetMap.get(fieldSet).getNameSpace()) ) {
                optionsList.add(new SelectOption(
                                                candidateFieldSetMap.get(fieldSet).getName(), 
                                                candidateFieldSetMap.get(fieldSet).getLabel()));
                
            } else {
                optionsList.add(new SelectOption(candidateFieldSetMap.get(fieldSet).getNameSpace() + '__' +
                                                candidateFieldSetMap.get(fieldSet).getName(), 
                                                candidateFieldSetMap.get(fieldSet).getLabel()));
                
            }
        }
        return optionsList;
    }
}